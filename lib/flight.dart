import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'book.dart';
import 'dart:async';
import 'populateFlight.dart';


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
      duration: const Duration(seconds: 10),
      vsync: this,
    )..repeat(reverse: true);

    _colorAnimation1 = ColorTween(
      begin: const Color(0xFFA3C6C6).withOpacity(0.3),
      end: Colors.blueGrey.withOpacity(0.3),
    ).animate(_animationController);

    _colorAnimation2 = ColorTween(
      begin: Colors.blueGrey.withOpacity(0.3),
      end: const Color(0xFFA3C6C6).withOpacity(0.3),
    ).animate(_animationController);
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
        .map((doc) => {...doc.data() as Map<String, dynamic>, 'id': doc.id})
        .toList());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Flights'),
        backgroundColor: const Color(0xFFA3C6C6),
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
                  ),
                ),
              );
            },
          ),
          // Main Content
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // ElevatedButton(
                  //   onPressed: () async {
                  //     await PopulateFlights.addFlights();
                  //   },
                  //   child: const Text('Populate Flights'),
                  // ),
                  // const SizedBox(height: 20),
                  const Text(
                    'Search Flights',
                    style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 20),
                  // From Field
                  TextField(
                    controller: _fromController,
                    decoration: InputDecoration(
                      labelText: 'From',
                      hintText: 'Enter departure city',
                      prefixIcon: const Icon(Icons.flight_takeoff),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      filled: true,
                      fillColor: Colors.white.withOpacity(0.8),
                    ),
                    onChanged: _onSearchChanged,
                  ),
                  const SizedBox(height: 10),
                  // To Field
                  TextField(
                    controller: _toController,
                    decoration: InputDecoration(
                      labelText: 'To',
                      hintText: 'Enter destination city',
                      prefixIcon: const Icon(Icons.flight_land),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      filled: true,
                      fillColor: Colors.white.withOpacity(0.8),
                    ),
                    onChanged: _onSearchChanged,
                  ),
                  const SizedBox(height: 10),
                  // Departure Date Field
                  TextField(
                    controller: _departureDateController,
                    readOnly: true,
                    decoration: InputDecoration(
                      labelText: 'Departure Date',
                      hintText: 'Select a departure date',
                      prefixIcon: const Icon(Icons.calendar_today),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      filled: true,
                      fillColor: Colors.white.withOpacity(0.8),
                    ),
                    onTap: () => _selectDate(context),
                  ),
                  const SizedBox(height: 20),
                  const Text(
                    'Available Flights',
                    style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 20),
                  // StreamBuilder for real-time flight data
                  StreamBuilder<List<Map<String, dynamic>>>(
                    stream: _fetchFlights(),
                    builder: (context, snapshot) {
                      if (_isLoading || snapshot.connectionState == ConnectionState.waiting) {
                        return const Center(
                          child: CircularProgressIndicator(),
                        );
                      }
                      if (snapshot.hasError) {
                        // Log the error for debugging
                        print('Firestore Error: ${snapshot.error}');
                        return const Text(
                          'Error loading flights. Check console for details.',
                          style: TextStyle(fontSize: 18),
                        );
                      }
                      final flights = snapshot.data ?? [];
                      if (flights.isEmpty) {
                        return const Text(
                          'No flights found for the given criteria.',
                          style: TextStyle(fontSize: 18),
                        );
                      }
                      return Column(
                        children: flights
                            .map((flight) => buildFlightCard(
                          context,
                          flight['from']!,
                          flight['to']!,
                          flight['departureTime']!,
                          flight['price']!,
                          flight['stopType']!,
                          flight['id']!,
                        ))
                            .toList(),
                      );
                    },
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  // Flight Card Widget
  Widget buildFlightCard(
      BuildContext context,
      String from,
      String to,
      String departure,
      String price,
      String stopType,
      String flightId,
      ) {
    return Card(
      elevation: 5,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      margin: const EdgeInsets.only(bottom: 16),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Row(
          children: [
            const Icon(Icons.flight_takeoff, size: 40, color: Color(0xFF003653)),
            const SizedBox(width: 15),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    '$from to $to',
                    style: const TextStyle(
                        fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  Text('Departure: $departure'),
                  Text('Stop Type: $stopType'),
                  Text('Price: $price'),
                ],
              ),
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => BookScreen(
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
                backgroundColor: const Color(0xFF003653),
                foregroundColor: Colors.white,
              ),
              child: const Text('Book Now'),
            ),
          ],
        ),
      ),
    );
  }
}