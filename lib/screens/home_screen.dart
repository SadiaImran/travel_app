import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:table_calendar/table_calendar.dart';
import 'package:travel_app/screens/search_screen.dart';
import 'editprofile.dart';

class HomeScreen extends StatefulWidget {
  final String username;

  const HomeScreen({Key? key, required this.username}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  List<Map<String, dynamic>> placesData = [];
  bool _isCalenderView = true;
  DateTime _focusedDay = DateTime.now();
  DateTime? _selectedDay;

  @override
  void initState() {
    super.initState();
    loadPlaces();
  }

  void loadPlaces() async {
    DatabaseReference ref = FirebaseDatabase.instance.ref("places");
    DatabaseEvent event = await ref.once();

    if (event.snapshot.value != null) {
      setState(() {
        placesData = (event.snapshot.value as Map)
            .values
            .map((e) => Map<String, dynamic>.from(e))
            .toList();
      });
// addScheduledPlaces();
    } else {
      print('No data available!');
    }
  }


  void addScheduledPlaces() async {
    // Get the current user
    User? currentUser = FirebaseAuth.instance.currentUser;
    if (currentUser == null) {
      print("No user is signed in.");
      return;
    }

    String userId = currentUser.uid; // Get the user ID of the signed-in user

    // Firebase Realtime Database reference
    DatabaseReference placesRef = FirebaseDatabase.instance.ref("places");
    DatabaseReference usersRef = FirebaseDatabase.instance.ref("users");

    // Fetch available places from the database
    DataSnapshot placesSnapshot = await placesRef.get();

    if (placesSnapshot.exists) {
      Map<dynamic, dynamic> places = placesSnapshot.value as Map<dynamic, dynamic>;

      // Get the current date (you can also use a custom date here)
      String currentDate = DateTime.now().toIso8601String().split("T")[0]; // YYYY-MM-DD format

      // Pick a few places (for demonstration, we'll pick the first 2 places)
      Map<String, dynamic> scheduledPlaces = {};
      int count = 0;

      places.forEach((placeId, placeData) {
        if (count < 2) { // Add the first 2 places to the schedule
          scheduledPlaces[placeId] = {
            "date": currentDate,  // Use the current date or a selected date
          };
          count++;
        }
      });

      // Add scheduled places with the date to the current user
      await usersRef.child(userId).child("scheduledPlaces").update(scheduledPlaces);

      print("Scheduled places with dates added for user $userId.");
    } else {
      print("No places available in the database.");
    }
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Column(
          children: [
            // Scrollable content
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Row with avatar and notification icon
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Container(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 12.0, vertical: 8.0),
                          decoration: BoxDecoration(
                            color: const Color(0xFFF7F7F9),
                            borderRadius: BorderRadius.circular(20.0),
                          ),
                          child: !_isCalenderView
                              ? Row(
                            children: [
                              const CircleAvatar(
                                radius: 20,
                                backgroundImage: AssetImage(
                                    'images/pngs/avatar.png'),
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
                          )
                              : const Row(
                            children: [
                              Text(
                                "Schedule",
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                  fontSize: 16,
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
                          child: GestureDetector(
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => EditProfileScreen(
                                      username: widget.username),
                                ),
                              );
                            },
                            child: Image.asset(
                              'images/pngs/Notifications.png',
                              height: 24,
                              width: 24,
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 25.0),

                    // Explore Header Image or Calendar
                    Container(
                      margin: const EdgeInsets.only(left: 20, right: 20),
                      child: _isCalenderView
                          ? TableCalendar(
                        firstDay: DateTime.utc(2000, 1, 1),
                        lastDay: DateTime.utc(2100, 12, 31),
                        focusedDay: _focusedDay,
                        selectedDayPredicate: (day) =>
                            isSameDay(_selectedDay, day),
                        onDaySelected: (selectedDay, focusedDay) {
                          setState(() {
                            _selectedDay = selectedDay;
                            _focusedDay = focusedDay;
                          });
                        },
                        calendarFormat: CalendarFormat.month,
                        daysOfWeekHeight: 20,
                        rowHeight: 40,
                        headerStyle: const HeaderStyle(
                          formatButtonVisible: false,
                          titleCentered: true,
                          titleTextStyle: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        calendarStyle: const CalendarStyle(
                          todayDecoration: BoxDecoration(
                            color: Colors.blue,
                            shape: BoxShape.circle,
                          ),
                          selectedDecoration: BoxDecoration(
                            color: Colors.orange,
                            shape: BoxShape.circle,
                          ),
                          outsideDaysVisible: false,
                        ),
                      )
                          : Image.asset(
                        'images/pngs/explore.png', // Default Explore Image
                        height: 80.0,
                        fit: BoxFit.contain,
                      ),
                    ),
                    const SizedBox(height: 20.0),

                    // Best Destination Section
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          _isCalenderView ? "My Schedule" : "Best Destination",
                          style: const TextStyle(
                            fontSize: 18,
                            fontFamily: "sf-ui-display-semibold",
                          ),
                        ),
                        TextButton(
                          onPressed: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => const SearchScreen()),
                            );
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
                      height: 280,
                      child: ListView.builder(
                        scrollDirection:
                        _isCalenderView ? Axis.vertical : Axis.horizontal,
                        padding: const EdgeInsets.symmetric(horizontal: 10),
                        itemCount: placesData.length,
                        itemBuilder: (context, index) {
                          var place = placesData[index];
                          return Container(
                            width: 200,
                            margin: _isCalenderView ? const EdgeInsets.symmetric(vertical: 12) : const EdgeInsets.symmetric(horizontal: 8.0) ,  // Spacing between items
                            child: _isCalenderView
                                ? Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                ClipRRect(
                                  borderRadius: BorderRadius.circular(16.0),
                                  child: Stack(
                                    children: [
                                      Image.network(
                                        place["imageUrl"] ??
                                            "https://example.com/default_image_url.jpg",
                                        height: 120,
                                        width: 150,
                                        fit: BoxFit.cover,
                                      ),
                                    ],
                                  ),
                                ),
                                const SizedBox(width: 8.0),
                                Column(
                                  children: [
                                    Row(
                                      children: [
                                        const Icon(Icons.calendar_today,
                                            size: 20, color: Colors.blue),
                                        const SizedBox(width: 8),
                                        Text(
                                          place["date"] ?? "No Date",
                                          style: const TextStyle(
                                            fontSize: 12,
                                            fontFamily: "sf-ui-display-semibold",
                                            color: Colors.blue,
                                          ),
                                        ),
                                      ],
                                    ),
                                    const SizedBox(height: 8),
                                    Text(
                                      place["name"] ?? "No Name",
                                      style: const TextStyle(
                                        fontSize: 14,
                                        fontFamily: "sf-ui-display-semibold",
                                        color: Colors.blue,
                                      ),
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                    const SizedBox(height: 8),
                                    Row(
                                      children: [
                                        const Icon(Icons.location_on,
                                            size: 20, color: Colors.blue),
                                        const SizedBox(width: 8),
                                        Text(
                                          place["location"] ?? "No Location",
                                          style: const TextStyle(
                                            fontSize: 12,
                                            fontFamily: "sf-ui-display-semibold",
                                            color: Colors.blue,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ],
                                )

                              ],
                            )
                                : Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                ClipRRect(
                                  borderRadius: BorderRadius.circular(16.0),
                                  child: Stack(
                                    children: [
                                      Image.network(
                                        place["imageUrl"] ?? "default_image_url",
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
                                    Expanded(
                                      child: Text(
                                        place["name"] ?? "No Title",
                                        style: const TextStyle(
                                          fontSize: 14,
                                          fontFamily: "sf-ui-display-semibold",
                                          color: Colors.blue,
                                        ),
                                        overflow: TextOverflow.ellipsis,
                                      ),
                                    ),
                                    Row(
                                      children: [
                                        Image.asset("images/pngs/icon-star.png"),
                                        const SizedBox(width: 8.0),
                                        Text(
                                          place["rating"]?.toString() ?? "0.0",
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
                                    const SizedBox(width: 4.0),
                                    Expanded(
                                      child: Text(
                                        place["location"] ?? "No Location",
                                        style: const TextStyle(
                                          fontSize: 12,
                                          color: Colors.grey,
                                        ),
                                        overflow: TextOverflow.ellipsis,
                                      ),
                                    ),
                                    Image.asset("images/pngs/icon-peoples.png")
                                  ],
                                ),
                              ],
                            ),
                          );
                        },
                      ),
                    ),
                    const SizedBox(height: 30.0),
                  ],
                ),
              ),
            ),
// Bottom Navigation
            Container(
              color: Colors.white,
              padding: const EdgeInsets.symmetric(vertical: 20),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  GestureDetector(
                    onTap: () {
                      setState(() {
                        _isCalenderView = false;
                      });
                    },
                    child: const Column(
                      children: [
                        Icon(Icons.home, size: 24.0, color: Colors.grey),
                        Text("Home",
                            style: TextStyle(color: Colors.grey, fontSize: 12)),
                      ],
                    ),
                  ),
                  GestureDetector(
                    onTap: () {
                      setState(() {
                        _isCalenderView = true;
                      });
                    },
                    child: const Column(
                      children: [
                        Icon(Icons.calendar_today, size: 24.0, color: Colors.grey),
                        Text("Calendar",
                            style: TextStyle(color: Colors.grey, fontSize: 12)),
                      ],
                    ),
                  ),
                  Column(
                    children: [
                      GestureDetector(
                        onTap: () {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => const SearchScreen()));
                        },
                        child: Container(
                          padding: const EdgeInsets.all(8.0),
                          decoration: const BoxDecoration(
                            color: Colors.blue,
                            shape: BoxShape.circle,
                          ),
                          child: const Icon(Icons.search,
                              size: 24.0, color: Colors.white),
                        ),
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
            ),
          ],
        ),
      ),
    );
  }
}
