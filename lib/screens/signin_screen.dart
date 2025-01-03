import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:travel_app/colors.dart';
import 'package:travel_app/screens/forget_password_screen.dart';
import 'package:travel_app/screens/home_screen.dart';
import 'package:travel_app/screens/signup_screen.dart';
import 'package:firebase_auth/firebase_auth.dart';

class SignInScreen extends StatefulWidget {
  const SignInScreen({super.key});

  @override
  _SignInScreenState createState() => _SignInScreenState();
}

class _SignInScreenState extends State<SignInScreen> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  String username = "Sadia"; // You can now change this inside the state class.

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SingleChildScrollView( // Added SingleChildScrollView
        child: Padding(
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
                    fontFamily: "sf-ui-display-regular",
                  ),
                ),
              ),
              const SizedBox(height: 40),
              TextField(
                controller: _emailController,
                decoration: InputDecoration(
                  hintText: "www.uihut@gmail.com",
                  hintStyle: const TextStyle(color: AppColors.darkText),
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
                controller: _passwordController,
                obscureText: true,
                decoration: InputDecoration(
                  hintText: "*********",
                  hintStyle: const TextStyle(color: AppColors.greyText),
                  suffixIcon: IconButton(
                    icon: const Icon(Icons.visibility_off),
                    color: AppColors.greyText,
                    onPressed: () {
                      // Handle password visibility toggle
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
                  onPressed: () async {
                    try {
                      final email = _emailController.text;
                      final password = _passwordController.text;

                      if (email.isEmpty || password.isEmpty) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content: Text('Please fill in both fields'),
                          ),
                        );
                        return;
                      }

                      UserCredential userCredential = await FirebaseAuth.instance
                          .signInWithEmailAndPassword(
                        email: email,
                        password: password,
                      );

                      if (userCredential.user != null) {
                        String uid = userCredential.user!.uid;

                        DatabaseReference ref = FirebaseDatabase.instance.ref("users/$uid");
                        DatabaseEvent event = await ref.once();

                        if (event.snapshot.value != null) {
                          final userData = event.snapshot.value as Map;
                          String username = userData["username"];
                          setState(() {
                            this.username = username;
                          });
                          print("Welcome back, $username!");
                        } else {
                          print("User data not found in database");
                        }
                        // Navigate to HomeScreen
                        Navigator.pushReplacement(
                          context,
                          MaterialPageRoute(
                            builder: (context) => HomeScreen(username: username),
                          ),
                        );
                      }
                    } on FirebaseAuthException catch (e) {
                      String message;
                      if (e.code == 'user-not-found') {
                        message = 'No user found for this email.';
                      } else if (e.code == 'wrong-password') {
                        message = 'Incorrect password.';
                      } else {
                        message = e.message ?? 'An error occurred.';
                      }
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(content: Text(message)),
                      );
                    } catch (e) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text('An unexpected error occurred.')),
                      );
                    }
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
                  const Text(
                    "Don’t have an account? ",
                    style: TextStyle(color: AppColors.greyText),
                  ),
                  TextButton(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => const SignUpScreen()),
                      );
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
              const SizedBox(height: 50),
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
                      // Instagram login functionality
                    },
                    icon: Image.asset('images/pngs/instagram.png'),
                    iconSize: 44,
                  ),
                  const SizedBox(width: 20),
                  IconButton(
                    onPressed: () {
                      // Twitter login functionality
                    },
                    icon: Image.asset('images/pngs/twitter.png'),
                    iconSize: 44,
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
