import 'package:flutter/material.dart';
import 'package:travel_app/colors.dart';
import 'package:travel_app/screens/forget_password_screen.dart';

class SignInScreen extends StatelessWidget {
  const SignInScreen({super.key});

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
                "Sign in now",
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
                "Please sign in to continue our app",
                style: TextStyle(
                  fontSize: 16,
                  color: AppColors.greyText,
                    fontFamily: "sf-ui-display-regular"
                ),
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
            const SizedBox(height: 20),
            TextField(
              obscureText: true,
              decoration: InputDecoration(
                hintText: "*********",
                  hintStyle: TextStyle(color: AppColors.greyText),
                suffixIcon: IconButton(
                  icon: const Icon(Icons.visibility_off),
                  color: AppColors.greyText,
                  onPressed: () {
                  },
                ),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                  borderSide: BorderSide.none,
                ),
                filled: true,
                fillColor: AppColors.lightGrey,
              ),
            ),
            const SizedBox(height: 10),
            Align(
              alignment: Alignment.centerRight,
              child: TextButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => ForgetPasswordScreen()),
                  );
                },
                child: const Text(
                  "Forget Password?",
                  style: TextStyle(color: AppColors.splashPrimaryBlue),
                ),
              ),
            ),
            const SizedBox(height: 20),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () {

                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.splashPrimaryBlue,
                  padding: const EdgeInsets.symmetric(vertical: 15),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
                child: const Text(
                  "Sign In",
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 18,
                  ),
                ),
              ),
            ),
            const SizedBox(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Text("Don’t have an account? ",style: TextStyle(color: AppColors.greyText),),
                TextButton(
                  onPressed: () {
                    // Sign Up functionality
                  },
                  child: const Text(
                    "Sign up",
                    style: TextStyle(color: AppColors.splashPrimaryBlue),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 20),
            const Center(
              child: Text(
                "Or connect",
                style: TextStyle(color: AppColors.greyText),
              ),
            ),
            const SizedBox(height: 100),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                IconButton(
                  onPressed: () {
                    // Facebook login functionality
                  },
                  icon: Image.asset('images/pngs/facebook.png'),
                  iconSize: 44,
                ),
                const SizedBox(width: 20),
                IconButton(
                  onPressed: () {
                    //Instagram login functionality
                  },
                  icon: Image.asset('images/pngs/instagram.png'),
                  iconSize: 44,
                ),
                const SizedBox(width: 20),
                IconButton(
                  onPressed: () {
                    //Twitter login functionality
                  },
                  icon: Image.asset('images/pngs/twitter.png'),
                  iconSize: 44,
                ),
              ],
            ),
            const SizedBox(height: 40),
          ],
        ),
      ),
    );
  }
}
