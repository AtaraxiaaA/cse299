import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:intl/intl.dart';
import 'UpcomingTrains.dart';
import 'MatchedTrainsPage.dart';
import 'Dashboard.dart'; // Ensure you have imported this screen

class TrainHomePage extends StatefulWidget {
  @override
  _TrainHomePageState createState() => _TrainHomePageState();
}

class _TrainHomePageState extends State<TrainHomePage> {
  TextEditingController departureDateController = TextEditingController();
  TextEditingController returnDateController = TextEditingController();

  String? selectedFromStation;
  String? selectedToStation;
  String seatCount = '2';
  String tripType = 'One Way';
  String selectedCountry = 'Bangladesh';

  DateTime? selectedDepartureDate;
  DateTime? selectedReturnDate;

  List<String> stationList = [];
  List<Map<String, dynamic>> matchedTrains = [];
  List<Map<String, dynamic>> todayTrains = [];
  List<Map<String, dynamic>> upcomingTrains = [];

  final List<String> countries = ['Bangladesh', 'India', 'Nepal'];

  Future<void> fetchStations() async {
    final doc = await FirebaseFirestore.instance.collection('Trains').doc(selectedCountry).get();
    final data = doc.data();
    if (data != null && data['Stations'] != null) {
      stationList = List<String>.from(data['Stations']);
    } else {
      stationList = [];
    }
    setState(() {});
  }

  @override
  void initState() {
    super.initState();
    fetchStations();
    fetchTodayAndUpcomingTrains();
  }

  Future<void> fetchTodayAndUpcomingTrains() async {
    final now = DateTime.now();
    final todayStart = DateTime(now.year, now.month, now.day);
    final todayEnd = DateTime(now.year, now.month, now.day, 23, 59, 59);
    final fifteenDaysLater = now.add(Duration(days: 15));

    List<Map<String, dynamic>> todayList = [];
    List<Map<String, dynamic>> upcomingList = [];

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

          if (trainTime.isAfter(now) && trainTime.isBefore(todayEnd)) {
            todayList.add({ ...data, 'ParsedDeparture': trainTime });
          } else if (trainTime.isAfter(todayEnd) && trainTime.isBefore(fifteenDaysLater)) {
            upcomingList.add({ ...data, 'ParsedDeparture': trainTime });
          }
        }
      }
    }

    todayList.sort((a, b) => a['ParsedDeparture'].compareTo(b['ParsedDeparture']));
    upcomingList.sort((a, b) => a['ParsedDeparture'].compareTo(b['ParsedDeparture']));

    setState(() {
      todayTrains = todayList;
      upcomingTrains = upcomingList;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (context) => DashboardScreen()),
          ),
        ),
        backgroundColor: Color(0xFF003C5F),
        title: Text('Train Search', style: GoogleFonts.lato(color: Colors.white)),
      ),
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [Color(0xFF003C5F), Color(0xFF006F8E)],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        padding: const EdgeInsets.all(20.0),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Row(
                children: [
                  _buildGradientRadio('One Way', 'One Way'),
                  SizedBox(width: 10),
                  _buildGradientRadio('Round Trip', 'Round Trip'),
                ],
              ),
              SizedBox(height: 20),
              Text('Country:', style: GoogleFonts.lato(fontSize: 16, color: Colors.white)),
              SizedBox(height: 10),
              _buildCountryDropdown(),
              SizedBox(height: 20),
              _buildStationDropdown('Current Location', selectedFromStation, (val) => setState(() => selectedFromStation = val)),
              SizedBox(height: 20),
              _buildStationDropdown('Destination', selectedToStation, (val) => setState(() => selectedToStation = val)),
              SizedBox(height: 20),
              _buildDateTextField(departureDateController, 'Departure Date'),
              SizedBox(height: 20),
              if (tripType == 'Round Trip') _buildDateTextField(returnDateController, 'Return Date', isReturn: true),
              SizedBox(height: 20),
              Row(
                children: [
                  Text('Seats:', style: GoogleFonts.lato(fontSize: 16, color: Colors.white)),
                  SizedBox(width: 10),
                  Container(width: 80, child: _buildDropdownButton()),
                  SizedBox(width: 20),
                  Expanded(
                    child: ElevatedButton(
                      onPressed: _searchTrains,
                      child: Text('Search Commuter Line', style: TextStyle(color: Colors.white)),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Color(0xFF1E88E5),
                        padding: EdgeInsets.symmetric(vertical: 18),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(35)),
                      ),
                    ),
                  ),
                ],
              ),
              SizedBox(height: 30),
              _buildTodayScheduleCard(),
              SizedBox(height: 30),
              _buildUpcomingTripsCard(), // Updated upcoming trains section
            ],
          ),
        ),
      ),
    );
  }

  Future<void> _pickDate(BuildContext context, TextEditingController controller, {bool isReturn = false}) async {
    final initialDate = isReturn && selectedDepartureDate != null
        ? selectedDepartureDate!.add(Duration(days: 1))
        : DateTime.now();

    final pickedDate = await showDatePicker(
      context: context,
      initialDate: initialDate,
      firstDate: initialDate,
      lastDate: DateTime(2101),
    );

    if (pickedDate != null) {
      setState(() {
        controller.text = DateFormat('yyyy-MM-dd').format(pickedDate);
        if (isReturn) selectedReturnDate = pickedDate;
        else {
          selectedDepartureDate = pickedDate;
          returnDateController.clear();
        }
      });
    }
  }

  void _searchTrains() async {
    if (selectedFromStation == null || selectedToStation == null) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Please select both stations')));
      return;
    }

    final snapshot = await FirebaseFirestore.instance
        .collection('Trains')
        .doc(selectedCountry)
        .collection('OneWay')
        .where('From', isEqualTo: selectedFromStation)
        .where('To', isEqualTo: selectedToStation)
        .get();

    if (snapshot.docs.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('No matching trains found')));
    } else {
      matchedTrains = snapshot.docs.map((doc) => doc.data()).toList();
      Navigator.push(context, MaterialPageRoute(builder: (context) => MatchedTrainsPage(trains: matchedTrains)));
    }
  }

  Widget _buildDateTextField(TextEditingController controller, String label, {bool isReturn = false}) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(15.0),
        boxShadow: [BoxShadow(color: Colors.grey.withOpacity(0.2), spreadRadius: 1, blurRadius: 8)],
      ),
      child: TextField(
        controller: controller,
        readOnly: true,
        onTap: () => _pickDate(context, controller, isReturn: isReturn),
        decoration: InputDecoration(
          labelText: label,
          hintText: 'Select your date',
          contentPadding: EdgeInsets.symmetric(vertical: 15, horizontal: 20),
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(15), borderSide: BorderSide.none),
        ),
      ),
    );
  }

  Widget _buildGradientRadio(String title, String value) {
    return Expanded(
      child: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(colors: [Color(0xFF1E88E5), Color(0xFF26C6DA)]),
          borderRadius: BorderRadius.circular(25),
        ),
        child: RadioListTile<String>(
          title: Text(title, style: GoogleFonts.lato(color: Colors.black)),
          value: value,
          groupValue: tripType,
          onChanged: (val) {
            setState(() {
              tripType = val!;
              returnDateController.clear();
            });
          },
          activeColor: Colors.white,
        ),
      ),
    );
  }

  Widget _buildDropdownButton() {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(15.0),
        boxShadow: [BoxShadow(color: Colors.grey.withOpacity(0.2), spreadRadius: 1, blurRadius: 8)],
      ),
      child: DropdownButton<String>(
        value: seatCount,
        onChanged: (val) => setState(() => seatCount = val!),
        items: ['1', '2', '3', '4', '5'].map((v) => DropdownMenuItem(value: v, child: Padding(padding: EdgeInsets.symmetric(horizontal: 20), child: Text(v)))).toList(),
        underline: SizedBox(),
      ),
    );
  }

  Widget _buildCountryDropdown() {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(15.0),
        boxShadow: [BoxShadow(color: Colors.grey.withOpacity(0.2), spreadRadius: 1, blurRadius: 8)],
      ),
      child: DropdownButton<String>(
        value: selectedCountry,
        onChanged: (val) => setState(() {
          selectedCountry = val!;
          fetchStations();
        }),
        items: countries.map((country) => DropdownMenuItem(value: country, child: Padding(padding: EdgeInsets.symmetric(horizontal: 20), child: Text(country)))).toList(),
        underline: SizedBox(),
        isExpanded: true,
      ),
    );
  }

  Widget _buildStationDropdown(String label, String? value, ValueChanged<String?> onChanged) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(15.0),
        boxShadow: [BoxShadow(color: Colors.grey.withOpacity(0.2), spreadRadius: 1, blurRadius: 8)],
      ),
      padding: EdgeInsets.symmetric(horizontal: 15),
      child: DropdownButton<String>(
        value: value,
        onChanged: onChanged,
        hint: Text(label),
        items: stationList.map((station) => DropdownMenuItem(value: station, child: Text(station))).toList(),
        isExpanded: true,
        underline: SizedBox(),
      ),
    );
  }

  Widget _buildTodayScheduleCard() {
    return Card(
      elevation: 10,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
      color: Color(0xFFFAFAFA),
      child: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Today Schedule', style: GoogleFonts.lato(fontSize: 18, fontWeight: FontWeight.bold)),
            SizedBox(height: 10),
            if (todayTrains.isEmpty)
              Text('No trains available now.'),
            ...todayTrains.map((t) => Column(children: [
              _buildScheduleRow(t['From'], t['To'], DateFormat('hh:mm a').format(t['ParsedDeparture']), t['Duration']),
              Divider(),
            ])),
          ],
        ),
      ),
    );
  }

  Widget _buildUpcomingTripsCard() {
    print("🔥 Upcoming trains count: ${upcomingTrains.length}");
    return Container(
      margin: EdgeInsets.only(bottom: 24),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(24),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 14,
            offset: Offset(0, 8),
          ),
        ],
      ),
      child: Card(
        elevation: 12,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
        color: Colors.white,
        shadowColor: Colors.grey.shade300,
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Upcoming Trains',
                    style: GoogleFonts.lato(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      color: Colors.black87,
                    ),
                  ),
                  ElevatedButton.icon(
                    onPressed: () => Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => UpcomingTrains()),
                    ),
                    icon: Icon(Icons.list_alt, size: 18, color: Colors.white),  // Icon color set to white
                    label: Text('View All', style: TextStyle(color: Colors.white)),  // Text color set to white
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Color(0xFF1E88E5),
                      padding: EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(14),
                      ),
                    ),
                  ),
                ],
              ),
              SizedBox(height: 20),
              if (upcomingTrains.isEmpty)
                Center(
                  child: Text(
                    'No upcoming trains found.',
                    style: GoogleFonts.lato(fontSize: 16, color: Colors.grey[700]),
                  ),
                ),
              // Limit the display to the first train only
              ...upcomingTrains.take(1).map((t) {
                try {
                  final String from = t['From'] ?? 'Unknown';
                  final String to = t['To'] ?? 'Unknown';
                  final DateTime parsed = t['ParsedDeparture'];
                  final String time = DateFormat('hh:mm a').format(parsed);
                  final String date = DateFormat('EEE, MMM dd').format(parsed);
                  final String duration = t['Duration'] ?? 'N/A';
                  final String name = t['Name'] ?? 'Unnamed';
                  final String price = t['Price']?.toString() ?? '—';
                  final String seats = t['AvailableSeats']?.toString() ?? '—';

                  return Container(
                    margin: EdgeInsets.only(bottom: 18),
                    padding: EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(20),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black12,
                          blurRadius: 10,
                          offset: Offset(0, 4),
                        ),
                      ],
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
                              Text(
                                name,
                                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                              ),
                              SizedBox(height: 4),
                              Text(
                                '$from → $to',
                                style: TextStyle(fontSize: 14, color: Colors.grey[700]),
                              ),
                              SizedBox(height: 2),
                              Text(
                                '$date • $time',
                                style: TextStyle(fontSize: 13, color: Colors.grey[600]),
                              ),
                              SizedBox(height: 10),
                              Wrap(
                                spacing: 10,
                                children: [
                                  _buildTag(Icons.attach_money, '\$price', Colors.green.shade50, Colors.green.shade800),
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
                } catch (e) {
                  print("❌ Error rendering train: \$e");
                  return SizedBox();
                }
              }).toList(),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildTag(IconData icon, String text, Color bgColor, Color textColor) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 10, vertical: 6),
      decoration: BoxDecoration(
        color: bgColor,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 14, color: textColor),
          SizedBox(width: 4),
          Text(
            text,
            style: TextStyle(fontSize: 12, color: textColor, fontWeight: FontWeight.w600),
          ),
        ],
      ),
    );
  }

  Widget _buildScheduleRow(String from, String to, String time, String duration) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(from, style: TextStyle(fontSize: 14)),
        Icon(Icons.train, size: 16),
        Text(to, style: TextStyle(fontSize: 14)),
        Text(time, style: TextStyle(fontSize: 14)),
        Text(duration, style: TextStyle(fontSize: 14)),
      ],
    );
  }
}
