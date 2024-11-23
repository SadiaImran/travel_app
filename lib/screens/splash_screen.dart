import 'package:flutter/material.dart';
import 'package:travel_app/colors.dart';

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
            fontFamily: 'Geometr415', // Custom font
            fontSize: 34,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }
}
