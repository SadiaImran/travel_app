import 'package:flutter/material.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}
class _HomeScreenState extends State<HomeScreen> {
  @override
  Widget build(BuildContext context) {
    final List<String> imagePaths = [
      'images/pngs/place1.png',
      'images/pngs/place2.png'
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
                  child: Row(
                    children: [
                      CircleAvatar(
                        radius: 20,
                        backgroundImage: AssetImage('images/pngs/avatar.png'),
                      ),
                      const SizedBox(width: 8),
                      const Text(
                        'Leonardo',
                        style: TextStyle(
                          fontSize: 12,
                          fontFamily: "sf-ui-display-semibold",
                        ),
                      ),
                    ],
                  ),
                ),
                Container(
                  padding: const EdgeInsets.all(8.0),
                  decoration: BoxDecoration(
                    color: const Color(0xFFF7F7F9),
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

            Container(
              margin: const EdgeInsets.only(left: 12.0, right: 114.0),
              child: Image.asset(
                'images/pngs/explore.png',
                height: 80.0,
                fit: BoxFit.contain,
              ),
            ),
            const SizedBox(height: 20.0),

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
                const SizedBox(width: 16),
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
            const SizedBox(height: 24.0),


            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                Column(
                  children: [
                    Icon(Icons.home, size: 24.0, color: Colors.grey),
                    Text("Home", style: TextStyle(color: Colors.grey, fontSize: 12)),
                  ],
                ),
                Column(
                  children: [
                    Icon(Icons.calendar_today, size: 24.0, color: Colors.grey),
                    Text("Calendar", style: TextStyle(color: Colors.grey, fontSize: 12)),
                  ],
                ),
                Column(
                  children: [
                    Container(
                      padding: EdgeInsets.all(8.0),
                      decoration: BoxDecoration(
                        color: Colors.blue, // Background color
                        shape: BoxShape.circle,
                      ),
                      child: Icon(Icons.search, size: 24.0, color: Colors.white),
                    ),
                    Text("Search", style: TextStyle(color: Colors.blue, fontSize: 12)),
                  ],
                ),
                Column(
                  children: [
                    Icon(Icons.bookmark, size: 24.0, color: Colors.grey),
                    Text("Bookmarks", style: TextStyle(color: Colors.grey, fontSize: 12)),
                  ],
                ),
                Column(
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
