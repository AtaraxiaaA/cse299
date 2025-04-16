import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'rewardsBookingSummary.dart';


class HotelBookingScreen extends StatefulWidget {
  final String hotelName;
  final String price;
  final String discount;
  final List<Map<String, dynamic>> reviews;
  final String specialOffer;
  final String imageUrl;

  const HotelBookingScreen({
    required this.hotelName,
    required this.price,
    required this.discount,
    required this.reviews,
    required this.specialOffer,
    required this.imageUrl,
  });

  @override
  _HotelBookingScreenState createState() => _HotelBookingScreenState();
}

class _HotelBookingScreenState extends State<HotelBookingScreen> with SingleTickerProviderStateMixin {
  DateTime checkInDate = DateTime.now();
  DateTime checkOutDate = DateTime.now().add(Duration(days: 1));
  TimeOfDay checkInTime = TimeOfDay(hour: 14, minute: 0);
  TimeOfDay checkOutTime = TimeOfDay(hour: 12, minute: 0);
  String? selectedDuration;
  List<String> selectedAmenities = [];
  int earnedPoints = 0;
  String couponCode = '';
  bool noCreditCardNeeded = true;
  bool freeCancellation = true;
  bool breakfastIncluded = true;
  bool noPrepaymentNeeded = true;
  double discountPercentage = 10.0;

  final List<String> amenitiesOptions = [
    'Spa and Wellness Centre',
    'Free Parking',
    'Free WiFi',
    'Restaurant',
    'Room with View',
    'Access to Pool',
    'Access to Gym',
  ];

  late AnimationController _animationController;
  late Animation<double> _scaleAnimation;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      vsync: this,
      duration: Duration(milliseconds: 200),
    );
    _scaleAnimation = Tween<double>(begin: 1.0, end: 1.2).animate(
      CurvedAnimation(parent: _animationController, curve: Curves.easeInOut),
    );
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  Future<void> _selectCheckInDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: checkInDate,
      firstDate: DateTime.now(),
      lastDate: DateTime(2025, 12, 31),
    );
    if (picked != null && picked != checkInDate) {
      setState(() {
        checkInDate = picked;
        checkOutDate = picked.add(Duration(days: int.parse(selectedDuration?.split(' ')[0] ?? '1')));
      });
    }
  }

  Future<void> _selectCheckOutDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: checkOutDate,
      firstDate: checkInDate.add(Duration(days: 1)),
      lastDate: DateTime(2025, 12, 31),
    );
    if (picked != null && picked != checkOutDate) {
      setState(() {
        checkOutDate = picked;
        selectedDuration = "${checkOutDate.difference(checkInDate).inDays} Night${checkOutDate.difference(checkInDate).inDays > 1 ? 's' : ''}";
        _calculatePoints();
      });
    }
  }

  Future<void> _selectCheckInTime(BuildContext context) async {
    final TimeOfDay? picked = await showTimePicker(
      context: context,
      initialTime: checkInTime,
    );
    if (picked != null && picked != checkInTime) {
      setState(() {
        checkInTime = picked;
      });
    }
  }

  Future<void> _selectCheckOutTime(BuildContext context) async {
    final TimeOfDay? picked = await showTimePicker(
      context: context,
      initialTime: checkOutTime,
    );
    if (picked != null && picked != checkOutTime) {
      setState(() {
        checkOutTime = picked;
      });
    }
  }

  void _toggleAmenity(String amenity) {
    setState(() {
      if (selectedAmenities.contains(amenity)) {
        selectedAmenities.remove(amenity);
      } else {
        selectedAmenities.add(amenity);
      }
    });
  }

  void _calculatePoints() {
    int nights = int.parse(selectedDuration?.split(' ')[0] ?? '1');
    setState(() {
      earnedPoints = nights * 100; // 100 points per night
    });
  }

  Future<void> _saveBookingToFirestore(BuildContext context) async {
    try {
      final user = FirebaseAuth.instance.currentUser;
      if (user == null) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("Please log in to book.")),
        );
        return;
      }

      await FirebaseFirestore.instance.collection('rewardsbookings').add({
        'userId': user.uid,
        'hotelName': widget.hotelName,
        'checkInDate': Timestamp.fromDate(checkInDate),
        'checkOutDate': Timestamp.fromDate(checkOutDate),
        'checkInTime': checkInTime.format(context),
        'checkOutTime': checkOutTime.format(context),
        'duration': selectedDuration ?? '1 Night',
        'amenities': selectedAmenities,
        'price': widget.price,
        'discount': widget.discount,
        'earnedPoints': earnedPoints,
        'noCreditCardNeeded': noCreditCardNeeded,
        'freeCancellation': freeCancellation,
        'breakfastIncluded': breakfastIncluded,
        'noPrepaymentNeeded': noPrepaymentNeeded,
        'discountPercentage': discountPercentage,
        'bookingDate': Timestamp.fromDate(DateTime.now()),
      });
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Booking successfully saved!")),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Failed to save booking: $e")),
      );
    }
  }

  void _showBookingSummary(BuildContext context) async {
    await _saveBookingToFirestore(context);
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => BookingSummaryScreen(
          hotelName: widget.hotelName,
          checkInDate: checkInDate,
          checkOutDate: checkOutDate,
          checkInTime: checkInTime,
          checkOutTime: checkOutTime,
          duration: selectedDuration ?? '1 Night',
          amenities: selectedAmenities,
          price: widget.price,
          discount: widget.discount,
          earnedPoints: earnedPoints,
          noCreditCardNeeded: noCreditCardNeeded,
          freeCancellation: freeCancellation,
          breakfastIncluded: breakfastIncluded,
          noPrepaymentNeeded: noPrepaymentNeeded,
          discountPercentage: discountPercentage,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Confirm Booking - ${widget.hotelName}",
          style: GoogleFonts.poppins(
            fontSize: 20,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
        backgroundColor: Color(0xFF00423A),
      ),
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              Color(0xFF001916),
              Color(0xFF00211D),
              Color(0xFF002925),
              Color(0xFF00423A),
            ],
            stops: [0.0, 0.3, 0.6, 1.0],
          ),
        ),
        child: SingleChildScrollView(
          padding: EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Stack(
                children: [
                  widget.imageUrl.isNotEmpty
                      ? Image.network(
                    widget.imageUrl,
                    height: 150,
                    width: double.infinity,
                    fit: BoxFit.cover,
                    errorBuilder: (context, error, stackTrace) => Container(
                      height: 150,
                      color: Colors.grey[300],
                      child: Center(child: Text("Image Not Available")),
                    ),
                  )
                      : Container(
                    height: 150,
                    color: Colors.grey[300],
                    child: Center(child: Text("Add Image Here")),
                  ),
                  Positioned(
                    top: 8,
                    left: 8,
                    child: Container(
                      padding: EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                      color: Colors.black.withOpacity(0.6),
                      child: Text(
                        widget.hotelName,
                        style: GoogleFonts.poppins(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              SizedBox(height: 16),
              Container(
                padding: EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(color: Colors.white),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "Price",
                      style: GoogleFonts.poppins(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                    SizedBox(height: 8),
                    Text(
                      widget.price,
                      style: GoogleFonts.poppins(
                        fontSize: 16,
                        color: Colors.white,
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(height: 16),
              Container(
                padding: EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(color: Colors.white),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "Discounts",
                      style: GoogleFonts.poppins(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                    SizedBox(height: 8),
                    Text(
                      widget.discount.isNotEmpty ? widget.discount : "No discounts available",
                      style: GoogleFonts.poppins(
                        fontSize: 16,
                        color: Colors.white,
                      ),
                    ),
                    SizedBox(height: 8),
                    Text(
                      "$discountPercentage% Genius Discount applied",
                      style: GoogleFonts.poppins(
                        fontSize: 16,
                        color: Colors.greenAccent,
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(height: 16),
              Container(
                padding: EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(color: Colors.white),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "Apply Coupon",
                      style: GoogleFonts.poppins(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                    SizedBox(height: 8),
                    TextField(
                      decoration: InputDecoration(
                        hintText: "Enter coupon code",
                        hintStyle: GoogleFonts.poppins(color: Colors.white70),
                        border: OutlineInputBorder(),
                        filled: true,
                        fillColor: Colors.white.withOpacity(0.2),
                      ),
                      style: GoogleFonts.poppins(color: Colors.white),
                      onChanged: (value) {
                        couponCode = value;
                      },
                    ),
                    SizedBox(height: 8),
                    ElevatedButton(
                      onPressed: () {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(content: Text("Coupon '$couponCode' applied!")),
                        );
                      },
                      child: Text("Apply"),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Color(0xFF00423A),
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(height: 16),
              Container(
                padding: EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(color: Colors.white),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "Special Offer",
                      style: GoogleFonts.poppins(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                    SizedBox(height: 8),
                    Text(
                      widget.specialOffer,
                      style: GoogleFonts.poppins(
                        fontSize: 16,
                        color: Colors.white,
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(height: 16),
              Container(
                padding: EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(color: Colors.white),
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
                    ...widget.reviews.map((review) => Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        ListTile(
                          leading: CircleAvatar(child: Icon(Icons.person)),
                          title: Text(
                            review["user"],
                            style: GoogleFonts.poppins(color: Colors.white),
                          ),
                          subtitle: Text(
                            review["comment"],
                            style: GoogleFonts.poppins(color: Colors.white70),
                          ),
                          trailing: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Icon(Icons.star, color: Colors.amber, size: 16),
                              Text(
                                review["rating"].toString(),
                                style: GoogleFonts.poppins(color: Colors.white),
                              ),
                            ],
                          ),
                        ),
                        Padding(
                          padding: EdgeInsets.symmetric(horizontal: 16),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(
                                    "Location",
                                    style: GoogleFonts.poppins(color: Colors.white70),
                                  ),
                                  Text(
                                    review["location"].toString(),
                                    style: GoogleFonts.poppins(color: Colors.white),
                                  ),
                                ],
                              ),
                              LinearProgressIndicator(
                                value: review["location"] / 10,
                                backgroundColor: Colors.grey,
                                valueColor: AlwaysStoppedAnimation<Color>(Colors.green),
                              ),
                              SizedBox(height: 8),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(
                                    "Cleanliness",
                                    style: GoogleFonts.poppins(color: Colors.white70),
                                  ),
                                  Text(
                                    review["cleanliness"].toString(),
                                    style: GoogleFonts.poppins(color: Colors.white),
                                  ),
                                ],
                              ),
                              LinearProgressIndicator(
                                value: review["cleanliness"] / 10,
                                backgroundColor: Colors.grey,
                                valueColor: AlwaysStoppedAnimation<Color>(Colors.green),
                              ),
                              SizedBox(height: 8),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(
                                    "Value for Money",
                                    style: GoogleFonts.poppins(color: Colors.white70),
                                  ),
                                  Text(
                                    review["value_for_money"].toString(),
                                    style: GoogleFonts.poppins(color: Colors.white),
                                  ),
                                ],
                              ),
                              LinearProgressIndicator(
                                value: review["value_for_money"] / 10,
                                backgroundColor: Colors.grey,
                                valueColor: AlwaysStoppedAnimation<Color>(Colors.green),
                              ),
                            ],
                          ),
                        ),
                      ],
                    )),
                  ],
                ),
              ),
              SizedBox(height: 16),
              Container(
                padding: EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(color: Colors.white),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "Booking Details",
                      style: GoogleFonts.poppins(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                    SizedBox(height: 12),
                    Text(
                      "Select Check-in Date",
                      style: GoogleFonts.poppins(
                        fontSize: 16,
                        color: Colors.white,
                      ),
                    ),
                    SizedBox(height: 8),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          "${checkInDate.toLocal()}".split(' ')[0],
                          style: GoogleFonts.poppins(color: Colors.white),
                        ),
                        ElevatedButton(
                          onPressed: () => _selectCheckInDate(context),
                          child: Text("Pick Date"),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Color(0xFF00423A),
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: 12),
                    Text(
                      "Select Check-in Time",
                      style: GoogleFonts.poppins(
                        fontSize: 16,
                        color: Colors.white,
                      ),
                    ),
                    SizedBox(height: 8),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          checkInTime.format(context),
                          style: GoogleFonts.poppins(color: Colors.white),
                        ),
                        ElevatedButton(
                          onPressed: () => _selectCheckInTime(context),
                          child: Text("Pick Time"),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Color(0xFF00423A),
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: 12),
                    Text(
                      "Select Check-out Date",
                      style: GoogleFonts.poppins(
                        fontSize: 16,
                        color: Colors.white,
                      ),
                    ),
                    SizedBox(height: 8),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          "${checkOutDate.toLocal()}".split(' ')[0],
                          style: GoogleFonts.poppins(color: Colors.white),
                        ),
                        ElevatedButton(
                          onPressed: () => _selectCheckOutDate(context),
                          child: Text("Pick Date"),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Color(0xFF00423A),
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: 12),
                    Text(
                      "Select Check-out Time",
                      style: GoogleFonts.poppins(
                        fontSize: 16,
                        color: Colors.white,
                      ),
                    ),
                    SizedBox(height: 8),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          checkOutTime.format(context),
                          style: GoogleFonts.poppins(color: Colors.white),
                        ),
                        ElevatedButton(
                          onPressed: () => _selectCheckOutTime(context),
                          child: Text("Pick Time"),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Color(0xFF00423A),
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: 12),
                    Text(
                      "Select Amenities",
                      style: GoogleFonts.poppins(
                        fontSize: 16,
                        color: Colors.white,
                      ),
                    ),
                    SizedBox(height: 8),
                    Wrap(
                      spacing: 8,
                      children: amenitiesOptions.map((amenity) {
                        final isSelected = selectedAmenities.contains(amenity);
                        return MouseRegion(
                          onEnter: (_) => _animationController.forward(),
                          onExit: (_) => _animationController.reverse(),
                          child: AnimatedBuilder(
                            animation: _animationController,
                            builder: (context, child) {
                              return Transform.scale(
                                scale: isSelected ? 1.0 : _scaleAnimation.value,
                                child: ChoiceChip(
                                  label: Text(
                                    amenity,
                                    style: GoogleFonts.poppins(
                                      color: Colors.teal,
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                  selected: isSelected,
                                  onSelected: (selected) {
                                    _toggleAmenity(amenity);
                                  },
                                  selectedColor: Color(0xFF00423A),
                                  backgroundColor: Colors.transparent,
                                  side: BorderSide(color: Colors.greenAccent),
                                  labelPadding: EdgeInsets.symmetric(horizontal: 13, vertical: 6),
                                  padding: EdgeInsets.all(12),
                                ),
                              );
                            },
                          ),
                        );
                      }).toList(),
                    ),
                    SizedBox(height: 12),
                    Text(
                      "Select Duration",
                      style: GoogleFonts.poppins(
                        fontSize: 16,
                        color: Colors.white,
                      ),
                    ),
                    SizedBox(height: 8),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        _buildDurationOption("1 Night"),
                        _buildDurationOption("2 Nights"),
                        _buildDurationOption("3 Nights"),
                      ],
                    ),
                    SizedBox(height: 12),
                    Text(
                      "Payment Options",
                      style: GoogleFonts.poppins(
                        fontSize: 16,
                        color: Colors.white,
                      ),
                    ),
                    SizedBox(height: 8),
                    Row(
                      children: [
                        Icon(Icons.check, color: Colors.green),
                        SizedBox(width: 8),
                        Text(
                          "No credit card needed",
                          style: GoogleFonts.poppins(color: Colors.white),
                        ),
                      ],
                    ),
                    Row(
                      children: [
                        Icon(Icons.check, color: Colors.green),
                        SizedBox(width: 8),
                        Text(
                          "Free cancellation before 18:00 on ${checkInDate.toLocal()}".split(' ')[0],
                          style: GoogleFonts.poppins(color: Colors.white),
                        ),
                      ],
                    ),
                    Row(
                      children: [
                        Icon(Icons.check, color: Colors.green),
                        SizedBox(width: 8),
                        Text(
                          "Breakfast included in the price",
                          style: GoogleFonts.poppins(color: Colors.white),
                        ),
                      ],
                    ),
                    Row(
                      children: [
                        Icon(Icons.check, color: Colors.green),
                        SizedBox(width: 8),
                        Text(
                          "No prepayment needed",
                          style: GoogleFonts.poppins(color: Colors.white),
                        ),
                      ],
                    ),
                    SizedBox(height: 12),
                    Text(
                      "Earned Points",
                      style: GoogleFonts.poppins(
                        fontSize: 16,
                        color: Colors.white,
                      ),
                    ),
                    SizedBox(height: 8),
                    Text(
                      "You will earn $earnedPoints points with this booking",
                      style: GoogleFonts.poppins(
                        fontSize: 14,
                        color: Colors.greenAccent,
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(height: 24),
              ElevatedButton(
                onPressed: () {
                  _showBookingSummary(context);
                },
                child: Text("Confirm Booking"),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.green,
                  minimumSize: Size(double.infinity, 50),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildDurationOption(String text) {
    bool isSelected = selectedDuration == text;
    return GestureDetector(
      onTap: () {
        setState(() {
          selectedDuration = text;
          checkOutDate = checkInDate.add(Duration(days: int.parse(text.split(' ')[0])));
          _calculatePoints();
        });
      },
      child: Container(
        padding: EdgeInsets.symmetric(vertical: 12, horizontal: 16),
        decoration: BoxDecoration(
          color: isSelected ? Color(0xFF00423A) : Colors.transparent,
          border: Border.all(color: Colors.black54),
          borderRadius: BorderRadius.circular(8),
        ),
        child: Text(
          text,
          style: GoogleFonts.poppins(
            color: isSelected ? Colors.white : Colors.white70,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
    );
  }
}