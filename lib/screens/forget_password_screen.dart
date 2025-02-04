import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:travel_app/colors.dart'; // Ensure the color file is imported
import 'package:travel_app/screens/signin_screen.dart'; // Import the SignInScreen

class ForgetPasswordScreen extends StatefulWidget {
  const ForgetPasswordScreen({super.key});

  @override
  _ForgetPasswordScreenState createState() => _ForgetPasswordScreenState();
}

class _ForgetPasswordScreenState extends State<ForgetPasswordScreen> {
  final TextEditingController emailController = TextEditingController();
  final FirebaseAuth _auth = FirebaseAuth.instance;

  void _sendVerificationCode() async {
    String email = emailController.text.trim();

    if (email.isEmpty) {
      _showError('Please enter an email address');
      return;
    }

    try {
      // Send password reset email
      await _auth.sendPasswordResetEmail(email: email);

      // Show popup
      _showPopup('Verification email sent', 'Check your inbox to reset the password.');

      // Navigate to SignInScreen after email is sent
      Future.delayed(const Duration(seconds: 2), () {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => const SignInScreen()),
        );
      });

    } catch (e) {
      _showError('Failed to send email. Please try again.');
    }
  }

  void _showPopup(String title, String message) {
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
                  child: Image.asset('images/pngs/email.png'),
                ),
                const SizedBox(height: 20),
                Text(
                  title,
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 8),
                Text(
                  message,
                  style: const TextStyle(fontSize: 16, color: AppColors.greyText),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 20),
                ElevatedButton(
                  onPressed: () => Navigator.pop(context),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.splashPrimaryBlue,
                    padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 20),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                  child: const Text(
                    "Close",
                    style: TextStyle(color: Colors.white, fontSize: 14),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  void _showError(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message)),
    );
  }

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
                  Navigator.pop(context); // Navigate back
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
                  fontFamily: "sf-ui-display-regular",
                ),
                textAlign: TextAlign.center,
              ),
            ),
            const SizedBox(height: 40),
            TextField(
              controller: emailController,
              decoration: InputDecoration(
                hintText: "your-email@example.com",
                hintStyle: const TextStyle(color: AppColors.darkText),
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
                onPressed: _sendVerificationCode,
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.splashPrimaryBlue,
                  padding: const EdgeInsets.symmetric(vertical: 15),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
                child: const Text(
                  "Send Verification Code",
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
