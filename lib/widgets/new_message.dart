import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class NewChatMessage extends StatefulWidget {
  const NewChatMessage({super.key});

  @override
  State<NewChatMessage> createState() => _NeChatwMessageState();
}

class _NeChatwMessageState extends State<NewChatMessage> {
  final _firestore = FirebaseFirestore.instance;
  final _auth = FirebaseAuth.instance;
  final _messageController = TextEditingController();

  void _sendMessage() async {
    final enteredMessage = _messageController.text.trim();
    FocusScope.of(context).unfocus();
    if (_messageController.text.isEmpty) {
      return;
    }

    // F I R E B A S E    C O D E
    final userId = _auth.currentUser!.uid;
    final userData = await _firestore.collection('users').doc(userId).get();

    _firestore.collection('chat').add({
      'text': enteredMessage,
      'createdAt': Timestamp.now(),
      'userId': userId,
      'username': userData.data()!['username'],
      'userImage': userData.data()!['image_url'],
    });

    _messageController.clear();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(top: 8),
      padding: const EdgeInsets.all(8),
      child: Row(
        children: [
          Expanded(
            child: TextField(
              controller: _messageController,
              textCapitalization: TextCapitalization.sentences,
              autocorrect: true,
              enableSuggestions: true,
              decoration: const InputDecoration(
                labelText: 'Send a message...',
              ),
            ),
          ),
          IconButton(
            onPressed: _sendMessage,
            icon: const Icon(Icons.send),
            color: Theme.of(context).colorScheme.secondary,
          ),
        ],
      ),
    );
  }
}
