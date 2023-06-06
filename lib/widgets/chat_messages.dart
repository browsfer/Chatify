import 'package:chatify/widgets/message_bubble.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';

class ChatMessages extends StatefulWidget {
  ChatMessages({super.key});

  @override
  State<ChatMessages> createState() => _ChatMessagesState();
}

class _ChatMessagesState extends State<ChatMessages> {
  void setupPushNotifications() async {
    final fcm = FirebaseMessaging.instance;
    await fcm.setAutoInitEnabled(true);
    await fcm.requestPermission();
    final token = await fcm.getToken();

    fcm.subscribeToTopic('chat');
  }

  @override
  void initState() {
    setupPushNotifications();
    super.initState();
  }

  final _firestore = FirebaseFirestore.instance;

  @override
  Widget build(BuildContext context) {
    final authenticatedUser = FirebaseAuth.instance.currentUser!;

    return StreamBuilder(
        stream: _firestore
            .collection('chat')
            .orderBy('createdAt', descending: true)
            .snapshots(),
        builder: (ctx, chatSnapshot) {
          if (chatSnapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }
          final loadedMessages = chatSnapshot.data!.docs;
          return ListView.builder(
            padding: const EdgeInsets.only(
              bottom: 40,
              left: 13,
              right: 13,
            ),
            reverse: true,
            itemCount: loadedMessages.length,
            itemBuilder: (ctx, index) {
              final chatMessage = loadedMessages[index].data();
              final nextMessage = index + 1 < loadedMessages.length
                  ? loadedMessages[index + 1].data()
                  : null;
              final currentMessageUserId = chatMessage['userId'];
              final nextMessageUserId =
                  nextMessage != null ? nextMessage['userId'] : null;
              final nextUserIsSame = currentMessageUserId == nextMessageUserId;

              if (nextUserIsSame) {
                return MessageBubble.next(
                  message: chatMessage['text'],
                  isMe: authenticatedUser.uid == currentMessageUserId,
                );
              } else {
                return MessageBubble.first(
                  userImage: chatMessage['userImage'],
                  username: chatMessage['username'],
                  message: chatMessage['text'],
                  isMe: authenticatedUser.uid == currentMessageUserId,
                );
              }
            },
          );
        });
  }
}
