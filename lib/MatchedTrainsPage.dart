import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class MatchedTrainsPage extends StatelessWidget {
  final List<Map<String, dynamic>> trains;

  const MatchedTrainsPage({super.key, required this.trains});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Matched Trains'),
        backgroundColor: Color(0xFF1E88E5),
      ),
      body: trains.isEmpty
          ? Center(child: Text('No trains found'))
          : ListView.builder(
        padding: const EdgeInsets.all(16),
        itemCount: trains.length,
        itemBuilder: (context, index) {
          return TrainCard(train: trains[index]);
        },
      ),
    );
  }
}

class TrainCard extends StatelessWidget {
  final Map<String, dynamic> train;

  const TrainCard({super.key, required this.train});

  @override
  Widget build(BuildContext context) {
    final name = train['Name'] ?? 'Train Name';
    final trainClass = train['Class'] ?? '';
    final from = train['From'] ?? '';
    final to = train['To'] ?? '';
    final duration = train['Duration'] ?? 'N/A';
    final seats = train['AvailableSeats'] ?? train['Seats'] ?? 'N/A';
    final price = train['Price'] ?? 'N/A';

    String timeFormatted = '';
    final rawTime = train['Time'];
    if (rawTime != null && rawTime is Timestamp) {
      final dt = rawTime.toDate();
      timeFormatted = DateFormat.jm().format(dt);
    }

    return Stack(
      children: [
        Container(
          margin: const EdgeInsets.symmetric(vertical: 14),
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [Color(0xFFE3F2FD), Color(0xFFBBDEFB)],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
            borderRadius: BorderRadius.circular(24),
            boxShadow: [
              BoxShadow(color: Colors.black26, blurRadius: 12, offset: Offset(0, 6))
            ],
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  CircleAvatar(
                    backgroundColor: Color(0xFF1E88E5),
                    child: Icon(Icons.train, color: Colors.white),
                  ),
                  SizedBox(width: 10),
                  Text(
                    name,
                    style: GoogleFonts.lato(
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF1E88E5),
                    ),
                  ),
                ],
              ),
              SizedBox(height: 16),
              Divider(thickness: 1, color: Colors.grey[300]),
              SizedBox(height: 10),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  _infoBlock("Departure", Colors.green, from, timeFormatted, Icons.location_on),
                  Container(width: 1, height: 70, color: Colors.grey[400]),
                  _infoBlock("Arrival", Colors.deepOrange, to, duration, Icons.flag, isDuration: true),
                ],
              ),
              SizedBox(height: 16),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(children: [
                    Icon(Icons.event_seat, color: Colors.green[700]),
                    SizedBox(width: 6),
                    Text(
                      "$seats Seats",
                      style: GoogleFonts.lato(
                        fontWeight: FontWeight.bold,
                        color: Colors.green[800],
                      ),
                    ),
                  ]),
                  Text(
                    "৳ $price",
                    style: GoogleFonts.lato(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Colors.blueGrey[900],
                    ),
                  ),
                ],
              ),
              SizedBox(height: 20),
              Row(
                children: [
                  Expanded(
                    child: ElevatedButton(
                      onPressed: () {},
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Color(0xFF1E88E5),
                        padding: EdgeInsets.symmetric(vertical: 16),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
                      ),
                      child: Text("Book Now", style: TextStyle(color: Colors.white)),
                    ),
                  ),
                  SizedBox(width: 12),
                  Expanded(
                    child: OutlinedButton(
                      onPressed: () {},
                      style: OutlinedButton.styleFrom(
                        padding: EdgeInsets.symmetric(vertical: 16),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
                        side: BorderSide(color: Color(0xFF1E88E5)),
                      ),
                      child: Text("View Details", style: TextStyle(color: Color(0xFF1E88E5))),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
        Positioned(
          top: 0,
          right: 16,
          child: Container(
            padding: EdgeInsets.symmetric(horizontal: 12, vertical: 6),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [Color(0xFF1E88E5), Color(0xFF26C6DA)],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              borderRadius: BorderRadius.circular(20),
              boxShadow: [BoxShadow(color: Colors.black26, blurRadius: 4)],
            ),
            child: Text(
              trainClass,
              style: GoogleFonts.lato(color: Colors.white, fontSize: 12, fontWeight: FontWeight.bold),
            ),
          ),
        ),
      ],
    );
  }

  Widget _infoBlock(String label, Color color, String place, String sub, IconData icon,
      {bool isDuration = false}) {
    return Expanded(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: EdgeInsets.symmetric(horizontal: 10, vertical: 5),
            decoration: BoxDecoration(
              color: color.withOpacity(0.15),
              borderRadius: BorderRadius.circular(6),
            ),
            child: Text(
              label,
              style: TextStyle(
                fontSize: 12,
                color: color,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          SizedBox(height: 8),
          Row(children: [
            Icon(icon, size: 16, color: Colors.grey[800]),
            SizedBox(width: 4),
            Expanded(child: Text(place, style: GoogleFonts.lato(fontSize: 14))),
          ]),
          SizedBox(height: 4),
          Row(children: [
            Icon(isDuration ? Icons.timer : Icons.schedule, size: 16, color: Colors.grey[600]),
            SizedBox(width: 4),
            Text(sub, style: GoogleFonts.lato(fontSize: 14, color: Colors.black)),
          ]),
        ],
      ),
    );
  }

}

