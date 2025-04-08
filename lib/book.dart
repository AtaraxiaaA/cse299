import 'package:flutter/material.dart';

class BookScreen extends StatefulWidget {
  final Map<String, String> flightDetails;
  const BookScreen({Key? key, required this.flightDetails}) : super(key: key);

  @override
  _BookScreenState createState() => _BookScreenState();
}

class _BookScreenState extends State<BookScreen> {
  int _passengerCount = 1;
  String _selectedClass = 'Economy';
  String _selectedPaymentMethod = 'Credit Card'; // Add this variable

  // Mock payment methods
  final List<String> _paymentMethods = ['Credit Card', 'PayPal', 'Debit Card'];

  // Calculate total price based on passengers and class
  double get totalPrice {
    double basePrice = double.parse(
      widget.flightDetails['price']!.substring(1),
    );
    double classMultiplier = _selectedClass == 'Business' ? 1.5 : 1.0;
    return basePrice * _passengerCount * classMultiplier;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Book Your Flight'),
        backgroundColor: Color(0xFF003653),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Flight Details
              Text(
                'Flight Details',
                style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 10),
              buildFlightDetailsCard(),
              SizedBox(height: 20),

              // Select Passenger Count
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text('Number of Passengers:', style: TextStyle(fontSize: 18)),
                  Row(
                    children: [
                      IconButton(
                        icon: Icon(Icons.remove),
                        onPressed: () {
                          setState(() {
                            if (_passengerCount > 1) _passengerCount--;
                          });
                        },
                      ),
                      Text('$_passengerCount', style: TextStyle(fontSize: 18)),
                      IconButton(
                        icon: Icon(Icons.add),
                        onPressed: () {
                          setState(() {
                            _passengerCount++;
                          });
                        },
                      ),
                    ],
                  ),
                ],
              ),
              SizedBox(height: 20),

              // Select Class Type
              Text('Select Class:', style: TextStyle(fontSize: 18)),
              SizedBox(height: 10),
              buildClassSelector(),
              SizedBox(height: 20),

              // Payment Method Selection
              Text(
                'Payment Method',
                style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 10),
              buildPaymentMethodSelector(),
              SizedBox(height: 20),

              // Total Price
              Text(
                'Total Price: \$${totalPrice.toStringAsFixed(2)}',
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 20),

              // Book Button
              ElevatedButton(
                onPressed: () {
                  // Implement booking logic (e.g., call API or show confirmation)
                  showDialog(
                    context: context,
                    builder: (context) {
                      return AlertDialog(
                        title: Text('Booking Confirmation'),
                        content: Text(
                          'You have successfully booked your flight!',
                        ),
                        actions: [
                          TextButton(
                            onPressed: () {
                              Navigator.pop(context);
                              Navigator.pop(
                                context,
                              ); // Go back to previous screen
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
                  backgroundColor: Color.fromARGB(
                    255,
                    252,
                    252,
                    252,
                  ), // Updated from `primary`
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

  // Flight details card
  Widget buildFlightDetailsCard() {
    return Card(
      elevation: 5,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              '${widget.flightDetails['from']} to ${widget.flightDetails['to']}',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 8),
            Text('Departure: ${widget.flightDetails['departure']}'),
            Text('Flight Price: ${widget.flightDetails['price']}'),
          ],
        ),
      ),
    );
  }

  // Class selector dropdown
  Widget buildClassSelector() {
    return DropdownButtonFormField<String>(
      value: _selectedClass,
      items:
          ['Economy', 'Business'].map((classType) {
            return DropdownMenuItem(value: classType, child: Text(classType));
          }).toList(),
      onChanged: (value) {
        setState(() {
          _selectedClass = value!;
        });
      },
      decoration: InputDecoration(
        filled: true,
        fillColor: Colors.white.withOpacity(0.9),
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
      ),
    );
  }

  // Payment method selector
  Widget buildPaymentMethodSelector() {
    return Column(
      children:
          _paymentMethods.map((method) {
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
