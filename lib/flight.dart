import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'flightbook.dart';
import 'dart:async';

class FlightScreen extends StatefulWidget {
  const FlightScreen({super.key});

  @override
  _FlightScreenState createState() => _FlightScreenState();
}

class _FlightScreenState extends State<FlightScreen>
    with SingleTickerProviderStateMixin {
  final TextEditingController _fromController = TextEditingController();
  final TextEditingController _toController = TextEditingController();
  final TextEditingController _departureDateController = TextEditingController();
  DateTime? _departureDate;
  bool _isLoading = false;
  Timer? _debounce;

  late AnimationController _animationController;
  late Animation<Color?> _colorAnimation1;
  late Animation<Color?> _colorAnimation2;

  @override
  void initState() {
    super.initState();
    // Initialize animation controller for gradient background
    _animationController = AnimationController(
      duration: const Duration(seconds: 8),
      vsync: this,
    )..repeat(reverse: true);

    _colorAnimation1 = ColorTween(
      begin: const Color(0xFF007E95),
      end: const Color(0xFF264653),
    ).animate(CurvedAnimation(
      parent: _animationController,
      curve: Curves.easeInOut,
    ));

    _colorAnimation2 = ColorTween(
      begin: const Color(0xFF264653),
      end: const Color(0xFF007E95),
    ).animate(CurvedAnimation(
      parent: _animationController,
      curve: Curves.easeInOut,
    ));
  }

  @override
  void dispose() {
    _fromController.dispose();
    _toController.dispose();
    _departureDateController.dispose();
    _animationController.dispose();
    _debounce?.cancel();
    super.dispose();
  }

  // Pick a date for departure
  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2023),
      lastDate: DateTime(2026),
      builder: (context, child) {
        return Theme(
          data: ThemeData.light().copyWith(
            colorScheme: const ColorScheme.light(
              primary: Color(0xFF007E95),
              onPrimary: Colors.white,
              surface: Colors.white,
              onSurface: Colors.black87,
            ),
            dialogBackgroundColor: Colors.white,
          ),
          child: child!,
        );
      },
    );
    if (picked != null && picked != _departureDate) {
      setState(() {
        _departureDate = picked;
        _departureDateController.text = DateFormat('yyyy-MM-dd').format(picked);
        _isLoading = true;
      });
      // Reset loading after a short delay
      Future.delayed(const Duration(milliseconds: 300), () {
        if (mounted) {
          setState(() {
            _isLoading = false;
          });
        }
      });
    }
  }

  // Debounce search input
  void _onSearchChanged(String value) {
    if (_debounce?.isActive ?? false) _debounce!.cancel();
    _debounce = Timer(const Duration(milliseconds: 300), () {
      setState(() {
        _isLoading = true;
      });
      Future.delayed(const Duration(milliseconds: 500), () {
        if (mounted) {
          setState(() {
            _isLoading = false;
          });
        }
      });
    });
  }

  // Fetch flights from Firestore with search filters
  Stream<List<Map<String, dynamic>>> _fetchFlights() {
    Query<Map<String, dynamic>> query =
    FirebaseFirestore.instance.collection('flights');

    // Normalize inputs
    String fromQuery = _fromController.text.trim().toLowerCase();
    String toQuery = _toController.text.trim().toLowerCase();

    // Apply filters
    if (fromQuery.isNotEmpty) {
      query = query.where('from',
          isGreaterThanOrEqualTo: fromQuery,
          isLessThanOrEqualTo: '$fromQuery\uf8ff');
    }
    if (toQuery.isNotEmpty) {
      query = query.where('to',
          isGreaterThanOrEqualTo: toQuery,
          isLessThanOrEqualTo: '$toQuery\uf8ff');
    }
    if (_departureDate != null) {
      Timestamp startOfDay = Timestamp.fromDate(
          DateTime(_departureDate!.year, _departureDate!.month, _departureDate!.day));
      Timestamp endOfDay = Timestamp.fromDate(
          DateTime(_departureDate!.year, _departureDate!.month, _departureDate!.day, 23, 59, 59));
      query = query.where('departureDate',
          isGreaterThanOrEqualTo: startOfDay, isLessThanOrEqualTo: endOfDay);
    }

    return query.snapshots().map((snapshot) => snapshot.docs
        .map((doc) => {...doc.data(), 'id': doc.id})
        .toList());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        title: Text(
          'Explore Flights',
          style: GoogleFonts.poppins(
            fontSize: 24,
            fontWeight: FontWeight.bold,
            color: Colors.white,
            shadows: [
              const Shadow(
                color: Colors.black26,
                offset: Offset(2, 2),
                blurRadius: 4,
              ),
            ],
          ),
        ),
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios, color: Colors.white, size: 28),
          onPressed: () {
            Navigator.of(context).pop();
          },
        ),
      ),
      body: Stack(
        children: [
          // Custom Animated Gradient Background
          AnimatedBuilder(
            animation: _animationController,
            builder: (context, child) {
              return Container(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [
                      _colorAnimation1.value!,
                      _colorAnimation2.value!,
                    ],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    stops: const [0.0, 1.0],
                    tileMode: TileMode.clamp,
                  ),
                ),
              );
            },
          ),
          // Main Content
          SafeArea(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 10.0),
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Header Text
                    Text(
                      'Find Your Perfect Flight',
                      style: GoogleFonts.poppins(
                        fontSize: 28,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                        shadows: [
                          const Shadow(
                            color: Colors.black26,
                            offset: Offset(2, 2),
                            blurRadius: 4,
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 20),
                    // From Field
                    _buildTextField(
                      controller: _fromController,
                      label: 'From',
                      hint: 'Enter departure city',
                      icon: Icons.flight_takeoff,
                      onChanged: _onSearchChanged,
                    ),
                    const SizedBox(height: 15),
                    // To Field
                    _buildTextField(
                      controller: _toController,
                      label: 'To',
                      hint: 'Enter destination city',
                      icon: Icons.flight_land,
                      onChanged: _onSearchChanged,
                    ),
                    const SizedBox(height: 15),
                    // Departure Date Field
                    _buildTextField(
                      controller: _departureDateController,
                      label: 'Departure Date',
                      hint: 'Select a departure date',
                      icon: Icons.calendar_today,
                      readOnly: true,
                      onTap: () => _selectDate(context),
                    ),
                    const SizedBox(height: 30),
                    // Available Flights Header
                    Text(
                      'Available Flights',
                      style: GoogleFonts.poppins(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                        shadows: [
                          const Shadow(
                            color: Colors.black26,
                            offset: Offset(2, 2),
                            blurRadius: 4,
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 20),
                    // StreamBuilder for real-time flight data
                    StreamBuilder<List<Map<String, dynamic>>>(
                      stream: _fetchFlights(),
                      builder: (context, snapshot) {
                        if (_isLoading || snapshot.connectionState == ConnectionState.waiting) {
                          return const Center(
                            child: CircularProgressIndicator(
                              valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                            ),
                          );
                        }
                        if (snapshot.hasError) {
                          // Log the error for debugging
                          print('Firestore Error: ${snapshot.error}');
                          return Text(
                            'Error loading flights. Check console for details.',
                            style: GoogleFonts.poppins(
                              fontSize: 18,
                              color: Colors.white70,
                            ),
                          );
                        }
                        final flights = snapshot.data ?? [];
                        if (flights.isEmpty) {
                          return Center(
                            child: Column(
                              children: [
                                const Icon(
                                  Icons.airplane_ticket_outlined,
                                  size: 80,
                                  color: Colors.white70,
                                ),
                                const SizedBox(height: 10),
                                Text(
                                  'No flights found for the given criteria.',
                                  style: GoogleFonts.poppins(
                                    fontSize: 18,
                                    color: Colors.white70,
                                  ),
                                ),
                              ],
                            ),
                          );
                        }
                        return Column(
                          children: flights
                              .asMap()
                              .entries
                              .map((entry) {
                            int index = entry.key;
                            var flight = entry.value;
                            return buildFlightCard(
                              context,
                              flight['from']!,
                              flight['to']!,
                              flight['departureTime']!,
                              flight['price']!,
                              flight['stopType']!,
                              flight['id']!,
                              index,
                            );
                          })
                              .toList(),
                        );
                      },
                    ),
                    const SizedBox(height: 20),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  // Custom TextField Widget with Fancy Styling
  Widget _buildTextField({
    required TextEditingController controller,
    required String label,
    required String hint,
    required IconData icon,
    bool readOnly = false,
    Function(String)? onChanged,
    VoidCallback? onTap,
  }) {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 300),
      curve: Curves.easeInOut,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(15),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.2),
            blurRadius: 10,
            spreadRadius: 2,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: TextField(
        controller: controller,
        readOnly: readOnly,
        onTap: onTap,
        onChanged: onChanged,
        style: GoogleFonts.poppins(
          fontSize: 16,
          color: Colors.black87,
        ),
        decoration: InputDecoration(
          labelText: label,
          labelStyle: GoogleFonts.poppins(
            fontSize: 16,
            color: Colors.black54,
          ),
          hintText: hint,
          hintStyle: GoogleFonts.poppins(
            fontSize: 16,
            color: Colors.black38,
          ),
          prefixIcon: Icon(
            icon,
            color: const Color(0xFF007E95),
            size: 28,
          ),
          filled: true,
          fillColor: Colors.white.withOpacity(0.9),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(15),
            borderSide: BorderSide.none,
          ),
          contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 18),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(15),
            borderSide: const BorderSide(color: Colors.transparent),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(15),
            borderSide: const BorderSide(
              color: Color(0xFF007E95),
              width: 2,
            ),
          ),
        ),
      ),
    );
  }

  // Fancy Flight Card Widget with Animation
  Widget buildFlightCard(
      BuildContext context,
      String from,
      String to,
      String departure,
      String price,
      String stopType,
      String flightId,
      int index,
      ) {
    return AnimatedOpacity(
      opacity: 1.0,
      duration: Duration(milliseconds: 500 + (index * 100)),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
        margin: const EdgeInsets.only(bottom: 20),
        child: Material(
          elevation: 8,
          borderRadius: BorderRadius.circular(20),
          child: Container(
            padding: const EdgeInsets.all(20),
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
                // Flight Route with Icons
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
                          from.toUpperCase(),
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
                          to.toUpperCase(),
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
                // Flight Details
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        _buildFlightInfoRow(
                          icon: Icons.access_time,
                          label: "Departure",
                          value: departure,
                        ),
                        const SizedBox(height: 10),
                        _buildFlightInfoRow(
                          icon: Icons.swap_horiz,
                          label: "Stop Type",
                          value: stopType,
                        ),
                      ],
                    ),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        Text(
                          "Price",
                          style: GoogleFonts.poppins(
                            fontSize: 16,
                            fontWeight: FontWeight.w500,
                            color: Colors.black54,
                          ),
                        ),
                        const SizedBox(height: 2),
                        Text(
                          price,
                          style: GoogleFonts.poppins(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                            color: const Color(0xFF007E95),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
                const SizedBox(height: 15),
                // Book Now Button
                Center(
                  child: ElevatedButton(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => FlightBookScreen(
                            flightDetails: {
                              'from': from,
                              'to': to,
                              'departure': departure,
                              'price': price,
                              'flightId': flightId,
                            },
                          ),
                        ),
                      );
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF007E95),
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 15),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(30),
                      ),
                      elevation: 5,
                    ),
                    child: Text(
                      'Book Now',
                      style: GoogleFonts.poppins(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  // Helper method to build flight info rows
  Widget _buildFlightInfoRow({
    required IconData icon,
    required String label,
    required String value,
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
        Text(
          value,
          style: GoogleFonts.poppins(
            fontSize: 16,
            fontWeight: FontWeight.w500,
            color: Colors.black87,
          ),
        ),
      ],
    );
  }
}