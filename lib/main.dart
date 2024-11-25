import 'package:flutter/material.dart';
import 'package:travel_app/screens/forget_password_screen.dart';
import 'package:travel_app/screens/splash_screen.dart';
import 'package:travel_app/screens/signin_screen.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Travenor',
      home: SignInScreen(),
    );
  }
}
