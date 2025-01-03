import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';

class PopularPlacesScreen extends StatefulWidget {
  const PopularPlacesScreen({super.key});

  @override
  State<PopularPlacesScreen> createState() => _PopularPlacesScreenState();
}

class _PopularPlacesScreenState extends State<PopularPlacesScreen> {
  var placesData = [];
  var filteredPlaces = [];
  final TextEditingController searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    loadPopularPlaces();
    searchController.addListener(() {
      filterPlaces();
    });
  }

  @override
  void dispose() {
    searchController.dispose();
    super.dispose();
  }

  void loadPopularPlaces() async {
    try {
      DatabaseReference placesRef = FirebaseDatabase.instance.ref("places");

      DatabaseReference popularPlacesRef = FirebaseDatabase.instance.ref("popularPlaces");

      DatabaseEvent event = await placesRef.once();

      if (event.snapshot.value != null) {

        var allPlaces = (event.snapshot.value as Map).values.toList();

        allPlaces.sort((a, b) {
          double ratingA = double.tryParse(a["rating"]?.toString() ?? "0") ?? 0;
          double ratingB = double.tryParse(b["rating"]?.toString() ?? "0") ?? 0;
          return ratingB.compareTo(ratingA);
        });

        var top4Places = allPlaces.take(4).toList();


        await popularPlacesRef.set({
          for (var i = 0; i < top4Places.length; i++)
            'place_$i': top4Places[i]
        });

        setState(() {
          placesData = top4Places;
          filteredPlaces = List.from(placesData);
        });
      } else {
        print('No data available!');
      }
    } catch (error) {
      print('Error loading/storing popular places: $error');
    }
  }

  void filterPlaces() {
    String query = searchController.text.toLowerCase();
    setState(() {
      filteredPlaces = placesData.where((place) {
        String name = place["name"]?.toLowerCase() ?? "";
        String location = place["location"]?.toLowerCase() ?? "";
        return name.contains(query) || location.contains(query);
      }).toList();
    });
  }

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    int crossAxisCount = screenWidth > 600 ? 3 : 2;
    double crossAxisSpacing = screenWidth > 600 ? 20.0 : 10.0;
    double mainAxisSpacing = screenWidth > 600 ? 20.0 : 12.0;

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
          'Popular Places',
          style: TextStyle(color: Colors.black),
        ),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16.0),
                child: TextField(
                  controller: searchController,
                  decoration: InputDecoration(
                    hintText: 'Search Popular Places',
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
                  'Popular Places',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 40),
                child: GridView.builder(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: crossAxisCount,
                    childAspectRatio: 0.5,
                    crossAxisSpacing: crossAxisSpacing,
                    mainAxisSpacing: mainAxisSpacing,
                  ),
                  itemCount: filteredPlaces.length,
                  itemBuilder: (context, index) {
                    var place = filteredPlaces[index];
                    return Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(16.0),
                        color: Colors.white,
                        boxShadow: [
                          BoxShadow(
                            color: Colors.grey.withOpacity(0.2),
                            spreadRadius: 2,
                            blurRadius: 5,
                            offset: const Offset(0, 3),
                          ),
                        ],
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          ClipRRect(
                            borderRadius: BorderRadius.circular(16.0),
                            child: Image.asset (
                              place["imageUrl"] ?? "default_image_url",
                              height: 150,
                              width: double.infinity,
                              fit: BoxFit.cover,
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.all(12.0),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  place["name"] ?? "No Title",
                                  style: const TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                const SizedBox(height: 4.0),
                                Row(
                                  children: [
                                    const Icon(
                                      Icons.location_on,
                                      size: 16,
                                      color: Colors.grey,
                                    ),
                                    const SizedBox(width: 4.0),
                                    Text(
                                      place["location"] ?? "No Location",
                                      style: const TextStyle(
                                        fontSize: 12,
                                        color: Colors.grey,
                                      ),
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                  ],
                                ),
                                const SizedBox(height: 4.0),
                                Text(
                                  place["price"] ?? "No Price",
                                  style: const TextStyle(
                                    fontSize: 12,
                                    color: Colors.grey,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}