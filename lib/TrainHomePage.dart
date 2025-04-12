import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'UpcomingTrains.dart'; //train page

class TrainHomePage extends StatefulWidget {
  @override
  _TrainHomePageState createState() => _TrainHomePageState();
}

class _TrainHomePageState extends State<TrainHomePage> {
  TextEditingController currentLocationController = TextEditingController();
  TextEditingController destinationController = TextEditingController();
  TextEditingController departureDateController = TextEditingController();
  String seatCount = '2';
  String tripType = 'One Way'; // Default option is One Way

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: null, // Removed AppBar
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [
              Color(0xFF003C5F), // Darker blue (top)
              Color(0xFF006F8E), // Medium blue (bottom)
            ],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        padding: const EdgeInsets.all(20.0),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              // One Way and Round Trip Radio Buttons at the top
              Row(
                children: <Widget>[
                  _buildGradientRadio('One Way', 'One Way',
                      [Color(0xFF1E88E5), Color(0xFF26C6DA)]), // Blue to Cyan gradient
                  SizedBox(width: 10), // Gap between One Way and Round Trip
                  _buildGradientRadio('Round Trip', 'Round Trip',
                      [Color(0xFF1E88E5), Color(0xFF26C6DA)]), // Blue to Cyan gradient
                ],
              ),
              SizedBox(height: 20),
              // Text Fields for Current Location, Destination, Departure Date
              _buildTextField(
                controller: currentLocationController,
                label: 'Current Location',
                hint: 'Enter your current location',
              ),
              SizedBox(height: 20),
              _buildTextField(
                controller: destinationController,
                label: 'Destination',
                hint: 'Enter your destination',
              ),
              SizedBox(height: 20),
              _buildTextField(
                controller: departureDateController,
                label: 'Departure Date',
                hint: 'Select your departure date',
                onTap: () async {
                  DateTime? pickedDate = await showDatePicker(
                    context: context,
                    initialDate: DateTime.now(),
                    firstDate: DateTime(2020),
                    lastDate: DateTime(2101),
                  );
                  if (pickedDate != null) {
                    setState(() {
                      departureDateController.text =
                      '${pickedDate.year}-${pickedDate.month}-${pickedDate.day}';
                    });
                  }
                },
              ),
              SizedBox(height: 20),
              Row(
                children: <Widget>[
                  Text(
                    'Seats:',
                    style: GoogleFonts.lato(fontSize: 16, color: Colors.white),
                  ),
                  SizedBox(width: 10),
                  _buildDropdownButton(),
                ],
              ),
              SizedBox(height: 30),
              ElevatedButton(
                onPressed: () {
                  // Add the search commuter line functionality here
                },
                child: Text(
                  'Search Commuter Line',
                  style: TextStyle(color: Colors.white), // Text color changed to white
                ),
                style: ElevatedButton.styleFrom(
                  elevation: 8.0,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(30.0),
                  ),
                  padding: EdgeInsets.symmetric(vertical: 18, horizontal: 30),
                  backgroundColor: Color(0xFF1E88E5), // Blue to Cyan gradient
                  shadowColor: Colors.blueGrey.withOpacity(0.3),
                ),
              ),
              SizedBox(height: 30),
              // Card for Today's Schedule
              Card(
                elevation: 10,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(15),
                ),
                color: Color(0xFFFAFAFA), // Light card background
                shadowColor: Colors.black.withOpacity(0.2),
                child: Padding(
                  padding: const EdgeInsets.all(20.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Today\'s Schedule',
                        style: GoogleFonts.lato(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: Colors.black,
                        ),
                      ),
                      SizedBox(height: 15),
                      _buildScheduleRow('Rangpur', 'Dhaka', '10:45 PM', '2H 45M Trip'),
                      Divider(),
                      SizedBox(height: 10),
                      _buildScheduleRow('Rajshahi', 'Chittagong', '10:45 PM', '3H 30M Trip'),
                    ],
                  ),
                ),
              ),
              SizedBox(height: 30),
              // Card for More Upcoming Trips
              Card(
                elevation: 10,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(15),
                ),
                color: Color(0xFFFAFAFA), // Light card background
                shadowColor: Colors.black.withOpacity(0.2),
                child: Padding(
                  padding: const EdgeInsets.all(20.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            'More Upcoming Trips',
                            style: GoogleFonts.lato(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                              color: Colors.black,
                            ),
                          ),
                          ElevatedButton(
                            onPressed: () {
                              // Navigate to the UpcomingTrains page
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => UpcomingTrains(), // Navigate to the UpcomingTrains page
                                ),
                              );
                            },
                            child: Text(
                              'View All',
                              style: GoogleFonts.lato(fontSize: 14, color: Colors.white),
                            ),
                            style: ElevatedButton.styleFrom(
                              padding: EdgeInsets.symmetric(vertical: 8, horizontal: 16),
                              backgroundColor: Color(0xFF1E88E5), // Blue to Cyan gradient
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(15),
                              ),
                            ),
                          ),
                        ],
                      ),
                      SizedBox(height: 15),
                      _buildUpcomingTrips('12 May, 10:00 am', 'Kamalapur → Agartala'),
                      Divider(),
                      SizedBox(height: 10),
                    ],
                  ),
                ),
              ),
              SizedBox(height: 30),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildGradientRadio(String title, String value, List<Color> gradientColors) {
    return Expanded(
      child: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: gradientColors,
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
          borderRadius: BorderRadius.circular(25),
        ),
        child: RadioListTile<String>(
          title: Text(
            title,
            style: GoogleFonts.lato(color: Colors.black), // Text color changed to black
          ),
          value: value,
          groupValue: tripType,
          onChanged: (value) {
            setState(() {
              tripType = value!;
            });
          },
          activeColor: Colors.white,
          tileColor: Colors.transparent,
        ),
      ),
    );
  }

  Widget _buildTextField({
    required TextEditingController controller,
    required String label,
    required String hint,
    Function()? onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(15.0),
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(0.2),
              spreadRadius: 1,
              blurRadius: 8,
              offset: Offset(0, 4),
            ),
          ],
        ),
        child: TextField(
          controller: controller,
          decoration: InputDecoration(
            labelText: label,
            hintText: hint,
            contentPadding: EdgeInsets.symmetric(vertical: 15, horizontal: 20),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(15.0),
              borderSide: BorderSide.none,
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildDropdownButton() {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(15.0),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.2),
            spreadRadius: 1,
            blurRadius: 8,
            offset: Offset(0, 4),
          ),
        ],
      ),
      child: DropdownButton<String>(
        value: seatCount,
        onChanged: (String? newValue) {
          setState(() {
            seatCount = newValue!;
          });
        },
        items: <String>['1', '2', '3', '4', '5']
            .map<DropdownMenuItem<String>>((String value) {
          return DropdownMenuItem<String>(
            value: value,
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20.0),
              child: Text(value),
            ),
          );
        }).toList(),
        underline: SizedBox(),
      ),
    );
  }

  Widget _buildScheduleRow(String from, String to, String time, String duration) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: <Widget>[
        Text(
          from,
          style: TextStyle(fontSize: 14, color: Colors.black),
        ),
        Icon(Icons.train, size: 16, color: Colors.black), // Train icon instead of arrow
        Text(
          to,
          style: TextStyle(fontSize: 14, color: Colors.black),
        ),
        Text(
          time,
          style: TextStyle(fontSize: 14, color: Colors.black),
        ),
        Text(
          duration,
          style: TextStyle(fontSize: 14, color: Colors.black),
        ),
      ],
    );
  }

  Widget _buildUpcomingTrips(String time, String route) {
    return Row(
      children: <Widget>[
        Text(
          time,
          style: TextStyle(fontSize: 14, color: Colors.black),
        ),
        SizedBox(width: 10),
        Icon(Icons.train, size: 16, color: Colors.black), // Train icon instead of flight
        SizedBox(width: 10),
        Text(
          route,
          style: TextStyle(fontSize: 14, color: Colors.black),
        ),
      ],
    );
  }
}
