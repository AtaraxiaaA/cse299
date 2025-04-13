import 'package:cloud_firestore/cloud_firestore.dart';

class PopulateFlights {
  static Future<void> addFlights() async {
    final CollectionReference flights =
    FirebaseFirestore.instance.collection('flights');

    // List of 10 sample flights
    final List<Map<String, dynamic>> sampleFlights = [
      {
        'from': 'dhaka',
        'to': 'singapore',
        'departureTime': '10:00 AM',
        'price': '\$300',
        'stopType': 'Non-stop',
        'departureDate': Timestamp.fromDate(DateTime(2025, 4, 15)),
      },
      {
        'from': 'dhaka',
        'to': 'london',
        'departureTime': '02:00 PM',
        'price': '\$500',
        'stopType': '1 Stop',
        'departureDate': Timestamp.fromDate(DateTime(2025, 4, 16)),
      },
      {
        'from': 'dhaka',
        'to': 'new york',
        'departureTime': '08:00 PM',
        'price': '\$700',
        'stopType': 'Non-stop',
        'departureDate': Timestamp.fromDate(DateTime(2025, 4, 17)),
      },
      {
        'from': 'dhaka',
        'to': 'tokyo',
        'departureTime': '11:30 AM',
        'price': '\$450',
        'stopType': '1 Stop',
        'departureDate': Timestamp.fromDate(DateTime(2025, 4, 15)),
      },
      {
        'from': 'dhaka',
        'to': 'dubai',
        'departureTime': '03:00 PM',
        'price': '\$350',
        'stopType': 'Non-stop',
        'departureDate': Timestamp.fromDate(DateTime(2025, 4, 15)),
      },
      {
        'from': 'dhaka',
        'to': 'paris',
        'departureTime': '09:00 AM',
        'price': '\$600',
        'stopType': '1 Stop',
        'departureDate': Timestamp.fromDate(DateTime(2025, 4, 18)),
      },
      {
        'from': 'dhaka',
        'to': 'sydney',
        'departureTime': '07:00 PM',
        'price': '\$800',
        'stopType': '2 Stops',
        'departureDate': Timestamp.fromDate(DateTime(2025, 4, 19)),
      },
      {
        'from': 'dhaka',
        'to': 'bangkok',
        'departureTime': '01:00 PM',
        'price': '\$250',
        'stopType': 'Non-stop',
        'departureDate': Timestamp.fromDate(DateTime(2025, 4, 15)),
      },
      {
        'from': 'dhaka',
        'to': 'istanbul',
        'departureTime': '05:00 PM',
        'price': '\$400',
        'stopType': '1 Stop',
        'departureDate': Timestamp.fromDate(DateTime(2025, 4, 16)),
      },
      {
        'from': 'dhaka',
        'to': 'mumbai',
        'departureTime': '06:00 AM',
        'price': '\$200',
        'stopType': 'Non-stop',
        'departureDate': Timestamp.fromDate(DateTime(2025, 4, 20)),
      },
    ];

    // Add each flight to Firestore
    for (var flight in sampleFlights) {
      await flights.add(flight).then((docRef) {
        print('Flight added with ID: ${docRef.id}');
      }).catchError((error) {
        print('Error adding flight: $error');
      });
    }
    print('All flights added successfully');
  }
}