import 'package:flutter/material.dart';
import 'package:travel_app/colors.dart';

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

class SplashScreen extends StatelessWidget {
  const SplashScreen({super.key});
  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      backgroundColor: AppColors.splashPrimaryBlue,
      body: Center(
        child: Text(
          'Travenor',
          style: TextStyle(
            color: Colors.white,
            fontFamily: 'Geometr415', // Use the custom font family
            fontSize: 34,             // Font size for the text
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }
}
