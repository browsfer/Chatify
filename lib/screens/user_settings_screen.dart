// ignore_for_file: use_build_context_synchronously

import 'package:chatify/widgets/custom_button.dart';
import 'package:chatify/widgets/my_text_field.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:motion_toast/motion_toast.dart';

class UserSettingsScreen extends StatefulWidget {
  UserSettingsScreen({super.key});

  @override
  State<UserSettingsScreen> createState() => _UserSettingsScreenState();
}

class _UserSettingsScreenState extends State<UserSettingsScreen> {
  final _firebase = FirebaseFirestore.instance;

  final _currentUser = FirebaseAuth.instance.currentUser;

  final _newUsernameController = TextEditingController();

  final newContext = BuildContext;

  Future<void> _updateUserData() async {
    try {
      await _firebase.collection('users').doc(_currentUser!.uid).update(
        {
          'username': _newUsernameController.text.trim(),
        },
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
          'Failed to change your data.',
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
    void showChangeData() {
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
                const Text(
                  'Type your new username here:',
                  style: TextStyle(
                    fontSize: 16,
                  ),
                ),
                const SizedBox(height: 10),
                MyTextField(
                  textController: _newUsernameController,
                  labelText: 'New username',
                ),
                const SizedBox(height: 10),
                CustomButton(
                  textColor: Colors.white,
                  text: 'Submit',
                  color: Theme.of(context).primaryColor,
                  radius: 10,
                  onPressed: null,
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
            onTap: showChangeData,
          ),
          ListTile(
            leading: const Icon(Icons.lock),
            title: const Text('Change password'),
            onTap: showChangeData,
          ),
        ],
      ),
    );
  }
}
