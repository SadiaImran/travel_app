import 'package:flutter/material.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final List<String> imagePaths = [
      'images/pngs/desti1.png',
      'images/pngs/desti2.png'
    ];

    return Scaffold(
      backgroundColor: Colors.white,
      body: Padding(
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
                  child: const Row(
                    children: [
                      CircleAvatar(
                        radius: 20,
                        backgroundImage: AssetImage('images/pngs/avatar.png'),
                      ),
                      SizedBox(width: 8),
                      Text(
                        'Leonardo',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
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
            const SizedBox(height: 32.0),

            // "Explore the Beautiful World!" image
            Container(
              margin: const EdgeInsets.only(left: 12.0, right: 114.0),
              child: Image.asset(
                'images/pngs/ExploretheBeautifulworld!.png',
                height: 38.0, // Correct property
                fit: BoxFit.contain,
              ),
            ),
            const SizedBox(height: 16.0),

            Container(
              alignment: Alignment.centerLeft,
              padding: const EdgeInsets.only(top: 8.0, left: 12.0),
              child: Image.asset(
                'images/pngs/Vector1.png',
                height: 17.41,
                width: 57.0,
                fit: BoxFit.contain,
              ),
            ),
            const SizedBox(height: 24.0),

            // "Best Destination" Row
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  "Best Destination",
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(width: 16),
                TextButton(
                  onPressed: () {
                    // function of ViewAll
                  },
                  child: const Text(
                    "View All",
                    style: TextStyle(
                      fontSize: 14,
                      color: Colors.blue,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 18.0),

            // Horizontal Image List
            SizedBox(
              height: 238,
              child: ListView.builder(
                scrollDirection: Axis.horizontal,
                itemCount: imagePaths.length,
                itemBuilder: (context, index) {
                  return Container(
                    margin: const EdgeInsets.symmetric(horizontal: 8.0),
                    child: Column(
                      children: [
                        ClipRRect(
                          borderRadius: BorderRadius.circular(16.0),
                          child: Image.asset(
                            imagePaths[index],
                            height: 236,
                            width: 180,
                            fit: BoxFit.cover,
                          ),
                        ),
                      ],
                    ),
                  );
                },
              ),
            ),
            const SizedBox(height: 44.0),
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
                    Text("Calendar", style: TextStyle(color: Colors.grey, fontSize: 12)),
                  ],
                ),
                Column(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(8.0),
                      decoration: const BoxDecoration(
                        color: Colors.blue, // Background color
                        shape: BoxShape.circle,
                      ),
                      child: const Icon(Icons.search, size: 24.0, color: Colors.white),
                    ),
                    const Text("Search", style: TextStyle(color: Colors.blue, fontSize: 12)),
                  ],
                ),
                const Column(
                  children: [
                    Icon(Icons.bookmark, size: 24.0, color: Colors.grey),
                    Text("Bookmarks", style: TextStyle(color: Colors.grey, fontSize: 12)),
                  ],
                ),
                const Column(
                  children: [
                    Icon(Icons.person, size: 24.0, color: Colors.grey),
                    Text("Profile", style: TextStyle(color: Colors.grey, fontSize: 12)),
                  ],
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
