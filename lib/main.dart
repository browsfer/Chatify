import 'package:chatify/auth_screen.dart';
import 'package:flutter/material.dart';

void main() {
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
        colorScheme: ColorScheme.fromSeed(
            seedColor: Colors.blueGrey, background: Colors.grey[300]),
        useMaterial3: true,
        textTheme: TextTheme(
          headlineSmall: TextStyle(
            color: Colors.grey[700],
            fontSize: 20,
            fontWeight: FontWeight.w500,
          ),
        ),
      ),
      home: AuthScreen(),
    );
  }
}
