import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'auth_screen.dart';

void main() {
  runApp(const TodoSignupApp());
}

class TodoSignupApp extends StatelessWidget {
  const TodoSignupApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Todo Signup',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        useMaterial3: true,
        fontFamily: 'SF Pro Display',
      ),
      home: const AuthScreen(),
    );
  }
}