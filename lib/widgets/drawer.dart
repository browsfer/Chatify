import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class MyDrawer extends StatelessWidget {
  const MyDrawer({super.key});

  @override
  Widget build(BuildContext context) {
    final user = FirebaseAuth.instance.currentUser;

    return Drawer(
      child: StreamBuilder(
        stream: FirebaseFirestore.instance
            .collection('users')
            .doc(user!.uid)
            .snapshots(),
        builder: (ctx, userSnapshot) {
          final userData = userSnapshot.data?.data();

          if (userSnapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          return ListView(
            padding: EdgeInsets.zero,
            children: [
              DrawerHeader(
                decoration: BoxDecoration(
                  color: Theme.of(context).colorScheme.primary,
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    CircleAvatar(
                      radius: 30,
                      backgroundImage: NetworkImage(userData!['image_url']),
                    ),
                    const SizedBox(height: 10),
                    Text(
                      userData['username'],
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 18,
                      ),
                    ),
                    Text(
                      user.email!,
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 16,
                      ),
                    ),
                  ],
                ),
              ),
              Text(
                'Chat rooms',
                style: Theme.of(context).textTheme.titleLarge,
                textAlign: TextAlign.center,
              ),
              ListTile(
                leading: const Icon(Icons.chat_outlined),
                title: const Text('General'),
                onTap: () {
                  // Navigate to general schat screen
                },
              ),
              ListTile(
                leading: const Icon(Icons.chat_outlined),
                title: const Text('Events'),
                onTap: () {
                  // Navigate to events chat screen
                },
              ),
              ListTile(
                leading: const Icon(Icons.chat_outlined),
                title: const Text('Friends'),
                onTap: () {
                  // Navigate to friends chat screen
                },
              ),
              ListTile(
                leading: const Icon(Icons.settings),
                title: const Text('Settings'),
                onTap: () {
                  // Navigate to settings screen
                },
              ),
            ],
          );
        },
      ),
    );
  }
}
