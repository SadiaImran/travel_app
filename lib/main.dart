import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'screens/splash_screen.dart';
import 'firebase_options.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  try {
    // Check if Firebase is already initialized
    if (Firebase.apps.isEmpty) {
      await Firebase.initializeApp(
        options: DefaultFirebaseOptions.currentPlatform,
      );
      print('Firebase initialized successfully');
    } else {
      print('Firebase is already initialized');
    }
    // writeFeedback();  // Your function to write feedback
  } catch (e) {
    print('Error initializing Firebase: $e');
  }

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Travel App',
      home: SplashScreen(),
    );
  }
}

void writeFeedback() {
  // Correct way to reference Firebase Realtime Database
  final DatabaseReference _feedbackRef =
  FirebaseDatabase.instance.ref().child('feedback');  // Reference to the 'feedback' path
  _feedbackRef.push().set({
    'feedback': "wajiha 2 Feedback",
    'timestamp': ServerValue.timestamp,
  });
}


