import 'dart:io';

import 'package:chatify/widgets/custom_button.dart';
import 'package:chatify/widgets/user_image_picker.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
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
  bool _isLoading = false;

  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _usernameController = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  final _auth = FirebaseAuth.instance;
  final _storage = FirebaseStorage.instance;
  final _firestore = FirebaseFirestore.instance;
  File? _selectedImage;

  Future submitForm() async {
    final isValid = _formKey.currentState!.validate();
    FocusScope.of(context).unfocus();
    if (!isValid) {
      return;
    }
    if (!isLogin && _selectedImage == null) {
      MotionToast.warning(
        description: const Text('Please pick an image'),
        title: const Text(
          'No image selected',
        ),
        padding: const EdgeInsets.all(10),
      ).show(context);
      return;
    }

    // A  U T H E N T I C A T E    U S E R
    try {
      setState(() {
        _isLoading = true;
      });

      if (isLogin) {
        await _auth.signInWithEmailAndPassword(
          email: _emailController.text,
          password: _passwordController.text,
        );
      } else {
        final userCredentials = await _auth.createUserWithEmailAndPassword(
          email: _emailController.text,
          password: _passwordController.text,
        );

        // U P L O A D   I M A G E
        final ref = _storage
            .ref()
            .child('user_images')
            .child('${userCredentials.user!.uid}.jpg');
        await ref.putFile(_selectedImage!);
        final imageUrl = await ref.getDownloadURL();

        //S T O R E   U S E R   D A T A
        await _firestore
            .collection('users')
            .doc(userCredentials.user!.uid)
            .set({
          'username': _usernameController.text,
          'email': _emailController.text,
          'image_url': imageUrl,
        });
      }
    } on FirebaseAuthException catch (e) {
      MotionToast.error(
        description: Text(e.message!),
        title: const Text(
          'Failed to Authenticate',
        ),
        padding: const EdgeInsets.all(10),
      ).show(context);

      setState(() {
        _isLoading = false;
      });
    }
  }

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // L O G O
              FaIcon(
                FontAwesomeIcons.solidCommentDots,
                size: 120,
                color: Theme.of(context).colorScheme.primary,
              ),
              const SizedBox(
                height: 50,
              ),
              // T E X T  F I E L D S
              SingleChildScrollView(
                child: Padding(
                  padding: const EdgeInsets.all(10.0),
                  child: Form(
                    key: _formKey,
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(
                          isLogin ? 'Login to continue' : 'Create your account',
                          style: Theme.of(context).textTheme.headlineSmall,
                        ),
                        const SizedBox(height: 20),
                        // U S E R  I M A G E
                        if (!isLogin) ...[
                          UserImagePicker(
                            onPickImage: (pickedImage) {
                              setState(() {
                                _selectedImage = pickedImage;
                              });
                            },
                          ),

                          // U S E R N A M E
                          MyTextField(
                            prefixIcon: const Icon(Icons.person),
                            labelText: 'Username',
                            validator: (val) {
                              if (val!.isEmpty || val.length < 4) {
                                return 'Please enter at least 4 characters';
                              }
                              return null;
                            },
                            textController: _usernameController,
                          ),
                          const SizedBox(height: 10),
                        ],

                        MyTextField(
                          prefixIcon: const Icon(Icons.email),
                          labelText: 'Email',
                          textController: _emailController,
                          validator: (val) {
                            if (val!.isEmpty || !val.contains('@')) {
                              return 'Please enter a valid email address';
                            }
                            return null;
                          },
                        ),
                        const SizedBox(height: 10),

                        // P A S W O R D
                        MyTextField(
                          prefixIcon: const Icon(Icons.lock),
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
                          // C O N F I R M  P A S S W O R D
                          MyTextField(
                            prefixIcon: const Icon(Icons.lock_outline),
                            labelText: 'Confirm Password',
                            obscureText: true,
                            validator: (val) {
                              if (val!.isEmpty ||
                                  val != _passwordController.text) {
                                return 'Passwords do not match';
                              }
                              return null;
                            },
                          ),
                        ],

                        const SizedBox(
                          height: 10,
                        ),
                        // L O G I N  B U T T O N
                        if (_isLoading)
                          LoadingAnimationWidget.flickr(
                            leftDotColor: Theme.of(context).colorScheme.primary,
                            rightDotColor: Colors.teal,
                            size: 45,
                          ),
                        if (!_isLoading)
                          CustomButton(
                            radius: 10,
                            color: Theme.of(context).colorScheme.primary,
                            splashColor:
                                Theme.of(context).colorScheme.secondary,
                            width: double.infinity,
                            onPressed: submitForm,
                            textColor: Colors.white,
                            isLoading: _isLoading,
                            child: Text(
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
                        // C R E A T E  N E W  A C C O U N T
                        if (!_isLoading)
                          TextButton(
                            onPressed: () {
                              setState(() {
                                isLogin = !isLogin;
                              });
                            },
                            child: Text(isLogin
                                ? 'Create new account'
                                : 'Login instead'),
                          ),
                        const SizedBox(height: 100),

                        Text('Made with ❤️ by @browsfer',
                            style: Theme.of(context).textTheme.headlineSmall),
                      ],
                    ),
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
