import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'busbookingscreen.dart'; // Import your BusBookingScreen

class BusSearchScreen extends StatefulWidget {
  const BusSearchScreen({super.key});

  @override
  _BusSearchScreenState createState() => _BusSearchScreenState();
}

class _BusSearchScreenState extends State<BusSearchScreen> {
  bool isRoundTrip = true;
  TextEditingController _fromLocationController = TextEditingController();
  TextEditingController _toLocationController = TextEditingController();
  TextEditingController _departureDateController = TextEditingController();
  TextEditingController _returnDateController = TextEditingController();
  DateTime _departureDate = DateTime.now();
  DateTime _returnDate = DateTime.now();
  int travelers = 1;
  bool directBuses = false;
  String? driverAge;

  List<String> ageOptions =
  List.generate(80 - 18 + 1, (index) => (18 + index).toString());

  List<Map<String, String>> _availableBuses = [
    {
      'bus': 'Volvo AC Sleeper',
      'price': '\$30',
      'departureTime': '08:00 AM',
      'arrivalTime': '04:00 PM',
      'from': 'City A',
      'to': 'City B',
    },
    {
      'bus': 'Scania Multi-Axle',
      'price': '\$25',
      'departureTime': '10:00 AM',
      'arrivalTime': '06:00 PM',
      'from': 'City C',
      'to': 'City D',
    },
    {
      'bus': 'Non-AC Seater',
      'price': '\$15',
      'departureTime': '12:00 PM',
      'arrivalTime': '08:00 PM',
      'from': 'City E',
      'to': 'City F',
    },
  ];

  Future<void> _selectDate(BuildContext context, bool isDeparture) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: isDeparture ? _departureDate : _returnDate,
      firstDate: DateTime.now(),
      lastDate: DateTime(2026),
    );
    if (picked != null) {
      setState(() {
        if (isDeparture) {
          _departureDate = picked;
          _departureDateController.text = DateFormat('yyyy-MM-dd').format(picked);
        } else {
          _returnDate = picked;
          _returnDateController.text = DateFormat('yyyy-MM-dd').format(picked);
        }
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    List<Map<String, String>> filteredBuses = _availableBuses
        .where((bus) =>
    bus['from']!.toLowerCase().contains(_fromLocationController.text.toLowerCase()) &&
        bus['to']!.toLowerCase().contains(_toLocationController.text.toLowerCase()))
        .toList();

    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Search for Buses",
          style: GoogleFonts.poppins(
              fontWeight: FontWeight.w600, color: Colors.black),
        ),
        backgroundColor: Color(0xFF007E95),
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Search Buses',
              style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 20),
            TextField(
              controller: _fromLocationController,
              decoration: InputDecoration(
                labelText: 'Pick-up Location',
                hintText: 'Enter pick-up location',
                prefixIcon: Icon(Icons.location_on),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
            ),
            SizedBox(height: 10),
            TextField(
              controller: _toLocationController,
              decoration: InputDecoration(
                labelText: 'Drop-off Location',
                hintText: 'Enter drop-off location',
                prefixIcon: Icon(Icons.location_on),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
            ),
            SizedBox(height: 10),
            TextField(
              controller: _departureDateController,
              readOnly: true,
              decoration: InputDecoration(
                labelText: 'Pick-up Date',
                hintText: 'Select a pick-up date',
                prefixIcon: Icon(Icons.calendar_today),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              onTap: () => _selectDate(context, true),
            ),
            SizedBox(height: 10),
            if (isRoundTrip)
              TextField(
                controller: _returnDateController,
                readOnly: true,
                decoration: InputDecoration(
                  labelText: 'Return Date',
                  hintText: 'Select return date',
                  prefixIcon: Icon(Icons.calendar_today),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                onTap: () => _selectDate(context, false),
              ),
            SizedBox(height: 20),
            Text(
              'Available Buses',
              style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 20),
            if (filteredBuses.isEmpty)
              Text('No buses found', style: TextStyle(fontSize: 18)),
            for (var bus in filteredBuses)
              buildBusCard(
                context,
                bus['bus']!,
                bus['price']!,
                bus['departureTime']!,
                bus['arrivalTime']!,
                bus['from']!,
                bus['to']!,
              ),
          ],
        ),
      ),
    );
  }

  Widget buildBusCard(
      BuildContext context,
      String bus,
      String price,
      String departureTime,
      String arrivalTime,
      String from,
      String to,
      ) {
    return Card(
      elevation: 5,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      margin: EdgeInsets.only(bottom: 16),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Row(
          children: [
            Icon(Icons.directions_bus, size: 40, color: Color(0xFF007E95)),
            SizedBox(width: 15),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    bus,
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  Text('Departure: $departureTime'),
                  Text('Arrival: $arrivalTime'),
                  Text('Price: $price'),
                ],
              ),
            ),
            ElevatedButton(
              onPressed: () {
                // Navigate to the BusBookingScreen with bus details
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => BusBookingScreen(
                      busDetails: {
                        'bus': bus,
                        'price': price,
                        'departureTime': departureTime,
                        'arrivalTime': arrivalTime,
                        'from': from,
                        'to': to,
                      },
                      travelers: travelers, // Pass travelers here
                      driverAge: driverAge, // Pass driverAge here
                    ),
                  ),
                );
              },
              child: Text('Book Now'),
              style: ElevatedButton.styleFrom(
                backgroundColor: Color(0xFF007E95),
                foregroundColor: Colors.white,
              ),
            ),
          ],
        ),
      ),
    );
  }
}