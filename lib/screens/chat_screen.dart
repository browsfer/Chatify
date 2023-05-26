import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class ChatScreen extends StatelessWidget {
  ChatScreen({super.key});

  final firebaseAuth = FirebaseAuth.instance;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: const Text('Chatify'),
        actions: [
          IconButton(
            onPressed: () => firebaseAuth.signOut(),
            icon: const FaIcon(
              FontAwesomeIcons.arrowRightFromBracket,
              size: 20,
            ),
            color: Colors.white,
          ),
        ],
      ),
      body: const Center(child: Text('Chat Screen')),
    );
  }
}