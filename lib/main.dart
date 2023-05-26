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

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Chatify',
      theme: ThemeData(
        appBarTheme: AppBarTheme(
          color: Colors.blueGrey[900],
          titleTextStyle: TextStyle(
            color: Colors.grey[300],
            fontSize: 20,
            fontWeight: FontWeight.w500,
          ),
        ),
        colorScheme: ColorScheme.fromSeed(
          seedColor: Colors.blueGrey,
          background: Colors.grey[300],
        ),
        useMaterial3: true,
        textTheme: TextTheme(
          headlineSmall: TextStyle(
            color: Colors.grey[700],
            fontSize: 20,
            fontWeight: FontWeight.w500,
          ),
        ),
      ),
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
