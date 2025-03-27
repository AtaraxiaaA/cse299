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

  DateTime _pickUpDate = DateTime.now();
  DateTime _returnDate = DateTime.now();

  List<Map<String, String>> _carRentals = [
    {
      'car': 'Toyota Camry',
      'price': '\$50/day',
      'pickUpTime': '10:00 AM',
      'dropOffTime': '05:00 PM',
    },
    {
      'car': 'Honda Accord',
      'price': '\$60/day',
      'pickUpTime': '02:00 PM',
      'dropOffTime': '08:00 PM',
    },
    {
      'car': 'Ford Mustang',
      'price': '\$100/day',
      'pickUpTime': '06:00 AM',
      'dropOffTime': '04:00 PM',
    },
  ];

  // Function to pick a date
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

  @override
  Widget build(BuildContext context) {
    List<Map<String, String>> filteredCars = _carRentals
        .where(
          (car) =>
      (car['car']!.toLowerCase().contains(_pickUpLocationController.text.toLowerCase())) &&
          (car['price']!.toLowerCase().contains(_dropOffLocationController.text.toLowerCase())),
    )
        .toList();

    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Car Rentals',
          style: GoogleFonts.poppins(fontWeight: FontWeight.w600),
        ),
        backgroundColor: Color(0xFF007E95),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Search Bar
              Text(
                'Search Car Rentals',
                style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 20),

              // Pick-up Location
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

              // Drop-off Location
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

              // Pick-up Date
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

              // Return Date (only for round trips)
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

              // Available Cars Heading
              Text(
                'Available Cars',
                style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 20),

              // Displaying filtered cars
              if (filteredCars.isEmpty)
                Text('No cars found', style: TextStyle(fontSize: 18)),
              for (var car in filteredCars)
                buildCarCard(
                  context,
                  car['car']!,
                  car['price']!,
                  car['pickUpTime']!,
                  car['dropOffTime']!,
                ),
            ],
          ),
        ),
      ),
    );
  }

  // Car Rental Card Widget
  Widget buildCarCard(
      BuildContext context,
      String car,
      String price,
      String pickUpTime,
      String dropOffTime,
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
                ],
              ),
            ),
            ElevatedButton(
              onPressed: () {
                // Navigate to the CarRentalScreen with car rental details
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => CarRentalScreen(
                      carDetails: {
                        'car': car,
                        'price': price,
                        'pickUpTime': pickUpTime,
                        'dropOffTime': dropOffTime,
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
