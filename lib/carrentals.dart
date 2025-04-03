import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'carrentalscreen.dart'; // Import your booking screen for car rental

class CarRentalsPage extends StatefulWidget {
  const CarRentalsPage({super.key});

  @override
  _CarRentalsPageState createState() => _CarRentalsPageState();
}

class _CarRentalsPageState extends State<CarRentalsPage> {
  TextEditingController _pickUpLocationController = TextEditingController();
  TextEditingController _dropOffLocationController = TextEditingController();
  TextEditingController _pickUpDateController = TextEditingController();
  TextEditingController _returnDateController = TextEditingController();
  String? _selectedCarType;

  DateTime _pickUpDate = DateTime.now();
  DateTime _returnDate = DateTime.now();

  List<String> carTypeOptions = ['2 Seater', '4 Seater', '12 Seater'];

  List<Map<String, String>> _availableCars = [
    {
      'car': 'Toyota Camry',
      'price': '\$50/day',
      'pickUpTime': '10:00 AM',
      'dropOffTime': '05:00 PM',
      'from': 'Dhaka',
      'to': 'Chittagong',
      'date': '2024-10-26',
      'type': '4 Seater',
    },
    {
      'car': 'Honda Accord',
      'price': '\$60/day',
      'pickUpTime': '02:00 PM',
      'dropOffTime': '08:00 PM',
      'from': 'Sylhet',
      'to': 'Rajshahi',
      'date': '2024-10-27',
      'type': '4 Seater',
    },
    {
      'car': 'Ford Mustang',
      'price': '\$100/day',
      'pickUpTime': '06:00 AM',
      'dropOffTime': '04:00 PM',
      'from': 'Dhaka',
      'to': 'Chittagong',
      'date': '2024-10-26',
      'type': '2 Seater',
    },
    {
      'car': 'Nissan Altima',
      'price': '\$70/day',
      'pickUpTime': '09:00 AM',
      'dropOffTime': '06:00 PM',
      'from': 'Rajshahi',
      'to': 'Sylhet',
      'date': '2025-10-28',
      'type': '4 Seater',
    },
    {
      'car': 'Toyota Hiace',
      'price': '\$150/day',
      'pickUpTime': '11:00 AM',
      'dropOffTime': '07:00 PM',
      'from': 'Dhaka',
      'to': 'Chittagong',
      'date': '2024-10-26',
      'type': '12 Seater',
    },
    {
      'car': 'Mercedes Sprinter',
      'price': '\$180/day',
      'pickUpTime': '01:00 PM',
      'dropOffTime': '09:00 PM',
      'from': 'Sylhet',
      'to': 'Rajshahi',
      'date': '2024-10-27',
      'type': '12 Seater',
    },
  ];

  List<Map<String, String>> filteredCars = [];

  Future<void> _selectDate(BuildContext context, bool isPickUp) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: isPickUp ? _pickUpDate : _returnDate,
      firstDate: DateTime.now(),
      lastDate: DateTime(2026),
    );
    if (picked != null) {
      setState(() {
        if (isPickUp) {
          _pickUpDate = picked;
          _pickUpDateController.text = DateFormat('yyyy-MM-dd').format(picked);
        } else {
          _returnDate = picked;
          _returnDateController.text = DateFormat('yyyy-MM-dd').format(picked);
        }
      });
    }
  }

  void _searchCars(BuildContext context) {
    setState(() {
      filteredCars = _availableCars
          .where((car) =>
      car['from']!.toLowerCase().contains(_pickUpLocationController.text.toLowerCase()) &&
          car['to']!.toLowerCase().contains(_dropOffLocationController.text.toLowerCase()) &&
          car['date'] == _pickUpDateController.text &&
          (_selectedCarType == null || car['type'] == _selectedCarType))
          .toList();
    });

    if (filteredCars.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('No cars found!')),
      );
    } else {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => CarSearchResultsScreen(
            filteredCars: filteredCars,
            fromLocation: _pickUpLocationController.text,
            toLocation: _dropOffLocationController.text,
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
          "Search for Cars",
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
              controller: _pickUpLocationController,
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
              controller: _dropOffLocationController,
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
              controller: _pickUpDateController,
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
            if (true) // always show return date
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
              value: _selectedCarType,
              items: carTypeOptions.map((type) {
                return DropdownMenuItem<String>(
                  value: type,
                  child: Text(type),
                );
              }).toList(),
              onChanged: (value) {
                setState(() {
                  _selectedCarType = value;
                });
              },
              decoration: InputDecoration(
                labelText: 'Car Type',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: () => _searchCars(context),
              child: Text('Search Cars'),
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

class CarSearchResultsScreen extends StatelessWidget {
  final List<Map<String, String>> filteredCars;
  final String fromLocation;
  final String toLocation;

  CarSearchResultsScreen({
    required this.filteredCars,
    required this.fromLocation,
    required this.toLocation,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Available Cars'),
        backgroundColor: Color(0xFF007E95),
      ),
      body: ListView.builder(
        itemCount: filteredCars.length,
        itemBuilder: (context, index) {
          var car = filteredCars[index];
          return buildCarCard(
            context,
            car['car']!,
            car['price']!,
            car['pickUpTime']!,
            car['dropOffTime']!,
            car['from']!,
            car['to']!,
          );
        },
      ),
    );
  }

  Widget buildCarCard(
      BuildContext context,
      String car,
      String price,
      String pickUpTime,
      String dropOffTime,
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
            Icon(Icons.directions_car, size: 40, color: Color(0xFF007E95)),
            SizedBox(width: 15),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    car,
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  Text('Pick-up Time: $pickUpTime'),
                  Text('Drop-off Time: $dropOffTime'),
                  Text('Price: $price'),
                  Text('Pick-up: $from'),
                  Text('Drop-off: $to'),
                ],
              ),
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => CarRentalScreen(
                      carDetails: {
                        'car': car,
                        'price': price,
                        'pickUpTime': pickUpTime,
                        'dropOffTime': dropOffTime,
                        'from': from,
                        'to': to,
                      },
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