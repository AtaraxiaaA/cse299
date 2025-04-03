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
  String? _selectedBusType; // Added bus type selection

  List<String> ageOptions =
  List.generate(80 - 18 + 1, (index) => (18 + index).toString());

  List<String> busTypeOptions = ['All', 'AC', 'Non-AC']; // Added bus type options

  List<Map<String, String>> _availableBuses = [
    {
      'bus': 'Volvo AC Sleeper',
      'price': '\$30',
      'departureTime': '08:00 AM',
      'arrivalTime': '04:00 PM',
      'from': 'Dhaka',
      'to': 'Chittagong',
      'date': '2024-10-26',
      'type': 'AC',
    },
    {
      'bus': 'Scania AC Deluxe',
      'price': '\$35',
      'departureTime': '10:00 AM',
      'arrivalTime': '06:00 PM',
      'from': 'Dhaka',
      'to': 'Chittagong',
      'date': '2024-10-26',
      'type': 'AC',
    },
    {
      'bus': 'Mercedes Benz AC',
      'price': '\$40',
      'departureTime': '12:00 PM',
      'arrivalTime': '08:00 PM',
      'from': 'Dhaka',
      'to': 'Chittagong',
      'date': '2024-10-26',
      'type': 'AC',
    },
    {
      'bus': 'Tata AC Express',
      'price': '\$45',
      'departureTime': '02:00 PM',
      'arrivalTime': '10:00 PM',
      'from': 'Dhaka',
      'to': 'Chittagong',
      'date': '2024-10-26',
      'type': 'AC',
    },
    {
      'bus': 'Non-AC Seater',
      'price': '\$15',
      'departureTime': '09:00 AM',
      'arrivalTime': '05:00 PM',
      'from': 'Dhaka',
      'to': 'Chittagong',
      'date': '2024-10-26',
      'type': 'Non-AC',
    },
    {
      'bus': 'Ashok Leyland Non-AC',
      'price': '\$20',
      'departureTime': '11:00 AM',
      'arrivalTime': '07:00 PM',
      'from': 'Dhaka',
      'to': 'Chittagong',
      'date': '2024-10-26',
      'type': 'Non-AC',
    },
    {
      'bus': 'Non-AC Deluxe',
      'price': '\$22',
      'departureTime': '01:00 PM',
      'arrivalTime': '09:00 PM',
      'from': 'Dhaka',
      'to': 'Chittagong',
      'date': '2025-10-26',
      'type': 'Non-AC',
    },
    {
      'bus': 'Non-AC Express',
      'price': '\$25',
      'departureTime': '03:00 PM',
      'arrivalTime': '11:00 PM',
      'from': 'Dhaka',
      'to': 'Chittagong',
      'date': '2024-10-26',
      'type': 'Non-AC',
    },
  ];

  List<Map<String, String>> filteredBuses = [];

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

  void _searchBuses(BuildContext context) {
    setState(() {
      filteredBuses = _availableBuses
          .where((bus) =>
      bus['from']!.toLowerCase().contains(_fromLocationController.text.toLowerCase()) &&
          bus['to']!.toLowerCase().contains(_toLocationController.text.toLowerCase()) &&
          bus['date'] == _departureDateController.text &&
          (_selectedBusType == null || _selectedBusType == 'All' || bus['type'] == _selectedBusType))
          .toList();
    });

    if (filteredBuses.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('No buses found!')),
      );
    } else {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => BusSearchResultsScreen(
            filteredBuses: filteredBuses,
            travelers: travelers,
            driverAge: driverAge,
            fromLocation: _fromLocationController.text,
            toLocation: _toLocationController.text,
          ),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Search for Buses",
          style: GoogleFonts.poppins(fontWeight: FontWeight.w600, color: Colors.black),
        ),
        backgroundColor: Color(0xFF007E95),
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
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
            SizedBox(height: 10),
            DropdownButtonFormField<String>(
              value: _selectedBusType,
              items: busTypeOptions.map((type) {
                return DropdownMenuItem<String>(
                  value: type,
                  child: Text(type),
                );
              }).toList(),
              onChanged: (value) {
                setState(() {
                  _selectedBusType = value;
                });
              },
              decoration: InputDecoration(
                labelText: 'Bus Type',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: () => _searchBuses(context),
              child: Text('Search Buses'),
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

class BusSearchResultsScreen extends StatelessWidget {
  final List<Map<String, String>> filteredBuses;
  final int travelers;
  final String? driverAge;
  final String fromLocation;
  final String toLocation;

  BusSearchResultsScreen({
    required this.filteredBuses,
    required this.travelers,
    required this.driverAge,
    required this.fromLocation,
    required this.toLocation,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Available Buses'),
        backgroundColor: Color(0xFF007E95),
      ),
      body: ListView.builder(
        itemCount: filteredBuses.length,
        itemBuilder: (context, index) {
          var bus = filteredBuses[index];
          return buildBusCard(
            context,
            bus['bus']!,
            bus['price']!,
            bus['departureTime']!,
            bus['arrivalTime']!,
            bus['from']!,
            bus['to']!,
            fromLocation,
            toLocation,
          );
        },
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
      String fromLocation,
      String toLocation,
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
                  Text('Pick-up: $fromLocation'),
                  Text('Drop-off: $toLocation'),
                ],
              ),
            ),
            ElevatedButton(
              onPressed: () {
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
                      travelers: travelers,
                      driverAge: driverAge,
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