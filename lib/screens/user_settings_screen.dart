// ignore_for_file: use_build_context_synchronously

import 'package:chatify/services/firebase_service.dart';
import 'package:chatify/widgets/custom_button.dart';
import 'package:chatify/widgets/my_text_field.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:motion_toast/motion_toast.dart';

class UserSettingsScreen extends StatefulWidget {
  UserSettingsScreen({super.key});

  @override
  State<UserSettingsScreen> createState() => _UserSettingsScreenState();
}

class _UserSettingsScreenState extends State<UserSettingsScreen> {
  final _firebaseService = FirebaseService();

  final _newUsernameController = TextEditingController();

  final _oldPasswordController = TextEditingController();

  final _newPasswordController = TextEditingController();

  Future<void> _changePassword() async {
    try {
      await _firebaseService.changeUserPassword(
          newPassword: _newPasswordController.text);
      Navigator.of(context).pop();
      MotionToast.success(
        description: const Text('Password changed successfully'),
      ).show(context);
      _oldPasswordController.clear();
      _newPasswordController.clear();
    } on FirebaseAuthException catch (e) {
      MotionToast.error(
        description: Text(e.message!),
        title: const Text(
          'Failed to change your password.',
        ),
        padding: const EdgeInsets.all(10),
      ).show(context);
    }
  }

  Future<void> _changeUsername() async {
    try {
      await _firebaseService.changeUsername(
        username: _newUsernameController.text.trim(),
      );
      Navigator.of(context).pop();
      MotionToast.success(
        description: const Text('Username changed succesfully'),
      ).show(context);
      _newUsernameController.clear();
    } on FirebaseException catch (e) {
      MotionToast.error(
        description: Text(e.message!),
        title: const Text(
          'Failed to change your username.',
        ),
        padding: const EdgeInsets.all(10),
      ).show(context);
    }
  }

  @override
  void dispose() {
    _newUsernameController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    void showChangeData({required bool isChangingPassword}) {
      showDialog(
        context: context,
        builder: (context) => Dialog(
          child: Container(
            margin: const EdgeInsets.symmetric(
              horizontal: 20,
              vertical: 20,
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  isChangingPassword
                      ? 'Type your new password:'
                      : 'Type your new username:',
                  style: const TextStyle(
                    fontSize: 16,
                  ),
                ),
                const SizedBox(height: 10),
                if (!isChangingPassword)
                  MyTextField(
                    textController: _newUsernameController,
                    labelText: 'New username',
                  ),
                if (isChangingPassword) ...[
                  MyTextField(
                    labelText: 'Old password',
                    textController: _oldPasswordController,
                    obscureText: true,
                    autovalidateMode: AutovalidateMode.onUserInteraction,
                    validator: (val) {
                      if (val!.isEmpty || val.length < 7) {
                        return 'Password must be at least 7 characters long';
                      }
                      return null;
                    },
                  ),
                  MyTextField(
                    labelText: 'New password',
                    textController: _newPasswordController,
                    obscureText: true,
                    autovalidateMode: AutovalidateMode.onUserInteraction,
                    validator: (value) {
                      if (value!.isEmpty) {
                        return 'Please enter your new password';
                      } else if (value == _oldPasswordController.text) {
                        return 'Passwords are same';
                      }
                      return null;
                    },
                  ),
                ],
                const SizedBox(height: 10),
                CustomButton(
                  textColor: Colors.white,
                  text: 'Submit',
                  color: Theme.of(context).primaryColor,
                  radius: 10,
                  onPressed: () => isChangingPassword
                      ? _changePassword()
                      : _changeUsername(),
                ),
              ],
            ),
          ),
        ),
      );
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text('User settings',
            style: TextStyle(fontWeight: FontWeight.bold)),
      ),
      body: ListView(
        padding: const EdgeInsets.all(16.0),
        children: <Widget>[
          ListTile(
            leading: const Icon(Icons.person),
            title: const Text('Change username'),
            onTap: () => showChangeData(isChangingPassword: false),
          ),
          ListTile(
            leading: const Icon(Icons.lock),
            title: const Text('Change password'),
            onTap: () => showChangeData(isChangingPassword: true),
          ),
        ],
      ),
    );
  }
}
