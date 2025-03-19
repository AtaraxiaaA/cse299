import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class TravelGuidesScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFF007E95), // Match the dashboard's gradient background
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 20, vertical: 20),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    "Travel Guides",
                    style: GoogleFonts.poppins(
                      color: Colors.white,
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  IconButton(
                    icon: Icon(Icons.arrow_back, color: Colors.white, size: 28),
                    onPressed: () {
                      Navigator.of(context).pop(); // Go back to the previous screen
                    },
                  ),
                ],
              ),
            ),

            // Domestic and Overseas Options
            Expanded(
              child: Container(
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(30),
                    topRight: Radius.circular(30),
                  ),
                ),
                padding: EdgeInsets.all(20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "Domestic",
                      style: GoogleFonts.poppins(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    SizedBox(height: 10),
                    Expanded(
                      child: ListView(
                        children: [
                          buildCityCard("Dhaka", context, Color(0xFF007E95)),
                          buildCityCard("Chittagong", context, Color(0xFF004D65)),
                          buildCityCard("Sylhet", context, Color(0xFF003653)),
                          buildCityCard("Cox's Bazar", context, Color(0xFF007E95)),
                          buildCityCard("Sreemangal", context, Color(0xFF004D65)),
                          buildCityCard("Bandarban", context, Color(0xFF003653)),
                          buildCityCard("Rangamati", context, Color(0xFF007E95)),
                          buildCityCard("Khulna", context, Color(0xFF004D65)),
                          buildCityCard("Rajshahi", context, Color(0xFF003653)),
                          buildCityCard("Barisal", context, Color(0xFF007E95)),
                          buildCityCard("Pabna", context, Color(0xFF004D65)),
                          buildCityCard("Comilla", context, Color(0xFF003653)),
                          buildCityCard("Mymensingh", context, Color(0xFF007E95)),
                          buildCityCard("Dinajpur", context, Color(0xFF004D65)),
                          buildCityCard("Bogra", context, Color(0xFF003653)),
                        ],
                      ),
                    ),
                    SizedBox(height: 20),
                    Text(
                      "Overseas",
                      style: GoogleFonts.poppins(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    SizedBox(height: 10),
                    Expanded(
                      child: ListView(
                        children: [
                          buildCityCard("London", context, Color(0xFF007E95)),
                          buildCityCard("Paris", context, Color(0xFF004D65)),
                          buildCityCard("New York", context, Color(0xFF003653)),
                          buildCityCard("Tokyo", context, Color(0xFF007E95)),
                          buildCityCard("Kyoto", context, Color(0xFF004D65)),
                          buildCityCard("Edinburgh", context, Color(0xFF003653)),
                          buildCityCard("Singapore", context, Color(0xFF007E95)),
                          buildCityCard("Dubai", context, Color(0xFF004D65)),
                          buildCityCard("Sydney", context, Color(0xFF003653)),
                          buildCityCard("Bangkok", context, Color(0xFF007E95)),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // City Card Widget
  Widget buildCityCard(String city, BuildContext context, Color color) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => CityGuideScreen(city: city),
          ),
        );
      },
      child: Card(
        margin: EdgeInsets.symmetric(vertical: 10),
        color: color, // Apply the color to the card
        child: Padding(
          padding: EdgeInsets.all(15),
          child: Text(
            city,
            style: GoogleFonts.poppins(
              fontSize: 18,
              fontWeight: FontWeight.w600,
              color: Colors.white, // Ensure text is visible on the colored background
            ),
          ),
        ),
      ),
    );
  }
}

class CityGuideScreen extends StatelessWidget {
  final String city;

  CityGuideScreen({required this.city});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFF007E95), // Match the dashboard's gradient background
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 20, vertical: 20),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    city,
                    style: GoogleFonts.poppins(
                      color: Colors.white,
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  IconButton(
                    icon: Icon(Icons.arrow_back, color: Colors.white, size: 28),
                    onPressed: () {
                      Navigator.of(context).pop(); // Go back to the travel guides list
                    },
                  ),
                ],
              ),
            ),

            // City Guide Content
            Expanded(
              child: Container(
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(30),
                    topRight: Radius.circular(30),
                  ),
                ),
                padding: EdgeInsets.all(20),
                child: SingleChildScrollView(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      buildGuideSection("Brief Guide", getBriefGuide(city), context),
                      buildGuideSection("Must-Try Local Experiences", getLocalExperiences(city), context),
                      buildGuideSection("Travel Tips", getTravelTips(city), context),
                      buildGuideSection("Must-See Attractions", getAttractions(city), context),
                      buildGuideSection("Nightlife Highlights", getNightlife(city), context),
                      buildGuideSection("Where to Stay", getWhereToStay(city), context),
                      buildGuideSection("Food Guide", getFoodGuide(city), context),
                      buildGuideSection("Useful Guide", getUsefulGuide(city), context),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // Guide Section Widget
  Widget buildGuideSection(String title, String content, BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: GoogleFonts.poppins(
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
        ),
        SizedBox(height: 10),
        if (title == "Must-See Attractions")
          Column(
            children: getAttractionList(content).map((attraction) {
              return GestureDetector(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => AttractionDetailScreen(attractionName: attraction),
                    ),
                  );
                },
                child: Card(
                  margin: EdgeInsets.symmetric(vertical: 5),
                  child: Padding(
                    padding: EdgeInsets.all(15),
                    child: Text(
                      attraction,
                      style: GoogleFonts.poppins(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ),
              );
            }).toList(),
          )
        else
          Text(
            content,
            style: GoogleFonts.poppins(
              fontSize: 14,
            ),
          ),
        SizedBox(height: 20),
      ],
    );
  }

  // Dummy Data Functions (Replace with actual data)
  String getBriefGuide(String city) {
    return "This is a brief guide for $city. It includes an overview of the city's history, culture, and key highlights.";
  }

  String getLocalExperiences(String city) {
    return "Here are some must-try local experiences in $city. These activities will give you a true taste of the city's culture and lifestyle.";
  }

  String getTravelTips(String city) {
    return "Travel tips for $city. Learn about the best times to visit, local customs, and how to navigate the city.";
  }

  String getAttractions(String city) {
    return "Must-see attractions in $city. These are the top landmarks and places you shouldn't miss.";
  }

  List<String> getAttractionList(String content) {
    // Example attractions for each city
    if (city == "London") {
      return ["Big Ben", "London Eye", "Tower of London", "Buckingham Palace"];
    } else if (city == "Paris") {
      return ["Eiffel Tower", "Louvre Museum", "Notre-Dame Cathedral", "Montmartre"];
    } else if (city == "New York") {
      return ["Statue of Liberty", "Central Park", "Times Square", "Empire State Building"];
    } else {
      return ["Attraction 1", "Attraction 2", "Attraction 3"];
    }
  }

  String getNightlife(String city) {
    return "Nightlife highlights in $city. Discover the best bars, clubs, and entertainment spots.";
  }

  String getWhereToStay(String city) {
    return "Where to stay in $city. Recommendations for hotels, hostels, and accommodations.";
  }

  String getFoodGuide(String city) {
    return "Food guide for $city. Find the best restaurants, cafes, and local dishes to try.";
  }

  String getUsefulGuide(String city) {
    return "Useful guide for $city. Information on airports, transportation, buses, trains, and more.";
  }
}

class AttractionDetailScreen extends StatelessWidget {
  final String attractionName;

  AttractionDetailScreen({required this.attractionName});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFF007E95),
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 20, vertical: 20),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    attractionName,
                    style: GoogleFonts.poppins(
                      color: Colors.white,
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  IconButton(
                    icon: Icon(Icons.arrow_back, color: Colors.white, size: 28),
                    onPressed: () {
                      Navigator.of(context).pop();
                    },
                  ),
                ],
              ),
            ),

            // Attraction Details
            Expanded(
              child: Container(
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(30),
                    topRight: Radius.circular(30),
                  ),
                ),
                padding: EdgeInsets.all(20),
                child: SingleChildScrollView(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Booking Section
                      Text(
                        "Book",
                        style: GoogleFonts.poppins(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      SizedBox(height: 10),
                      Text(
                        "Booking options with prices will be displayed here.",
                        style: GoogleFonts.poppins(
                          fontSize: 14,
                        ),
                      ),
                      SizedBox(height: 20),

                      // Reviews & Info Section
                      Text(
                        "Reviews & Info",
                        style: GoogleFonts.poppins(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      SizedBox(height: 10),
                      Text(
                        "User reviews and information about the attraction.",
                        style: GoogleFonts.poppins(
                          fontSize: 14,
                        ),
                      ),
                      SizedBox(height: 20),

                      // Nearby Hotels Section
                      Text(
                        "Nearby",
                        style: GoogleFonts.poppins(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      SizedBox(height: 10),
                      Text(
                        "Nearby hotels with prices will be displayed here.",
                        style: GoogleFonts.poppins(
                          fontSize: 14,
                        ),
                      ),
                    ],
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