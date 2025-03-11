import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'main.dart'; // Assuming this contains AuthScreen or relevant pages

class DashboardScreen extends StatelessWidget {
  // Hotel data for each destination
  final Map<String, List<Map<String, dynamic>>> hotels = {
    "Cox's Bazar": [
      {
        "name": "Sayeman Beach Resort",
        "rating": 4.5,
        "reviews": 426,
        "price": "৳8,500",
        "discount": "10% Off",
      },
      {
        "name": "Seagull Hotel Ltd",
        "rating": 4.2,
        "reviews": 320,
        "price": "৳7,200",
        "discount": "5% Off",
      },
      {
        "name": "Ocean Paradise Hotel & Resort",
        "rating": 4.7,
        "reviews": 512,
        "price": "৳9,000",
        "discount": "15% Off",
      },
    ],
    "Teknaf": [
      {
        "name": "Hotel Ne-Taung",
        "rating": 3.9,
        "reviews": 120,
        "price": "৳5,500",
        "discount": "8% Off",
      },
      {
        "name": "Milky Resort",
        "rating": 4.1,
        "reviews": 210,
        "price": "৳6,800",
        "discount": "12% Off",
      },
    ],
    "Bandarban": [
      {
        "name": "Hotel Plaza Bandarban",
        "rating": 4.3,
        "reviews": 340,
        "price": "৳7,000",
        "discount": "7% Off",
      },
      {
        "name": "Hill View Resort",
        "rating": 4.0,
        "reviews": 280,
        "price": "৳6,500",
        "discount": "10% Off",
      },
    ],
    "Sreemangal": [
      {
        "name": "Grand Sultan Tea Resort & Golf",
        "rating": 4.6,
        "reviews": 450,
        "price": "৳10,000",
        "discount": "20% Off",
      },
      {
        "name": "Tea Heaven Resort",
        "rating": 4.4,
        "reviews": 390,
        "price": "৳9,500",
        "discount": "15% Off",
      },
    ],
    "Sajek": [
      {
        "name": "Sajek Resort",
        "rating": 4.2,
        "reviews": 310,
        "price": "৳6,000",
        "discount": "5% Off",
      },
      {
        "name": "Resort RungRang",
        "rating": 4.0,
        "reviews": 260,
        "price": "৳5,800",
        "discount": "8% Off",
      },
    ],
  };

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              Color(0xFF007E95), // Keep your background color
              Color(0xFF004D65),
              Color(0xFF003653),
            ],
            stops: [0.0, 0.5, 1.0],
          ),
        ),
        child: SafeArea(
          child: Column(
            children: [
              // Top Navigation Bar
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    GestureDetector(
                      onTap: () {
                        // Profile button action
                      },
                      child: CircleAvatar(
                        radius: 22,
                        backgroundColor: Colors.white,
                        child: CircleAvatar(
                          radius: 20,
                          backgroundColor: Color(0xFF003B53),
                          child: Icon(Icons.person, size: 28, color: Colors.white),
                        ),
                      ),
                    ),
                    Text(
                      'Tourify Dashboard',
                      style: GoogleFonts.poppins(
                        color: Colors.white,
                        fontSize: 20,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    GestureDetector(
                      onTap: () {
                        Navigator.pushReplacement(
                          context,
                          MaterialPageRoute(builder: (context) => AuthScreen()),
                        );
                      },
                      child: Icon(Icons.logout, color: Colors.white, size: 28),
                    ),
                  ],
                ),
              ),

              // Search Bar
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                child: Container(
                  padding: EdgeInsets.symmetric(horizontal: 15),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(30),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black12,
                        blurRadius: 6,
                        spreadRadius: 2,
                      ),
                    ],
                  ),
                  child: TextField(
                    decoration: InputDecoration(
                      hintText: "Where to?",
                      border: InputBorder.none,
                      prefixIcon: Icon(Icons.search, color: Color(0xFF264653)),
                    ),
                  ),
                ),
              ),

              // Icon Menu (Flights, Hotels, Car Rentals, etc.)
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    buildIconCard(Icons.flight, "Flights"),
                    buildIconCard(Icons.hotel, "Hotels"),
                    buildIconCard(Icons.directions_car, "Car Rentals"),
                    buildIconCard(Icons.tour, "Tour Packages"),
                  ],
                ),
              ),

              // Second Row for Experiences, Trains, Transfers, Travel Guides
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    buildIconCard(Icons.explore, "Experiences"),
                    buildIconCard(Icons.train, "Trains"),
                    buildIconCard(Icons.airport_shuttle, "Transfers"),
                    buildIconCard(Icons.map, "Travel Guides"),
                  ],
                ),
              ),

              // Search Bookings and Add Tourify Button
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                child: Row(
                  children: [
                    Expanded(
                      child: ElevatedButton.icon(
                        onPressed: () {},
                        icon: Icon(Icons.search, color: Colors.orange),
                        label: Text("Search Bookings"),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.orange[100],
                          foregroundColor: Colors.black,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(15),
                          ),
                        ),
                      ),
                    ),
                    SizedBox(width: 10),
                    Expanded(
                      child: ElevatedButton.icon(
                        onPressed: () {
                          showDialog(
                            context: context,
                            builder: (BuildContext context) {
                              return AlertDialog(
                                title: Text("Add Tourify to Home"),
                                content: Column(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    Image.asset('assets/add_to_home_demo.png'), // Add your demo image here
                                    SizedBox(height: 10),
                                    Text(
                                      "Follow these steps to add Tourify to your home screen for quick access:",
                                      style: GoogleFonts.poppins(fontSize: 14),
                                    ),
                                    SizedBox(height: 10),
                                    Text(
                                      "Step 1: Tap the icon at the bottom.",
                                      style: GoogleFonts.poppins(fontSize: 14),
                                    ),
                                    Text(
                                      "Step 2: Tap 'Add to Home Screen' from the menu.",
                                      style: GoogleFonts.poppins(fontSize: 14),
                                    ),
                                  ],
                                ),
                                actions: [
                                  TextButton(
                                    onPressed: () {
                                      Navigator.of(context).pop();
                                    },
                                    child: Text("Close"),
                                  )
                                ],
                              );
                            },
                          );
                        },
                        icon: Icon(Icons.add, color: Colors.blue),
                        label: Text("Add Tourify"),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.blue[100],
                          foregroundColor: Colors.black,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(15),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),

              // Additional Features Section
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                child: Column(
                  children: [
                    buildFeatureCard(
                      icon: Icons.support_agent,
                      title: "Customer Support in Seconds",
                      description: "Get instant help with your bookings.",
                    ),
                    SizedBox(height: 10),
                    buildFeatureCard(
                      icon: Icons.verified_user,
                      title: "Travel Worry-free",
                      description: "Enjoy a seamless and secure travel experience.",
                    ),
                    SizedBox(height: 10),
                    buildFeatureCard(
                      icon: Icons.discount,
                      title: "Exclusive Rewards & Discounts",
                      description: "Save big with exclusive deals and rewards.",
                    ),
                  ],
                ),
              ),

              // Popular Destinations Section
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "Where to next?",
                      style: GoogleFonts.poppins(
                        color: Colors.white,
                        fontSize: 18,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    SizedBox(height: 10),
                    SingleChildScrollView(
                      scrollDirection: Axis.horizontal,
                      child: Row(
                        children: [
                          buildDestinationCard("Cox's Bazar", context),
                          buildDestinationCard("Teknaf", context),
                          buildDestinationCard("Bandarban", context),
                          buildDestinationCard("Sreemangal", context),
                          buildDestinationCard("Sajek", context),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // Icon Card for Navigation Bar
  Widget buildIconCard(IconData icon, String title) {
    return Column(
      children: [
        CircleAvatar(
          radius: 30,
          backgroundColor: Colors.white,
          child: Icon(icon, size: 30, color: Color(0xFF264653)),
        ),
        SizedBox(height: 5),
        Text(
          title,
          style: GoogleFonts.poppins(
            color: Colors.white,
            fontSize: 12,
            fontWeight: FontWeight.w500,
          ),
        ),
      ],
    );
  }

  // Feature Card for Additional Features
  Widget buildFeatureCard({required IconData icon, required String title, required String description}) {
    return Card(
      color: Colors.white.withOpacity(0.9),
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Row(
          children: [
            Icon(icon, size: 30, color: Color(0xFF264653)),
            SizedBox(width: 10),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: GoogleFonts.poppins(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                Text(
                  description,
                  style: GoogleFonts.poppins(
                    fontSize: 14,
                    color: Colors.black54,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  // Destination Card for Popular Destinations
  Widget buildDestinationCard(String destination, BuildContext context) {
    return GestureDetector(
      onTap: () {
        showModalBottomSheet(
          context: context,
          isScrollControlled: true,
          builder: (BuildContext context) {
            return Container(
              padding: EdgeInsets.all(20),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        "Hotels in $destination",
                        style: GoogleFonts.poppins(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      IconButton(
                        icon: Icon(Icons.arrow_back, color: Color(0xFF264653)),
                        onPressed: () {
                          Navigator.of(context).pop(); // Close the bottom sheet
                        },
                      ),
                    ],
                  ),
                  SizedBox(height: 10),
                  Expanded(
                    child: ListView.builder(
                      itemCount: hotels[destination]?.length ?? 0,
                      itemBuilder: (context, index) {
                        final hotel = hotels[destination]![index];
                        return Card(
                          margin: EdgeInsets.symmetric(vertical: 5),
                          child: Padding(
                            padding: EdgeInsets.all(10),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  hotel["name"],
                                  style: GoogleFonts.poppins(
                                    fontSize: 18,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                                SizedBox(height: 5),
                                Row(
                                  children: [
                                    Icon(Icons.star, color: Colors.amber, size: 16),
                                    SizedBox(width: 5),
                                    Text(
                                      "${hotel["rating"]} (${hotel["reviews"]} reviews)",
                                      style: GoogleFonts.poppins(fontSize: 14),
                                    ),
                                  ],
                                ),
                                SizedBox(height: 5),
                                Text(
                                  "Price: ${hotel["price"]} | ${hotel["discount"]}",
                                  style: GoogleFonts.poppins(
                                    fontSize: 14,
                                    color: Colors.green,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                ],
              ),
            );
          },
        );
      },
      child: Padding(
        padding: const EdgeInsets.only(right: 10),
        child: Chip(
          label: Text(
            destination,
            style: GoogleFonts.poppins(
              color: Colors.white,
              fontSize: 14,
            ),
          ),
          backgroundColor: Color(0xFF264653),
        ),
      ),
    );
  }
}