import 'package:chatify/services/firebase_service.dart';
import 'package:chatify/widgets/custom_button.dart';
import 'package:chatify/widgets/my_text_field.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:motion_toast/motion_toast.dart';

import '../widgets/loading_widget.dart';

class PasswordResetScreen extends StatefulWidget {
  PasswordResetScreen({super.key});

  @override
  State<PasswordResetScreen> createState() => _PasswordResetScreenState();
}

class _PasswordResetScreenState extends State<PasswordResetScreen> {
  final _emailController = TextEditingController();

  final _firebaseService = FirebaseService();

  bool _isLoading = false;

  Future _passwordReset() async {
    try {
      setState(() {
        _isLoading = true;
      });
      await _firebaseService.resetUserPassword(
        email: _emailController.text.trim(),
      );
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
    setState(() {
      _isLoading = false;
    });
  }

  @override
  void dispose() {
    _emailController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        foregroundColor: Colors.grey,
        elevation: 0,
        backgroundColor: Colors.transparent,
      ),
      body: Padding(
        padding: const EdgeInsets.all(10.0),
        child: SafeArea(
            child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            FaIcon(
              FontAwesomeIcons.solidCommentDots,
              size: 120,
              color: Theme.of(context).colorScheme.primary,
            ),
            const SizedBox(height: 50),
            const Text(
              'Insert you e-mail address to reset password',
              style: TextStyle(
                fontSize: 20,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 20),

            //EMAIL INPUT
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
            const SizedBox(height: 20),
            if (_isLoading) const LoadingWidget(),
            if (!_isLoading)
              CustomButton(
                radius: 10,
                color: Theme.of(context).colorScheme.primary,
                splashColor: Theme.of(context).colorScheme.secondary,
                width: double.infinity,
                onPressed: _passwordReset,
                textColor: Colors.white,
                child: const Text(
                  'Reset password',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 17,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
          ],
        )),
      ),
    );
  }
}
