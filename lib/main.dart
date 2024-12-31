import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:travel_app/screens/details_screen.dart';
import 'package:travel_app/screens/editprofile.dart';
import 'package:travel_app/screens/forget_password_screen.dart';
import 'package:travel_app/screens/home_screen.dart';
import 'package:travel_app/screens/search_screen.dart';
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
    // writePlaces();
  } catch (e) {
    print('Error initializing Firebase: $e');
  }

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Travel App',
      home: HomeScreen(username: "wajiha"),
    );
  }
}

void writePlaces() {
  final DatabaseReference _dbRef = FirebaseDatabase.instance.ref("places");


  // Function to add a new place to Firebase Realtime Database
  Future<void> addPlace({
    required String name,
    required String location,
    required String price,
    required String imageUrl,
    required String rating,
  }) async {
    try {
      // Create a new place entry in the database with a unique key
      DatabaseReference newPlaceRef = _dbRef.push();

      // Set the values for the new place
      await newPlaceRef.set({
        "name": name,
        "location": location,
        "price": price,
        "imageUrl": imageUrl,
        "rating": rating,
      });

      print("Place added successfully!");
    } catch (e) {
      print("Error adding place: $e");
    }
  }

  // Adding six places to Firebase Realtime Database
  Future<void> addMultiplePlaces() async {
    await addPlace(
      name: "Beautiful Beach House",
      location: "Miami, FL",
      price: "\$500 per night",
      imageUrl: "images/pngs/image-place-3.png",
      rating: "4.5",
    );

    await addPlace(
      name: "Mountain Retreat",
      location: "Aspen, CO",
      price: "\$700 per night",
      imageUrl: "images/pngs/image-place-4.png",
      rating: "4.7",
    );

    await addPlace(
      name: "City Apartment",
      location: "New York, NY",
      price: "\$350 per night",
      imageUrl: "images/pngs/image-place-5.png",
      rating: "4.0",
    );

    await addPlace(
      name: "Countryside Villa",
      location: "Napa Valley, CA",
      price: "\$600 per night",
      imageUrl: "images/pngs/image-place-6.png",
      rating: "4.8",
    );

    await addPlace(
      name: "Lakeview Cottage",
      location: "Lake Tahoe, CA",
      price: "\$450 per night",
      imageUrl: "images/pngs/image-place-3.png",
      rating: "4.6",
    );

    await addPlace(
      name: "Desert Oasis",
      location: "Phoenix, AZ",
      price: "\$400 per night",
      imageUrl: "images/pngs/image-place-4.png",
      rating: "4.3",
    );
  }

  // Call the function to add multiple places
  addMultiplePlaces();

}
