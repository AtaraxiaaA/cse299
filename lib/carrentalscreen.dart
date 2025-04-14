import 'package:flutter/material.dart';
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
  bool _discountApplied = false;

  @override
  void initState() {
    super.initState();
    _calculateTotalPrice();
  }

  void _calculateTotalPrice() {
    if (widget.carDetails == null || widget.carDetails!['price'] == null) {
      _totalPrice = 0.0;
      return;
    }
    try {
      double basePrice = double.parse(widget.carDetails!['price']!.substring(1).split('/')[0]);
      double discount = DiscountForCarRental.getDiscount(_rentalDays, DiscountForCarRental.isCodeValid(_couponCode));
      _totalPrice = (basePrice * _rentalDays) - (basePrice * _rentalDays * discount);
      setState(() {});
    } catch (e) {
      _totalPrice = 0.0;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Book Your Car Rental'), backgroundColor: Color(0xFF007E95), foregroundColor: Colors.white, leadingWidth: 15),
      body: Stack(
        children: [
          Image.asset('images/car3.jpg', fit: BoxFit.cover, width: double.infinity, height: double.infinity),
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Car Details', style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold, color: Colors.black)),
                  SizedBox(height: 5),
                  SizedBox(width: MediaQuery.of(context).size.width * 0.5, child: buildCarDetailsCard()), // Shorter Width
                  SizedBox(height: 10),
                  Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
                    Text('Rental Days:', style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold, color: Colors.black)),
                    Row(mainAxisSize: MainAxisSize.min, children: [
                      IconButton(icon: Icon(Icons.remove, color: Colors.black, size: 24), onPressed: () => setState(() {if (_rentalDays > 1) _rentalDays--; if (_discountApplied) _calculateTotalPrice();}), style: ElevatedButton.styleFrom(backgroundColor: Colors.white.withOpacity(0.8))),
                      Padding(padding: const EdgeInsets.symmetric(horizontal: 8.0), child: Text('$_rentalDays', style: TextStyle(fontSize: 20, color: Colors.black))),
                      IconButton(icon: Icon(Icons.add, color: Colors.black, size: 24), onPressed: () => setState(() {_rentalDays++; if (_discountApplied) _calculateTotalPrice();}), style: ElevatedButton.styleFrom(backgroundColor: Colors.white.withOpacity(0.8))),
                    ]),
                  ]),
                  SizedBox(height: 10),
                  SizedBox(width: MediaQuery.of(context).size.width * 0.5, child: TextField(decoration: InputDecoration(labelText: 'Discount Code', filled: true, fillColor: Colors.white, border: OutlineInputBorder(borderRadius: BorderRadius.circular(8.0), borderSide: BorderSide(color: Colors.grey.shade300)), enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(8.0), borderSide: BorderSide(color: Colors.grey.shade300))), onChanged: (value) => _couponCode = value)),
                  SizedBox(height: 5),
                  ElevatedButton(onPressed: () => setState(() {_calculateTotalPrice(); _discountApplied = true;}), child: Text('Apply Discount', style: TextStyle(color: Colors.white)), style: ElevatedButton.styleFrom(backgroundColor: Color(0xFF004B63), shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8.0)))),
                  SizedBox(height: 5),
                  Text('Payment Method', style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold, color: Colors.black)),
                  SizedBox(height: 5),
                  Column(children: ['Credit Card', 'PayPal', 'Debit Card'].map((method) => RadioListTile<String>(title: Text(method, style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold)), value: method, groupValue: _selectedPaymentMethod, onChanged: (value) => setState(() => _selectedPaymentMethod = value!), activeColor: Colors.black)).toList()),
                  SizedBox(height: 5),
                  Text('Discount: \$${(_totalPrice == 0 ? 0 : (_totalPrice * DiscountForCarRental.getDiscount(_rentalDays, DiscountForCarRental.isCodeValid(_couponCode)))).toStringAsFixed(2)}', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.black)),
                  SizedBox(height: 5),
                  Text('Total Price: \$${_totalPrice.toStringAsFixed(2)}', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.black)),
                  SizedBox(height: 10),
                  Container(width: double.infinity, child: ElevatedButton(onPressed: () {if (widget.carDetails == null) {ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Car details missing.'))); return;} showDialog(context: context, builder: (context) => AlertDialog(title: Text('Booking Confirmation'), content: Text('Booking successful!'), actions: [TextButton(onPressed: () {Navigator.pop(context); Navigator.pop(context);}, child: Text('OK'))]));}, child: Text('Confirm Booking'), style: ElevatedButton.styleFrom(backgroundColor: Color(0xFF004B63), foregroundColor: Colors.white, padding: EdgeInsets.symmetric(vertical: 15, horizontal: 30), textStyle: TextStyle(fontSize: 14)))),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget buildCarDetailsCard() {
    return SizedBox(
      width: MediaQuery.of(context).size.width * 0.5, // Even shorter width
      child: Card(
        elevation: 5,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        color: Colors.white.withOpacity(0.8),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: widget.carDetails == null ? [Text('Car details not available.', style: TextStyle(color: Colors.black))] : [
              Text('Car: ${widget.carDetails!['car'] ?? 'N/A'}', style: TextStyle(color: Colors.black)),
              Text('Price: ${widget.carDetails!['price'] ?? 'N/A'}', style: TextStyle(color: Colors.black)),
              Text('PickUp Time: ${widget.carDetails!['pickUpTime'] ?? 'N/A'}', style: TextStyle(color: Colors.black)),
              Text('DropOff Time: ${widget.carDetails!['dropOffTime'] ?? 'N/A'}', style: TextStyle(color: Colors.black)),
              Text('PickUp Location: ${widget.rentalDetails != null ? widget.rentalDetails!['from'] ?? 'N/A' : 'N/A'}', style: TextStyle(color: Colors.black)),
              Text('DropOff Location: ${widget.rentalDetails != null ? widget.rentalDetails!['to'] ?? 'N/A' : 'N/A'}', style: TextStyle(color: Colors.black)),
              Text('PickUp Date: ${widget.rentalDetails != null ? widget.rentalDetails!['date'] ?? 'N/A' : 'N/A'}', style: TextStyle(color: Colors.black)),
              Text('Return Date: ${widget.rentalDetails != null ? widget.rentalDetails!['returnDate'] ?? 'N/A' : 'N/A'}', style: TextStyle(color: Colors.black)),
              Text('Car Type: ${widget.carDetails!['type'] ?? 'N/A'}', style: TextStyle(color: Colors.black)),
            ],
          ),
        ),
      ),
    );
  }
}