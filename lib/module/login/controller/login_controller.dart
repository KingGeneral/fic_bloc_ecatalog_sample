import 'package:flutter/material.dart';
import 'package:flutter_ecatalog/core.dart';
import 'package:flutter_ecatalog/data/datasources/local_datasource.dart';
import 'package:flutter_ecatalog/module/home/view/home_view.dart';
import 'package:flutter_ecatalog/state_util.dart';
import '../view/login_view.dart';

class LoginController extends State<LoginView> implements MvcController {
  static late LoginController instance;
  late LoginView view;

  TextEditingController? emailController;
  TextEditingController? passwordController;

  @override
  void initState() {
    instance = this;

    checkAuth();
    emailController = TextEditingController();
    passwordController = TextEditingController();

    super.initState();
  }

  @override
  void dispose() {
    super.dispose();

    emailController!.dispose();
    passwordController!.dispose();
  }

  void checkAuth() async {
    final auth = await LocalDataSource().getToken();
    if (auth.isNotEmpty) {
      Navigator.push(context, MaterialPageRoute(builder: (_) {
        return const HomeView();
      }));
    }
  }

  @override
  Widget build(BuildContext context) => widget.build(context, this);
}
