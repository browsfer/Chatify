import 'package:flutter/material.dart';

import 'my_text_field.dart';

class AuthScreen extends StatefulWidget {
  const AuthScreen({super.key});

  @override
  State<AuthScreen> createState() => _AuthScreenState();
}

class _AuthScreenState extends State<AuthScreen> {
  bool isLogin = true;

  String? userEmail;
  String? userPassword;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(10.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Flexible(
                child: Icon(
                  Icons.chat_outlined,
                  size: 100,
                  color: Theme.of(context).colorScheme.primary,
                ),
              ),
              const SizedBox(
                height: 50,
              ),
              Text(
                isLogin ? 'Login to continue' : 'Create your account',
                style: Theme.of(context).textTheme.headlineSmall,
              ),
              const SizedBox(
                height: 20,
              ),
              const MyTextField(labelText: 'Email'),
              const SizedBox(
                height: 10,
              ),
              const MyTextField(
                labelText: 'Password',
                obscureText: true,
              ),
              if (!isLogin) ...[
                const SizedBox(
                  height: 10,
                ),
                const MyTextField(
                  labelText: 'Confirm Password',
                  obscureText: true,
                ),
              ],
              const SizedBox(
                height: 20,
              ),
              ElevatedButton(
                  onPressed: () {},
                  child: Text(
                    isLogin ? 'Login' : 'Create account',
                  )),
              const SizedBox(
                height: 20,
              ),
              TextButton(
                onPressed: () {
                  setState(() {
                    isLogin = !isLogin;
                  });
                },
                child: Text(isLogin ? 'Create new account' : 'Login instead'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
