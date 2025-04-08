import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'carrentalscreen.dart';

class CarRentalsPage extends StatefulWidget {
  const CarRentalsPage({Key? key}) : super(key: key);
  @override
  _CarRentalsPageState createState() => _CarRentalsPageState();
}

class _CarRentalsPageState extends State<CarRentalsPage> {
  TextEditingController _pickUpLocationController = TextEditingController();
  TextEditingController _dropOffLocationController = TextEditingController();
  TextEditingController _pickUpDateController = TextEditingController();
  TextEditingController _returnDateController = TextEditingController();
  TextEditingController _pickUpTimeController = TextEditingController();
  TextEditingController _returnTimeController = TextEditingController();
  String? _selectedCarType;

  DateTime _pickUpDate = DateTime.now();
  DateTime _returnDate = DateTime.now();
  TimeOfDay _pickUpTime = TimeOfDay.now();
  TimeOfDay _returnTime = TimeOfDay.now();

  List<String> carTypeOptions = ['2 Seater', '4 Seater', '12 Seater'];

  List<Map<String, String>> _availableCars = [
    // ... (Your _availableCars data remains the same)
    {
      'car': 'Toyota Camry',
      'price': '\$50/day',
      'pickUpTime': '10:00 AM',
      'dropOffTime': '05:00 PM',
      'from': 'Dhaka',
      'to': 'Chittagong',
      'date': '2025-04-26',
      'returnDate': '2025-04-27',
      'type': '4 Seater',
    },
    {
      'car': 'Honda Accord',
      'price': '\$60/day',
      'pickUpTime': '02:00 PM',
      'dropOffTime': '08:00 PM',
      'from': 'Sylhet',
      'to': 'Rajshahi',
      'date': '2025-10-27',
      'returnDate': '2025-10-28',
      'type': '4 Seater',
    },
    {
      'car': 'Ford Mustang',
      'price': '\$100/day',
      'pickUpTime': '06:00 AM',
      'dropOffTime': '04:00 PM',
      'from': 'Dhaka',
      'to': 'Chittagong',
      'date': '2025-10-26',
      'returnDate': '2025-10-27',
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
      'returnDate': '2025-10-29',
      'type': '4 Seater',
    },
    {
      'car': 'Toyota Hiace',
      'price': '\$150/day',
      'pickUpTime': '11:00 AM',
      'dropOffTime': '07:00 PM',
      'from': 'Dhaka',
      'to': 'Chittagong',
      'date': '2025-10-26',
      'returnDate': '2025-10-28',
      'type': '12 Seater',
    },
    {
      'car': 'Mercedes Sprinter',
      'price': '\$180/day',
      'pickUpTime': '01:00 PM',
      'dropOffTime': '09:00 PM',
      'from': 'Sylhet',
      'to': 'Rajshahi',
      'date': '2025-10-27',
      'returnDate': '2025-10-29',
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

  Future<void> _selectTime(BuildContext context, bool isPickUp) async {
    final TimeOfDay? picked = await showTimePicker(
      context: context,
      initialTime: isPickUp ? _pickUpTime : _returnTime,
      builder: (BuildContext context, Widget? child) {
        return Theme(
          data: ThemeData.light().copyWith(
            colorScheme: ColorScheme.light(
              primary: Colors.deepPurple,
              onPrimary: Colors.white,
              surface: Colors.deepPurple.shade50,
              onSurface: Colors.black,
            ),
            dialogBackgroundColor: Colors.white,
          ),
          child: child!,
        );
      },
    );
    if (picked != null) {
      setState(() {
        if (isPickUp) {
          _pickUpTime = picked;
          _pickUpTimeController.text = picked.format(context);
        } else {
          _returnTime = picked;
          _returnTimeController.text = picked.format(context);
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
    double inputWidth = MediaQuery.of(context).size.width * 0.5; // Shorter width

    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Search Car Rentals",
          style: GoogleFonts.poppins(fontWeight: FontWeight.w600, color: Colors.white),
        ),
        backgroundColor: Color(0xFF007E95),
        leadingWidth: 20,
      ),
      body: Stack(
        children: [
          Image.asset(
            'images/car3.jpg',
            fit: BoxFit.cover,
            width: double.infinity,
            height: double.infinity,
          ),
          SingleChildScrollView(
            padding: EdgeInsets.all(20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(height: 20),
                _buildTextField(
                  controller: _pickUpLocationController,
                  labelText: 'Pick-up Location',
                  hintText: 'Enter pick-up location',
                  prefixIcon: Icons.location_on,
                  width: inputWidth,
                ),
                SizedBox(height: 10),
                _buildTextField(
                  controller: _dropOffLocationController,
                  labelText: 'Drop-off Location',
                  hintText: 'Enter drop-off location',
                  prefixIcon: Icons.location_on,
                  width: inputWidth,
                ),
                SizedBox(height: 10),
                _buildDateField(
                  controller: _pickUpDateController,
                  labelText: 'Pick-up Date',
                  onTap: () => _selectDate(context, true),
                  width: inputWidth,
                ),
                SizedBox(height: 10),
                _buildTimeField(
                  controller: _pickUpTimeController,
                  labelText: 'Pick-up Time',
                  onTap: () => _selectTime(context, true),
                  width: inputWidth,
                ),
                SizedBox(height: 10),
                _buildDateField(
                  controller: _returnDateController,
                  labelText: 'Return Date',
                  onTap: () => _selectDate(context, false),
                  width: inputWidth,
                ),
                SizedBox(height: 10),
                _buildTimeField(
                  controller: _returnTimeController,
                  labelText: 'Return Time',
                  onTap: () => _selectTime(context, false),
                  width: inputWidth,
                ),
                SizedBox(height: 10),
                _buildCarTypeDropdown(width: inputWidth),
                SizedBox(height: 20),
                Align(
                  alignment: Alignment.centerLeft,
                  child: _buildSearchButton(context),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTextField({
    required TextEditingController controller,
    required String labelText,
    required String hintText,
    required IconData prefixIcon,
    required double width,
  }) {
    return Container(
      width: width,
      child: TextField(
        controller: controller,
        decoration: InputDecoration(
          labelText: labelText,
          hintText: hintText,
          prefixIcon: Icon(prefixIcon),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          filled: true,
          fillColor: Colors.white.withOpacity(0.7),
          labelStyle: TextStyle(color: Colors.black),
          hintStyle: TextStyle(color: Colors.black),
        ),
        style: TextStyle(color: Colors.black),
      ),
    );
  }

  Widget _buildDateField({
    required TextEditingController controller,
    required String labelText,
    required VoidCallback onTap,
    required double width,
  }) {
    return Container(
      width: width,
      child: TextField(
        controller: controller,
        readOnly: true,
        decoration: InputDecoration(
          labelText: labelText,
          prefixIcon: Icon(Icons.calendar_today),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          filled: true,
          fillColor: Colors.white.withOpacity(0.7),
          labelStyle: TextStyle(color: Colors.black),
          hintStyle: TextStyle(color: Colors.black),
        ),
        style: TextStyle(color: Colors.black),
        onTap: onTap,
      ),
    );
  }

  Widget _buildTimeField({
    required TextEditingController controller,
    required String labelText,
    required VoidCallback onTap,
    required double width,
  }) {
    return Container(
      width: width,
      child: TextField(
        controller: controller,
        readOnly: true,
        decoration: InputDecoration(
          labelText: labelText,
          prefixIcon: Icon(Icons.access_time),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          filled: true,
          fillColor: Colors.white.withOpacity(0.7),
          labelStyle: TextStyle(color: Colors.black),
          hintStyle: TextStyle(color: Colors.black),
        ),
        style: TextStyle(color: Colors.black),
        onTap: onTap,
      ),
    );
  }

  Widget _buildCarTypeDropdown({required double width}) {
    return Container(
      width: width,
      child: DropdownButtonFormField<String>(
        value: _selectedCarType,
        items: carTypeOptions.map((type) {
          return DropdownMenuItem<String>(
            value: type,
            child: Text(
              type,
              style: TextStyle(color: Colors.black),
            ),
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
          filled: true,
          fillColor: Colors.white.withOpacity(0.7),
          labelStyle: TextStyle(color: Colors.black),
          hintStyle: TextStyle(color: Colors.black),
        ),
        style: TextStyle(color: Colors.black),
      ),
    );
  }

  Widget _buildSearchButton(BuildContext context) {
    return ElevatedButton(
      onPressed: () => _searchCars(context),
      child: Text('Search Cars'),
      style: ElevatedButton.styleFrom(
        backgroundColor: Color(0xFF007E95),
        foregroundColor: Colors.white,
        textStyle: TextStyle(fontWeight: FontWeight.bold),
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
        foregroundColor: Colors.white,
        leadingWidth: 100,
      ),
      body: Stack(
        children: [
          Image.asset(
            'images/car3.jpg',
            fit: BoxFit.cover,
            width: double.infinity,
            height: double.infinity,
          ),
          ListView.builder(
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
        ],
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
    Map<String, String>? selectedCar;
    for (var availableCar in filteredCars) {
      if (availableCar['car'] == car &&
          availableCar['price'] == price &&
          availableCar['pickUpTime'] == pickUpTime &&
          availableCar['dropOffTime'] == dropOffTime &&
          availableCar['from'] == from &&
          availableCar['to'] == to) {
        selectedCar = availableCar;
        break;
      }
    }

    return Card(
      elevation: 5,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      margin: EdgeInsets.only(bottom: 16),
      color: Colors.white.withOpacity(0.8),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Row(
          children: [
            Icon(Icons.directions_car, size: 40, color: Color(0xFF007E95)),
            SizedBox(width: 15),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  car,
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.black),
                ),
                Text('Pick-up Time: $pickUpTime', style: TextStyle(color: Colors.black)),
                Text('Drop-off Time: $dropOffTime', style: TextStyle(color: Colors.black)),
                Text('Price: $price', style: TextStyle(color: Colors.black)),
                Text('Pick-up Location: $from', style: TextStyle(color: Colors.black)),
                Text('Drop-off Location: $to', style: TextStyle(color: Colors.black)),
              ],
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
                        'type': selectedCar?['type'] ?? 'Not Available',
                      },
                      rentalDetails: {
                        'from': from,
                        'to': to,
                        'date': selectedCar?['date'] ?? 'Not Available',
                        'returnDate': selectedCar?['returnDate'] ?? 'Not Available',
                        'type': selectedCar?['type'] ?? 'Not Available',
                      },
                    ),
                  ),
                );
              },
              child: Text('Book Now'),
              style: ElevatedButton.styleFrom(
                backgroundColor: Color(0xFF007E95),
                foregroundColor: Colors.white,
                textStyle: TextStyle(fontWeight: FontWeight.bold),
              ),
            ),
          ],
        ),
      ),
    );
  }
}