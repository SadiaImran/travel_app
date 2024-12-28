import 'package:flutter/material.dart';
import 'package:firebase_database/firebase_database.dart';

// Place Model
class Place {
  final String name;
  final String imageUrl;
  final String price;

  Place({
    required this.name,
    required this.imageUrl,
    required this.price,
  });

  // Convert Place object to a Map
  Map<String, dynamic> toMap() {
    return {
      'name': name,
      'imageUrl': imageUrl,
      'price': price,
    };
  }

  // Create Place object from a Map
  factory Place.fromMap(Map<String, dynamic> map) {
    return Place(
      name: map['name'] ?? '',
      imageUrl: map['imageUrl'] ?? '',
      price: map['price'] ?? '',
    );
  }
}

// Places Service for Firebase Operations
class PlacesService {
  final DatabaseReference _placesRef = FirebaseDatabase.instance.ref().child('places');

  // Write all places to Firebase
  Future<void> writePlacesToFirebase(List<Place> places) async {
    try {
      for (var place in places) {
        await _placesRef.push().set(place.toMap());
      }
      print('Places written to Firebase successfully');
    } catch (e) {
      print('Error writing places to Firebase: $e');
      rethrow;
    }
  }

  // Read places from Firebase
  Future<List<Place>> getPlacesFromFirebase() async {
    try {
      final snapshot = await _placesRef.get();
      final List<Place> places = [];

      if (snapshot.value != null) {
        Map<dynamic, dynamic> placesMap = snapshot.value as Map<dynamic, dynamic>;
        placesMap.forEach((key, value) {
          places.add(Place.fromMap(Map<String, dynamic>.from(value)));
        });
      }

      return places;
    } catch (e) {
      print('Error reading places from Firebase: $e');
      rethrow;
    }
  }
}

// Main SearchScreen Widget
class SearchScreen extends StatefulWidget {
  const SearchScreen({super.key});

  @override
  State<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  final PlacesService _placesService = PlacesService();
  List<Place> places = [];
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadPlaces();
  }

  Future<void> _loadPlaces() async {
    try {
      // Uncomment this line only once to write sample data to Firebase
     // await _placesService.writePlacesToFirebase(placesList);

      final loadedPlaces = await _placesService.getPlacesFromFirebase();
      setState(() {
        places = loadedPlaces;
        isLoading = false;
      });
    } catch (e) {
      print('Error loading places: $e');
      setState(() {
        isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text(
          'Search',
          style: TextStyle(color: Colors.black),
        ),
        actions: [
          TextButton(
            onPressed: () {},
            child: const Text(
              'Cancel',
              style: TextStyle(color: Colors.blue),
            ),
          ),
        ],
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            child: TextField(
              decoration: InputDecoration(
                hintText: 'Search Places',
                prefixIcon: const Icon(Icons.search),
                suffixIcon: const Icon(Icons.mic),
                filled: true,
                fillColor: Colors.grey[200],
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                  borderSide: BorderSide.none,
                ),
              ),
            ),
          ),
          const Padding(
            padding: EdgeInsets.all(16.0),
            child: Text(
              'Search Places',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          Expanded(
            child: isLoading
                ? const Center(child: CircularProgressIndicator())
                : GridView.builder(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                childAspectRatio: 1.1,
                crossAxisSpacing: 10,
                mainAxisSpacing: 10,
              ),
              itemCount: places.length,
              itemBuilder: (context, index) {
                return PlaceCard(place: places[index]);
              },
            ),
          ),
        ],
      ),
    );
  }
}

// PlaceCard Widget
class PlaceCard extends StatelessWidget {
  final Place place;

  const PlaceCard({super.key, required this.place});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12),
        image: DecorationImage(
          image: AssetImage(place.imageUrl),
          fit: BoxFit.cover,
        ),
      ),
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(12),
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              Colors.transparent,
              Colors.black.withOpacity(0.7),
            ],
          ),
        ),
        padding: const EdgeInsets.all(12),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.end,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              place.name,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
            ),
            Text(
              place.price,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 14,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// Sample Data (for initial Firebase write)
final List<Place> placesList = [
  Place(
    name: 'Niladin Reservoir',
    imageUrl: 'images/jpgs/pic1.jpg',
    price: '\$585/Person',
  ),
  Place(
    name: 'Casa Las Tortugas',
    imageUrl: 'images/jpgs/pic2.jpg',
    price: '\$486/Person',
  ),
  Place(
    name: 'Beach Paradise',
    imageUrl: 'images/jpgs/pic3.jpg',
    price: '\$386/Person',
  ),
  Place(
    name: 'Mountain Retreat',
    imageUrl: 'images/jpgs/pic4.jpg',
    price: '\$286/Person',
  ),
];
