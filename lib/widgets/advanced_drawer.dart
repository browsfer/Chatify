import 'package:chatify/screens/chat_screen.dart';
import 'package:chatify/screens/user_settings_screen.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_advanced_drawer/flutter_advanced_drawer.dart';

class MyAdvancedDrawer extends StatefulWidget {
  final Widget child;
  final AdvancedDrawerController? controller;

  const MyAdvancedDrawer({super.key, required this.child, this.controller});

  @override
  State<MyAdvancedDrawer> createState() => _MyAdvancedDrawerState();
}

class _MyAdvancedDrawerState extends State<MyAdvancedDrawer> {
  @override
  Widget build(BuildContext context) {
    final user = FirebaseAuth.instance.currentUser;

    return AdvancedDrawer(
      backdrop: Container(
        width: double.infinity,
        height: double.infinity,
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              Theme.of(context).colorScheme.primary,
              Theme.of(context).colorScheme.secondary
            ],
          ),
        ),
      ),
      controller: widget.controller,
      animationCurve: Curves.easeInOut,
      animationDuration: const Duration(milliseconds: 300),
      animateChildDecoration: true,
      rtlOpening: false,
      disabledGestures: false,
      childDecoration: const BoxDecoration(
        borderRadius: BorderRadius.all(Radius.circular(16)),
      ),
      drawer: StreamBuilder(
        stream: FirebaseFirestore.instance
            .collection('users')
            .doc(user!.uid)
            .snapshots(),
        builder: (context, userSnapshot) {
          final userData = userSnapshot.data?.data();

          if (userSnapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          return SafeArea(
            child: ListTileTheme(
              textColor: Colors.white,
              iconColor: Colors.white,
              child: Column(
                mainAxisSize: MainAxisSize.max,
                children: [
                  const SizedBox(height: 25),
                  Text(
                    userData!['username'],
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 20,
                    ),
                  ),
                  Text(
                    user.email!,
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 13,
                    ),
                  ),
                  Container(
                    width: 128.0,
                    height: 128.0,
                    margin: const EdgeInsets.only(
                      top: 24.0,
                      bottom: 64.0,
                    ),
                    clipBehavior: Clip.antiAlias,
                    decoration: const BoxDecoration(
                      color: Colors.black26,
                      shape: BoxShape.circle,
                    ),
                    child: CircleAvatar(
                      backgroundImage: NetworkImage(
                        userData['image_url'],
                      ),
                    ),
                  ),
                  ListTile(
                    onTap: () => Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(builder: (context) => ChatScreen()),
                    ),
                    leading: const Icon(Icons.home),
                    title: const Text('Home'),
                  ),
                  ListTile(
                    onTap: () => Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => UserSettingsScreen(),
                      ),
                    ),
                    leading: const Icon(Icons.settings),
                    title: const Text('Settings'),
                  ),
                  const Spacer(),
                  DefaultTextStyle(
                    style: const TextStyle(
                      fontSize: 12,
                      color: Colors.white54,
                    ),
                    child: Container(
                      margin: const EdgeInsets.symmetric(
                        vertical: 16.0,
                      ),
                      child: const Text('Terms of Service | Privacy Policy'),
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
      child: widget.child,
    );
  }
}
