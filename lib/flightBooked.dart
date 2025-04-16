import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:intl/intl.dart'; // For formatting timestamp

class FlightBookedScreen extends StatefulWidget {
  const FlightBookedScreen({super.key});

  @override
  _FlightBookedScreenState createState() => _FlightBookedScreenState();
}

class _FlightBookedScreenState extends State<FlightBookedScreen> {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  bool _isLoading = true;
  List<Map<String, dynamic>> _bookedFlights = [];

  @override
  void initState() {
    super.initState();
    _fetchBookedFlights();
  }

  Future<void> _fetchBookedFlights() async {
    try {
      User? user = _auth.currentUser;
      if (user == null) {
        setState(() {
          _isLoading = false;
        });
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: const Text('Please log in to view your booked flights.'),
            duration: const Duration(seconds: 2),
            backgroundColor: Colors.redAccent,
            behavior: SnackBarBehavior.floating,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10),
            ),
          ),
        );
        return;
      }

      // Query the flightbookings collection for flights booked by the current user
      QuerySnapshot querySnapshot = await _firestore
          .collection('flightbookings')
          .where('userId', isEqualTo: user.uid)
          .get();

      // Map the query results to a list of booking data
      List<Map<String, dynamic>> bookedFlights = querySnapshot.docs.map((doc) {
        return {
          'id': doc.id,
          ...doc.data() as Map<String, dynamic>,
        };
      }).toList();

      setState(() {
        _bookedFlights = bookedFlights;
        _isLoading = false;
      });

      if (bookedFlights.isEmpty) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: const Text('No flight bookings found.'),
            duration: const Duration(seconds: 2),
            backgroundColor: Colors.blueAccent,
            behavior: SnackBarBehavior.floating,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10),
            ),
          ),
        );
      }
    } catch (e) {
      setState(() {
        _isLoading = false;
      });
      print('Error fetching booked flights: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Error fetching booked flights: $e'),
          duration: const Duration(seconds: 2),
          backgroundColor: Colors.redAccent,
          behavior: SnackBarBehavior.floating,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              Color(0xFF007E95),
              Color(0xFF264653),
            ],
          ),
        ),
        child: SafeArea(
          child: Column(
            children: [
              // Custom AppBar-like header
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 20.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      "Your Flight Bookings",
                      style: GoogleFonts.poppins(
                        fontSize: 28,
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
                    IconButton(
                      icon: const Icon(Icons.arrow_back_ios, color: Colors.white, size: 28),
                      onPressed: () {
                        Navigator.of(context).pop();
                      },
                    ),
                  ],
                ),
              ),
              // Body
              Expanded(
                child: _isLoading
                    ? const Center(
                  child: CircularProgressIndicator(
                    valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                  ),
                )
                    : _bookedFlights.isEmpty
                    ? Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Icon(
                        Icons.airplane_ticket_outlined,
                        size: 80,
                        color: Colors.white70,
                      ),
                      const SizedBox(height: 20),
                      Text(
                        "No flight bookings found.",
                        style: GoogleFonts.poppins(
                          fontSize: 20,
                          color: Colors.white70,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ],
                  ),
                )
                    : ListView.builder(
                  padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 10.0),
                  itemCount: _bookedFlights.length,
                  itemBuilder: (context, index) {
                    final booking = _bookedFlights[index];
                    // Format the booking timestamp as departure date
                    String departureDate = booking['bookingTimestamp'] != null
                        ? DateFormat('yyyy-MM-dd')
                        .format(booking['bookingTimestamp'].toDate())
                        : 'N/A';

                    return AnimatedContainer(
                      duration: const Duration(milliseconds: 500),
                      curve: Curves.easeInOut,
                      margin: const EdgeInsets.symmetric(vertical: 10.0),
                      child: Material(
                        elevation: 8,
                        borderRadius: BorderRadius.circular(20),
                        child: Container(
                          padding: const EdgeInsets.all(20.0),
                          decoration: BoxDecoration(
                            gradient: const LinearGradient(
                              begin: Alignment.topLeft,
                              end: Alignment.bottomRight,
                              colors: [
                                Colors.white,
                                Color(0xFFE6F0FA),
                              ],
                            ),
                            borderRadius: BorderRadius.circular(20),
                            border: Border.all(
                              color: Colors.white.withOpacity(0.5),
                              width: 2,
                            ),
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              // Flight Route (From - To)
                              Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  Row(
                                    children: [
                                      const Icon(
                                        Icons.flight_takeoff,
                                        color: Color(0xFF007E95),
                                        size: 28,
                                      ),
                                      const SizedBox(width: 10),
                                      Text(
                                        "${booking['from']?.toString().toUpperCase() ?? 'N/A'}",
                                        style: GoogleFonts.poppins(
                                          fontSize: 20,
                                          fontWeight: FontWeight.bold,
                                          color: const Color(0xFF264653),
                                        ),
                                      ),
                                    ],
                                  ),
                                  const Icon(
                                    Icons.arrow_forward,
                                    color: Color(0xFF007E95),
                                    size: 24,
                                  ),
                                  Row(
                                    children: [
                                      Text(
                                        "${booking['to']?.toString().toUpperCase() ?? 'N/A'}",
                                        style: GoogleFonts.poppins(
                                          fontSize: 20,
                                          fontWeight: FontWeight.bold,
                                          color: const Color(0xFF264653),
                                        ),
                                      ),
                                      const SizedBox(width: 10),
                                      const Icon(
                                        Icons.flight_land,
                                        color: Color(0xFF007E95),
                                        size: 28,
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                              const Divider(
                                color: Color(0xFF007E95),
                                thickness: 1,
                                height: 20,
                              ),
                              // Departure Date (from bookingTimestamp)
                              _buildInfoRow(
                                icon: Icons.calendar_today,
                                label: "Departure Date",
                                value: departureDate,
                              ),
                              const SizedBox(height: 10),
                              // Departure Time
                              _buildInfoRow(
                                icon: Icons.access_time,
                                label: "Departure",
                                value: booking['departure'] ?? 'N/A',
                              ),
                              const SizedBox(height: 10),
                              // Passenger Count
                              _buildInfoRow(
                                icon: Icons.person,
                                label: "Passengers",
                                value: booking['passengerCount']?.toString() ?? 'N/A',
                              ),
                              const SizedBox(height: 10),
                              // Payment Method
                              _buildInfoRow(
                                icon: Icons.payment,
                                label: "Payment Method",
                                value: booking['paymentMethod'] ?? 'N/A',
                              ),
                              const SizedBox(height: 10),
                              // Total Paid Amount
                              _buildInfoRow(
                                icon: Icons.account_balance_wallet,
                                label: "Total Paid",
                                value: "\$${booking['totalPrice']?.toString() ?? 'N/A'}",
                                highlight: true,
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
        ),
      ),
    );
  }

  Widget _buildInfoRow({
    required IconData icon,
    required String label,
    required String value,
    bool highlight = false,
  }) {
    return Row(
      children: [
        Icon(
          icon,
          color: const Color(0xFF007E95),
          size: 24,
        ),
        const SizedBox(width: 10),
        Text(
          "$label: ",
          style: GoogleFonts.poppins(
            fontSize: 16,
            fontWeight: FontWeight.w500,
            color: Colors.black54,
          ),
        ),
        Expanded(
          child: Text(
            value,
            style: GoogleFonts.poppins(
              fontSize: 16,
              fontWeight: highlight ? FontWeight.bold : FontWeight.w500,
              color: highlight ? const Color(0xFF007E95) : Colors.black87,
            ),
          ),
        ),
      ],
    );
  }
}