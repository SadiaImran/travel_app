import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:table_calendar/table_calendar.dart';
import 'package:travel_app/screens/popularplaces_screen.dart';
import 'package:travel_app/screens/search_screen.dart';
import 'details_screen.dart';
import 'editprofile.dart';

class HomeScreen extends StatefulWidget {
  final String username;

  const HomeScreen({super.key, required this.username});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  List<Map<String, dynamic>> allPlacesData = [];
  List<Map<String, dynamic>> scheduledPlacesData = [];
  bool _isCalenderView = false;
  DateTime _focusedDay = DateTime.now();
  DateTime? _selectedDay;

  @override
  void initState() {
    super.initState();
    loadAllPlaces();
    loadScheduledPlaces(_focusedDay);
  }

  void loadAllPlaces() async {
    DatabaseReference ref = FirebaseDatabase.instance.ref("places");
    DatabaseEvent event = await ref.once();

    if (event.snapshot.value != null) {
      setState(() {
        allPlacesData = (event.snapshot.value as Map)
            .entries
            .map((e) => {
          ...Map<String, dynamic>.from(e.value),
          'id': e.key,
        })
            .toList();
      });
    } else {
      print('No places available!');
    }
  }

  void loadScheduledPlaces(DateTime selectedDate) async {
    User? currentUser = FirebaseAuth.instance.currentUser;
    if (currentUser == null) {
      print("No user is signed in.");
      return;
    }

    String userId = currentUser.uid;
    DatabaseReference placesRef = FirebaseDatabase.instance.ref("places");
    DatabaseReference scheduledPlacesRef = FirebaseDatabase.instance.ref("users/$userId/scheduledPlaces");

    try {
      DatabaseEvent scheduledPlacesEvent = await scheduledPlacesRef.once();
      DatabaseEvent allPlacesEvent = await placesRef.once();

      if (scheduledPlacesEvent.snapshot.value != null && allPlacesEvent.snapshot.value != null) {
        Map<dynamic, dynamic> scheduledPlaces = scheduledPlacesEvent.snapshot.value as Map<dynamic, dynamic>;
        Map<dynamic, dynamic> allPlaces = allPlacesEvent.snapshot.value as Map<dynamic, dynamic>;

        List<Map<String, dynamic>> filteredPlaces = [];

        scheduledPlaces.forEach((placeId, placeDetails) {
          if (allPlaces.containsKey(placeId)) {
            Map<String, dynamic> place = Map<String, dynamic>.from(allPlaces[placeId]);
            DateTime scheduledDate = DateTime.parse(placeDetails['date']);

            if (isSameDay(scheduledDate, selectedDate)) {
              place['scheduledDate'] = placeDetails['date'];
              filteredPlaces.add(place);
            }
          }
        });

        setState(() {
          scheduledPlacesData = filteredPlaces;
        });
      }
    } catch (e) {
      print("Error loading scheduled places: $e");
      setState(() {
        scheduledPlacesData = [];
      });
    }
  }

  List<Map<String, dynamic>> get currentPlacesData {
    return _isCalenderView ? scheduledPlacesData : allPlacesData;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
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
                            backgroundImage:
                            AssetImage('images/pngs/avatar.png'),
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
                              builder: (context) =>
                                  EditProfileScreen(username: widget.username),
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
                      loadScheduledPlaces(selectedDay);
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
                    'images/pngs/explore.png',
                    height: 80.0,
                    fit: BoxFit.contain,
                  ),
                ),
                const SizedBox(height: 20.0),

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

                SizedBox(
                  height: 280,
                  child: ListView.builder(
                    scrollDirection:
                    _isCalenderView ? Axis.vertical : Axis.horizontal,
                    padding: const EdgeInsets.symmetric(horizontal: 10),
                    itemCount: currentPlacesData.length,
                    itemBuilder: (context, index) {
                      var place = currentPlacesData[index];
                      return GestureDetector(
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) =>
                                  DetailsScreen(place: place),
                            ),
                          );
                        },
                        child: Container(
                          width: 200,
                          margin: _isCalenderView
                              ? const EdgeInsets.symmetric(vertical: 12)
                              : const EdgeInsets.symmetric(horizontal: 8.0),
                          child: _isCalenderView
                              ? Row(
                            crossAxisAlignment:
                            CrossAxisAlignment.start,
                            children: [
                              ClipRRect(
                                borderRadius:
                                BorderRadius.circular(16.0),
                                child: Stack(
                                  children: [
                                    Image.asset(
                                      place["imageUrl"] ??
                                          "default_image_url",
                                      height: 120,
                                      width: 150,
                                      fit: BoxFit.cover,
                                    ),
                                  ],
                                ),
                              ),
                              const SizedBox(width: 8.0),
                              Column(
                                crossAxisAlignment:
                                CrossAxisAlignment.start,
                                children: [
                                  Row(
                                    children: [
                                      const Icon(Icons.calendar_today,
                                          size: 20,
                                          color: Colors.blue),
                                      const SizedBox(width: 8),
                                      Text(
                                        place["scheduledDate"] ??
                                            "No Date",
                                        style: const TextStyle(
                                          fontSize: 12,
                                          fontFamily:
                                          "sf-ui-display-semibold",
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
                                      fontFamily:
                                      "sf-ui-display-semibold",
                                      color: Colors.blue,
                                    ),
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                  const SizedBox(height: 8),
                                  Row(
                                    children: [
                                      const Icon(Icons.location_on,
                                          size: 20,
                                          color: Colors.blue),
                                      const SizedBox(width: 8),
                                      Text(
                                        place["location"] ??
                                            "No Location",
                                        style: const TextStyle(
                                          fontSize: 12,
                                          fontFamily:
                                          "sf-ui-display-semibold",
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
                            crossAxisAlignment:
                            CrossAxisAlignment.start,
                            children: [
                              ClipRRect(
                                borderRadius:
                                BorderRadius.circular(16.0),
                                child: Stack(
                                  children: [
                                    Image.asset(
                                      place["imageUrl"] ??
                                          "default_image_url",
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
                                mainAxisAlignment:
                                MainAxisAlignment.spaceBetween,
                                children: [
                                  Expanded(
                                    child: Text(
                                      place["name"] ?? "No Title",
                                      style: const TextStyle(
                                        fontSize: 14,
                                        fontFamily:
                                        "sf-ui-display-semibold",
                                        color: Colors.blue,
                                      ),
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                  ),
                                  Row(
                                    children: [
                                      Image.asset(
                                          "images/pngs/icon-star.png"),
                                      const SizedBox(width: 8.0),
                                      Text(
                                        place["rating"]?.toString() ??
                                            "0.0",
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
                                  Image.asset(
                                      "images/pngs/icon-location.png"),
                                  const SizedBox(width: 4.0),
                                  Expanded(
                                    child: Text(
                                      place["location"] ??
                                          "No Location",
                                      style: const TextStyle(
                                        fontSize: 12,
                                        color: Colors.grey,
                                      ),
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                  ),
                                  Image.asset(
                                      "images/pngs/icon-peoples.png")
                                ],
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                  ),
                ),
                const SizedBox()
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
                  GestureDetector(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) =>
                              const PopularPlacesScreen(),
                        ),
                      );
                    },
                    child: const Column(
                      children: [
                        Icon(Icons.bookmark, size: 24.0, color: Colors.grey),
                        Text("Bookmarks",
                            style: TextStyle(color: Colors.grey, fontSize: 12)),
                      ],
                    ),
                  ),
                  GestureDetector(
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) =>
                                EditProfileScreen(username: widget.username),
                          ),
                        );
                      },
                    child: const Column(
                      children: [
                        Icon(Icons.person, size: 24.0, color: Colors.grey),
                        Text("Profile",
                            style: TextStyle(color: Colors.grey, fontSize: 12)),
                      ],
                    ),
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



