import 'package:flutter/material.dart';

class BusBookingScreen extends StatefulWidget {
  final Map<String, String> busDetails;
  final int travelers;
  final String? driverAge;

  BusBookingScreen({required this.busDetails, required this.travelers, this.driverAge});

  @override
  _BusBookingScreenState createState() => _BusBookingScreenState();
}

class _BusBookingScreenState extends State<BusBookingScreen> {
  int _localTravelers = 1;
  String selectedCarType = 'Standard';
  String selectedPaymentMethod = 'Credit Card';

  @override
  void initState() {
    super.initState();
    _localTravelers = widget.travelers;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Book Your Bus Ticket'),
        backgroundColor: Color(0xFF007E95),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Bus Details',
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 10),
              Container(
                padding: EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.grey[200],
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      widget.busDetails['bus']!,
                      style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                    ),
                    SizedBox(height: 5),
                    Text('From: ${widget.busDetails['from']}'),
                    Text('To: ${widget.busDetails['to']}'),
                    Text('Price: ${widget.busDetails['price']}'),
                  ],
                ),
              ),
              SizedBox(height: 20),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text('Number of Travelers:'),
                  Row(
                    children: [
                      IconButton(
                        icon: Icon(Icons.remove),
                        onPressed: () {
                          setState(() {
                            if (_localTravelers > 1) {
                              _localTravelers--;
                            }
                          });
                        },
                      ),
                      Text('$_localTravelers'),
                      IconButton(
                        icon: Icon(Icons.add),
                        onPressed: () {
                          setState(() {
                            _localTravelers++;
                          });
                        },
                      ),
                    ],
                  ),
                ],
              ),
              SizedBox(height: 20),
              Text(
                'Select Bus Type:',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              ),
              DropdownButton<String>(
                value: selectedCarType,
                onChanged: (String? newValue) {
                  setState(() {
                    selectedCarType = newValue!;
                  });
                },
                items: <String>['Standard', 'Luxury', 'Sleeper', 'Semi-Sleeper']
                    .map<DropdownMenuItem<String>>((String value) {
                  return DropdownMenuItem<String>(
                    value: value,
                    child: Text(value),
                  );
                }).toList(),
              ),
              SizedBox(height: 20),
              Text(
                'Payment Method',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              ),
              RadioListTile<String>(
                title: const Text('Credit Card'),
                value: 'Credit Card',
                groupValue: selectedPaymentMethod,
                onChanged: (String? value) {
                  setState(() {
                    selectedPaymentMethod = value!;
                  });
                },
              ),
              RadioListTile<String>(
                title: const Text('PayPal'),
                value: 'PayPal',
                groupValue: selectedPaymentMethod,
                onChanged: (String? value) {
                  setState(() {
                    selectedPaymentMethod = value!;
                  });
                },
              ),
              RadioListTile<String>(
                title: const Text('Debit Card'),
                value: 'Debit Card',
                groupValue: selectedPaymentMethod,
                onChanged: (String? value) {
                  setState(() {
                    selectedPaymentMethod = value!;
                  });
                },
              ),
              SizedBox(height: 20),
              Center(
                child: ElevatedButton(
                  onPressed: () {
                    showDialog(
                      context: context,
                      builder: (context) {
                        return AlertDialog(
                          title: Text('Booking Confirmed'),
                          content: Text('Your bus booking for ${widget.busDetails['bus']} is confirmed!'),
                          actions: [
                            TextButton(
                              onPressed: () {
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
                    padding: EdgeInsets.symmetric(vertical: 15, horizontal: 30),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}