import 'package:chatify/screens/auth_screen.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';

import 'screens/chat_screen.dart';
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
      appBarTheme: const AppBarTheme(
        backgroundColor: Color(0xFFC2BAA6),
        actionsIconTheme: IconThemeData(color: Color(0xFF353535)),
        elevation: 20,
        titleTextStyle: TextStyle(
          color: Color(0xFF353535),
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
      // theme: ThemeData(
      //   appBarTheme: AppBarTheme(
      //     backgroundColor: Colors.blueGrey,
      //     titleTextStyle: TextStyle(
      //       color: Colors.grey[300],
      //       fontSize: 20,
      //       fontWeight: FontWeight.w500,
      //     ),
      //   ),
      //   colorScheme: ColorScheme.fromSeed(
      //     seedColor: Colors.blueGrey,
      //     background: Colors.grey[300],
      //   ),
      //   useMaterial3: true,
      //   textTheme: TextTheme(
      //     headlineSmall: TextStyle(
      //       color: Colors.grey[700],
      //       fontSize: 20,
      //       fontWeight: FontWeight.w500,
      //     ),
      //   ),
      // ),
      home: StreamBuilder(
        stream: FirebaseAuth.instance.authStateChanges(),
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            return ChatScreen();
          } else {
            return const AuthScreen();
          }
        },
      ),
    );
  }
}
