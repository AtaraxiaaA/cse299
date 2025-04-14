import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'dashboard.dart';
import 'profile.dart';
import 'HotelHomePage.dart';
import 'MatchedTrainsPage.dart';
import 'package:intl/intl.dart';

class UpcomingTrains extends StatefulWidget {
  const UpcomingTrains({super.key});

  @override
  State<UpcomingTrains> createState() => _UpcomingTrainsState();
}

class _UpcomingTrainsState extends State<UpcomingTrains> {
  int _selectedIndex = 0;
  List<Map<String, dynamic>> upcomingTrains = [];

  @override
  void initState() {
    super.initState();
    fetchUpcomingTrains();
  }

  void fetchUpcomingTrains() async {
    final now = DateTime.now();
    final end = now.add(Duration(days: 15));

    List<Map<String, dynamic>> trains = [];

    final countries = ['Bangladesh', 'India', 'Nepal'];

    for (String country in countries) {
      final snapshot = await FirebaseFirestore.instance
          .collection('Trains')
          .doc(country)
          .collection('OneWay')
          .get();

      for (var doc in snapshot.docs) {
        final data = doc.data();
        if (data.containsKey('Time') && data['Time'] is Timestamp) {
          final DateTime trainTime = (data['Time'] as Timestamp).toDate();
          if (trainTime.isAfter(now) && trainTime.isBefore(end)) {
            trains.add({ ...data, 'ParsedDeparture': trainTime });
          }
        }
      }
    }

    trains.sort((a, b) => a['ParsedDeparture'].compareTo(b['ParsedDeparture']));

    setState(() {
      upcomingTrains = trains;
    });
  }

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Train Search', style: GoogleFonts.poppins(color: Colors.white, fontSize: 22)),
        backgroundColor: Color(0xFF003653),
        actions: [
          IconButton(
            icon: Icon(Icons.notifications, color: Colors.white),
            onPressed: () {},
          )
        ],
      ),
      body: SingleChildScrollView(
        child: Container(
          padding: EdgeInsets.all(16),
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [Color(0xFF007E95), Color(0xFF004D65), Color(0xFF003653)],
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
            ),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                padding: EdgeInsets.symmetric(horizontal: 30),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(30),
                  boxShadow: [BoxShadow(color: Colors.black12, blurRadius: 6, spreadRadius: 2)],
                ),
                child: TextField(
                  decoration: InputDecoration(
                    prefixIcon: Icon(Icons.search, color: Color(0xFF264653)),
                    hintText: 'Search a train',
                    border: InputBorder.none,
                  ),
                ),
              ),
              SizedBox(height: 20),
              ...upcomingTrains.map((train) {
                final DateTime parsed = train['ParsedDeparture'];
                return GestureDetector(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => MatchedTrainsPage(trains: [train]),
                      ),
                    );
                  },
                  child: buildStyledTrainCard(
                    name: train['Name'] ?? 'Unnamed',
                    from: train['From'] ?? 'Unknown',
                    to: train['To'] ?? 'Unknown',
                    date: DateFormat('EEE, MMM dd').format(parsed),
                    time: DateFormat('hh:mm a').format(parsed),
                    duration: train['Duration'] ?? 'N/A',
                    price: train['Price']?.toString() ?? '—',
                    seats: train['AvailableSeats']?.toString() ?? '—',
                  ),
                );
              }).toList(),
            ],
          ),
        ),
      ),
      bottomNavigationBar: BottomNavigationBar(
        backgroundColor: Color(0xFF003653),
        selectedItemColor: Colors.white,
        unselectedItemColor: Colors.blueGrey,
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Home'),
          BottomNavigationBarItem(icon: Icon(Icons.search), label: 'Search'),
          BottomNavigationBarItem(icon: Icon(Icons.favorite), label: 'Profile'),
        ],
        currentIndex: _selectedIndex,
        onTap: (index) {
          setState(() {
            _selectedIndex = index;
          });

          switch (index) {
            case 0:
              Navigator.push(context, MaterialPageRoute(builder: (context) => DashboardScreen()));
              break;
            case 1:
              Navigator.push(context, MaterialPageRoute(builder: (context) => HotelHomePage()));
              break;
            case 2:
              Navigator.push(context, MaterialPageRoute(builder: (context) => ProfileScreen()));
              break;
          }
        },
      ),
    );
  }

  Widget _buildTag(IconData icon, String text, Color bgColor, Color textColor) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 10, vertical: 6),
      decoration: BoxDecoration(color: bgColor, borderRadius: BorderRadius.circular(12)),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 14, color: textColor),
          SizedBox(width: 4),
          Text(text, style: TextStyle(fontSize: 12, color: textColor, fontWeight: FontWeight.w600)),
        ],
      ),
    );
  }

  Widget buildStyledTrainCard({
    required String name,
    required String from,
    required String to,
    required String date,
    required String time,
    required String duration,
    required String price,
    required String seats,
  }) {
    return Container(
      margin: EdgeInsets.only(bottom: 18),
      padding: EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [BoxShadow(color: Colors.black12, blurRadius: 10, offset: Offset(0, 4))],
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          CircleAvatar(
            radius: 26,
            backgroundColor: Colors.blue.shade100,
            child: Icon(Icons.train, size: 28, color: Colors.blue.shade900),
          ),
          SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(name, style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                SizedBox(height: 4),
                Text('$from → $to', style: TextStyle(fontSize: 14, color: Colors.grey[700])),
                SizedBox(height: 2),
                Text('$date • $time', style: TextStyle(fontSize: 13, color: Colors.grey[600])),
                SizedBox(height: 10),
                Wrap(
                  spacing: 10,
                  children: [
                    _buildTag(Icons.attach_money, '৳$price', Colors.green.shade50, Colors.green.shade800),
                    _buildTag(Icons.event_seat, '$seats seats', Colors.orange.shade50, Colors.orange.shade700),
                    _buildTag(Icons.timer, duration, Colors.grey.shade200, Colors.grey.shade700),
                  ],
                ),
              ],
            ),
          ),
          SizedBox(width: 8),
          Icon(Icons.arrow_forward_ios_rounded, size: 16, color: Colors.grey.shade500),
        ],
      ),
    );
  }
}
