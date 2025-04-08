import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'discountforcarrental.dart';

class CarRentalScreen extends StatefulWidget {
  final Map<String, String>? carDetails;
  final Map<String, String>? rentalDetails;
  const CarRentalScreen({Key? key, required this.carDetails, this.rentalDetails}) : super(key: key);

  @override
  _CarRentalScreenState createState() => _CarRentalScreenState();
}

class _CarRentalScreenState extends State<CarRentalScreen> {
  int _rentalDays = 1;
  String _selectedPaymentMethod = 'Credit Card';
  double _totalPrice = 0.0;
  String _couponCode = '';
  bool _isCouponValid = false;
  double _discountAmount = 0.0;
  bool _discountApplied = false; // Add a state variable to track if discount is applied

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
        _discountAmount = 0.0;
      });
      return;
    }
    try {
      double basePrice = double.parse(
        widget.carDetails!['price']!.substring(1).split('/')[0],
      );

      _isCouponValid = DiscountForCarRental.isCodeValid(_couponCode);
      double discount = DiscountForCarRental.getDiscount(_rentalDays, _isCouponValid);

      _discountAmount = basePrice * _rentalDays * discount;
      _totalPrice = (basePrice * _rentalDays) - _discountAmount;

      setState(() {});
    } catch (e) {
      print('Error parsing price: $e');
      setState(() {
        _totalPrice = 0.0;
        _discountAmount = 0.0;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Book Your Car Rental'),
        backgroundColor: Color(0xFF007E95),
        foregroundColor: Colors.white,
      ),
      body: Stack(
        children: [
          Image.asset(
            'images/car3.jpg',
            fit: BoxFit.cover,
            width: double.infinity,
            height: double.infinity,
          ),
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Car Details',
                    style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold, color: Colors.black),
                  ),
                  SizedBox(height: 10),
                  buildCarDetailsCard(),
                  SizedBox(height: 20),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'Number of Rental Days:',
                        style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold, color: Colors.black),
                      ),
                      Row(
                        children: [
                          IconButton(
                            icon: Icon(Icons.remove, color: Colors.black),
                            onPressed: () {
                              setState(() {
                                if (_rentalDays > 1) _rentalDays--;
                                if(_discountApplied) _calculateTotalPrice(); // Recalculate if discount is applied
                              });
                            },
                          ),
                          Text('$_rentalDays', style: TextStyle(fontSize: 18, color: Colors.black)),
                          IconButton(
                            icon: Icon(Icons.add, color: Colors.black),
                            onPressed: () {
                              setState(() {
                                _rentalDays++;
                                if(_discountApplied) _calculateTotalPrice(); // Recalculate if discount is applied
                              });
                            },
                          ),
                        ],
                      ),
                    ],
                  ),
                  SizedBox(height: 20),
                  TextField(
                    decoration: InputDecoration(
                      labelText: 'Discount Code',
                      filled: true,
                      fillColor: Colors.white,
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8.0),
                        borderSide: BorderSide(color: Colors.grey.shade300),
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8.0),
                        borderSide: BorderSide(color: Colors.grey.shade300),
                      ),
                    ),
                    onChanged: (value) {
                      _couponCode = value;
                      _discountApplied = false; // Reset discount application on code change
                    },
                  ),
                  SizedBox(height: 10),
                  ElevatedButton(
                    onPressed: () {
                      _calculateTotalPrice();
                      setState(() {
                        _discountApplied = true;
                      });
                    },
                    child: Text('Apply Discount', style: TextStyle(color: Colors.white)),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Color(0xFF004B63),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8.0),
                      ),
                    ),
                  ),
                  SizedBox(height: 10),
                  Text(
                    'Payment Method',
                    style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold, color: Colors.black),
                  ),
                  SizedBox(height: 10),
                  buildPaymentMethodSelector(),
                  SizedBox(height: 10),
                  Text(
                    'Discount: \$${_discountAmount.toStringAsFixed(2)}',
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.black),
                  ),
                  SizedBox(height: 10),
                  Text(
                    'Total Price: \$${_totalPrice.toStringAsFixed(2)}',
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.black),
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
                        padding: EdgeInsets.symmetric(vertical: 15, horizontal: 30),
                        textStyle: TextStyle(fontSize: 14),
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

  Widget buildCarDetailsCard() {
    if (widget.carDetails == null) {
      return Card(
        elevation: 5,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        color: Colors.white.withOpacity(0.8),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Text('Car details not available.', style: TextStyle(color: Colors.black)),
        ),
      );
    }
    return Card(
      elevation: 5,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      color: Colors.white.withOpacity(0.8),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Car: ${widget.carDetails!['car'] ?? 'Not Available'}', style: TextStyle(color: Colors.black)),
            Text('Rental Price Per Day: ${widget.carDetails!['price'] ?? 'Not Available'}', style: TextStyle(color: Colors.black)),
            Text('PickUp Time: ${widget.carDetails!['pickUpTime'] ?? 'Not Available'}', style: TextStyle(color: Colors.black)),
            Text('DropOff Time: ${widget.carDetails!['dropOffTime'] ?? 'Not Available'}', style: TextStyle(color: Colors.black)),
            Text('PickUp Location: ${widget.rentalDetails != null ? widget.rentalDetails!['from'] ?? 'Not Available' : 'Not Available'}', style: TextStyle(color: Colors.black)),
            Text('DropOff Location: ${widget.rentalDetails != null ? widget.rentalDetails!['to'] ?? 'Not Available' : 'Not Available'}', style: TextStyle(color: Colors.black)),
            Text('PickUp Date: ${widget.rentalDetails != null ? widget.rentalDetails!['date'] ?? 'Not Available' : 'Not Available'}', style: TextStyle(color: Colors.black)),
            Text('Return Date: ${widget.rentalDetails != null ? widget.rentalDetails!['returnDate'] ?? 'Not Available' : 'Not Available'}', style: TextStyle(color: Colors.black)),
            Text('Car Type: ${widget.carDetails!['type'] ?? 'Not Available'}', style: TextStyle(color: Colors.black)),
          ],
        ),
      ),
    );
  }

  Widget buildPaymentMethodSelector() {
    return Column(
      children: _paymentMethods.map((method) {
        return RadioListTile<String>(
          title: Text(method, style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold)),
          value: method,
          groupValue: _selectedPaymentMethod,
          onChanged: (value) {
            setState(() {
              _selectedPaymentMethod = value!;
            });
          },
          activeColor: Colors.black,
        );
      }).toList(),
    );
  }
}