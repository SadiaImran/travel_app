import 'package:flutter/material.dart';

class DetailsScreen extends StatelessWidget {
  final Map<String, dynamic> place;

  const DetailsScreen({Key? key, required this.place}) : super(key: key);

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
                    // Action for Book Now button
                    print("Booking Now...");
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
