import 'package:chatify/widgets/advanced_drawer.dart';
import 'package:chatify/chat/chat_messages.dart';
import 'package:chatify/chat/new_message.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:flutter_advanced_drawer/flutter_advanced_drawer.dart';

class ChatScreen extends StatefulWidget {
  const ChatScreen({super.key});

  @override
  State<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  final firebaseAuth = FirebaseAuth.instance;

  @override
  Widget build(BuildContext context) {
    final advancedDrawerController = AdvancedDrawerController();

    void handleMenuButtonPressed() {
      // NOTICE: Manage Advanced Drawer state through the Controller.
      // _advancedDrawerController.value = AdvancedDrawerValue.visible();
      advancedDrawerController.showDrawer();
    }

    return MyAdvancedDrawer(
      controller: advancedDrawerController,
      child: Scaffold(
        appBar: AppBar(
          leading: IconButton(
            onPressed: handleMenuButtonPressed,
            icon: ValueListenableBuilder<AdvancedDrawerValue>(
              valueListenable: advancedDrawerController,
              builder: (_, value, __) {
                return AnimatedSwitcher(
                  duration: const Duration(milliseconds: 250),
                  child: Icon(
                    value.visible ? Icons.clear : Icons.menu,
                    key: ValueKey<bool>(value.visible),
                  ),
                );
              },
            ),
          ),
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
        body: const Column(
          children: [
            Expanded(child: ChatMessages()),
            NewChatMessage(),
          ],
        ),
      ),
    );
  }
}
