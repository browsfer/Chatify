import 'package:chatify/screens/auth_screen.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';

import 'chat/chat_screen.dart';
import 'firebase_options.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = ThemeData(
      drawerTheme: const DrawerThemeData(
        backgroundColor: Color(0xFFC2BAA6),
        endShape: BeveledRectangleBorder(),
      ),
      appBarTheme: const AppBarTheme(
        backgroundColor: Color(0xFFC2BAA6),
        actionsIconTheme: IconThemeData(color: Color(0xFF353535)),
        elevation: 20,
        titleTextStyle: TextStyle(
          color: Color(0xFF5F5F5F),
          fontSize: 20,
          fontWeight: FontWeight.w500,
        ),
      ),
      useMaterial3: true,
      brightness: Brightness.light,
      colorScheme: ColorScheme.fromSeed(
        seedColor: const Color(0xFF8FBF9F),
        background: const Color(0xFFEBE2CD),
      ),
    );
    return MaterialApp(
      title: 'Chatify',
      theme: theme,
      home: StreamBuilder(
        stream: FirebaseAuth.instance.authStateChanges(),
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            return const ChatScreen();
          } else {
            return const AuthScreen();
          }
        },
      ),
    );
  }
}
