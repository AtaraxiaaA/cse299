import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class TourPackagesScreen extends StatelessWidget {
  // List of tour packages with image URLs
  final List<Map<String, String>> tourPackages = [
    {
      "name": "Tour de Coxsbazar",
      "location": "Cox's Bazar, Bangladesh",
      "description": "Explore the world's longest natural sea beach.",
      "image": "https://dynamic-media-cdn.tripadvisor.com/media/photo-o/10/e2/f8/43/longest-sea-beach-in.jpg?w=1100&h=1100&s=1",
    },
    {
      "name": "Tour de Sreemangal",
      "location": "Sreemangal, Sylhet, Bangladesh",
      "description": "Discover the tea capital of Bangladesh.",
      "image": "https://pathfriend-bd.com/wp-content/uploads/2021/01/Sreemangal-Tea-Estate-and-Museum.gif",
    },
    {
      "name": "Shitakunda",
      "location": "Chittagong, Bangladesh",
      "description": "Visit the ancient Buddhist temples and waterfalls.",
      "image": "https://live.staticflickr.com/4437/36981961226_b2d8075889_b.jpg",
    },
    {
      "name": "Shajek",
      "location": "Rangamati, Bangladesh",
      "description": "Experience the beauty of the hills and valleys.",
      "image": "https://cdn.pixabay.com/photo/2019/12/12/15/16/bangladesh-4690978_1280.jpg",
    },
  ];

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
                    "Tour Packages",
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

            // Tour Packages List
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
                child: ListView.builder(
                  itemCount: tourPackages.length,
                  itemBuilder: (context, index) {
                    final package = tourPackages[index];
                    return GestureDetector(
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => TourPackageDetailsScreen(package: package),
                          ),
                        );
                      },
                      child: Card(
                        elevation: 8,
                        margin: EdgeInsets.symmetric(vertical: 10),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            // Image Header
                            ClipRRect(
                              borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
                              child: Image.network(
                                package["image"]!,
                                height: 150,
                                width: double.infinity,
                                fit: BoxFit.cover,
                                errorBuilder: (context, error, stackTrace) => Container(
                                  height: 150,
                                  color: Color(0xFF003653),
                                  child: Center(
                                    child: Icon(
                                      Icons.image_not_supported,
                                      color: Colors.white,
                                      size: 40,
                                    ),
                                  ),
                                ),
                              ),
                            ),
                            Padding(
                              padding: EdgeInsets.all(15),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    package["name"]!,
                                    style: GoogleFonts.poppins(
                                      fontSize: 18,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  SizedBox(height: 5),
                                  Text(
                                    package["location"]!,
                                    style: GoogleFonts.poppins(
                                      fontSize: 14,
                                      color: Colors.grey,
                                    ),
                                  ),
                                  SizedBox(height: 10),
                                  Text(
                                    package["description"]!,
                                    style: GoogleFonts.poppins(
                                      fontSize: 14,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class TourPackageDetailsScreen extends StatelessWidget {
  final Map<String, String> package;

  TourPackageDetailsScreen({required this.package});

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
                    package["name"]!,
                    style: GoogleFonts.poppins(
                      color: Colors.white,
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  IconButton(
                    icon: Icon(Icons.arrow_back, color: Colors.white, size: 28),
                    onPressed: () {
                      Navigator.of(context).pop(); // Go back to the tour packages list
                    },
                  ),
                ],
              ),
            ),

            // Tour Package Details
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
                      "Location: ${package["location"]!}",
                      style: GoogleFonts.poppins(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    SizedBox(height: 10),
                    Text(
                      package["description"]!,
                      style: GoogleFonts.poppins(
                        fontSize: 14,
                      ),
                    ),
                    SizedBox(height: 20),

                    // Booking Section
                    Text(
                      "Book Your Tour",
                      style: GoogleFonts.poppins(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    SizedBox(height: 10),
                    buildBookingOption("1-Day Ticket + 1 Hour Early Park Entry Pass", "৳2,500"),
                    buildBookingOption("Family Package (2 Adults + 1 Child)", "৳6,000"),
                    buildBookingOption("3 Persons Package", "৳7,500"),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // Booking Option Widget
  Widget buildBookingOption(String title, String price) {
    return Card(
      margin: EdgeInsets.symmetric(vertical: 10),
      child: Padding(
        padding: EdgeInsets.all(15),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              title,
              style: GoogleFonts.poppins(
                fontSize: 16,
                fontWeight: FontWeight.w600,
              ),
            ),
            SizedBox(height: 5),
            Text(
              "Price: $price",
              style: GoogleFonts.poppins(
                fontSize: 14,
                color: Colors.green,
              ),
            ),
            SizedBox(height: 10),
            ElevatedButton(
              onPressed: () {
                // Add booking functionality
              },
              child: Text("Select Option"),
              style: ElevatedButton.styleFrom(
                backgroundColor: Color(0xFF264653),
                foregroundColor: Colors.white,
              ),
            ),
          ],
        ),
      ),
    );
  }
}