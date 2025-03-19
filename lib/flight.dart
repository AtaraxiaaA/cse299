import 'package:flutter/material.dart';

class FlightScreen extends StatelessWidget {
  const FlightScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Flights'),
        backgroundColor: Color(0xFF003653), // Same color theme
      ),
      body: Center(
        child: Text(
          'Flight Information Screen',
          style: TextStyle(fontSize: 24, color: Colors.black),
        ),
      ),
    );
  }
}
