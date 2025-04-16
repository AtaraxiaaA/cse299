import 'package:flutter/material.dart';
import 'discountforbusticket.dart'; // Import the DiscountForBusTicket class

class BusBookingScreen extends StatefulWidget {
  final Map<String, String> busDetails;
  final int travelers;
  final String? driverAge;

  const BusBookingScreen({super.key, required this.busDetails, required this.travelers, this.driverAge});

  @override
  _BusBookingScreenState createState() => _BusBookingScreenState();
}

class _BusBookingScreenState extends State<BusBookingScreen> {
  int _localTravelers = 1;
  String selectedPaymentMethod = 'Credit Card';
  double totalPrice = 0.0;
  String discountCode = '';
  double discountPercentage = 0.0;
  bool discountApplied = false;

  void _calculateTotalPrice() {
    double basePrice = double.parse(widget.busDetails['price']!.substring(1));
    double discount = discountPercentage;

    setState(() {
      totalPrice = basePrice * _localTravelers * (1 - discount);
    });
  }

  void _applyDiscount() async {
    bool isActive = await DiscountForBusTicket.isDiscountActive(); // Check if discount is active

    if (DiscountForBusTicket.isCodeValid(discountCode) && isActive) {
      setState(() {
        discountPercentage = DiscountForBusTicket.discountPercentage;
        discountApplied = true;
        _calculateTotalPrice();
      });
    } else {
      setState(() {
        discountPercentage = 0.0;
        discountApplied = false;
        _calculateTotalPrice();
      });
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Invalid or inactive discount code')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Book Your Bus Ticket',
          style: TextStyle(color: Colors.white),
        ),
        backgroundColor: Color(0xFF007E95),
      ),
      body: Stack(
        children: [
          Container(
            decoration: BoxDecoration(
              image: DecorationImage(
                image: AssetImage('images/busimage1.jpg'),
                fit: BoxFit.cover,
              ),
            ),
          ),
          Container(
            color: Colors.black.withOpacity(0.5),
          ),
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(height: 10),
                  Container(
                    padding: EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: Colors.grey[800]?.withOpacity(0.7),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          widget.busDetails['bus']!,
                          style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.white),
                        ),
                        SizedBox(height: 8),
                        Text('From: ${widget.busDetails['from']}', style: TextStyle(fontSize: 16, color: Colors.white)),
                        Text('To: ${widget.busDetails['to']}', style: TextStyle(fontSize: 16, color: Colors.white)),
                        Text('Price: ${widget.busDetails['price']}', style: TextStyle(fontSize: 16, color: Colors.white)),
                      ],
                    ),
                  ),
                  SizedBox(height: 20),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text('Number of Travelers:', style: TextStyle(fontSize: 18, color: Colors.white)),
                      Row(
                        children: [
                          IconButton(
                            icon: Icon(Icons.remove, color: Colors.white),
                            onPressed: () {
                              setState(() {
                                if (_localTravelers > 1) {
                                  _localTravelers--;
                                  _calculateTotalPrice();
                                }
                              });
                            },
                          ),
                          Text('$_localTravelers', style: TextStyle(fontSize: 18, color: Colors.white)),
                          IconButton(
                            icon: Icon(Icons.add, color: Colors.white),
                            onPressed: () {
                              setState(() {
                                _localTravelers++;
                                _calculateTotalPrice();
                              });
                            },
                          ),
                        ],
                      ),
                    ],
                  ),
                  SizedBox(height: 20),
                  TextField(
                    onChanged: (value) {
                      discountCode = value;
                    },
                    decoration: InputDecoration(
                      labelText: 'Discount Code',
                      labelStyle: TextStyle(color: Colors.white),
                      enabledBorder: OutlineInputBorder(
                        borderSide: BorderSide(
                            color: discountApplied
                                ? Colors.green
                                : Colors.white),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderSide: BorderSide(
                            color: discountApplied
                                ? Colors.green
                                : Colors.white),
                      ),
                    ),
                    style: TextStyle(color: Colors.white),
                  ),
                  SizedBox(height: 10),
                  ElevatedButton(
                    onPressed: _applyDiscount,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.white,
                    ),
                    child: Text(
                      discountApplied ? 'Discount Applied' : 'Apply Discount',
                      style: TextStyle(color: Colors.black),
                    ),
                  ),
                  if (discountApplied)
                    Padding(
                      padding: const EdgeInsets.only(top: 8.0),
                      child: Text(
                        'Discount applied!',
                        style: TextStyle(color: Colors.green),
                      ),
                    ),
                  SizedBox(height: 20),
                  Text(
                    'Payment Method',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.white),
                  ),
                  RadioListTile<String>(
                    title: Text('Credit Card', style: TextStyle(color: Colors.white)),
                    value: 'Credit Card',
                    groupValue: selectedPaymentMethod,
                    onChanged: (String? value) {
                      setState(() {
                        selectedPaymentMethod = value!;
                      });
                    },
                    activeColor: Colors.purple,
                    controlAffinity: ListTileControlAffinity.leading,
                    selectedTileColor: Colors.white,
                    tileColor: Colors.transparent,
                    contentPadding: EdgeInsets.zero,
                    visualDensity: VisualDensity.compact,
                    fillColor: WidgetStateColor.resolveWith((states) {
                      if (states.contains(WidgetState.selected)) {
                        return Colors.white;
                      }
                      return Colors.white;
                    }),
                  ),
                  RadioListTile<String>(
                    title: Text('PayPal', style: TextStyle(color: Colors.white)),
                    value: 'PayPal',
                    groupValue: selectedPaymentMethod,
                    onChanged: (String? value) {
                      setState(() {
                        selectedPaymentMethod = value!;
                      });
                    },
                    activeColor: Colors.purple,
                    controlAffinity: ListTileControlAffinity.leading,
                    selectedTileColor: Colors.white,
                    tileColor: Colors.transparent,
                    contentPadding: EdgeInsets.zero,
                    visualDensity: VisualDensity.compact,
                    fillColor: WidgetStateColor.resolveWith((states) {
                      if (states.contains(WidgetState.selected)) {
                        return Colors.white;
                      }
                      return Colors.white;
                    }),
                  ),
                  RadioListTile<String>(
                    title: Text('Debit Card', style: TextStyle(color: Colors.white)),
                    value: 'Debit Card',
                    groupValue: selectedPaymentMethod,
                    onChanged: (String? value) {
                      setState(() {
                        selectedPaymentMethod = value!;
                      });
                    },
                    activeColor: Colors.purple,
                    controlAffinity: ListTileControlAffinity.leading,
                    selectedTileColor: Colors.white,
                    tileColor: Colors.transparent,
                    contentPadding: EdgeInsets.zero,
                    visualDensity: VisualDensity.compact,
                    fillColor: WidgetStateColor.resolveWith((states) {
                      if (states.contains(WidgetState.selected)) {
                        return Colors.white;
                      }
                      return Colors.white;
                    }),
                  ),
                  SizedBox(height: 20),
                  Text(
                    'Total Price: \$${totalPrice.toStringAsFixed(2)}',
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.white),
                  ),
                  SizedBox(height: 20),
                  Center(
                    child: ElevatedButton(
                      onPressed: () {
                        showDialog(
                          context: context,
                          builder: (context) {
                            return AlertDialog(
                              title: Text('Booking Confirmed', style: TextStyle(color: Colors.white)),
                              backgroundColor: Colors.grey[800],
                              content: Text('Your bus booking for ${widget.busDetails['bus']} is confirmed!', style: TextStyle(color: Colors.white)),
                              actions: [
                                TextButton(
                                  onPressed: () {
                                    Navigator.pop(context);
                                  },
                                  child: Text('OK', style: TextStyle(color: Colors.white)),
                                ),
                              ],
                            );
                          },
                        );
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.white,
                        padding: EdgeInsets.symmetric(vertical: 15, horizontal: 30),
                      ),
                      child: Text(
                        'Confirm Booking',
                        style: TextStyle(color: Colors.black),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}