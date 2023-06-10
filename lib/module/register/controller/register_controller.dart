import 'package:flutter/material.dart';
import 'package:flutter_ecatalog/state_util.dart';
import '../view/register_view.dart';

class RegisterController extends State<RegisterView> implements MvcController {
  static late RegisterController instance;
  late RegisterView view;

  TextEditingController? nameController;
  TextEditingController? emailController;
  TextEditingController? passwordController;

  @override
  void initState() {
    instance = this;

    nameController = TextEditingController();
    emailController = TextEditingController();
    passwordController = TextEditingController();
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
    nameController!.dispose();
    emailController!.dispose();
    passwordController!.dispose();
  }

  @override
  Widget build(BuildContext context) => widget.build(context, this);
}
