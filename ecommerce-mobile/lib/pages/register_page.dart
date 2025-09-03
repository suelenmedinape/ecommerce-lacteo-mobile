import 'package:ecommerce/service/auth_service.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:provider/provider.dart';

import '../components/my_button.dart';
import '../components/my_textfield.dart'; // ajuste o caminho

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
      backgroundColor: Theme.of(context).colorScheme.surface,
      body: SafeArea(
        child: Form(
          key: _formKey,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const SizedBox(height: 50),
              // logo
              SvgPicture.asset(
                'assets/icons/cow-auth.svg',
                width: 100,
                height: 100,
              ),
              const SizedBox(height: 50),

              // welcome back, you've been missed!
              Text(
                'Welcome back you\'ve been missed!',
                style: TextStyle(
                  color: Theme.of(context).colorScheme.inversePrimary,
                  fontSize: 16,
                ),
              ),
              const SizedBox(height: 25),

              MyTextFormField(
                controller: nameController,
                hintText: 'Name',
                obscureText: false,
              ),
              const SizedBox(height: 25),

              MyTextFormField(
                controller: emailController,
                hintText: 'Email',
                obscureText: false,
              ),
              const SizedBox(height: 25),

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
              const SizedBox(height: 50),

              // not a member? register now
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    'It\'s a member?',
                    style: TextStyle(
                      color: Theme.of(context).colorScheme.inversePrimary,
                    ),
                  ),
                  const SizedBox(width: 4),
                  GestureDetector(
                    onTap: () {
                      Navigator.pushNamed(context, '/login_page');
                    },
                    child: const Text(
                      'Sign In',
                      style: TextStyle(
                        color: Colors.amber,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
