import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class TourPackagesScreen extends StatelessWidget {
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
                      Navigator.of(context).pop();
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
                child: StreamBuilder<QuerySnapshot>(
                  stream: FirebaseFirestore.instance.collection('tourpackage').snapshots(),
                  builder: (context, snapshot) {
                    if (snapshot.hasError) {
                      return Center(child: Text('Error: ${snapshot.error}', style: GoogleFonts.poppins()));
                    }
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return Center(child: CircularProgressIndicator());
                    }

                    final tourPackages = snapshot.data!.docs.map((doc) {
                      final data = doc.data() as Map<String, dynamic>;
                      return {
                        "name": data['name'] as String,
                        "location": data['location'] as String,
                        "description": data['description'] as String,
                        "image": data['image'] as String,
                      };
                    }).toList();

                    if (tourPackages.isEmpty) {
                      return Center(child: Text("No tour packages available.", style: GoogleFonts.poppins()));
                    }

                    return ListView.builder(
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
                      Navigator.of(context).pop();
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
                    buildBookingOption("1-Day Ticket + 1 Hour Early Park Entry Pass", 2500, context),
                    buildBookingOption("Family Package (2 Adults + 1 Child)", 6000, context),
                    buildBookingOption("3 Persons Package", 7500, context),
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
  Widget buildBookingOption(String title, int price, BuildContext context) {
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
              "Price: ৳${price.toStringAsFixed(2)}",
              style: GoogleFonts.poppins(
                fontSize: 14,
                color: Colors.green,
              ),
            ),
            SizedBox(height: 10),
            ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => BookingDetailsScreen(
                      packageName: package["name"]!,
                      location: package["location"]!,
                      optionName: title,
                      originalPrice: price,
                    ),
                  ),
                );
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

class BookingDetailsScreen extends StatefulWidget {
  final String packageName;
  final String location;
  final String optionName;
  final int originalPrice;

  const BookingDetailsScreen({
    required this.packageName,
    required this.location,
    required this.optionName,
    required this.originalPrice,
  });

  @override
  _BookingDetailsScreenState createState() => _BookingDetailsScreenState();
}

class _BookingDetailsScreenState extends State<BookingDetailsScreen> {
  final TextEditingController _couponController = TextEditingController();
  bool _couponApplied = false;
  double _discountedPrice = 0;
  DateTime? _selectedDate;
  TimeOfDay? _selectedTime;

  // Tour guides data for each location
  final Map<String, List<Map<String, String>>> tourGuides = {
    "Cox's Bazar, Bangladesh": [
      {
        "name": "Rahim Khan",
        "background": "Local expert with deep knowledge of Cox's Bazar's beaches and culture.",
        "tours": "150+ tours conducted"
      },
      {
        "name": "Ayesha Begum",
        "background": "Marine enthusiast, specializes in coastal history and seafood tours.",
        "tours": "120+ tours conducted"
      },
      {
        "name": "Sajid Ahmed",
        "background": "Adventure guide, focuses on water sports and hidden beach spots.",
        "tours": "90+ tours conducted"
      },
    ],
    "Sreemangal, Sylhet, Bangladesh": [
      {
        "name": "Mina Rahman",
        "background": "Tea estate expert, born and raised in Sreemangal.",
        "tours": "200+ tours conducted"
      },
      {
        "name": "Kamal Hossain",
        "background": "Wildlife enthusiast, specializes in Lawachara National Park tours.",
        "tours": "180+ tours conducted"
      },
      {
        "name": "Rina Akter",
        "background": "Cultural guide, focuses on local tribes and tea traditions.",
        "tours": "110+ tours conducted"
      },
    ],
    "Chittagong, Bangladesh": [
      {
        "name": "Arif Chowdhury",
        "background": "Historian with expertise in Shitakunda's Buddhist heritage.",
        "tours": "160+ tours conducted"
      },
      {
        "name": "Fatima Noor",
        "background": "Nature guide, specializes in waterfall and hiking tours.",
        "tours": "130+ tours conducted"
      },
      {
        "name": "Zahir Uddin",
        "background": "Local explorer, known for uncovering hidden gems in Chittagong.",
        "tours": "95+ tours conducted"
      },
    ],
    "Rangamati, Bangladesh": [
      {
        "name": "Shyamal Tripura",
        "background": "Indigenous guide with deep knowledge of Rangamati's tribal culture.",
        "tours": "140+ tours conducted"
      },
      {
        "name": "Laila Akter",
        "background": "Hill tract specialist, focuses on scenic boat tours in Kaptai Lake.",
        "tours": "115+ tours conducted"
      },
      {
        "name": "Ratan Das",
        "background": "Adventure guide, expert in Shajek's trekking routes.",
        "tours": "80+ tours conducted"
      },
    ],
  };

  // Hotel options for each location
  final Map<String, List<Map<String, String>>> hotels = {
    "Cox's Bazar, Bangladesh": [
      {
        "name": "Sayeman Beach Resort",
        "description": "Oceanfront rooms, infinity pool, rooftop restaurant.",
        "price": "BDT 10,000 per night"
      },
      {
        "name": "Royal Tulip Sea Pearl",
        "description": "5-star beachfront resort, private beach access, spa.",
        "price": "BDT 15,000 per night"
      },
    ],
    "Sreemangal, Sylhet, Bangladesh": [
      {
        "name": "Grand Sultan Tea Resort",
        "description": "5-star tea garden resort, golf course, infinity pool.",
        "price": "BDT 12,000 per night"
      },
      {
        "name": "Lemon Garden Resort",
        "description": "Eco-friendly stay, surrounded by tea gardens.",
        "price": "BDT 8,000 per night"
      },
    ],
    "Chittagong, Bangladesh": [
      {
        "name": "The Peninsula Chittagong",
        "description": "Business-friendly hotel, rooftop lounge, sauna.",
        "price": "BDT 7,000 per night"
      },
      {
        "name": "Hotel Agrabad",
        "description": "Classic luxury, outdoor pool, Thai spa.",
        "price": "BDT 6,500 per night"
      },
    ],
    "Rangamati, Bangladesh": [
      {
        "name": "Parjatan Motel",
        "description": "Scenic views of Kaptai Lake, budget-friendly.",
        "price": "BDT 5,000 per night"
      },
      {
        "name": "Lake View Resort",
        "description": "Hilltop stay, panoramic views, cozy cabins.",
        "price": "BDT 7,500 per night"
      },
    ],
  };

  // Places to visit for each location
  final Map<String, List<Map<String, String>>> placesToVisit = {
    "Cox's Bazar, Bangladesh": [
      {
        "name": "Cox's Bazar Beach",
        "description": "World's longest natural sea beach, perfect for sunset views."
      },
      {
        "name": "Himchari National Park",
        "description": "Lush greenery, waterfalls, and wildlife spotting."
      },
      {
        "name": "Inani Beach",
        "description": "Pristine beach with coral stones, ideal for relaxation."
      },
    ],
    "Sreemangal, Sylhet, Bangladesh": [
      {
        "name": "Lawachara National Park",
        "description": "Biodiverse forest with hiking trails and rare wildlife."
      },
      {
        "name": "Madhabpur Lake",
        "description": "Scenic lake surrounded by tea gardens, great for photography."
      },
      {
        "name": "Baikka Beel",
        "description": "Wetland sanctuary, perfect for bird watching."
      },
    ],
    "Chittagong, Bangladesh": [
      {
        "name": "Shitakunda Eco Park",
        "description": "Nature park with hiking trails and waterfalls."
      },
      {
        "name": "Chandranath Temple",
        "description": "Ancient hilltop temple with panoramic views."
      },
      {
        "name": "Khoiyachora Waterfall",
        "description": "Seven-layered waterfall, a hidden gem for adventurers."
      },
    ],
    "Rangamati, Bangladesh": [
      {
        "name": "Kaptai Lake",
        "description": "Largest man-made lake, ideal for boat rides."
      },
      {
        "name": "Hanging Bridge",
        "description": "Iconic bridge over Kaptai Lake, great for photos."
      },
      {
        "name": "Shuvolong Waterfall",
        "description": "Scenic waterfall accessible by boat, surrounded by hills."
      },
    ],
  };

  @override
  void initState() {
    super.initState();
    _discountedPrice = widget.originalPrice.toDouble();
  }

  void _applyCoupon() {
    if (_couponController.text.trim().toUpperCase() == "HAPPYTOUR") {
      setState(() {
        _couponApplied = true;
        _discountedPrice = widget.originalPrice * 0.85; // 15% discount
      });
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Coupon applied successfully! 15% discount added.")),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Invalid coupon code. Please try again.")),
      );
    }
  }

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime.now(),
      lastDate: DateTime(2025, 12, 31),
    );
    if (picked != null && picked != _selectedDate) {
      setState(() {
        _selectedDate = picked;
      });
    }
  }

  Future<void> _selectTime(BuildContext context) async {
    final TimeOfDay? picked = await showTimePicker(
      context: context,
      initialTime: TimeOfDay.now(),
    );
    if (picked != null && picked != _selectedTime) {
      setState(() {
        _selectedTime = picked;
      });
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
            // Header
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 20, vertical: 20),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    "Booking Details",
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

            // Booking Details
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
                      Text(
                        "Package: ${widget.packageName}",
                        style: GoogleFonts.poppins(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      SizedBox(height: 10),
                      Text(
                        "Option: ${widget.optionName}",
                        style: GoogleFonts.poppins(
                          fontSize: 16,
                        ),
                      ),
                      SizedBox(height: 20),
                      Text(
                        "Original Price: ৳${widget.originalPrice.toStringAsFixed(2)}",
                        style: GoogleFonts.poppins(
                          fontSize: 16,
                        ),
                      ),
                      SizedBox(height: 20),

                      // Coupon Code Section
                      Text(
                        "Apply Coupon Code",
                        style: GoogleFonts.poppins(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      SizedBox(height: 10),
                      Row(
                        children: [
                          Expanded(
                            child: TextField(
                              controller: _couponController,
                              decoration: InputDecoration(
                                hintText: "Enter coupon code",
                                border: OutlineInputBorder(),
                              ),
                            ),
                          ),
                          SizedBox(width: 10),
                          ElevatedButton(
                            onPressed: _applyCoupon,
                            child: Text("Apply"),
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Color(0xFF264653),
                              foregroundColor: Colors.white,
                            ),
                          ),
                        ],
                      ),
                      SizedBox(height: 20),

                      // Discounted Price Display
                      if (_couponApplied)
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              "Discount: 15%",
                              style: GoogleFonts.poppins(
                                fontSize: 16,
                                color: Colors.green,
                              ),
                            ),
                            SizedBox(height: 10),
                            Text(
                              "Discounted Price: ৳${_discountedPrice.toStringAsFixed(2)}",
                              style: GoogleFonts.poppins(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                                color: Colors.green,
                              ),
                            ),
                            SizedBox(height: 20),
                          ],
                        ),

                      // Date and Time Selection
                      Text(
                        "Select Date and Time",
                        style: GoogleFonts.poppins(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      SizedBox(height: 10),
                      Row(
                        children: [
                          ElevatedButton(
                            onPressed: () => _selectDate(context),
                            child: Text(
                              _selectedDate == null
                                  ? "Select Date"
                                  : "Date: ${_selectedDate!.day}/${_selectedDate!.month}/${_selectedDate!.year}",
                            ),
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Color(0xFF264653),
                              foregroundColor: Colors.white,
                            ),
                          ),
                          SizedBox(width: 10),
                          ElevatedButton(
                            onPressed: () => _selectTime(context),
                            child: Text(
                              _selectedTime == null
                                  ? "Select Time"
                                  : "Time: ${_selectedTime!.format(context)}",
                            ),
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Color(0xFF264653),
                              foregroundColor: Colors.white,
                            ),
                          ),
                        ],
                      ),
                      SizedBox(height: 30),

                      // Calendar View
                      Text(
                        "Available Dates",
                        style: GoogleFonts.poppins(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      SizedBox(height: 10),
                      _buildCalendar(),
                      SizedBox(height: 20),

                      // Tour Guides Section
                      Text(
                        "Tour Guides",
                        style: GoogleFonts.poppins(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      SizedBox(height: 10),
                      GridView.builder(
                        shrinkWrap: true,
                        physics: NeverScrollableScrollPhysics(),
                        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 2,
                          crossAxisSpacing: 10,
                          mainAxisSpacing: 10,
                          childAspectRatio: 0.8,
                        ),
                        itemCount: tourGuides[widget.location]!.length,
                        itemBuilder: (context, index) {
                          final guide = tourGuides[widget.location]![index];
                          return Card(
                            child: Container(
                              decoration: BoxDecoration(
                                gradient: LinearGradient(
                                  colors: [Color(0xFF013550), Color(0xFF0A3C43)],
                                  begin: Alignment.topLeft,
                                  end: Alignment.bottomRight,
                                ),
                                borderRadius: BorderRadius.circular(10),
                              ),
                              padding: EdgeInsets.all(10),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    guide["name"]!,
                                    style: GoogleFonts.poppins(
                                      fontSize: 16,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.white,
                                    ),
                                  ),
                                  SizedBox(height: 5),
                                  Text(
                                    guide["background"]!,
                                    style: GoogleFonts.poppins(
                                      fontSize: 12,
                                      color: Colors.white70,
                                    ),
                                    maxLines: 3,
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                  Spacer(),
                                  Text(
                                    guide["tours"]!,
                                    style: GoogleFonts.poppins(
                                      fontSize: 12,
                                      color: Colors.white,
                                      fontWeight: FontWeight.w500,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          );
                        },
                      ),
                      SizedBox(height: 20),

                      // Hotel/Stay Selection Section
                      Text(
                        "Hotel/Stay Selection",
                        style: GoogleFonts.poppins(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      SizedBox(height: 10),
                      GridView.builder(
                        shrinkWrap: true,
                        physics: NeverScrollableScrollPhysics(),
                        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 2,
                          crossAxisSpacing: 10,
                          mainAxisSpacing: 10,
                          childAspectRatio: 0.8,
                        ),
                        itemCount: hotels[widget.location]!.length,
                        itemBuilder: (context, index) {
                          final hotel = hotels[widget.location]![index];
                          return Card(
                            child: Container(
                              decoration: BoxDecoration(
                                gradient: LinearGradient(
                                  colors: [Color(0xFF013550), Color(0xFF0A3C43)],
                                  begin: Alignment.topLeft,
                                  end: Alignment.bottomRight,
                                ),
                                borderRadius: BorderRadius.circular(10),
                              ),
                              padding: EdgeInsets.all(10),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    hotel["name"]!,
                                    style: GoogleFonts.poppins(
                                      fontSize: 16,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.white,
                                    ),
                                  ),
                                  SizedBox(height: 5),
                                  Text(
                                    hotel["description"]!,
                                    style: GoogleFonts.poppins(
                                      fontSize: 12,
                                      color: Colors.white70,
                                    ),
                                    maxLines: 3,
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                  Spacer(),
                                  Text(
                                    hotel["price"]!,
                                    style: GoogleFonts.poppins(
                                      fontSize: 12,
                                      color: Colors.white,
                                      fontWeight: FontWeight.w500,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          );
                        },
                      ),
                      SizedBox(height: 20),

                      // Places to Visit Section
                      Text(
                        "Places to Visit",
                        style: GoogleFonts.poppins(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      SizedBox(height: 10),
                      GridView.builder(
                        shrinkWrap: true,
                        physics: NeverScrollableScrollPhysics(),
                        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 2,
                          crossAxisSpacing: 10,
                          mainAxisSpacing: 10,
                          childAspectRatio: 0.8,
                        ),
                        itemCount: placesToVisit[widget.location]!.length,
                        itemBuilder: (context, index) {
                          final place = placesToVisit[widget.location]![index];
                          return Card(
                            child: Container(
                              decoration: BoxDecoration(
                                gradient: LinearGradient(
                                  colors: [Color(0xFF013550), Color(0xFF0A3C43)],
                                  begin: Alignment.topLeft,
                                  end: Alignment.bottomRight,
                                ),
                                borderRadius: BorderRadius.circular(10),
                              ),
                              padding: EdgeInsets.all(10),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    place["name"]!,
                                    style: GoogleFonts.poppins(
                                      fontSize: 16,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.white,
                                    ),
                                  ),
                                  SizedBox(height: 5),
                                  Text(
                                    place["description"]!,
                                    style: GoogleFonts.poppins(
                                      fontSize: 12,
                                      color: Colors.white70,
                                    ),
                                    maxLines: 3,
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                ],
                              ),
                            ),
                          );
                        },
                      ),
                      SizedBox(height: 30),

                      // Place Order Button
                      Center(
                        child: ElevatedButton(
                          onPressed: () {
                            if (_selectedDate == null || _selectedTime == null) {
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(content: Text("Please select date and time before placing order")),
                              );
                            } else {
                              // Place order logic here
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(content: Text("Order placed successfully!")),
                              );
                              Navigator.popUntil(context, (route) => route.isFirst);
                            }
                          },
                          child: Padding(
                            padding: EdgeInsets.symmetric(horizontal: 30, vertical: 15),
                            child: Text(
                              "PLACE ORDER",
                              style: GoogleFonts.poppins(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Color(0xFF007E95),
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
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildCalendar() {
    // This is a simplified calendar widget based on your image
    return Card(
      child: Padding(
        padding: EdgeInsets.all(15),
        child: Column(
          children: [
            Text(
              "April, 2025",
              style: GoogleFonts.poppins(
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 10),
            Table(
              children: [
                TableRow(
                  children: ['Sun', 'Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat']
                      .map((day) => Center(child: Text(day)))
                      .toList(),
                ),
                TableRow(
                  children: ['6', '7', '8', '9', '10', '11', '12']
                      .map((day) => Padding(
                    padding: EdgeInsets.all(8),
                    child: Column(
                      children: [
                        Text(day),
                        SizedBox(height: 5),
                        if (int.parse(day) >= 9 && int.parse(day) <= 12)
                          Text(
                            int.parse(day) == 9 ? "৳62.60" :
                            int.parse(day) == 10 ? "৳62.60" :
                            int.parse(day) == 11 ? "৳62.60" : "৳70.06",
                            style: TextStyle(fontSize: 10),
                          ),
                      ],
                    ),
                  ))
                      .toList(),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}