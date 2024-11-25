import 'package:flutter/material.dart';
import 'package:travel_app/colors.dart';

class ForgetPasswordScreen extends StatelessWidget {
  const ForgetPasswordScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 56),
            CircleAvatar(
              radius: 20,
              backgroundColor: AppColors.lightGrey,
              child: IconButton(
                icon: Image.asset('images/pngs/back-arrow.png'),
                onPressed: () {
                  // back functionality
                  Navigator.pop(context);
                },
              ),
            ),
            const SizedBox(height: 40),
            const Center(
              child: Text(
                "Forgot Password",
                style: TextStyle(
                  fontSize: 26,
                  fontFamily: "sf-ui-display-semibold",
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            const SizedBox(height: 10),
            const Center(
              child: Text(
                "Enter your email account to reset your password",
                style: TextStyle(
                    fontSize: 16,
                    color: AppColors.greyText,
                    fontFamily: "sf-ui-display-regular"
                ),
                textAlign: TextAlign.center,
              ),
            ),
            const SizedBox(height: 40),
            TextField(
              decoration: InputDecoration(
                hintText: "www.uihut@gmail.com",
                hintStyle: TextStyle(color: AppColors.darkText),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                  borderSide: BorderSide.none,
                ),
                filled: true,
                fillColor: AppColors.lightGrey,
              ),
            ),
            const SizedBox(height: 40),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () {
                  showPopup(context);
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.splashPrimaryBlue,
                  padding: const EdgeInsets.symmetric(vertical: 15),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
                child: const Text(
                  "Reset Password",
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 16,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
void showPopup(BuildContext context) {
  showDialog(
    context: context,
    builder: (context) {
      return Dialog(
        backgroundColor: Colors.white,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(30),
        ),
        child: Container(
          height: 196,
          padding: const EdgeInsets.all(20),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              CircleAvatar(
                radius: 20,
                backgroundColor: AppColors.lightBackground,
                child: Image.asset(
                  'images/pngs/email.png',
                ),
              ),
              const SizedBox(height: 20),
              const Text(
                "Check your email",
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 8),
              const Text(
                "We have sent password recovery instructions to your email",
                style: TextStyle(fontSize: 16, color: AppColors.greyText),
                textAlign: TextAlign.center,
              ),
            ],
          ),
        ),
      );
    },
  );
}
