import 'package:flutter/material.dart';
//import 'package:intl/intl.dart';
import 'book.dart';

class FlightScreen extends StatefulWidget {
  const FlightScreen({super.key});

  @override
  _FlightScreenState createState() => _FlightScreenState();
}

class _FlightScreenState extends State<FlightScreen> {
  TextEditingController _fromController = TextEditingController();
  TextEditingController _toController = TextEditingController();
  TextEditingController _departureDateController = TextEditingController();

  final String _searchQuery = '';
  DateTime _departureDate = DateTime.now();

  List<Map<String, String>> _flights = [
    {
      'from': 'Dhaka',
      'to': 'Singapore',
      'departure': '10:00 AM',
      'price': '\$300',
      'stopType': 'Non-stop',
    },
    {
      'from': 'Dhaka',
      'to': 'London',
      'departure': '02:00 PM',
      'price': '\$500',
      'stopType': '1 Stop',
    },
    {
      'from': 'Dhaka',
      'to': 'New York',
      'departure': '08:00 PM',
      'price': '\$700',
      'stopType': 'Non-stop',
    },
  ];

  // Function to pick a date
  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: _departureDate,
      firstDate: DateTime(2023),
      lastDate: DateTime(2025),
    );
    if (picked != null && picked != _departureDate) {
      setState(() {
        _departureDate = picked;
        //_departureDateController.text = DateFormat('yyyy-MM-dd').format(picked);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    List<Map<String, String>> filteredFlights =
        _flights
            .where(
              (flight) =>
                  (flight['from']!.toLowerCase().contains(
                    _fromController.text.toLowerCase(),
                  )) &&
                  (flight['to']!.toLowerCase().contains(
                    _toController.text.toLowerCase(),
                  )),
            )
            .toList();

    return Scaffold(
      appBar: AppBar(
        title: Text('Flights'),
        backgroundColor: Color(0xFF003653),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Search Bar
              Text(
                'Search Flights',
                style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 20),

              // From (Departure City)
              TextField(
                controller: _fromController,
                decoration: InputDecoration(
                  labelText: 'From',
                  hintText: 'Enter departure city',
                  prefixIcon: Icon(Icons.flight_takeoff),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
              ),
              SizedBox(height: 10),

              // To (Destination City)
              TextField(
                controller: _toController,
                decoration: InputDecoration(
                  labelText: 'To',
                  hintText: 'Enter destination city',
                  prefixIcon: Icon(Icons.flight_land),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
              ),
              SizedBox(height: 10),

              // Departure Date
              TextField(
                controller: _departureDateController,
                readOnly: true,
                decoration: InputDecoration(
                  labelText: 'Departure Date',
                  hintText: 'Select a departure date',
                  prefixIcon: Icon(Icons.calendar_today),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                onTap: () => _selectDate(context),
              ),
              SizedBox(height: 20),

              // Available Flights Heading
              Text(
                'Available Flights',
                style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 20),

              // Displaying filtered flights
              if (filteredFlights.isEmpty)
                Text('No flights found', style: TextStyle(fontSize: 18)),
              for (var flight in filteredFlights)
                buildFlightCard(
                  context,
                  flight['from']!,
                  flight['to']!,
                  flight['departure']!,
                  flight['price']!,
                  flight['stopType']!,
                ),
            ],
          ),
        ),
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
  ) {
    return Card(
      elevation: 5,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      margin: EdgeInsets.only(bottom: 16),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Row(
          children: [
            Icon(Icons.flight_takeoff, size: 40, color: Color(0xFF003653)),
            SizedBox(width: 15),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    '$from to $to',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  Text('Departure: $departure'),
                  Text('Stop Type: $stopType'),
                  Text('Price: $price'),
                ],
              ),
            ),
            ElevatedButton(
              onPressed: () {
                // Navigate to the BookScreen with flight details
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder:
                        (context) => BookScreen(
                          flightDetails: {
                            'from': from,
                            'to': to,
                            'departure': departure,
                            'price': price,
                          },
                        ),
                  ),
                );
              },
              child: Text('Book Now'),
              style: ElevatedButton.styleFrom(
                backgroundColor: Color(0xFF003653), // Updated to a darker color
                foregroundColor: Colors.white, // Ensures text is readable
              ),
            ),
          ],
        ),
      ),
    );
  }
}
