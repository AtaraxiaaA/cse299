import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'busbookingscreen.dart';

class BusSearchScreen extends StatefulWidget {
  const BusSearchScreen({super.key});

  @override
  _BusSearchScreenState createState() => _BusSearchScreenState();
}

class _BusSearchScreenState extends State<BusSearchScreen> {
  TextEditingController _fromLocationController = TextEditingController();
  TextEditingController _toLocationController = TextEditingController();
  TextEditingController _departureDateController = TextEditingController();
  DateTime _departureDate = DateTime.now();
  int travelers = 1;
  String? driverAge;
  String? _selectedBusType;
  bool _isFromLocationSelected = false;
  bool _isToLocationSelected = false;
  bool _isDepartureDateSelected = false;

  List<String> ageOptions =
  List.generate(80 - 18 + 1, (index) => (18 + index).toString());

  List<String> busTypeOptions = [
    'All',
    'AC',
    'Non-AC',
    'Sleeper Coach AC',
    'Sleeper Coach Non-AC'
  ];

  List<Map<String, String>> _availableBuses = [
    {
      'bus': 'Volvo AC Sleeper',
      'price': '\$30',
      'departureTime': '08:00 AM',
      'arrivalTime': '04:00 PM',
      'from': 'Dhaka',
      'to': 'Chittagong',
      'date': '2025-10-26',
      'type': 'AC',
    },
    {
      'bus': 'Volvo AC Sleeper',
      'price': '\$20',
      'departureTime': '08:00 AM',
      'arrivalTime': '04:00 PM',
      'from': 'Dhaka',
      'to': 'Chittagong',
      'date': '2025-10-27',
      'type': 'AC',
    },
    {
      'bus': 'Scania AC',
      'price': '\$35',
      'departureTime': '10:00 AM',
      'arrivalTime': '06:00 PM',
      'from': 'Dhaka',
      'to': 'Chittagong',
      'date': '2025-10-26',
      'type': 'AC',
    },
    {
      'bus': 'Mercedes Benz AC',
      'price': '\$40',
      'departureTime': '12:00 PM',
      'arrivalTime': '08:00 PM',
      'from': 'Dhaka',
      'to': 'Chittagong',
      'date': '2025-10-26',
      'type': 'AC',
    },
    {
      'bus': 'Tata AC Express',
      'price': '\$45',
      'departureTime': '02:00 PM',
      'arrivalTime': '10:00 PM',
      'from': 'Dhaka',
      'to': 'Chittagong',
      'date': '2025-10-26',
      'type': 'AC',
    },
    {
      'bus': 'Non-AC Seater',
      'price': '\$15',
      'departureTime': '09:00 AM',
      'arrivalTime': '05:00 PM',
      'from': 'Dhaka',
      'to': 'Chittagong',
      'date': '2025-10-26',
      'type': 'Non-AC',
    },
    {
      'bus': 'Ashok Leyland Non-AC',
      'price': '\$20',
      'departureTime': '11:00 AM',
      'arrivalTime': '07:00 PM',
      'from': 'Dhaka',
      'to': 'Chittagong',
      'date': '2025-10-26',
      'type': 'Non-AC',
    },
    {
      'bus': 'Non-AC',
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
      'date': '2025-10-26',
      'type': 'Non-AC',
    },
    {
      'bus': 'Sleeper Coach AC',
      'price': '\$50',
      'departureTime': '06:00 AM',
      'arrivalTime': '02:00 PM',
      'from': 'Dhaka',
      'to': 'Chittagong',
      'date': '2025-10-26',
      'type': 'Sleeper Coach AC',
    },
    {
      'bus': 'Sleeper Coach Non-AC',
      'price': '\$35',
      'departureTime': '07:00 AM',
      'arrivalTime': '03:00 PM',
      'from': 'Dhaka',
      'to': 'Chittagong',
      'date': '2025-10-26',
      'type': 'Sleeper Coach Non-AC',
    },
    {
      'bus': 'Sleeper Coach AC',
      'price': '\$48',
      'departureTime': '09:00 AM',
      'arrivalTime': '05:00 PM',
      'from': 'Dhaka',
      'to': 'Chittagong',
      'date': '2025-10-27',
      'type': 'Sleeper Coach AC',
    },
    {
      'bus': 'Sleeper Coach Non-AC',
      'price': '\$38',
      'departureTime': '10:00 AM',
      'arrivalTime': '06:00 PM',
      'from': 'Dhaka',
      'to': 'Chittagong',
      'date': '2025-10-27',
      'type': 'Sleeper Coach Non-AC',
    },
    {
      'bus': 'AC',
      'price': '\$38',
      'departureTime': '11:00 AM',
      'arrivalTime': '07:00 PM',
      'from': 'Dhaka',
      'to': 'Chittagong',
      'date': '2025-10-27',
      'type': 'AC',
    },
    {
      'bus': 'Non-AC',
      'price': '\$18',
      'departureTime': '12:00 PM',
      'arrivalTime': '08:00 PM',
      'from': 'Dhaka',
      'to': 'Chittagong',
      'date': '2025-10-27',
      'type': 'Non-AC',
    },
  ];
  List<Map<String, String>> filteredBuses = [];

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: _departureDate,
      firstDate: DateTime.now(),
      lastDate: DateTime(2026),
      builder: (BuildContext context, Widget? child) {
        return Theme(
          data: ThemeData.light().copyWith(
            colorScheme: ColorScheme.light(primary: Colors.blue),
            textTheme: TextTheme(
              bodyLarge: TextStyle(color: Colors.black),
              bodyMedium: TextStyle(color: Colors.black),
              bodySmall: TextStyle(color: Colors.black),
              titleLarge: TextStyle(color: Colors.black),
              titleMedium: TextStyle(color: Colors.black),
              titleSmall: TextStyle(color: Colors.black),
              headlineLarge: TextStyle(color: Colors.black),
              headlineMedium: TextStyle(color: Colors.black),
              headlineSmall: TextStyle(color: Colors.black),
              labelLarge: TextStyle(color: Colors.black),
            ),
            textButtonTheme: TextButtonThemeData(
              style: TextButton.styleFrom(
                foregroundColor: Colors.blue[900],
              ),
            ),
          ),
          child: child!,
        );
      },
    );
    if (picked != null) {
      setState(() {
        _departureDate = picked;
        _departureDateController.text = DateFormat('yyyy-MM-dd').format(picked);
        _isDepartureDateSelected = true;
      });
    }
  }

  void _searchBuses(BuildContext context) {
    setState(() {
      filteredBuses = _availableBuses
          .where((bus) =>
      bus['from']!.toLowerCase().trim() == _fromLocationController.text.toLowerCase().trim() &&
          bus['to']!.toLowerCase().trim() == _toLocationController.text.toLowerCase().trim() &&
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
          style: GoogleFonts.poppins(fontWeight: FontWeight.w600, color: Colors.white),
        ),
        backgroundColor: Color(0xFF007E95),
      ),
      body: LayoutBuilder(
        builder: (BuildContext context, BoxConstraints viewportConstraints) {
          return SingleChildScrollView(
            child: ConstrainedBox(
              constraints: BoxConstraints(
                minHeight: viewportConstraints.maxHeight,
              ),
              child: Container(
                decoration: BoxDecoration(
                  image: DecorationImage(
                    image: AssetImage('images/busimage1.jpg'),
                    fit: BoxFit.cover,
                    colorFilter: ColorFilter.mode(
                      Colors.black.withOpacity(0.4),
                      BlendMode.darken,
                    ),
                  ),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      SizedBox(height: 20),
                      TextField(
                        controller: _fromLocationController,
                        decoration: InputDecoration(
                          hintText: 'Enter pick-up location',
                          hintStyle: TextStyle(color: Colors.black),
                          prefixIcon: Icon(Icons.location_on, color: Colors.black),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                          filled: true,
                          fillColor: Colors.white.withOpacity(0.8),
                        ),
                        style: TextStyle(color: Colors.black),
                      ),
                      SizedBox(height: 10),
                      TextField(
                        controller: _toLocationController,
                        decoration: InputDecoration(
                          hintText: 'Enter drop-off location',
                          hintStyle: TextStyle(color: Colors.black),
                          prefixIcon: Icon(Icons.location_on, color: Colors.black),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                          filled: true,
                          fillColor: Colors.white.withOpacity(0.8),
                        ),
                        style: TextStyle(color: Colors.black),
                      ),
                      SizedBox(height: 10),
                      GestureDetector(
                        onTap: () => _selectDate(context),
                        child: TextField(
                          controller: _departureDateController,
                          enabled: false,
                          decoration: InputDecoration(
                            hintText: 'Select a pick-up date',
                            hintStyle: TextStyle(color: Colors.black),
                            prefixIcon: Icon(Icons.calendar_today, color: Colors.black),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                            filled: true,
                            fillColor: Colors.white.withOpacity(0.8),
                          ),
                          style: TextStyle(color: Colors.black),
                        ),
                      ),
                      SizedBox(height: 10),
                      DropdownButtonFormField<String>(
                        value: _selectedBusType,
                        items: busTypeOptions.map((type) {
                          return DropdownMenuItem<String>(
                            value: type,
                            child: Text(type, style: TextStyle(color: Colors.black)),
                          );
                        }).toList(),
                        onChanged: (value) {
                          setState(() {
                            _selectedBusType = value;
                          });
                        },
                        decoration: InputDecoration(
                          labelText: 'Bus Type',
                          labelStyle: TextStyle(color: Colors.black),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                          filled: true,
                          fillColor: Colors.white.withOpacity(0.8),
                        ),
                        style: TextStyle(color: Colors.black),
                      ),
                      SizedBox(height: 20),
                      Center(
                        child: ElevatedButton(
                          onPressed: () => _searchBuses(context),
                          child: Text('Search Buses', style: TextStyle(color: Colors.black)),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.white,
                            padding: EdgeInsets.symmetric(horizontal: 40, vertical: 16),
                          ),
                        ),
                      ),
                      SizedBox(height: 20),
                    ],
                  ),
                ),
              ),
            ),
          );
        },
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
        title: Text('Available Buses', style: TextStyle(color: Colors.white)),
        backgroundColor: Color(0xFF007E95),
      ),
      body: Container(
        decoration: BoxDecoration(
          image: DecorationImage(
            image: AssetImage('images/busimage1.jpg'),
            fit: BoxFit.cover,
            colorFilter: ColorFilter.mode(
              Colors.black.withOpacity(0.4),
              BlendMode.darken,
            ),
          ),
        ),
        child: ListView.builder(
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