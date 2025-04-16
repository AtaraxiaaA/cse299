import 'package:flutter/material.dart';
import 'carrentalscreen.dart'; // Import carrentalscreen.dart

class AvailableCarsScreen extends StatelessWidget {
  final List<Map<String, String>> filteredCars;
  final String fromLocation;
  final String toLocation;

  AvailableCarsScreen({
    required this.filteredCars,
    required this.fromLocation,
    required this.toLocation,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Available Cars'),
        backgroundColor: Color(0xFF007E95),
        foregroundColor: Colors.white,
        leadingWidth:15,
      ),
      body: Stack(
        children: [
          Image.asset(
            'images/car3.jpg', // Replace with your background image asset
            fit: BoxFit.cover,
            width: double.infinity,
            height: double.infinity,
          ),
          ListView.builder(
            itemCount: filteredCars.length,
            itemBuilder: (context, index) {
              var car = filteredCars[index];
              return buildCarCard(
                context,
                car['car'] ?? '',
                car['price'] ?? '',
                car['pickUpTime'] ?? '',
                car['dropOffTime'] ?? '',
                car['from'] ?? '',
                car['to'] ?? '',
              );
            },
          ),
        ],
      ),
    );
  }

  Widget buildCarCard(
      BuildContext context,
      String car,
      String price,
      String pickUpTime,
      String dropOffTime,
      String from,
      String to,
      ) {
    Map<String, String>? selectedCar;
    for (var availableCar in filteredCars) {
      if (availableCar['car'] == car &&
          availableCar['price'] == price &&
          availableCar['pickUpTime'] == pickUpTime &&
          availableCar['dropOffTime'] == dropOffTime &&
          availableCar['from'] == from &&
          availableCar['to'] == to) {
        selectedCar = availableCar;
        break;
      }
    }

    return Card(
      elevation: 5,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      margin: EdgeInsets.only(bottom: 16),
      color: Colors.white.withOpacity(0.8),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Row(
          children: [
            Icon(Icons.directions_car, size: 40, color: Color(0xFF007E95)),
            SizedBox(width: 15),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    car,
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.black),
                  ),
                  Text('Pick-up Time: ${pickUpTime ?? 'N/A'}', style: TextStyle(color: Colors.black)),
                  Text('Drop-off Time: ${dropOffTime ?? 'N/A'}', style: TextStyle(color: Colors.black)),
                  Text('Price: $price/day', style: TextStyle(color: Colors.black)),
                  Text('Pick-up Location: $from', style: TextStyle(color: Colors.black)),
                  Text('Drop-off Location: $to', style: TextStyle(color: Colors.black)),
                ],
              ),
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => CarRentalScreen(
                      carDetails: {
                        'car': car,
                        'price': price,
                        'pickUpTime': pickUpTime,
                        'dropOffTime': dropOffTime,
                        'from': from,
                        'to': to,
                        'type': selectedCar?['type'] ?? 'Not Available',
                      },
                      rentalDetails: {
                        'from': from,
                        'to': to,
                        'date': selectedCar?['date'] ?? 'Not Available',
                        'returnDate': selectedCar?['returnDate'] ?? 'Not Available',
                        'type': selectedCar?['type'] ?? 'Not Available',
                      },
                    ),
                  ),
                );
              },
              child: Text('Book Now'),
              style: ElevatedButton.styleFrom(
                backgroundColor: Color(0xFF007E95),
                foregroundColor: Colors.white,
                textStyle: TextStyle(fontWeight: FontWeight.bold),
              ),
            ),
          ],
        ),
      ),
    );
  }
}