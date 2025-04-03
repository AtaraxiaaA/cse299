import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class CarRentalScreen extends StatefulWidget {
  final Map<String, String>? carDetails;
  const CarRentalScreen({Key? key, required this.carDetails}) : super(key: key);

  @override
  _CarRentalScreenState createState() => _CarRentalScreenState();
}

class _CarRentalScreenState extends State<CarRentalScreen> {
  int _rentalDays = 1;
  String _selectedCarType = 'Standard';
  String _selectedPaymentMethod = 'Credit Card';
  double _totalPrice = 0.0;

  final List<String> _paymentMethods = ['Credit Card', 'PayPal', 'Debit Card'];

  @override
  void initState() {
    super.initState();
    _calculateTotalPrice();
  }

  void _calculateTotalPrice() {
    if (widget.carDetails == null || widget.carDetails!['price'] == null) {
      print('Error: Car details or price is null.');
      setState(() {
        _totalPrice = 0.0;
      });
      return;
    }
    try {
      double basePrice = double.parse(
        widget.carDetails!['price']!.substring(1).split('/')[0], // Remove the '$' and '/day'
      );
      double carTypeMultiplier = _selectedCarType == 'Luxury' ? 1.5 : 1.0;
      setState(() {
        _totalPrice = basePrice * _rentalDays * carTypeMultiplier;
      });
    } catch (e) {
      print('Error parsing price: $e');
      setState(() {
        _totalPrice = 0.0;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Book Your Car Rental'),
        backgroundColor: Color(0xFF007E95),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Car Details',
                style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 10),
              buildCarDetailsCard(),
              SizedBox(height: 20),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text('Number of Rental Days:', style: TextStyle(fontSize: 18)),
                  Row(
                    children: [
                      IconButton(
                        icon: Icon(Icons.remove),
                        onPressed: () {
                          setState(() {
                            if (_rentalDays > 1) _rentalDays--;
                            _calculateTotalPrice();
                          });
                        },
                      ),
                      Text('$_rentalDays', style: TextStyle(fontSize: 18)),
                      IconButton(
                        icon: Icon(Icons.add),
                        onPressed: () {
                          setState(() {
                            _rentalDays++;
                            _calculateTotalPrice();
                          });
                        },
                      ),
                    ],
                  ),
                ],
              ),
              SizedBox(height: 20),
              Text('Select Car Type:', style: TextStyle(fontSize: 18)),
              SizedBox(height: 10),
              buildCarTypeSelector(),
              SizedBox(height: 20),
              Text(
                'Payment Method',
                style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 10),
              buildPaymentMethodSelector(),
              SizedBox(height: 20),
              Text(
                'Total Price: \$${_totalPrice.toStringAsFixed(2)}',
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 20),
              Container(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () {
                    if (widget.carDetails == null) {
                      print("Car Details are null, booking cannot be processed.");
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(content: Text('Car details are missing.')),
                      );
                      return;
                    }
                    showDialog(
                      context: context,
                      builder: (context) {
                        return AlertDialog(
                          title: Text('Booking Confirmation'),
                          content: Text(
                            'You have successfully booked your rental car!',
                          ),
                          actions: [
                            TextButton(
                              onPressed: () {
                                Navigator.pop(context);
                                Navigator.pop(context);
                              },
                              child: Text('OK'),
                            ),
                          ],
                        );
                      },
                    );
                  },
                  child: Text('Confirm Booking'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Color(0xFF004B63),
                    foregroundColor: Colors.white,
                    padding: EdgeInsets.symmetric(vertical: 15, horizontal: 30), // Reduced padding
                    textStyle: TextStyle(fontSize: 14), // Smaller font size
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget buildCarDetailsCard() {
    if (widget.carDetails == null) {
      return Card(
        elevation: 5,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Text('Car details not available.'),
        ),
      );
    }
    return Card(
      elevation: 5,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              widget.carDetails!['car'] ?? 'Car Name Not Available',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 8),
            Text('Car Type: $_selectedCarType'),
            Text('Rental Price Per Day: ${widget.carDetails!['price'] ?? 'Price Not Available'}'),
          ],
        ),
      ),
    );
  }

  Widget buildCarTypeSelector() {
    return DropdownButtonFormField<String>(
      value: _selectedCarType,
      items: ['Standard', 'Luxury'].map((carType) {
        return DropdownMenuItem(value: carType, child: Text(carType));
      }).toList(),
      onChanged: (value) {
        setState(() {
          _selectedCarType = value!;
          _calculateTotalPrice();
        });
      },
      decoration: InputDecoration(
        filled: true,
        fillColor: Colors.white.withOpacity(0.9),
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
      ),
    );
  }

  Widget buildPaymentMethodSelector() {
    return Column(
      children: _paymentMethods.map((method) {
        return ListTile(
          title: Text(method),
          leading: Radio<String>(
            value: method,
            groupValue: _selectedPaymentMethod,
            onChanged: (value) {
              setState(() {
                _selectedPaymentMethod = value!;
              });
            },
          ),
        );
      }).toList(),
    );
  }
}