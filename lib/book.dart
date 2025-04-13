import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
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
  String _selectedPaymentMethod = 'Credit Card';
  bool _isLoading = false;

  final List<String> _paymentMethods = ['Credit Card', 'PayPal', 'Debit Card'];

  // Calculate total price based on passengers and class
  double get totalPrice {
    double basePrice = double.parse(
      widget.flightDetails['price']!.substring(1),
    );
    double classMultiplier = _selectedClass == 'Business' ? 1.5 : 1.0;
    return basePrice * _passengerCount * classMultiplier;
  }

  // Save booking to Firestore
  Future<void> _saveBooking() async {
    // Get the current user
    User? user = FirebaseAuth.instance.currentUser;
    if (user == null) {
      // User not logged in, show a dialog to prompt login
      await showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: const Text('Login Required'),
            content: const Text('Please log in to book a flight.'),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.pop(context);
                  // Optionally navigate to a login screen
                  // Navigator.pushNamed(context, '/login');
                },
                child: const Text('OK'),
              ),
            ],
          );
        },
      );
      return;
    }

    setState(() {
      _isLoading = true;
    });

    try {
      // Prepare booking data
      final bookingData = {
        'userId': user.uid,
        'flightId': widget.flightDetails['flightId'],
        'from': widget.flightDetails['from'],
        'to': widget.flightDetails['to'],
        'departure': widget.flightDetails['departure'],
        'price': widget.flightDetails['price'],
        'passengerCount': _passengerCount,
        'selectedClass': _selectedClass,
        'paymentMethod': _selectedPaymentMethod,
        'totalPrice': totalPrice,
        'bookingTimestamp': Timestamp.now(),
      };

      // Save to Firestore
      await FirebaseFirestore.instance.collection('bookings').add(bookingData);

      // Show success dialog
      await showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: const Text('Booking Confirmation'),
            content: const Text('You have successfully booked your flight!'),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.pop(context);
                  Navigator.pop(context); // Go back to FlightScreen
                },
                child: const Text('OK'),
              ),
            ],
          );
        },
      );
    } catch (e) {
      // Show error dialog
      await showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: const Text('Booking Error'),
            content: Text('Failed to book flight: $e'),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: const Text('OK'),
              ),
            ],
          );
        },
      );
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Book Your Flight'),
        backgroundColor: const Color(0xFF003653),
      ),
      body: Stack(
        children: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Flight Details
                  const Text(
                    'Flight Details',
                    style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 10),
                  buildFlightDetailsCard(),
                  const SizedBox(height: 20),

                  // Select Passenger Count
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text('Number of Passengers:', style: TextStyle(fontSize: 18)),
                      Row(
                        children: [
                          IconButton(
                            icon: const Icon(Icons.remove),
                            onPressed: () {
                              setState(() {
                                if (_passengerCount > 1) _passengerCount--;
                              });
                            },
                          ),
                          Text('$_passengerCount', style: const TextStyle(fontSize: 18)),
                          IconButton(
                            icon: const Icon(Icons.add),
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
                  const SizedBox(height: 20),

                  // Select Class Type
                  const Text('Select Class:', style: TextStyle(fontSize: 18)),
                  const SizedBox(height: 10),
                  buildClassSelector(),
                  const SizedBox(height: 20),

                  // Payment Method Selection
                  const Text(
                    'Payment Method',
                    style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 10),
                  buildPaymentMethodSelector(),
                  const SizedBox(height: 20),

                  // Total Price
                  Text(
                    'Total Price: \$${totalPrice.toStringAsFixed(2)}',
                    style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 20),

                  // Book Button
                  ElevatedButton(
                    onPressed: _isLoading ? null : _saveBooking,
                    child: _isLoading
                        ? const CircularProgressIndicator(color: Colors.white)
                        : const Text('Book Now'),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color.fromARGB(255, 252, 252, 252),
                      padding: const EdgeInsets.symmetric(vertical: 14),
                      textStyle: const TextStyle(fontSize: 18),
                    ),
                  ),
                ],
              ),
            ),
          ),
          if (_isLoading)
            const Center(
              child: CircularProgressIndicator(),
            ),
        ],
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
              style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
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
      items: ['Economy', 'Business'].map((classType) {
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