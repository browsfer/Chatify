import 'package:chatify/widgets/advanced_drawer.dart';
import 'package:chatify/widgets/chat_messages.dart';
import 'package:chatify/widgets/new_message.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:flutter_advanced_drawer/flutter_advanced_drawer.dart';

class ChatScreen extends StatefulWidget {
  ChatScreen({super.key});

  @override
  State<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  final firebaseAuth = FirebaseAuth.instance;

  @override
  Widget build(BuildContext context) {
    final _advancedDrawerController = AdvancedDrawerController();

    void _handleMenuButtonPressed() {
      // NOTICE: Manage Advanced Drawer state through the Controller.
      // _advancedDrawerController.value = AdvancedDrawerValue.visible();
      _advancedDrawerController.showDrawer();
    }

    return MyAdvancedDrawer(
      controller: _advancedDrawerController,
      child: Scaffold(
        appBar: AppBar(
          leading: IconButton(
            onPressed: _handleMenuButtonPressed,
            icon: ValueListenableBuilder<AdvancedDrawerValue>(
              valueListenable: _advancedDrawerController,
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
        body: Column(
          children: [
            Expanded(child: ChatMessages()),
            const NewChatMessage(),
          ],
        ),
      ),
    );
  }
}
