import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_ecatalog/bloc/login/login_bloc.dart';
import 'package:flutter_ecatalog/core.dart';
import '../controller/login_controller.dart';

class LoginView extends StatefulWidget {
  const LoginView({Key? key}) : super(key: key);

  Widget build(context, LoginController controller) {
    controller.view = this;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Login Page'),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Center(child: Text('Login User')),
            const SizedBox(
              height: 16,
            ),
            TextField(
              controller: controller.emailController,
              decoration: const InputDecoration(labelText: 'Email'),
            ),
            TextField(
              obscureText: true,
              controller: controller.passwordController,
              decoration: const InputDecoration(labelText: 'Password'),
            ),
            const SizedBox(
              height: 16,
            ),
            BlocConsumer<LoginBloc, LoginState>(
              builder: (context, state) {
                if (state is LoginLoading) {
                  return const Center(
                    child: CircularProgressIndicator(),
                  );
                }
                return ElevatedButton(
                    onPressed: () {
                      final requestModel = LoginRequestModel(
                          email: controller.emailController!.text,
                          password: LoginController
                              .instance.passwordController!.text);
                      context.read<LoginBloc>().add(
                            DoLoginEvent(model: requestModel),
                          );
                    },
                    child: const Text('Login'));
              },
              listener: (context, state) {
                if (state is LoginError) {
                  ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                    content: Text(state.message),
                    backgroundColor: Colors.red,
                  ));
                }

                if (state is LoginLoaded) {
                  LocalDataSource().saveToken(state.model.accessToken);
                  ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                    content: Text('Login Success'),
                    backgroundColor: Colors.blue,
                  ));
                  Navigator.push(context, MaterialPageRoute(builder: (context) {
                    return const HomeView();
                  }));
                }
              },
            ),
            const SizedBox(
              height: 16,
            ),
            InkWell(
              onTap: () {
                Navigator.push(context, MaterialPageRoute(builder: (_) {
                  return const RegisterView();
                }));
              },
              child: const Text('Belum punya akun? Register'),
            )
          ],
        ),
      ),
    );
  }

  @override
  State<LoginView> createState() => LoginController();
}
