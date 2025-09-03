import 'package:ecommerce/service/register_service.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../components/my_button.dart';
import '../components/my_textfield.dart';// ajuste o caminho

class RegisterPage extends StatelessWidget {
  RegisterPage({super.key});

  final _formKey = GlobalKey<FormState>();
  final nameController = TextEditingController();
  final emailController = TextEditingController();
  final passwordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    final registerProvider = context.watch<RegisterService>();

    return Scaffold(
      body: SafeArea(
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              MyTextFormField(
                controller: nameController,
                hintText: 'Name',
                obscureText: false,
              ),
              MyTextFormField(
                controller: emailController,
                hintText: 'Email',
                obscureText: false,
              ),
              MyTextFormField(
                controller: passwordController,
                hintText: 'Password',
                obscureText: true,
              ),
              const SizedBox(height: 25),
              MyButtonAuth(
                textButtonName: 'Register',
                loading: registerProvider.loading,
                onTap: () {
                  registerProvider.register(
                    name: nameController.text.trim(),
                    email: emailController.text.trim(),
                    password: passwordController.text.trim(),
                    formKey: _formKey,
                    context: context,
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
