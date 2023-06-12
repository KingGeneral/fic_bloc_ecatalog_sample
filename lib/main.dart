import 'package:flutter_ecatalog/bloc/auth/login/login_bloc.dart';
import 'package:flutter_ecatalog/bloc/auth/register/register_bloc.dart';
import 'package:flutter_ecatalog/bloc/product/add_product/add_product_bloc.dart';
import 'package:flutter_ecatalog/bloc/product/get_pagination_product/get_pagination_product_bloc.dart';
import 'package:flutter_ecatalog/bloc/product/get_products/products_bloc.dart';
import 'package:flutter_ecatalog/bloc/product/update_product/update_product_bloc.dart';
import 'package:flutter_ecatalog/module/login/view/login_view.dart';
import 'package:flutter_ecatalog/state_util.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_ecatalog/data/datasources/auth_datasource.dart';
import 'package:flutter_ecatalog/data/datasources/product_datasource.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (context) => RegisterBloc(AuthDatasource()),
        ),
        BlocProvider(
          create: (context) => LoginBloc(AuthDatasource()),
        ),
        BlocProvider(
          create: (context) => GetPaginationProductBloc(ProductDataSource()),
        ),
        BlocProvider(
          create: (context) => UpdateProductBloc(ProductDataSource()),
        ),
        BlocProvider(
          create: (context) => ProductsBloc(ProductDataSource()),
        ),
        BlocProvider(
          create: (context) => AddProductBloc(ProductDataSource()),
        ),
      ],
      child: MaterialApp(
        title: 'Flutter Platzi Catalog',
        navigatorKey: Get.navigatorKey,
        theme: ThemeData(
          colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
          useMaterial3: true,
        ),
        home: const LoginView(),
      ),
    );
  }
}
