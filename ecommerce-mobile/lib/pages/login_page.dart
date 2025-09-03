import 'package:ecommerce/components/my_button.dart';
import 'package:ecommerce/components/my_textfield.dart';
import 'package:ecommerce/service/auth_service.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:provider/provider.dart';

class LoginPage extends StatelessWidget {
  LoginPage({super.key});

  // text editing controllers
  final _formKey = GlobalKey<FormState>();
  final emailController = TextEditingController();
  final passwordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    final loginProvider = context.watch<LoginService>();

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
          
                // email textfield
                MyTextFormField(
                  controller: emailController,
                  hintText: 'Email',
                  obscureText: false,
                ),
                const SizedBox(height: 25),
          
                // password textfield
                MyTextFormField(
                  controller: passwordController,
                  hintText: 'Password',
                  obscureText: true,
                ),
                const SizedBox(height: 25),
          
                // sign in button
                MyButtonAuth(
                  textButtonName: 'Sign In',
                  loading: loginProvider.loading,
                  onTap: () { 
                    loginProvider.login(
                      email: emailController.text.trim(),
                      password: passwordController.text.trim(),
                      formKey: _formKey,
                      context: context
                    );
                  },
                ),
                const SizedBox(height: 50),
          
                // not a member? register now
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      'Not a member?',
                      style: TextStyle(
                        color: Theme.of(context).colorScheme.inversePrimary,
                      ),
                    ),
                    const SizedBox(width: 4),
                    GestureDetector(
                      onTap: () {
                        Navigator.pushNamed(context, '/register_page');
                      },
                      child: const Text(
                        'Register now',
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
