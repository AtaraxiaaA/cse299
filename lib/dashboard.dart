import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'main.dart'; // Assuming this contains AuthScreen or relevant pages
import 'listofhotels.dart';
import 'profile.dart'; // Importing the ProfileScreen
import 'flight.dart'; // Importing the FlightScreen
import 'experiences.dart';

class DashboardScreen extends StatelessWidget {
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
                        // Navigate to the ProfileScreen
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => ProfileScreen(),
                          ),
                        );
                      },
                      child: CircleAvatar(
                        radius: 22,
                        backgroundColor: Colors.white,
                        child: CircleAvatar(
                          radius: 20,
                          backgroundColor: Color(0xFF003B53),
                          child: Icon(
                            Icons.person,
                            size: 28,
                            color: Colors.white,
                          ),
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
                padding: const EdgeInsets.symmetric(
                  horizontal: 20,
                  vertical: 10,
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    GestureDetector(
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => FlightScreen(),
                          ),
                        );
                      },
                      child: buildIconCard(Icons.flight, "Flights"),
                    ),

                    buildIconCard(Icons.hotel, "Hotels"),
                    buildIconCard(Icons.directions_car, "Car Rentals"),
                    GestureDetector(
                      onTap: () {
                        // // Navigate to the TourPackagesScreen
                        // Navigator.push(
                        //   context,
                        //   MaterialPageRoute(
                        //     builder: (context) => TourPackagesScreen(),
                        //   ),
                        // );
                      },
                      child: buildIconCard(Icons.tour, "Tour Packages"),
                    ),
                  ],
                ),
              ),

              // Second Row for Experiences, Trains, Transfers, Travel Guides
              Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 20,
                  vertical: 10,
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    // buildIconCard(Icons.explore, "Experiences"),
                    GestureDetector(
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => ExperienceScreen(),
                          ),
                        );
                      },
                      child: buildIconCard(Icons.explore, "Experiences"),
                    ),
                    buildIconCard(Icons.train, "Trains"),
                    buildIconCard(Icons.airport_shuttle, "Transfers"),
                    GestureDetector(
                      onTap: () {},
                      child: buildIconCard(Icons.map, "Travel Guides"),
                    ),
                  ],
                ),
              ),

              // Additional Features Section
              Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 20,
                  vertical: 10,
                ),
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
                      description:
                          "Enjoy a seamless and secure travel experience.",
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
                padding: const EdgeInsets.symmetric(
                  horizontal: 20,
                  vertical: 10,
                ),
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
  Widget buildFeatureCard({
    required IconData icon,
    required String title,
    required String description,
  }) {
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
        // Navigation logic for destinations
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
                                    Icon(
                                      Icons.star,
                                      color: Colors.amber,
                                      size: 16,
                                    ),
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
            style: GoogleFonts.poppins(color: Colors.white, fontSize: 14),
          ),
          backgroundColor: Color(0xFF264653),
        ),
      ),
    );
  }
}
