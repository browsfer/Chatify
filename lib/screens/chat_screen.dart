import 'package:chatify/widgets/chat_messages.dart';
import 'package:chatify/widgets/drawer.dart';
import 'package:chatify/widgets/new_message.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class ChatScreen extends StatelessWidget {
  ChatScreen({super.key});

  final firebaseAuth = FirebaseAuth.instance;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: const MyDrawer(),
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
          ),
        ],
      ),
      body: Column(
        children: [
          Expanded(child: ChatMessages()),
          const NewChatMessage(),
        ],
      ),
    );
  }
}
