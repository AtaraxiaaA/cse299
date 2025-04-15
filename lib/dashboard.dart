import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:tourify_sample_project/HotelHomePage.dart';
import 'listofhotels.dart';
import 'profile.dart';
import 'tourpackages.dart';
import 'TravelGuides.dart';
import 'Rewards&Discounts.dart';
import 'customersupport.dart';
import 'experiences.dart';
import 'flight.dart';
import 'TrainHomePage.dart';
import 'AuthScreen.dart';

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
              Color(0xFF007E95),
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

              // Icon Menu
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
                          MaterialPageRoute(builder: (context) => FlightScreen()),
                        );
                      },
                      child: buildIconCard(Icons.flight, "Flights"),
                    ),
                    GestureDetector(
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) => HotelHomePage()),
                        );
                      },
                      child: buildIconCard(Icons.hotel, "Hotels"),
                    ),
                    buildIconCard(Icons.directions_car, "Car Rentals"),
                    GestureDetector(
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) => TourPackagesScreen()),
                        );
                      },
                      child: buildIconCard(Icons.tour, "Tour Packages"),
                    ),
                  ],
                ),
              ),

              // Second Row
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
                          MaterialPageRoute(builder: (context) => ExperienceScreen()),
                        );
                      },
                      child: buildIconCard(Icons.explore, "Experiences"),
                    ),
                    GestureDetector(
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) => TrainHomePage()),
                        );
                      },
                      child: buildIconCard(Icons.train, "Train"),
                    ),
                    buildIconCard(Icons.airport_shuttle, "Transfers"),
                    GestureDetector(
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) => TravelGuidesScreen()),
                        );
                      },
                      child: buildIconCard(Icons.map, "Travel Guides"),
                    ),
                  ],
                ),
              ),

              // Additional Features Section
              Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 20,
                  vertical: 20,
                ),
                child: Column(
                  children: [
                    GestureDetector(
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) => CustomerSupportScreen()),
                        );
                      },
                      child: buildFeatureCard(
                        icon: Icons.support_agent,
                        title: "Customer Support in Seconds",
                        description: "Get instant help with your bookings.",
                      ),
                    ),
                    SizedBox(height: 20),
                    buildFeatureCard(
                      icon: Icons.verified_user,
                      title: "Travel Worry-free",
                      description: "Enjoy a seamless travel experience.",
                    ),
                    SizedBox(height: 20),
                    GestureDetector(
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) => RewardsDiscountsScreen()),
                        );
                      },
                      child: buildFeatureCard(
                        icon: Icons.discount,
                        title: "Exclusive Rewards & Discounts",
                        description: "Save with exclusive deals and rewards.",
                      ),
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

  Widget buildDestinationCard(String destination, BuildContext context) {
    return GestureDetector(
      onTap: () {
        showModalBottomSheet(
          context: context,
          isScrollControlled: true,
          builder: (BuildContext context) {
            return Container(
              padding: EdgeInsets.all(20),
              height: MediaQuery.of(context).size.height * 0.9,
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
                        icon: Icon(Icons.close, color: Color(0xFF264653)),
                        onPressed: () => Navigator.pop(context),
                      ),
                    ],
                  ),
                  SizedBox(height: 10),
                  Expanded(
                    child: ListView.builder(
                      itemCount: hotels[destination]?.length ?? 0,
                      itemBuilder: (context, index) {
                        final hotel = hotels[destination]![index];
                        return GestureDetector(
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => HotelBookingDetailsScreen(
                                  hotelName: hotel["name"],
                                  location: hotel["location"] ?? destination,
                                  priceRange: hotel["price"],
                                  rating: hotel["rating"],
                                  reviews: hotel["reviews"],
                                  features: hotel["features"] ?? "Luxury hotel with premium amenities",
                                  discount: hotel["discount"] ?? "",
                                ),
                              ),
                            );
                          },
                          child: Card(
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
                                  if (hotel["location"] != null)
                                    Text(
                                      hotel["location"],
                                      style: GoogleFonts.poppins(
                                        fontSize: 14,
                                        color: Colors.grey,
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
                                    "Price: ${hotel["price"]}",
                                    style: GoogleFonts.poppins(
                                      fontSize: 14,
                                      color: Colors.green,
                                    ),
                                  ),
                                  if (hotel["discount"] != null)
                                    Text(
                                      "Special Offer: ${hotel["discount"]}",
                                      style: GoogleFonts.poppins(
                                        fontSize: 14,
                                        color: Colors.orange,
                                      ),
                                    ),
                                ],
                              ),
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
//latest change emu

class HotelBookingDetailsScreen extends StatefulWidget {
  final String hotelName;
  final String location;
  final String priceRange;
  final double rating;
  final int reviews;
  final String features;
  final String discount;

  const HotelBookingDetailsScreen({
    required this.hotelName,
    required this.location,
    required this.priceRange,
    required this.rating,
    required this.reviews,
    required this.features,
    required this.discount,
  });

  @override
  _HotelBookingDetailsScreenState createState() => _HotelBookingDetailsScreenState();
}

class _HotelBookingDetailsScreenState extends State<HotelBookingDetailsScreen> {
  int selectedDuration = 1; // Track selected duration
  int selectedStars = 0; // Track star rating

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Row(
          children: [
            // Placeholder for hotel image - you can replace with actual image
            Container(
              width: 40,
              height: 40,
              margin: EdgeInsets.only(right: 10),
              decoration: BoxDecoration(
                color: Color(0xFF005254),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Icon(Icons.hotel, color: Colors.white),
            ),
            Text(widget.hotelName,
                style: GoogleFonts.poppins(color: Colors.white,fontWeight: FontWeight.w600),
            ),
          ],
        ),
        backgroundColor: Color(0xFF00292a),
        iconTheme: IconThemeData(color: Colors.white),
      ),
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              Color(0xFF00292a),
              Color(0xFF003e3f),
              Color(0xFF005254),
              Color(0xFF009092),
            ],
            stops: [0.0, 0.3, 0.6, 1.0],
          ),
        ),
        child: SingleChildScrollView(
          padding: EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Hotel Info Section
              Container(
                padding: EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.2),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        // Hotel image placeholder - replace with actual image
                        Container(
                          width: 60,
                          height: 60,
                          decoration: BoxDecoration(
                            color: Color(0xFF005254),
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: Icon(Icons.hotel, color: Colors.white, size: 30),
                        ),
                        SizedBox(width: 16),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                widget.hotelName,
                                style: GoogleFonts.poppins(
                                  fontSize: 20,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.white,
                                ),
                              ),
                              SizedBox(height: 4),
                              Text(
                                widget.location,
                                style: GoogleFonts.poppins(
                                  fontSize: 14,
                                  color: Colors.white70,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: 16),
                    Row(
                      children: [
                        Icon(Icons.star, color: Colors.amber, size: 20),
                        SizedBox(width: 4),
                        Text(
                          "${widget.rating} (${widget.reviews} reviews)",
                          style: GoogleFonts.poppins(
                            color: Colors.white,
                            fontSize: 14,
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: 8),
                    Text(
                      "Features:",
                      style: GoogleFonts.poppins(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                    SizedBox(height: 4),
                    Text(
                      widget.features,
                      style: GoogleFonts.poppins(
                        color: Colors.white70,
                      ),
                    ),
                    SizedBox(height: 8),
                    Container(
                      padding: EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        color: Colors.white.withOpacity(0.3),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Text(
                        "Price: ${widget.priceRange}",
                        style: GoogleFonts.poppins(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                    ),
                    if (widget.discount.isNotEmpty)
                      Column(
                        children: [
                          SizedBox(height: 8),
                          Container(
                            padding: EdgeInsets.all(8),
                            decoration: BoxDecoration(
                              color: Colors.orange.withOpacity(0.3),
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: Text(
                              "Special Offer: ${widget.discount}",
                              style: GoogleFonts.poppins(
                                fontSize: 14,
                                fontWeight: FontWeight.bold,
                                color: Colors.white,
                              ),
                            ),
                          ),
                        ],
                      ),
                  ],
                ),
              ),
              SizedBox(height: 24),

              // Booking Options Section
              Container(
                padding: EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.2),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "Booking Options",
                      style: GoogleFonts.poppins(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                    SizedBox(height: 16),
                    Text(
                      "Select Date",
                      style: GoogleFonts.poppins(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                        color: Colors.white,
                      ),
                    ),
                    SizedBox(height: 8),
                    Container(
                      padding: EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            "April 2025",
                            style: GoogleFonts.poppins(),
                          ),
                          Icon(Icons.calendar_today),
                        ],
                      ),
                    ),
                    SizedBox(height: 16),
                    Container(
                      padding: EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: CalendarDatePicker(
                        initialDate: DateTime.now(),
                        firstDate: DateTime.now(),
                        lastDate: DateTime(2025, 12, 31),
                        onDateChanged: (date) {},
                      ),
                    ),
                    SizedBox(height: 16),
                    Text(
                      "Select Duration",
                      style: GoogleFonts.poppins(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                        color: Colors.white,
                      ),
                    ),
                    SizedBox(height: 8),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        _buildDurationOption("1 Night", 1, context),
                        _buildDurationOption("2 Nights", 2, context),
                        _buildDurationOption("3 Nights", 3, context),
                      ],
                    ),
                  ],
                ),
              ),
              SizedBox(height: 24),

              // Reviews Section
              Container(
                padding: EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.2),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "Reviews",
                      style: GoogleFonts.poppins(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                    SizedBox(height: 8),
                    ListTile(
                      leading: CircleAvatar(
                        backgroundColor: Color(0xFF005254),
                        child: Icon(Icons.person, color: Colors.white),
                      ),
                      title: Text(
                        "John Doe",
                        style: GoogleFonts.poppins(color: Colors.white),
                      ),
                      subtitle: Text(
                        "Amazing place! Would definitely stay again.",
                        style: GoogleFonts.poppins(color: Colors.white70),
                      ),
                      trailing: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(Icons.star, color: Colors.amber, size: 16),
                          Text(
                            "5.0",
                            style: GoogleFonts.poppins(color: Colors.white),
                          ),
                        ],
                      ),
                    ),
                    Divider(color: Colors.white54),
                    ListTile(
                      leading: CircleAvatar(
                        backgroundColor: Color(0xFF005254),
                        child: Icon(Icons.person, color: Colors.white),
                      ),
                      title: Text(
                        "Sarah Smith",
                        style: GoogleFonts.poppins(color: Colors.white),
                      ),
                      subtitle: Text(
                        "Great location but rooms could be cleaner",
                        style: GoogleFonts.poppins(color: Colors.white70),
                      ),
                      trailing: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(Icons.star, color: Colors.amber, size: 16),
                          Text(
                            "4.0",
                            style: GoogleFonts.poppins(color: Colors.white),
                          ),
                        ],
                      ),
                    ),
                    SizedBox(height: 16),
                    ElevatedButton(
                      onPressed: () {
                        _showAddReviewDialog(context);
                      },
                      child: Text("Add Your Review",
                          style: GoogleFonts.poppins(color: Colors.white),
                      ),

                      style: ElevatedButton.styleFrom(
                        backgroundColor: Color(0xFF005254),
                        minimumSize: Size(double.infinity, 50),
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(height: 24),
              ElevatedButton(
                onPressed: () {
                  _showBookingConfirmation(context);
                },
                child: Text("Book Now"),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.greenAccent,
                  minimumSize: Size(double.infinity, 50),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildDurationOption(String text, int duration, BuildContext context) {
    return GestureDetector(
      onTap: () {
        setState(() {
          selectedDuration = duration;
        });
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("Selected $text")),
        );
      },
      child: Container(
        padding: EdgeInsets.symmetric(vertical: 12, horizontal: 16),
        decoration: BoxDecoration(
          color: selectedDuration == duration ? Color(0xFF005254) : Colors.transparent,
          border: Border.all(
            color: selectedDuration == duration ? Colors.transparent : Color(0xFF005254),
          ),
          borderRadius: BorderRadius.circular(8),
        ),
        child: Text(
          text,
          style: GoogleFonts.poppins(
            color: Colors.white,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
    );
  }

  void _showAddReviewDialog(BuildContext context) {
    int tempStars = selectedStars;

    showDialog(
      context: context,
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setState) {
            return AlertDialog(
              backgroundColor: Color(0xFF003e3f),
              title: Text(
                "Add Your Review",
                style: GoogleFonts.poppins(color: Colors.white),
              ),
              content: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  TextField(
                    decoration: InputDecoration(
                      labelText: "Your Name",
                      labelStyle: GoogleFonts.poppins(color: Colors.white70),
                      enabledBorder: UnderlineInputBorder(
                        borderSide: BorderSide(color: Colors.white54),
                      ),
                      focusedBorder: UnderlineInputBorder(
                        borderSide: BorderSide(color: Colors.white),
                      ),
                    ),
                    style: GoogleFonts.poppins(color: Colors.white),
                  ),
                  SizedBox(height: 16),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        "Rating:",
                        style: GoogleFonts.poppins(color: Colors.white),
                      ),
                      SizedBox(width: 8),
                      for (int i = 1; i <= 5; i++)
                        GestureDetector(
                          onTap: () {
                            setState(() {
                              tempStars = i;
                            });
                          },
                          child: Icon(
                            i <= tempStars ? Icons.star : Icons.star_border,
                            color: Colors.amber,
                            size: 30,
                          ),
                        ),
                    ],
                  ),
                  SizedBox(height: 16),
                  TextField(
                    decoration: InputDecoration(
                      labelText: "Your Review",
                      labelStyle: GoogleFonts.poppins(color: Colors.white70),
                      enabledBorder: UnderlineInputBorder(
                        borderSide: BorderSide(color: Colors.white54),
                      ),
                      focusedBorder: UnderlineInputBorder(
                        borderSide: BorderSide(color: Colors.white),
                      ),
                    ),
                    style: GoogleFonts.poppins(color: Colors.white),
                    maxLines: 3,
                  ),
                ],
              ),
              actions: [
                TextButton(
                  onPressed: () => Navigator.pop(context),
                  child: Text(
                    "Cancel",
                    style: GoogleFonts.poppins(color: Colors.white),
                  ),
                ),
                ElevatedButton(
                  onPressed: () {
                    setState(() {
                      selectedStars = tempStars;
                    });
                    Navigator.pop(context);
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text("Review submitted successfully!")),
                    );
                  },
                  child: Text("Submit"),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Color(0xFF005254),
                  ),
                ),
              ],
            );
          },
        );
      },
    );
  }

  void _showBookingConfirmation(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          backgroundColor: Color(0xFF003e3f),
          title: Text(
            "Confirm Booking",
            style: GoogleFonts.poppins(color: Colors.white),
          ),
          content: Text(
            "Are you sure you want to book ${widget.hotelName} for $selectedDuration night(s)?",
            style: GoogleFonts.poppins(color: Colors.white),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: Text(
                "Cancel",
                style: GoogleFonts.poppins(color: Colors.white),
              ),
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.pop(context);
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text("Booking confirmed for ${widget.hotelName}!")),
                );
              },
              child: Text("Confirm"),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.green,
              ),
            ),
          ],
        );
      },
    );
  }
}