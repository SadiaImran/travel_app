import 'package:flutter/material.dart';
import 'package:travel_app/screens/splash_screen.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Travenor',
      home: SplashScreen(),
    );
  }
}
