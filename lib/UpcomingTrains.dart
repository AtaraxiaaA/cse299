import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'dashboard.dart';
import 'profile.dart';
import 'HotelHomePage.dart';

class UpcomingTrains extends StatefulWidget {
  const UpcomingTrains({super.key});

  @override
  State<UpcomingTrains> createState() => _UpcomingTrainsState();
}

class _UpcomingTrainsState extends State<UpcomingTrains> {
  int _selectedIndex = 0;

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Train Search',
          style: GoogleFonts.poppins(color: Colors.white, fontSize: 22),
        ),
        backgroundColor: Color(0xFF003653),
        actions: [
          IconButton(
            icon: Icon(Icons.notifications, color: Colors.white),
            onPressed: () {
              // Add action for notifications
            },
          )
        ],
      ),
      body: SingleChildScrollView(
        child: Container(
          padding: EdgeInsets.all(16),
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [
                Color(0xFF007E95),
                Color(0xFF004D65),
                Color(0xFF003653),
              ],
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
            ),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Greeting Text
              Text(
                'Hi User!',
                style: TextStyle(
                    color: Colors.white, fontSize: 28, fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 10),
              Text(
                'Where do you want to go?',
                style: TextStyle(
                    color: Colors.white, fontSize: 28, fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 20),

              // Search Field
              Container(
                padding: EdgeInsets.symmetric(horizontal: 20),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(30),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black12,
                      blurRadius: 6,
                      spreadRadius: 2,
                    ),
                  ],
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

              // Upcoming Trains Section
              Text(
                'Upcoming Trains',
                style: GoogleFonts.poppins(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 20),
              ),
              SizedBox(height: 10),
              upcomingTripsCard(),
              upcomingTripsCard(),
              upcomingTripsCard(),  // Add more upcoming trips here if needed

              // New Section - More Upcoming Trips
              SizedBox(height: 20),
              Text(
                'More Upcoming Trips',
                style: GoogleFonts.poppins(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 20),
              ),
              SizedBox(height: 10),
              moreUpcomingTrips(),
            ],
          ),
        ),
      ),
      bottomNavigationBar: BottomNavigationBar(
        backgroundColor: Color(0xFF003653),
        selectedItemColor: Colors.white,
        unselectedItemColor: Colors.blueGrey,
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.search),
            label: 'Search',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.favorite),
            label: 'Profile',
          ),
        ],
        currentIndex: _selectedIndex,
        onTap: (int index) {
          setState(() {
            _selectedIndex = index;
          });

          switch(index) {
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

  // Upcoming Trip Card with Border
  Widget upcomingTripsCard() {
    return Container(
      padding: EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Color(0xFF1C5E85),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: Colors.white, width: 2),  // Added Border here
      ),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text('10 May, 12:30 pm', style: TextStyle(color: Colors.white)),
              Text('11 May, 08:15 am', style: TextStyle(color: Colors.white)),
            ],
          ),
          SizedBox(height: 10),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text('Dhaka', style: TextStyle(color: Colors.white, fontSize: 20, fontWeight: FontWeight.bold)),
              Icon(Icons.train, color: Colors.white), // Train icon instead of flight
              Text('Chittagong', style: TextStyle(color: Colors.white, fontSize: 20, fontWeight: FontWeight.bold)),
            ],
          ),
        ],
      ),
    );
  }

  // More Upcoming Trips Section with Borders
  Widget moreUpcomingTrips() {
    return Column(
      children: [
        upcomingTripCard('12 May, 10:00 am', 'Dhaka', 'Rajshahi'),
        upcomingTripCard('13 May, 11:00 am', 'Chittagong', 'Rangpur'),
        upcomingTripCard('14 May, 09:30 am', 'Rajshahi', 'Sylhet'),
      ],
    );
  }

  // Helper Method for Upcoming Trip Card with Border
  Widget upcomingTripCard(String dateTime, String from, String to) {
    return Card(
      color: Colors.white,
      margin: EdgeInsets.symmetric(vertical: 10),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10),
        side: BorderSide(color: Colors.grey, width: 1.5),  // Border for the card
      ),
      child: Padding(
        padding: EdgeInsets.all(15),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(dateTime, style: GoogleFonts.poppins(fontSize: 16, fontWeight: FontWeight.bold)),
                SizedBox(height: 5),
                Text('$from → $to', style: GoogleFonts.poppins(fontSize: 14)),
              ],
            ),
            Icon(Icons.train, size: 30, color: Color(0xFF264653)), // Train icon instead of flight
          ],
        ),
      ),
    );
  }
}
