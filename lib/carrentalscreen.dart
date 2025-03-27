import 'package:flutter/material.dart';

class CarRentalScreen extends StatefulWidget {
  final Map<String, String>? carDetails; // Make carDetails nullable
  const CarRentalScreen({Key? key, required this.carDetails}) : super(key: key);

  @override
  _CarRentalScreenState createState() => _CarRentalScreenState();
}

class _CarRentalScreenState extends State<CarRentalScreen> {
  int _rentalDays = 1;
  String _selectedCarType = 'Standard';
  String _selectedPaymentMethod = 'Credit Card';

  final List<String> _paymentMethods = ['Credit Card', 'PayPal', 'Debit Card'];

  double get totalPrice {
    if (widget.carDetails == null || widget.carDetails!['price'] == null) {
      print('Error: Car details or price is null.');
      return 0.0;
    }
    try {
      double basePrice = double.parse(
        widget.carDetails!['price']!.substring(1), // Remove the '$' symbol
      );
      double carTypeMultiplier = _selectedCarType == 'Luxury' ? 1.5 : 1.0;
      return basePrice * _rentalDays * carTypeMultiplier;
    } catch (e) {
      print('Error parsing price: $e');
      return 0.0; // Return 0.0 if there is a parsing error
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
                          });
                        },
                      ),
                      Text('$_rentalDays', style: TextStyle(fontSize: 18)),
                      IconButton(
                        icon: Icon(Icons.add),
                        onPressed: () {
                          setState(() {
                            _rentalDays++;
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
                'Total Price: \$${totalPrice.toStringAsFixed(2)}',
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 20),
              ElevatedButton(
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
                child: Text('Book Now'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Color.fromARGB(255, 252, 252, 252),
                  padding: EdgeInsets.symmetric(vertical: 14),
                  textStyle: TextStyle(fontSize: 18),
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