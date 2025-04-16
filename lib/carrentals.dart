import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'AvailableCarsScreen.dart'; // Import AvailableCarsScreen

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

  List<String> carTypeOptions = ['2 seater', '4 seater', '12 seater'];

  List<Map<String, String>> _availableCars = [];

  List<Map<String, String>> filteredCars = [];

  @override
  void initState() {
    super.initState();
    _fetchCarsFromFirestore();
  }

  Future<void> _fetchCarsFromFirestore() async {
    try {
      QuerySnapshot querySnapshot =
      await FirebaseFirestore.instance.collection('car').get();

      List<Map<String, String>> fetchedCars = [];
      querySnapshot.docs.forEach((doc) {
        Map<String, dynamic> data = doc.data() as Map<String, dynamic>;
        print(
            'Firestore Car: ${data['car']}, From: ${data['from']}, To: ${data['to']}, Date: ${data['date']}, Type: ${data['type']}');
        fetchedCars.add({
          'car': data['car'] as String? ?? '',
          'price': data['price'] as String? ?? '',
          'pickUpTime': data['pickUpTime'] as String? ?? '',
          'dropOffTime': data['dropOffTime'] as String? ?? '',
          'from': data['from']?.toLowerCase() ?? '',
          'to': data['to']?.toLowerCase() ?? '',
          'date': data['date'] as String? ?? '',
          'returnDate': data['returnDate'] as String? ?? '',
          'type': data['type']?.toLowerCase() ?? '',
        });
      });

      setState(() {
        _availableCars = fetchedCars;
        print('Available Cars: $_availableCars');
      });
    } catch (e) {
      print('Error fetching cars: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to load cars. Please check your connection.')),
      );
    }
  }

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
    print(
        'Pick-up: ${_pickUpLocationController.text}, Type: ${_pickUpLocationController.text.runtimeType}');
    print(
        'Drop-off: ${_dropOffLocationController.text}, Type: ${_dropOffLocationController.text.runtimeType}');
    print(
        'Pick-up Date: ${_pickUpDateController.text}, Type: ${_pickUpDateController.text.runtimeType}');
    print(
        'Selected Type: $_selectedCarType, Type: $_selectedCarType.runtimeType');
    print(
        'Firestore Date (from _availableCars): ${_availableCars.isNotEmpty ? _availableCars[0]['date'] : 'No cars in _availableCars'}');

    setState(() {
      filteredCars = _availableCars
          .where((car) =>
      car['from'] == _pickUpLocationController.text.toLowerCase() &&
          car['to'] == _dropOffLocationController.text.toLowerCase() &&
          car['date'] == _pickUpDateController.text &&
          (_selectedCarType == null || car['type'] == _selectedCarType))
          .toList();
    });

    print('Filtered Cars: $filteredCars');

    if (filteredCars.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('No cars found!')),
      );
    } else {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => AvailableCarsScreen( // Use AvailableCarsScreen
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
    double inputWidth = MediaQuery.of(context).size.width * 0.5;

    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Search Car For Rentals",
          style: GoogleFonts.poppins(fontWeight: FontWeight.w600, color: Colors.white),
        ),
        backgroundColor: Color(0xFF007E95),
        leadingWidth: 20,
      ),
      body: Stack(
        children: [
          Image.asset('images/car3.jpg', fit: BoxFit.cover, width: double.infinity, height: double.infinity),
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
            _selectedCarType = value?.toLowerCase();
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