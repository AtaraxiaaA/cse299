import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class RewardsDiscountsScreen extends StatelessWidget {
  List<Map<String, String>> hotels = [
    {
      'name': 'Pan Pacific Sonargaon Dhaka',
      'location': '107 Kazi Nazrul Islam Avenue, Dhaka',
      'features': 'Luxury hotel, swimming pool, spa, fine dining restaurants.',
      'price': 'BDT 10,000–20,000 per night',
      'reviews': '4.5/5 ⭐ (Excellent service, great location)',
      'coupon': '15% OFF on first booking',
    },
    {
      'name': 'The Westin Dhaka',
      'location': 'Gulshan Avenue, Dhaka',
      'features': '5-star hotel, rooftop pool, fitness center, multiple dining options.',
      'price': 'BDT 12,000–25,000 per night',
      'reviews': '4.7/5 ⭐ (Great amenities, central location)',
      'coupon': 'Earn 2x reward points on booking',
    },
    {
      'name': 'The Peninsula Chittagong',
      'location': 'GEC Circle, Chittagong',
      'features': 'Business-friendly hotel, multiple restaurants, rooftop lounge, sauna, free WiFi.',
      'price': 'BDT 7,000–18,000 per night',
      'reviews': '4.4/5 ⭐ (Comfortable stay, great food)',
      'coupon': '10% cashback on stays over 3 nights',
    },
    {
      'name': 'Hotel Agrabad',
      'location': 'Agrabad, Chittagong',
      'features': 'Classic luxury, outdoor pool, Thai spa, 24/7 room service, conference hall.',
      'price': 'BDT 6,500–15,000 per night',
      'reviews': '4.3/5 ⭐ (Nice ambiance, friendly staff)',
      'coupon': '20% OFF weekend stays',
    },
    {
      'name': 'Royal Tulip Sea Pearl Beach Resort & Spa',
      'location': 'Inani Beach, Cox’s Bazar',
      'features': '5-star beachfront resort, private beach access, water park, spa, casino.',
      'price': 'BDT 15,000–35,000 per night',
      'reviews': '4.6/5 ⭐ (Stunning beach view, premium experience)',
      'coupon': 'Exclusive 25% OFF for early bookings',
    },
    {
      'name': 'Sayeman Beach Resort',
      'location': 'Marine Drive, Cox’s Bazar',
      'features': 'Oceanfront rooms, infinity pool, rooftop restaurant, wellness spa.',
      'price': 'BDT 10,000–22,000 per night',
      'reviews': '4.5/5 ⭐ (Excellent ocean view, relaxing atmosphere)',
      'coupon': 'Book 3 nights, get 1 night free',
    },
    {
      'name': 'Grand Sultan Tea Resort & Golf',
      'location': 'Sreemangal, Sylhet',
      'features': '5-star tea garden resort, 18-hole golf course, spa, sauna, infinity pool.',
      'price': 'BDT 12,000–30,000 per night',
      'reviews': '4.8/5 ⭐ (Luxury amidst nature, great service)',
      'coupon': '30% OFF for honeymoon packages',
    },
    {
      'name': 'The Savoy',
      'location': 'The Strand, London',
      'features': 'Iconic luxury hotel, riverside views, Michelin-star dining, butler service.',
      'price': '£500–£1,200 per night',
      'reviews': '4.9/5 ⭐ (Unparalleled service, historical charm)',
      'coupon': '£100 discount on spa treatments',
    },
    {
      'name': 'Le Meurice – Dorchester Collection',
      'location': 'Rue de Rivoli, Paris',
      'features': 'Royal luxury, palace hotel, spa, gourmet restaurants, art-inspired decor.',
      'price': '€800–€2,500 per night',
      'reviews': '4.9/5 ⭐ (Opulent decor, world-class dining)',
      'coupon': '15% OFF romantic getaway package',
    },
    {
      'name': 'The Ritz-Carlton Tokyo',
      'location': 'Midtown Tower, Roppongi',
      'features': 'Sky-high luxury, panoramic city & Mount Fuji views, luxury spa.',
      'price': '¥80,000–¥300,000 per night',
      'reviews': '4.9/5 ⭐ (Breathtaking views, top-notch service)',
      'coupon': 'Complimentary breakfast with bookings over 2 nights',
    },
    {
      'name': 'The Plaza Hotel',
      'location': 'Fifth Avenue, New York',
      'features': 'Iconic landmark, luxurious suites, butler service, fine dining.',
      'price': '\$900–\$5,000 per night',
      'reviews': '4.8/5 ⭐ (Historic elegance, VIP treatment)',
      'coupon': 'Luxury chauffeur service included with suite bookings',
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Exclusive Rewards & Discounts")),
      body: Padding(
        padding: const EdgeInsets.all(10.0),
        child: GridView.builder(
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
                    Text(hotel['name']!, style: TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.bold)),
                    SizedBox(height: 5),
                    Text(hotel['features']!, style: TextStyle(color: Colors.white70, fontSize: 12)),
                    Spacer(),
                    Text(hotel['price']!, style: TextStyle(color: Colors.white, fontSize: 14, fontWeight: FontWeight.w500)),
                    SizedBox(height: 5),
                    ElevatedButton(
                      onPressed: () => showHotelDetails(context, hotel),
                      child: Text("Book Now"),
                    )
                  ],
                ),
              ),
            );
          },
        ),
      ),
    );
  }

  void showHotelDetails(BuildContext context, Map<String, dynamic> hotel) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text(hotel['name']!),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text("Location: ${hotel['location']}", style: TextStyle(fontSize: 14)),
              SizedBox(height: 5),
              Text("Features: ${hotel['features']}", style: TextStyle(fontSize: 14)),
              SizedBox(height: 5),
              Text("Price: ${hotel['price']}", style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold)),
              SizedBox(height: 5),
              Text("Reviews: ${hotel['reviews']}", style: TextStyle(fontSize: 14, color: Colors.green)),
              SizedBox(height: 10),
              Text("Special Offer: ${hotel['coupon']}", style: TextStyle(fontSize: 14, color: Colors.redAccent)),
              SizedBox(height: 15),
              Center(
                child: ElevatedButton(
                  onPressed: () => Navigator.pop(context),
                  child: Text("Close"),
                ),
              )
            ],
          ),
        );
      },
    );
  }
}