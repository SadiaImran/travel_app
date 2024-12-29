import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';

class HomeScreen extends StatefulWidget {
  final String username;

  const HomeScreen({Key? key, required this.username}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  var placesData = [];

  // Load data only once in initState
  @override
  void initState() {
    super.initState();
    loadPlaces();
  }

  // Fetch places from Firebase Realtime Database
  void loadPlaces() async {
    DatabaseReference ref = FirebaseDatabase.instance.ref("places");
    DatabaseEvent event = await ref.once();

    if (event.snapshot.value != null) {
      setState(() {
        placesData = (event.snapshot.value as Map).values.toList();
      });
    } else {
      print('No data available!');
    }
  }

  @override
  Widget build(BuildContext context) {
    final List<String> imagePaths = [
      "images/pngs/image-place-1.png",
      "images/pngs/image-place-2.png",
      "images/pngs/image-place-1.png",
      "images/pngs/image-place-2.png",
    ];

    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Row with avatar and notification icon
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 12.0, vertical: 8.0),
                      decoration: BoxDecoration(
                        color: const Color(0xFFF7F7F9),
                        borderRadius: BorderRadius.circular(20.0),
                      ),
                      child: Row(
                        children: [
                          const CircleAvatar(
                            radius: 20,
                            backgroundImage: AssetImage('images/pngs/avatar.png'),
                          ),
                          const SizedBox(width: 8),
                          Text(
                            widget.username,
                            style: const TextStyle(
                              fontSize: 12,
                              fontFamily: "sf-ui-display-semibold",
                            ),
                          ),
                        ],
                      ),
                    ),
                    Container(
                      padding: const EdgeInsets.all(8.0),
                      decoration: const BoxDecoration(
                        color: Color(0xFFF7F7F9),
                        shape: BoxShape.circle,
                      ),
                      child: Image.asset(
                        'images/pngs/Notifications.png',
                        height: 24,
                        width: 24,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 25.0),

                // Explore Header Image
                Container(
                  margin: const EdgeInsets.only(left: 12.0, right: 114.0),
                  child: Image.asset(
                    'images/pngs/explore.png',
                    height: 80.0,
                    fit: BoxFit.contain,
                  ),
                ),
                const SizedBox(height: 20.0),

                // Best Destination Section
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text(
                      "Best Destination",
                      style: TextStyle(
                        fontSize: 18,
                        fontFamily: "sf-ui-display-semibold",
                      ),
                    ),
                    TextButton(
                      onPressed: () {
                        // function of ViewAll
                      },
                      child: const Text(
                        "View All",
                        style: TextStyle(
                          fontSize: 14,
                          fontFamily: "sf-ui-display-semibold",
                          color: Colors.blue,
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 18.0),

                // Horizontal Image List with bookmark icon
                SizedBox(
                  height: 280, // Adjust the height to include both the image and text
                  child: ListView.builder(
                    scrollDirection: Axis.horizontal,
                    itemCount: placesData.length,
                    itemBuilder: (context, index) {
                      var place = placesData[index];
                      return Container(
                        width: 200, // Width of each item
                        margin: const EdgeInsets.symmetric(horizontal: 8.0),
                        child: SingleChildScrollView(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              ClipRRect(
                                borderRadius: BorderRadius.circular(16.0),
                                child: Stack(
                                  children: [
                                    Image.asset(
                                      imagePaths[index],
                                      height: 220,
                                      width: 200,
                                      fit: BoxFit.cover,
                                    ),
                                    Positioned(
                                      top: 10.0,
                                      right: 10.0,
                                      child: Image.asset(
                                        "images/pngs/icon-bookmark.png",
                                        height: 28.0,
                                        width: 28.0,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              const SizedBox(height: 8.0),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(
                                    place["name"] ?? "No Title", // Use title from the fetched data
                                    style: const TextStyle(
                                      fontSize: 14,
                                      fontFamily: "sf-ui-display-semibold",
                                      color: Colors.blue,
                                    ),
                                  ),
                                  Row(
                                    children: [
                                      Image.asset(
                                        "images/pngs/icon-star.png",
                                      ),
                                      const SizedBox(width: 8.0),
                                      Text(
                                        place["rating"].toString() ?? "0.0",
                                        style: const TextStyle(
                                          fontSize: 12,
                                        ),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                              const SizedBox(height: 8.0),
                              Row(
                                children: [
                                  Image.asset("images/pngs/icon-location.png"),
                                  const SizedBox(width: 4.0), // Spacing between icon and text
                                  Expanded(
                                    child: Text(
                                      place["location"] ?? "No Location", // Use location from the fetched data
                                      style: const TextStyle(
                                        fontSize: 12,
                                        color: Colors.grey,
                                      ),
                                      overflow: TextOverflow.visible,
                                      softWrap: true,
                                    ),
                                  ),
                                  Image.asset("images/pngs/icon-peoples.png"),
                                ],
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                  ),
                ),
                const SizedBox(height: 44.0),

                // Bottom Navigation
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    const Column(
                      children: [
                        Icon(Icons.home, size: 24.0, color: Colors.grey),
                        Text("Home", style: TextStyle(color: Colors.grey, fontSize: 12)),
                      ],
                    ),
                    const Column(
                      children: [
                        Icon(Icons.calendar_today, size: 24.0, color: Colors.grey),
                        Text("Calendar",
                            style: TextStyle(color: Colors.grey, fontSize: 12)),
                      ],
                    ),
                    Column(
                      children: [
                        Container(
                          padding: EdgeInsets.all(8.0),
                          decoration: BoxDecoration(
                            color: Colors.blue,
                            shape: BoxShape.circle,
                          ),
                          child: Icon(Icons.search, size: 24.0, color: Colors.white),
                        ),
                        const Text("Search",
                            style: TextStyle(color: Colors.blue, fontSize: 12)),
                      ],
                    ),
                    const Column(
                      children: [
                        Icon(Icons.bookmark, size: 24.0, color: Colors.grey),
                        Text("Bookmarks",
                            style: TextStyle(color: Colors.grey, fontSize: 12)),
                      ],
                    ),
                    const Column(
                      children: [
                        Icon(Icons.person, size: 24.0, color: Colors.grey),
                        Text("Profile",
                            style: TextStyle(color: Colors.grey, fontSize: 12)),
                      ],
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
