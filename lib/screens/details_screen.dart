import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';

class DetailsScreen extends StatelessWidget {
  final Map<String, dynamic> place;

  const DetailsScreen({Key? key, required this.place}) : super(key: key);

  void addScheduledPlaces(BuildContext context, Map<String, dynamic> place) async {
    // Get the current user
    User? currentUser = FirebaseAuth.instance.currentUser;
    if (currentUser == null) {
      print("No user is signed in.");
      return;
    }

    String userId = currentUser.uid; // Get the user ID of the signed-in user

    // Firebase Realtime Database reference for user
    DatabaseReference userRef = FirebaseDatabase.instance.ref("users").child(userId);

    // Prompt user to pick a date
    DateTime? pickedDate = await _selectDate(context);
    if (pickedDate == null) return; // If no date is selected, return

    String selectedDate = pickedDate.toIso8601String().split("T")[0]; // Format date as YYYY-MM-DD

    // Reference to the scheduled places node
    DatabaseReference scheduledPlacesRef = userRef.child("scheduledPlaces");

    // Retrieve all places from the database to find the corresponding place ID
    DatabaseReference placesRef = FirebaseDatabase.instance.ref("places");
    DataSnapshot placesSnapshot = await placesRef.get();

    // Check if places exist in the database
    if (placesSnapshot.exists) {
      // Cast the snapshot value to a Map
      Map<dynamic, dynamic> places = placesSnapshot.value as Map<dynamic, dynamic>;

      // Variable to hold the matched placeId
      String placeId = '';

      // Debugging: Print out all places to see if they are fetched correctly
      print("Fetched places: $places");

      // Loop through all places and check for a match based on 'name' field
      places.forEach((key, value) {
        if (value['name'] == place['name']) {
          placeId = key; // Found the matching place, store the key (placeId)
        }
      });

      // Debugging: Check if the placeId was found
      if (placeId.isNotEmpty) {
        print("Found matching placeId: $placeId");

        // Prepare the scheduled place data to be added to the database
        Map<String, dynamic> scheduledPlace = {
          placeId: {
            "date": selectedDate,
          },
        };

        // Update the scheduled places in the database
        try {
          await scheduledPlacesRef.update(scheduledPlace);
          print("Scheduled place with date $selectedDate added for user $userId.");

          // Show a dialog confirming the booking
          showDialog(
            context: context,
            builder: (context) {
              return AlertDialog(
                title: Text("Booking Done!"),
                content: Text("Your place has been successfully booked for $selectedDate."),
                actions: [
                  TextButton(
                    onPressed: () {
                      Navigator.pop(context); // Close the dialog
                    },
                    child: Text("OK"),
                  ),
                ],
              );
            },
          );
        } catch (e) {
          print("Error adding scheduled place: $e");
        }
      } else {
        print("No matching place found.");
      }
    } else {
      print("No places found in the database.");
    }
  }

// Function to show the date picker
  Future<DateTime?> _selectDate(BuildContext context) async {
    DateTime? selectedDate = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime(2101),
    );
    return selectedDate;
  }





  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(place["name"] ?? "Place Details"),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Image
            ClipRRect(
              borderRadius: BorderRadius.circular(16.0),
              child: Image.network(
                place["imageUrl"] ?? "default_image_url",
                height: 250,
                width: double.infinity,
                fit: BoxFit.cover,
              ),
            ),
            const SizedBox(height: 16.0),

            // Name
            Text(
              place["name"] ?? "No Title",
              style: const TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 8.0),

            // Rating, Price, and Location in the same Row
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                // Location
                Row(
                  children: [
                    const Icon(Icons.location_on, color: Colors.red),
                    const SizedBox(width: 8.0),
                    Text(
                      place["location"] ?? "No Location",
                      style: const TextStyle(fontSize: 16, color: Colors.grey),
                    ),
                  ],
                ),

                // Price
                Text(
                  "Price: ${place["price"] ?? "Not available"}",
                  style: const TextStyle(fontSize: 16),
                ),

                // Rating
                Row(
                  children: [
                    const Icon(Icons.star, color: Colors.amber),
                    const SizedBox(width: 8.0),
                    Text(
                      place["rating"]?.toString() ?? "0.0",
                      style: const TextStyle(fontSize: 16),
                    ),
                  ],
                ),
              ],
            ),
            const SizedBox(height: 16.0),

            // About Destination
            const Text(
              "About Destination",
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 8.0),
            const Text(
              "This is a beautiful destination with amazing views, scenic landscapes, and wonderful activities. It's a perfect place to relax and explore the beauty of nature. Enjoy your time here and make unforgettable memories.",
              style: TextStyle(fontSize: 16, color: Colors.grey),
            ),
            const SizedBox(height: 20.0),

            // Book Now Button covering the whole row with rounded corners
            Center(
              child: SizedBox(
                width: double.infinity, // Make the button cover the full width
                child: ElevatedButton(
                  onPressed: () {
                    // Trigger the date selection and add to scheduled places
                    addScheduledPlaces(context,place);
                  },
                  child: const Text(
                    "Book Now",
                    style: TextStyle(fontSize: 18),
                  ),
                  style: ElevatedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 40.0, vertical: 12.0), backgroundColor: Colors.blue,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12.0), // Rounded corners
                    ),
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
