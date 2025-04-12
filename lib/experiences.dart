import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class ExperienceScreen extends StatefulWidget {
  const ExperienceScreen({super.key});

  @override
  _ExperienceScreenState createState() => _ExperienceScreenState();
}

class _ExperienceScreenState extends State<ExperienceScreen> {
  TextEditingController _locationController = TextEditingController();

  bool _isVisible = false; // For fade-in animation

  List<Map<String, dynamic>> _experiences = [
    {
      'title': 'Sunset Cruise in Cox\'s Bazar',
      'location': 'Cox\'s Bazar',
      'duration': '3 hours',
      'rating': 4.8,
      'image': 'https://www.bangladeshscenictours.com/wp-content/uploads/2019/11/Exploring-Coxs-Bazar.jpg',
    },
    {
      'title': 'Tea Garden Tour in Sreemangal',
      'location': 'Sreemangal',
      'duration': '5 hours',
      'rating': 4.5,
      'image': 'https://dynamic-media-cdn.tripadvisor.com/media/photo-o/18/6a/d3/1d/srimangal-is-an-upazila.jpg?w=700&h=-1&s=1',
    },
    {
      'title': 'Trekking in Bandarban',
      'location': 'Bandarban',
      'duration': '6 hours',
      'rating': 4.7,
      'image': 'https://ttg.com.bd/uploads/tours/plans/204_36376273530_3c9a0335f5_b-copyjpg.jpg',
    },
    {
      'title': 'Cultural Night in Sajek',
      'location': 'Sajek',
      'duration': '4 hours',
      'rating': 4.6,
      'image': 'https://images.pexels.com/photos/28672619/pexels-photo-28672619/free-photo-of-lush-green-hills-of-sajek-valley-in-bangladesh.jpeg?auto=compress&cs=tinysrgb&w=1260&h=750&dpr=2',
    },
  ];

  @override
  void initState() {
    super.initState();
    // Trigger animation after a slight delay
    Future.delayed(Duration(milliseconds: 100), () {
      setState(() {
        _isVisible = true;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    List<Map<String, dynamic>> filteredExperiences = _experiences
        .where((experience) =>
        experience['location']!
            .toLowerCase()
            .contains(_locationController.text.toLowerCase()))
        .toList();

    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Experiences',
          style: GoogleFonts.poppins(
            color: Colors.white,
            fontSize: 22,
            fontWeight: FontWeight.w600,
          ),
        ),
        backgroundColor: Color(0xFF003653),
        elevation: 0,
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => Navigator.pop(context),
        ),
      ),
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
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Animated Search Section (Location only)
                AnimatedOpacity(
                  opacity: _isVisible ? 1.0 : 0.0,
                  duration: Duration(milliseconds: 500),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Find Your Adventure',
                        style: GoogleFonts.poppins(
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                          shadows: [
                            Shadow(
                              color: Colors.black26,
                              offset: Offset(2, 2),
                              blurRadius: 4,
                            ),
                          ],
                        ),
                      ),
                      SizedBox(height: 20),
                      TextField(
                        controller: _locationController,
                        decoration: InputDecoration(
                          labelText: 'Location',
                          labelStyle: TextStyle(color: Colors.white70),
                          hintText: 'Enter location',
                          hintStyle: TextStyle(color: Colors.white54),
                          prefixIcon:
                          Icon(Icons.location_on, color: Colors.white70),
                          filled: true,
                          fillColor: Colors.white.withOpacity(0.2),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12),
                            borderSide: BorderSide.none,
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12),
                            borderSide: BorderSide(color: Colors.white70),
                          ),
                        ),
                        style: TextStyle(color: Colors.white),
                        onChanged: (value) => setState(() {}),
                      ),
                    ],
                  ),
                ),
                SizedBox(height: 20),

                // Available Experiences Heading
                Text(
                  'Available Experiences',
                  style: GoogleFonts.poppins(
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                    shadows: [
                      Shadow(
                        color: Colors.black26,
                        offset: Offset(2, 2),
                        blurRadius: 4,
                      ),
                    ],
                  ),
                ),
                SizedBox(height: 20),

                // Animated Experience Cards
                if (filteredExperiences.isEmpty)
                  Text(
                    'No experiences found',
                    style: GoogleFonts.poppins(
                      fontSize: 18,
                      color: Colors.white70,
                    ),
                  ),
                ...filteredExperiences.asMap().entries.map((entry) {
                  int index = entry.key;
                  var experience = entry.value;
                  return AnimatedOpacity(
                    opacity: _isVisible ? 1.0 : 0.0,
                    duration: Duration(milliseconds: 500 + index * 200),
                    child: buildExperienceCard(
                      context,
                      experience['title']!,
                      experience['location']!,
                      experience['duration']!,
                      experience['rating']!,
                      experience['image']!,
                    ),
                  );
                }).toList(),
              ],
            ),
          ),
        ),
      ),
    );
  }

  // Enhanced Experience Card Widget (No Price or Book Button)
  Widget buildExperienceCard(
      BuildContext context,
      String title,
      String location,
      String duration,
      double rating,
      String imageUrl,
      ) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: Card(
        elevation: 8,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        color: Colors.white.withOpacity(0.95),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Image Header
            ClipRRect(
              borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
              child: Image.network(
                imageUrl,
                height: 150,
                width: double.infinity,
                fit: BoxFit.cover,
                errorBuilder: (context, error, stackTrace) => Container(
                  height: 150,
                  color: Color(0xFF003653),
                  child: Center(
                    child: Icon(Icons.image_not_supported,
                        color: Colors.white, size: 40),
                  ),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: GoogleFonts.poppins(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF003653),
                    ),
                  ),
                  SizedBox(height: 5),
                  Text(
                    '$location - $duration',
                    style: GoogleFonts.poppins(
                      fontSize: 14,
                      color: Colors.black54,
                    ),
                  ),
                  SizedBox(height: 5),
                  Row(
                    children: [
                      Icon(Icons.star, size: 16, color: Colors.amber),
                      SizedBox(width: 5),
                      Text(
                        '$rating',
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
          ],
        ),
      ),
    );
  }
}