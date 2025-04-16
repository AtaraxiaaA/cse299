import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'rewardsBooking.dart';

class RewardsDiscountsScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Exclusive Rewards & Discounts")),
      body: Padding(
        padding: const EdgeInsets.all(10.0),
        child: StreamBuilder<QuerySnapshot>(
          stream: FirebaseFirestore.instance.collection('rewards').snapshots(),
          builder: (context, snapshot) {
            if (snapshot.hasError) {
              return Center(child: Text('Error: ${snapshot.error}'));
            }
            if (snapshot.connectionState == ConnectionState.waiting) {
              return Center(child: CircularProgressIndicator());
            }

            final hotels = snapshot.data!.docs.map((doc) => {
              ...doc.data() as Map<String, dynamic>,
              'id': doc.id,
            }).toList();

            if (hotels.isEmpty) {
              return Center(child: Text("No rewards available."));
            }

            return GridView.builder(
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                crossAxisSpacing: 10,
                mainAxisSpacing: 10,
                childAspectRatio: 0.8,
              ),
              itemCount: hotels.length,
              itemBuilder: (context, index) {
                final hotel = hotels[index];
                return GestureDetector(
                  onTap: () => showHotelDetails(context, hotel),
                  child: Container(
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        colors: [Color(0xFF043836), Color(0xFF032a29), Color(0xFF021c1b)],
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                      ),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    padding: EdgeInsets.all(12),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          hotel['name']!,
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        SizedBox(height: 5),
                        Text(
                          hotel['features']!,
                          style: TextStyle(color: Colors.white70, fontSize: 12),
                        ),
                        Spacer(),
                        Text(
                          hotel['price']!,
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 14,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                        SizedBox(height: 5),
                        ElevatedButton(
                          onPressed: () => showHotelDetails(context, hotel),
                          child: Text("Book Now"),
                        ),
                      ],
                    ),
                  ),
                );
              },
            );
          },
        ),
      ),
    );
  }

  void showHotelDetails(BuildContext context, Map<String, dynamic> hotel) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => HotelBookingScreen(
          hotelName: hotel['name']!,
          price: hotel['price']!,
          discount: hotel['coupon']!,
          reviews: [
            {
              "user": "John Doe",
              "rating": double.parse(hotel['reviews']['overall'].split('/')[0]),
              "comment": hotel['reviews']['overall'],
              "location": hotel['reviews']['location'],
              "cleanliness": hotel['reviews']['cleanliness'],
              "value_for_money": hotel['reviews']['value_for_money'],
            },
          ],
          specialOffer: hotel['coupon']!,
          imageUrl: hotel['image']!,
        ),
      ),
    );
  }
}