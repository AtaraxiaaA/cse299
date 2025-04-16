import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class TrainBookedScreen extends StatelessWidget {
  const TrainBookedScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Train Booked",
          style: GoogleFonts.poppins(
            fontWeight: FontWeight.w600,
            color: Colors.white,
          ),
        ),
        backgroundColor: const Color(0xFF007E95),
      ),
      body: const Center(
        child: Text(
          "Train Booked Screen\n(Displaying booked trains will be implemented here)",
          textAlign: TextAlign.center,
          style: TextStyle(fontSize: 18),
        ),
      ),
    );
  }
}