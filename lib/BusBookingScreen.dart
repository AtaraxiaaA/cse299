import 'package:flutter/material.dart';
import 'discountforbusticket.dart';

class BusBookingScreen extends StatefulWidget {
  final Map<String, dynamic> busDetails; // Changed to dynamic
  final int travelers;
  final String? driverAge;

  BusBookingScreen({required this.busDetails, required this.travelers, this.driverAge});

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

  @override
  void initState() {
    super.initState();
    _calculateTotalPrice();
  }

  void _calculateTotalPrice() {
    double basePrice = double.parse(widget.busDetails['price'].toString().substring(1)); // Adjusted
    double discount = discountPercentage;

    setState(() {
      totalPrice = basePrice * _localTravelers * (1 - discount);
    });
  }

  void _applyDiscount() async {
    bool isActive = await DiscountForBusTicket.isDiscountActive();

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
        title: Text('Book Your Bus Ticket', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
        backgroundColor: Color(0xFF007E95),
      ),
      body: Stack(
        children: [
          Container(
            decoration: BoxDecoration(
              image: const DecorationImage(
                image: AssetImage('images/busimage1.jpg'),
                fit: BoxFit.cover,
                colorFilter: ColorFilter.mode(
                  Color.fromRGBO(0, 0, 0, 0.4),
                  BlendMode.darken,
                ),
              ),
            ),
          ),
          SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    padding: EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: Colors.grey[800]?.withOpacity(0.7),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(widget.busDetails['bus'].toString(), style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.white)), // Adjusted
                        SizedBox(height: 8),
                        Text('From: ${widget.busDetails['from'].toString()}', style: TextStyle(fontSize: 16, color: Colors.white)), // Adjusted
                        Text('To: ${widget.busDetails['to'].toString()}', style: TextStyle(fontSize: 16, color: Colors.white)), // Adjusted
                        Text('Ticket Price: ${widget.busDetails['price'].toString()}', style: TextStyle(fontSize: 16, color: Colors.white)), // Adjusted
                        Text('Departure Time: ${widget.busDetails['departureTime'].toString()}', style: TextStyle(fontSize: 16, color: Colors.white)), // Adjusted
                        Text('Arrival Time: ${widget.busDetails['arrivalTime'].toString()}', style: TextStyle(fontSize: 16, color: Colors.white)), // Adjusted
                      ],
                    ),
                  ),
                  SizedBox(height: 20),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text('Number of Travelers:', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.white)),
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
                        borderSide: BorderSide(color: Colors.white),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderSide: BorderSide(color: Colors.white),
                      ),
                    ),
                    style: TextStyle(color: Colors.white),
                  ),
                  SizedBox(height: 10),
                  ElevatedButton(
                    onPressed: _applyDiscount,
                    child: Text(
                      discountApplied ? 'Discount Applied' : 'Apply Discount',
                      style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
                    ),
                    style: ElevatedButton.styleFrom(backgroundColor: Colors.white),
                  ),
                  if (discountApplied)
                    Padding(
                      padding: const EdgeInsets.only(top: 8.0),
                      child: Text('Discount applied!', style: TextStyle(color: Colors.green)),
                    ),
                  SizedBox(height: 20),
                  Text('Payment Method', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.white)),
                  RadioListTile<String>(
                    title: Text('Credit Card', style: TextStyle(color: Colors.white)),
                    value: 'Credit Card',
                    groupValue: selectedPaymentMethod,
                    onChanged: (String? value) {
                      setState(() {
                        selectedPaymentMethod = value!;
                      });
                    },
                    activeColor: Color(0xFF007E95),
                    controlAffinity: ListTileControlAffinity.leading,
                    selectedTileColor: Colors.grey[200],
                    tileColor: Colors.white,
                    contentPadding: EdgeInsets.zero,
                    visualDensity: VisualDensity.compact,
                    fillColor: MaterialStateColor.resolveWith((states) => states.contains(MaterialState.selected) ? Colors.grey[200]! : Colors.white),
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
                    activeColor: Color(0xFF007E95),
                    controlAffinity: ListTileControlAffinity.leading,
                    selectedTileColor: Colors.grey[200],
                    tileColor: Colors.white,
                    contentPadding: EdgeInsets.zero,
                    visualDensity: VisualDensity.compact,
                    fillColor: MaterialStateColor.resolveWith((states) => states.contains(MaterialState.selected) ? Colors.grey[200]! : Colors.white),
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
                    activeColor: Color(0xFF007E95),
                    controlAffinity: ListTileControlAffinity.leading,
                    selectedTileColor: Colors.grey[200],
                    tileColor: Colors.white,
                    contentPadding: EdgeInsets.zero,
                    visualDensity: VisualDensity.compact,
                    fillColor: MaterialStateColor.resolveWith((states) => states.contains(MaterialState.selected) ? Colors.grey[200]! : Colors.white),
                  ),
                  SizedBox(height: 20),
                  Text('Total Price: \$${totalPrice.toStringAsFixed(2)}', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.white)),
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
                      child: Text('Confirm Booking', style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold)),
                      style: ElevatedButton.styleFrom(backgroundColor: Colors.white, padding: EdgeInsets.symmetric(vertical: 15, horizontal: 30)),
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