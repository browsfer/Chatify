import 'package:chatify/widgets/custom_button.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:motion_toast/motion_toast.dart';

import '../widgets/my_text_field.dart';

class AuthScreen extends StatefulWidget {
  const AuthScreen({super.key});

  @override
  State<AuthScreen> createState() => _AuthScreenState();
}

class _AuthScreenState extends State<AuthScreen> {
  bool isLogin = true;
  bool isLoading = false;

  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  final firebaseAuth = FirebaseAuth.instance;

  Future submitForm() async {
    final isValid = _formKey.currentState!.validate();
    FocusScope.of(context).unfocus();
    if (!isValid) {
      return;
    }

    if (isLogin) {
      // Login user
      try {
        setState(() {
          isLoading = true;
        });
        await firebaseAuth.signInWithEmailAndPassword(
          email: _emailController.text,
          password: _passwordController.text,
        );
      } on FirebaseAuthException catch (e) {
        setState(() {
          isLoading = false;
        });
        MotionToast.error(
          description: Text(e.message!),
          title: const Text(
            'Failed to Sign In',
          ),
          padding: const EdgeInsets.all(10),
        ).show(context);
      }
    } else {
      // Create account
      try {
        setState(() {
          isLoading = true;
        });
        await firebaseAuth.createUserWithEmailAndPassword(
          email: _emailController.text,
          password: _passwordController.text,
        );
      } on FirebaseAuthException catch (e) {
        setState(() {
          isLoading = false;
        });
        MotionToast.error(
          description: Text(e.message!),
          title: const Text(
            'Failed to Sign Up',
          ),
          padding: const EdgeInsets.all(10),
        ).show(context);
      }
    }
    setState(() {
      isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(10.0),
        child: Form(
          key: _formKey,
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
              MyTextField(
                labelText: 'Email',
                textController: _emailController,
                validator: (val) {
                  if (val!.isEmpty || !val.contains('@')) {
                    return 'Please enter a valid email address';
                  }
                  return null;
                },
              ),
              const SizedBox(
                height: 10,
              ),
              MyTextField(
                labelText: 'Password',
                textController: _passwordController,
                obscureText: true,
                validator: (val) {
                  if (val!.isEmpty || val.length < 7) {
                    return 'Password must be at least 7 characters long';
                  }
                  return null;
                },
              ),
              if (!isLogin) ...[
                const SizedBox(
                  height: 10,
                ),
                MyTextField(
                  labelText: 'Confirm Password',
                  obscureText: true,
                  validator: (val) {
                    if (val!.isEmpty || val != _passwordController.text) {
                      return 'Passwords do not match';
                    }
                    return null;
                  },
                ),
              ],
              const SizedBox(
                height: 10,
              ),
              CustomButton(
                radius: 10,
                color: Theme.of(context).colorScheme.primary,
                splashColor: Theme.of(context).colorScheme.secondary,
                width: double.infinity,
                onPressed: submitForm,
                textColor: Colors.white,
                isLoading: isLoading,
                child: isLoading
                    ? LoadingAnimationWidget.flickr(
                        leftDotColor: Colors.amber,
                        rightDotColor: Colors.white,
                        size: 25,
                      )
                    : Text(
                        isLogin ? 'Login' : 'Create account',
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 17,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
              ),
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
