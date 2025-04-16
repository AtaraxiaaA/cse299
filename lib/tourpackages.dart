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

 TourPackagesScreen({super.key});

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

  const TourPackageDetailsScreen({super.key, required this.package});

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
                      optionName: title,
                      originalPrice: price,
                    ),
                  ),
                );
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Color(0xFF264653),
                foregroundColor: Colors.white,
              ),
              child: Text("Select Option"),
            ),
          ],
        ),
      ),
    );
  }
}

class BookingDetailsScreen extends StatefulWidget {
  final String packageName;
  final String optionName;
  final int originalPrice;

  const BookingDetailsScreen({super.key, 
    required this.packageName,
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
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Color(0xFF264653),
                              foregroundColor: Colors.white,
                            ),
                            child: Text("Apply"),
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
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Color(0xFF264653),
                              foregroundColor: Colors.white,
                            ),
                            child: Text(
                              _selectedDate == null
                                  ? "Select Date"
                                  : "Date: ${_selectedDate!.day}/${_selectedDate!.month}/${_selectedDate!.year}",
                            ),
                          ),
                          SizedBox(width: 10),
                          ElevatedButton(
                            onPressed: () => _selectTime(context),
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Color(0xFF264653),
                              foregroundColor: Colors.white,
                            ),
                            child: Text(
                              _selectedTime == null
                                  ? "Select Time"
                                  : "Time: ${_selectedTime!.format(context)}",
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
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Color(0xFF007E95),
                            foregroundColor: Colors.white,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(30),
                            ),
                          ),
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
                // Add more rows as needed for the full calendar
              ],
            ),
          ],
        ),
      ),
    );
  }
}