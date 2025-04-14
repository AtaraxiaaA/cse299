import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'busbookingscreen.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class AvailableBusesScreen extends StatefulWidget {
  final List<Map<String, dynamic>> availableBuses;

  AvailableBusesScreen({required this.availableBuses});

  @override
  _AvailableBusesScreenState createState() => _AvailableBusesScreenState();
}

class _AvailableBusesScreenState extends State<AvailableBusesScreen> {
  List<Map<String, dynamic>> _availableBuses = [];

  @override
  void initState() {
    super.initState();
    _availableBuses = widget.availableBuses;
  }

  Future<void> _refetchBusData() async {
    try {
      QuerySnapshot querySnapshot = await FirebaseFirestore.instance
          .collection('bus')
          .where('bus', isEqualTo: _availableBuses[0]['bus'])
          .where('date', isEqualTo: _availableBuses[0]['date'])
          .get();

      if (querySnapshot.docs.isNotEmpty) {
        setState(() {
          _availableBuses = querySnapshot.docs.map((doc) => doc.data() as Map<String, dynamic>).toList();
        });
      }
    } catch (e) {
      print('Error refetching bus data: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Available Buses",
          style: GoogleFonts.poppins(
            fontWeight: FontWeight.w600,
            color: Colors.white,
          ),
        ),
        backgroundColor: const Color(0xFF007E95),
      ),
      body: Stack(
        children: [
          Container(
            decoration: const BoxDecoration(
              image: DecorationImage(
                image: AssetImage('images/busimage1.jpg'),
                fit: BoxFit.cover,
                colorFilter: ColorFilter.mode(
                  Color.fromRGBO(0, 0, 0, 0.4),
                  BlendMode.darken,
                ),
              ),
            ),
          ),
          ListView.builder(
            itemCount: _availableBuses.length,
            itemBuilder: (context, index) {
              final bus = _availableBuses[index];
              return BusCard(bus: bus, refetchData: _refetchBusData);
            },
          ),
        ],
      ),
    );
  }
}

class BusCard extends StatelessWidget {
  final Map<String, dynamic> bus;
  final Function refetchData;

  const BusCard({Key? key, required this.bus, required this.refetchData}) : super(key: key);

  Future<void> _addOrUpdateBusDetails(Map<String, dynamic> busData) async {
    try {
      QuerySnapshot querySnapshot = await FirebaseFirestore.instance
          .collection('bus')
          .where('bus', isEqualTo: busData['bus'])
          .where('date', isEqualTo: busData['date'])
          .get();

      if (querySnapshot.docs.isNotEmpty) {
        await FirebaseFirestore.instance
            .collection('bus')
            .doc(querySnapshot.docs.first.id)
            .update({
          'departureTime': busData['departureTime'],
          'arrivalTime': busData['arrivalTime'],
        });
        print('Bus details updated in Firestore.');
      } else {
        await FirebaseFirestore.instance.collection('bus').add({
          'bus': busData['bus'],
          'date': busData['date'],
          'from': busData['from'],
          'price': busData['price'],
          'to': busData['to'],
          'type': busData['type'],
          'departureTime': busData['departureTime'],
          'arrivalTime': busData['arrivalTime'],
        });
        print('Bus details added to Firestore.');
      }
      await refetchData();
    } catch (e) {
      print('Error adding/updating bus details in Firestore: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.all(8.0),
      elevation: 4,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Row(
          children: [
            const Icon(Icons.directions_bus, size: 48, color: Color(0xFF007E95)),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(bus['bus'] ?? 'Bus Name', style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                  Text('Departure Time: ${bus['departureTime'] ?? 'N/A'}', style: const TextStyle(fontSize: 14)),
                  Text('Arrival Time: ${bus['arrivalTime'] ?? 'N/A'}', style: const TextStyle(fontSize: 14)),
                  Text('Ticket Price: ${bus['price'] ?? 'N/A'}', style: const TextStyle(fontSize: 14)),
                  Text('Pick-up Location: ${bus['from'] ?? 'N/A'}', style: const TextStyle(fontSize: 14)),
                  Text('Drop-off Location: ${bus['to'] ?? 'N/A'}', style: const TextStyle(fontSize: 14)),
                ],
              ),
            ),
            ElevatedButton(
              onPressed: () {
                _addOrUpdateBusDetails(bus);
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => BusBookingScreen(
                      busDetails: {
                        'bus': bus['bus'] ?? '',
                        'from': bus['from'] ?? '',
                        'to': bus['to'] ?? '',
                        'price': bus['price'] ?? '',
                        'date': bus['date'] ?? '',
                        'type': bus['type'] ?? '',
                        'departureTime': bus['departureTime'] ?? '',
                        'arrivalTime': bus['arrivalTime'] ?? '',
                      },
                      travelers: 1,
                    ),
                  ),
                );
              },
              child: const Text('Book Now'),
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF007E95),
                foregroundColor: Colors.white,
              ),
            ),
          ],
        ),
      ),
    );
  }
}