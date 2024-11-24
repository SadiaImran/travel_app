import 'dart:async';
import 'package:travel_app/screens/onboard_screen.dart';
import 'package:flutter/material.dart';
import 'package:travel_app/colors.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<StatefulWidget> createState() {
    return _SplashScreenState() ;
  }

}

class _SplashScreenState extends State<SplashScreen>{

  @override
  void initState() {
    super.initState();

    Timer(const Duration(seconds: 2) , () {
        Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => const OnBoardScreen()));
    }) ;
  }
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
