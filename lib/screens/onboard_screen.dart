import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:travel_app/colors.dart'; // Import your colors file

class OnBoardScreen extends StatelessWidget {
  const OnBoardScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Container(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
           Row(
             children: [
               Image.asset('images/image-onboard-1.jpg'),
             ],
           ),
            SizedBox(width: 40,height: 40),
            Row(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Text("Life is short and the world is wide" , style: TextStyle(
                      color: AppColors.onBoardTextBlack,
                      fontFamily: 'Abel',
                      fontSize: 30,
                      fontWeight: FontWeight.normal,
                    ),)
                  ],
                )
              ],
            ),

          ],
        ),
      ),
    );
  }
}
