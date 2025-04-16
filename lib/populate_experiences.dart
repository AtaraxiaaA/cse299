import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class PopulateExperiencesScreen extends StatelessWidget {
  final List<Map<String, String>> experiencesData = [
    {
      "title": "Sunset Kayaking in Cox's Bazar",
      "location": "Cox's Bazar, Bangladesh",
      "description": "Paddle through the serene waters of Cox's Bazar beach as the sun sets, offering breathtaking views.",
      "image": "https://images.unsplash.com/photo-1507525428034-b723cf961d3e?ixlib=rb-4.0.3&auto=format&fit=crop&w=1350&q=80",
      "category": "Adventure",
    },
    {
      "title": "Tea Tasting in Sreemangal",
      "location": "Sreemangal, Sylhet, Bangladesh",
      "description": "Experience the rich tea culture of Sreemangal with a guided tea-tasting tour in the lush tea gardens.",
      "image": "https://images.unsplash.com/photo-1600585154340-be6161a56a0c?ixlib=rb-4.0.3&auto=format&fit=crop&w=1350&q=80",
      "category": "Cultural",
    },
    {
      "title": "Hiking in Chittagong Hill Tracts",
      "location": "Chittagong, Bangladesh",
      "description": "Trek through the scenic trails of Shitakunda Eco Park, discovering waterfalls and ancient temples.",
      "image": "https://images.unsplash.com/photo-1519125323398-675f398f6978?ixlib=rb-4.0.3&auto=format&fit=crop&w=1350&q=80",
      "category": "Adventure",
    },
    {
      "title": "Boat Ride on Kaptai Lake",
      "location": "Rangamati, Bangladesh",
      "description": "Enjoy a peaceful boat ride on Kaptai Lake, surrounded by lush hills and tribal villages.",
      "image": "https://images.unsplash.com/photo-1592194996308-7b43878e84a6?ixlib=rb-4.0.3&auto=format&fit=crop&w=1350&q=80",
      "category": "Nature",
    },
  ];

  Future<void> _populateExperiences() async {
    try {
      final collection = FirebaseFirestore.instance.collection('experiences');
      for (var experience in experiencesData) {
        await collection.add(experience);
      }
      print("Experiences populated successfully!");
    } catch (e) {
      print("Error populating experiences: $e");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFF007E95),
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 20, vertical: 20),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    "Populate Experiences",
                    style: GoogleFonts.poppins(
                      color: Colors.white,
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  IconButton(
                    icon: Icon(Icons.arrow_back, color: Colors.white, size: 28),
                    onPressed: () => Navigator.of(context).pop(),
                  ),
                ],
              ),
            ),
            Center(
              child: ElevatedButton(
                onPressed: () async {
                  await _populateExperiences();
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text("Experiences populated successfully!")),
                  );
                },
                child: Padding(
                  padding: EdgeInsets.symmetric(horizontal: 30, vertical: 15),
                  child: Text(
                    "Populate Experiences",
                    style: GoogleFonts.poppins(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Color(0xFF264653),
                  foregroundColor: Colors.white,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(30),
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