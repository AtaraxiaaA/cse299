import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class TravelGuidesScreen extends StatelessWidget {
  // Map of city names to their image URLs
  final Map<String, String> cityImages = {
    'Dhaka': 'https://upload.wikimedia.org/wikipedia/commons/5/5f/Bangladesh_Bank_%2833398162476%29.jpg',
    'Chittagong': 'https://upload.wikimedia.org/wikipedia/commons/3/3a/Bayazid_Bostami_Road%2C_Chittagong.jpg',
    'Sylhet': 'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcTtdUhaC5rpDkzKbopf5UF90ccKowzRiYxE8A&s',
    'Cox\'s Bazar': 'https://tbbd-flight.s3.ap-southeast-1.amazonaws.com/blogiJR0K1sWVNFzinGC_l4r3IdsVLyxZfkr.jpg',
    'Sreemangal': 'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcTuWaJ4yXGGygH2eNQFX7QJdpHgeUwZDaxNbQ&s',
    'Bandarban': 'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcQYjzWANK-S8gXOPZ79ThwNutu2oar4CzrauQ&s',
    'London': 'https://upload.wikimedia.org/wikipedia/commons/thumb/6/67/London_Skyline_%28125508655%29.jpeg/960px-London_Skyline_%28125508655%29.jpeg',
    'Paris': 'https://img.static-af.com/transform/45cb9a13-b167-4842-8ea8-05d0cc7a4d04/',
    'New York': 'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcRMLYh7jRBjiM2rx4frVlb3-1lu5BIzRx8wCA&s',
    'Tokyo': 'https://chopsticksontheloose.com/wp-content/uploads/2023/08/ce0d98f97cb947559ba1af37f059ee86-jpg.webp',
    'Kyoto': 'https://upload.wikimedia.org/wikipedia/commons/thumb/e/e3/Kyoto_montage.jpg/1024px-Kyoto_montage.jpg',
    'Edinburgh': 'https://upload.wikimedia.org/wikipedia/commons/thumb/1/1a/Skyline_of_Edinburgh.jpg/1200px-Skyline_of_Edinburgh.jpg',
    'Singapore': 'https://upload.wikimedia.org/wikipedia/commons/thumb/4/41/Singapore_City_Skyline.jpg/1024px-Singapore_City_Skyline.jpg',
    'Dubai': 'https://upload.wikimedia.org/wikipedia/commons/thumb/8/86/DubaiCollage.jpg/1200px-DubaiCollage.jpg',
    'Sydney': 'https://upload.wikimedia.org/wikipedia/commons/thumb/5/53/Sydney_Opera_House_and_Harbour_Bridge_Dusk_%282%29_2019-06-21.jpg/1024px-Sydney_Opera_House_and_Harbour_Bridge_Dusk_%282%29_2019-06-21.jpg',
    'Bangkok': 'https://upload.wikimedia.org/wikipedia/commons/thumb/a/af/Bangkok_Montage_2021.jpg/1024px-Bangkok_Montage_2021.jpg',
  };

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFF007E95), // Match the dashboard's gradient background
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 20, vertical: 20),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    "Travel Guides",
                    style: GoogleFonts.poppins(
                      color: Colors.white,
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  IconButton(
                    icon: Icon(Icons.arrow_back, color: Colors.white, size: 28),
                    onPressed: () {
                      Navigator.of(context).pop(); // Go back to the previous screen
                    },
                  ),
                ],
              ),
            ),

            // Domestic and Overseas Options
            Expanded(
              child: Container(
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(30),
                    topRight: Radius.circular(30),
                  ),
                ),
                padding: EdgeInsets.all(20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "Domestic",
                      style: GoogleFonts.poppins(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    SizedBox(height: 10),
                    Expanded(
                      child: ListView(
                        children: [
                          buildCityCard("Dhaka", context),
                          buildCityCard("Chittagong", context),
                          buildCityCard("Sylhet", context),
                          buildCityCard("Cox's Bazar", context),
                          buildCityCard("Sreemangal", context),
                          buildCityCard("Bandarban", context),
                          buildCityCard("Rangamati", context),
                          buildCityCard("Khulna", context),
                          buildCityCard("Rajshahi", context),
                          buildCityCard("Barisal", context),
                          buildCityCard("Pabna", context),
                          buildCityCard("Comilla", context),
                          buildCityCard("Mymensingh", context),
                          buildCityCard("Dinajpur", context),
                          buildCityCard("Bogra", context),
                        ],
                      ),
                    ),
                    SizedBox(height: 20),
                    Text(
                      "Overseas",
                      style: GoogleFonts.poppins(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    SizedBox(height: 10),
                    Expanded(
                      child: ListView(
                        children: [
                          buildCityCard("London", context),
                          buildCityCard("Paris", context),
                          buildCityCard("New York", context),
                          buildCityCard("Tokyo", context),
                          buildCityCard("Kyoto", context),
                          buildCityCard("Edinburgh", context),
                          buildCityCard("Singapore", context),
                          buildCityCard("Dubai", context),
                          buildCityCard("Sydney", context),
                          buildCityCard("Bangkok", context),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // City Card Widget with landscape-oriented image
  Widget buildCityCard(String city, BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => CityGuideScreen(city: city),
          ),
        );
      },
      child: Container(
        height: 120, // Fixed height for landscape cards
        margin: EdgeInsets.symmetric(vertical: 8),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(12),
          boxShadow: [
            BoxShadow(
              color: Colors.black26,
              blurRadius: 6,
              offset: Offset(0, 2),
            ),
          ],
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(12),
          child: Stack(
            fit: StackFit.expand,
            children: [
              // Background Image
              Image.network(
                cityImages.containsKey(city)
                    ? cityImages[city]!
                    : 'https://via.placeholder.com/400x200?text=$city',
                fit: BoxFit.cover,
                loadingBuilder: (BuildContext context, Widget child, ImageChunkEvent? loadingProgress) {
                  if (loadingProgress == null) return child;
                  return Center(
                    child: CircularProgressIndicator(
                      value: loadingProgress.expectedTotalBytes != null
                          ? loadingProgress.cumulativeBytesLoaded / loadingProgress.expectedTotalBytes!
                          : null,
                    ),
                  );
                },
                errorBuilder: (context, error, stackTrace) => Container(
                  color: Color(0xFF003653),
                  child: Center(
                    child: Icon(
                      Icons.image_not_supported,
                      color: Colors.white,
                      size: 40,
                    ),
                  ),
                ),
              ),
              // Gradient Overlay for better text visibility
              Container(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.bottomCenter,
                    end: Alignment.topCenter,
                    colors: [
                      Colors.black.withOpacity(0.7),
                      Colors.transparent,
                    ],
                  ),
                ),
              ),
              // City Name
              Align(
                alignment: Alignment.bottomLeft,
                child: Padding(
                  padding: EdgeInsets.all(16),
                  child: Text(
                    city,
                    style: GoogleFonts.poppins(
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class CityGuideScreen extends StatelessWidget {
  final String city;

  CityGuideScreen({required this.city});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFF007E95), // Match the dashboard's gradient background
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 20, vertical: 20),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    city,
                    style: GoogleFonts.poppins(
                      color: Colors.white,
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  IconButton(
                    icon: Icon(Icons.arrow_back, color: Colors.white, size: 28),
                    onPressed: () {
                      Navigator.of(context).pop(); // Go back to the travel guides list
                    },
                  ),
                ],
              ),
            ),

            // City Guide Content
            Expanded(
              child: Container(
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(30),
                    topRight: Radius.circular(30),
                  ),
                ),
                padding: EdgeInsets.all(20),
                child: SingleChildScrollView(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      buildGuideSection("Brief Guide", getBriefGuide(city), context),
                      buildGuideSection("Must-Try Local Experiences", getLocalExperiences(city), context),
                      buildGuideSection("Travel Tips", getTravelTips(city), context),
                      buildGuideSection("Must-See Attractions", getAttractions(city), context),
                      buildGuideSection("Nightlife Highlights", getNightlife(city), context),
                      buildGuideSection("Where to Stay", getWhereToStay(city), context),
                      buildGuideSection("Food Guide", getFoodGuide(city), context),
                      buildGuideSection("Useful Guide", getUsefulGuide(city), context),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // Guide Section Widget
  Widget buildGuideSection(String title, String content, BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: GoogleFonts.poppins(
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
        ),
        SizedBox(height: 10),
        if (title == "Must-See Attractions")
          Column(
            children: getAttractionList(city).map((attraction) {
              return GestureDetector(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => AttractionDetailScreen(
                        attractionName: attraction['name']!,
                        city: city,
                        imageUrl: attraction['image']!,
                        description: attraction['description']!,
                        rating: attraction['rating']!,
                        reviews: attraction['reviews']!,
                      ),
                    ),
                  );
                },
                child: Card(
                  margin: EdgeInsets.symmetric(vertical: 5),
                  child: Padding(
                    padding: EdgeInsets.all(15),
                    child: Row(
                      children: [
                        ClipRRect(
                          borderRadius: BorderRadius.circular(8),
                          child: Image.network(
                            attraction['image']!,
                            width: 80,
                            height: 80,
                            fit: BoxFit.cover,
                            errorBuilder: (context, error, stackTrace) => Container(
                              width: 80,
                              height: 80,
                              color: Colors.grey[300],
                              child: Icon(Icons.image_not_supported),
                            ),
                          ),
                        ),
                        SizedBox(width: 15),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                attraction['name']!,
                                style: GoogleFonts.poppins(
                                  fontSize: 16,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                              SizedBox(height: 5),
                              Row(
                                children: [
                                  Icon(Icons.star, color: Colors.amber, size: 16),
                                  SizedBox(width: 4),
                                  Text(
                                    attraction['rating']!,
                                    style: GoogleFonts.poppins(fontSize: 14),
                                  ),
                                  SizedBox(width: 8),
                                  Text(
                                    '(${attraction['reviews']!})',
                                    style: GoogleFonts.poppins(fontSize: 14, color: Colors.grey),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                        Icon(Icons.chevron_right, color: Colors.grey),
                      ],
                    ),
                  ),
                ),
              );
            }).toList(),
          )
        else
          Text(
            content,
            style: GoogleFonts.poppins(
              fontSize: 14,
            ),
          ),
        SizedBox(height: 20),
      ],
    );
  }

  // Dummy Data Functions (Replace with actual data)
  String getBriefGuide(String city) {
    return "This is a brief guide for $city. Dhaka, the capital of Bangladesh, is a vibrant metropolis rich in history and culture. Once the center of Mughal Bengal, the city blends ancient architecture with modern urban life. From historical forts to bustling markets, Dhaka offers an unforgettable experience.";
  }

  String getLocalExperiences(String city) {
    return "Here are some must-try local experiences in $city:\n"
        "- Rickshaw Ride Through Old Dhaka: Explore the winding alleys in a colorful rickshaw.\n"
        "- Boat Ride on the Buriganga River: Enjoy views of river life and Sadarghat.\n"
        "- Street Food Tasting: Try fuchka, jhalmuri, and kebabs from street vendors.\n"
        "- Traditional Bengali Music or Dance Show: Experience local culture through performing arts.";
  }


  String getTravelTips(String city) {
    return "Travel tips for $city:\n"
        "- Best Time to Visit: October to March.\n"
        "- Dress Code: Modest clothing is recommended.\n"
        "- Getting Around: Use rickshaws for short distances, Pathao or Uber for longer rides.\n"
        "- Language: Bengali is widely spoken; English is common in tourist areas.";
  }

  String getAttractions(String city) {
    return "Must-see attractions in $city:\n"
        "- Lalbagh Fort: A 17th-century Mughal fort with gardens. ⭐ 4.5 (1,234 reviews)\n"
        "- Ahsan Manzil: The Pink Palace turned museum. ⭐ 4.3 (987 reviews)\n"
        "- Bangladesh National Museum: The country’s largest museum. ⭐ 4.2 (876 reviews)";
  }

  List<Map<String, String>> getAttractionList(String city) {
    // Example attractions for each city
    if (city == "Dhaka") {
      return [
        {
          'name': 'Lalbagh Fort',
          'image': 'https://lh3.googleusercontent.com/gps-cs-s/AB5caB-wBUM3MICnuDI0OTNBBoOE3U8iBszTuoNgjuipBabFSt-eSQ5EFjoV0fMQMdmNNflwUfzsWbmtawi02zUYns2yQ2A6x-1Zcrg7yVQRk1q2bQH7Q59Nb1NgAjddHJ3vbvfuldNBWA=s294-w294-h220-k-no',
          'description': 'Lalbagh Fort is an incomplete 17th-century Mughal fort complex in Dhaka. The construction was started in 1678 AD by Mughal Subahdar Muhammad Azam Shah.',
          'rating': '4.5',
          'reviews': '1,234 reviews',
        },
        {
          'name': 'Ahsan Manjil',
          'image': 'https://lh3.googleusercontent.com/gps-cs-s/AB5caB93FA_WdILzBHDzc0TwwJ9v_e0sEOJE5cvyT21BdhhwE8NQskeqKIA0ULGtp7PW-TGz--e1nAH3KvHR2rYrnZXDjkjqiYB5widB6rU0kk_Q8tZ8F4ahNh7WGN3dDXMbbreCdw2CMw=s294-w294-h220-k-no',
          'description': 'Ahsan Manzil was the official residential palace and seat of the Nawab of Dhaka. The building is now a museum.',
          'rating': '4.3',
          'reviews': '987 reviews',
        },
        {
          'name': 'Bangladesh National Museum',
          'image': 'https://lh3.googleusercontent.com/gps-cs-s/AB5caB8cvzE0FXIyCLk_CTtlgu7xTRPhXUINyMs5CPqs53bQjRzEPumpOk3Vd6xIUZeEVV4cSexhwG7sR54ibaEbrYYUKofKMQreJg-DnGy1bjbLHt_psetmxpp5uLcbTAbAcacIzuY=s294-w294-h220-k-no',
          'description': 'The Bangladesh National Museum is the national museum of Bangladesh. It preserves and displays history and heritage of Bangladesh.',
          'rating': '4.2',
          'reviews': '876 reviews',
        },
      ];
    } else if (city == "Chittagong") {
      return [
        {
          'name': 'Patenga Sea Beach',
          'image': 'https://lh3.googleusercontent.com/gps-cs-s/AB5caB9RQ-sO5ErGZneeVEVtYF_emW_N1XWak03eKcsdKa92DoLln7I0rVJNg2_EhsSIM43_y2xIw5K695mYXODpxFOtK0PG8rZvQXs4Zk9PsNPKN46Lx-X2krIsKQ9WyfO4NTa4URaxVw=s294-w294-h220-k-no',
          'description': 'Patenga is a popular sea beach in Chittagong, located near the mouth of the Karnaphuli River.',
          'rating': '4.4',
          'reviews': '1,123 reviews',
        },
        {
          'name': 'Khoiyachara Waterfalls',
          'image': 'https://lh3.googleusercontent.com/gps-cs-s/AB5caB8KtkKMGY5CuYKqm0oORCVJQ3TVB9Pyv4XqVnqPLBhdSN22hahuXOSxw9ttUm1Z5_kFs3otEZPvSOhGD4KsbxFn8TQszbH8a2-6bI5LilX16_X-L0ZLwQQR6CZgxFff38rD6FqlKw=s294-w294-h220-k-no',
          'description': 'Khoiyachara is a beautiful waterfall in Chittagong Hill Tracts, surrounded by lush green hills.',
          'rating': '4.6',
          'reviews': '765 reviews',
        },
        {
          'name': 'Guliakhali Sea Beach',
          'image': 'https://lh3.googleusercontent.com/gps-cs-s/AB5caB9VaeUFsL475B2wMlwg-D0MX9UJkB4QTaw32rOEImmGnezpr1XOmhRhEfA6DEaknR1egbe8VhLArJ8X5w_ECZ1R-W5tM5WgRd62wZOKUMNYMWE-0yTcLENHE3AHfB9P2Ib7bCYQ=s294-w294-h220-k-no',
          'description': 'Guliakhali is a serene sea beach near Chittagong, less crowded than Patenga and perfect for relaxation.',
          'rating': '4.3',
          'reviews': '543 reviews',
        },
      ];
    } else if (city == "London") {
      return [
        {
          'name': 'Big Ben',
          'image': 'https://lh3.googleusercontent.com/gps-cs-s/AB5caB9TpwDtDjL-viPt8JMz7cLzsxL3Mw7gW80owscIFPZEyanB4X6e0UNNZq9se98ajK12gd2fvxJ7CkF2objAmvJgwWjdGMSH7SrUeMxfI_uQhoZnVUc7WG2hQVMK15vMHpExAldS=s1360-w1360-h1020',
          'description': 'Big Ben is the nickname for the Great Bell of the striking clock at the north end of the Palace of Westminster in London.',
          'rating': '4.8',
          'reviews': '45,678 reviews',
        },
        {
          'name': 'London Eye',
          'image': 'https://lh3.googleusercontent.com/gps-cs-s/AB5caB-5yuuKtn1vFREIijOUrM_XeO03UHdb8u6WTzLHsPfc4BkytXB2s2yqwWSIog8j5NQOnz7xPfzpNrK2m4z5qcGuURcWy8X2uJR5qpbZ-pDB4t8cJk39msKka6TrMQdy0Skana8L0Q=s1360-w1360-h1020',
          'description': 'The London Eye is a cantilevered observation wheel on the South Bank of the River Thames in London.',
          'rating': '4.7',
          'reviews': '38,921 reviews',
        },
        {
          'name': 'Tower of London',
          'image': 'https://lh3.googleusercontent.com/gps-cs-s/AB5caB9lsUqoylrLa7VyMOFKh0J8N4K1qQtEjq-pbFChPkcLUjq6arBLBUjC2H9SGTSPyyDXivxBqYs9xg0lCfGp3rEfWS6R24fAGjJHYdmGOt4BKe4zA1WnO19uOAcsK3zHwCqhfM-E=s1360-w1360-h1020',
          'description': 'The Tower of London, officially Her Majesty\'s Royal Palace and Fortress of the Tower of London, is a historic castle on the north bank of the River Thames.',
          'rating': '4.6',
          'reviews': '32,456 reviews',
        },
        {
          'name': 'Buckingham Palace',
          'image': 'https://lh3.googleusercontent.com/gps-cs-s/AB5caB8dsyCuxyIZDw-8ls7kPWRaYL65-jCeZPpXRrm7LiuwIclkeXh-UdE8JHisrQ7YBm-7piKWXkCN18N9SBtEQryI9m3DDU1aKK89ympq2zRkfmUSCe-_APUqmaXEpB5ilquwzCuzoA=s1360-w1360-h1020',
          'description': 'Buckingham Palace is the London residence and administrative headquarters of the monarch of the United Kingdom.',
          'rating': '4.5',
          'reviews': '28,765 reviews',
        },
      ];
    } else {
      return [
        {
          'name': 'Attraction 1',
          'image': 'https://via.placeholder.com/400x200?text=Attraction+1',
          'description': 'Description for Attraction 1 in $city',
          'rating': '4.0',
          'reviews': '100 reviews',
        },
        {
          'name': 'Attraction 2',
          'image': 'https://via.placeholder.com/400x200?text=Attraction+2',
          'description': 'Description for Attraction 2 in $city',
          'rating': '3.8',
          'reviews': '85 reviews',
        },
        {
          'name': 'Attraction 3',
          'image': 'https://via.placeholder.com/400x200?text=Attraction+3',
          'description': 'Description for Attraction 3 in $city',
          'rating': '4.2',
          'reviews': '120 reviews',
        },
      ];
    }
  }

  String getNightlife(String city) {
    return "Nightlife highlights in $city:\n"
        "Discover the best bars, clubs, and entertainment spots. Popular areas include Gulshan and Banani, known for their upscale lounges, rooftop cafes, and live music. Some top venues include Club 13, Level 5 Lounge, and Dhaka Regency Rooftop.";
  }


  String getWhereToStay(String city) {
    return "Where to stay in $city:\n"
        "- Gulshan & Banani: Ideal for luxury hotels, international restaurants, and safe neighborhoods.\n"
        "- Dhanmondi: Perfect for budget-friendly stays, close to cultural spots and eateries.\n"
        "- Motijheel: Good for short business visits and easy access to the commercial center.";
  }


  String getFoodGuide(String city) {
    return "Food guide for $city:\n"
        "- Must-Try Dishes: Kacchi Biryani, Hilsa Fish Curry, Bhuna Khichuri, and Paratha with Beef Curry.\n"
        "- Popular Restaurants: Star Kabab, Fakruddin, Panshi, and Dhaba.\n"
        "- Desserts: Don't miss Mishti Doi, Rasgulla, and Chomchom.";
  }

  String getUsefulGuide(String city) {
    return "Useful guide for $city:\n"
        "- Airport: Hazrat Shahjalal International Airport (DAC), the main entry point.\n"
        "- Local Transport: Use rickshaws for short distances, CNG (auto-rickshaws), and ride-sharing apps like Pathao and Uber.\n"
        "- SIM Cards: Available at the airport and local shops; Grameenphone and Robi are reliable options.\n"
        "- Currency: Bangladeshi Taka (BDT); credit/debit cards are accepted in most hotels and major stores.\n"
        "- Public Transport: Buses and trains are available, but not always foreigner-friendly—ride-sharing apps are more convenient.";
  }

}

class AttractionDetailScreen extends StatelessWidget {
  final String attractionName;
  final String city;
  final String imageUrl;
  final String description;
  final String rating;
  final String reviews;

  AttractionDetailScreen({
    required this.attractionName,
    required this.city,
    required this.imageUrl,
    required this.description,
    required this.rating,
    required this.reviews,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFF007E95),
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 20, vertical: 20),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    attractionName,
                    style: GoogleFonts.poppins(
                      color: Colors.white,
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  IconButton(
                    icon: Icon(Icons.arrow_back, color: Colors.white, size: 28),
                    onPressed: () {
                      Navigator.of(context).pop();
                    },
                  ),
                ],
              ),
            ),

            // Attraction Details
            Expanded(
              child: Container(
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(30),
                    topRight: Radius.circular(30),
                  ),
                ),
                child: SingleChildScrollView(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Hero Image
                      Container(
                        height: 250,
                        width: double.infinity,
                        child: ClipRRect(
                          borderRadius: BorderRadius.only(
                            topLeft: Radius.circular(30),
                            topRight: Radius.circular(30),
                          ),
                          child: Image.network(
                            imageUrl,
                            fit: BoxFit.cover,
                            errorBuilder: (context, error, stackTrace) => Container(
                              color: Colors.grey[300],
                              child: Center(
                                child: Icon(Icons.image_not_supported, size: 50),
                              ),
                            ),
                          ),
                        ),
                      ),
                      Padding(
                        padding: EdgeInsets.all(20),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            // Title and Rating
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  attractionName,
                                  style: GoogleFonts.poppins(
                                    fontSize: 24,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                Container(
                                  padding: EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                                  decoration: BoxDecoration(
                                    color: Colors.amber,
                                    borderRadius: BorderRadius.circular(20),
                                  ),
                                  child: Row(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      Icon(Icons.star, color: Colors.white, size: 18),
                                      SizedBox(width: 4),
                                      Text(
                                        rating,
                                        style: GoogleFonts.poppins(
                                          color: Colors.white,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                            SizedBox(height: 5),
                            Text(
                              reviews,
                              style: GoogleFonts.poppins(
                                color: Colors.grey,
                                fontSize: 14,
                              ),
                            ),
                            SizedBox(height: 20),

                            // Description
                            Text(
                              "Description",
                              style: GoogleFonts.poppins(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            SizedBox(height: 10),
                            Text(
                              description,
                              style: GoogleFonts.poppins(
                                fontSize: 14,
                              ),
                            ),
                            SizedBox(height: 20),

                            // Location
                            Text(
                              "Location",
                              style: GoogleFonts.poppins(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            SizedBox(height: 10),
                            Text(
                              "$attractionName is located in $city. The exact address would be displayed here with a map view in a real application.",
                              style: GoogleFonts.poppins(
                                fontSize: 14,
                              ),
                            ),
                            SizedBox(height: 20),

                            // Reviews Section
                            Text(
                              "Reviews",
                              style: GoogleFonts.poppins(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            SizedBox(height: 10),
                            buildReviewCard("John Doe", "5", "Amazing place! Must visit when in $city.", "2 days ago"),
                            buildReviewCard("Sarah Smith", "4", "Beautiful location but can get crowded.", "1 week ago"),
                            buildReviewCard("Mike Johnson", "5", "One of the best attractions in $city. Highly recommended!", "2 weeks ago"),
                            SizedBox(height: 20),

                            // Booking Section
                            Text(
                              "Book Tickets",
                              style: GoogleFonts.poppins(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            SizedBox(height: 10),
                            Card(
                              child: Padding(
                                padding: EdgeInsets.all(15),
                                child: Column(
                                  children: [
                                    Row(
                                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                      children: [
                                        Text(
                                          "Standard Ticket",
                                          style: GoogleFonts.poppins(
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                        Text(
                                          "\$20.00",
                                          style: GoogleFonts.poppins(
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                      ],
                                    ),
                                    SizedBox(height: 10),
                                    Row(
                                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                      children: [
                                        Text(
                                          "VIP Ticket",
                                          style: GoogleFonts.poppins(
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                        Text(
                                          "\$35.00",
                                          style: GoogleFonts.poppins(
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                      ],
                                    ),
                                    SizedBox(height: 15),
                                    SizedBox(
                                      width: double.infinity,
                                      child: ElevatedButton(
                                        style: ElevatedButton.styleFrom(
                                          backgroundColor: Color(0xFF007E95),
                                          shape: RoundedRectangleBorder(
                                            borderRadius: BorderRadius.circular(10),
                                          ),
                                          padding: EdgeInsets.symmetric(vertical: 15),
                                        ),
                                        onPressed: () {},
                                        child: Text(
                                          "Book Now",
                                          style: GoogleFonts.poppins(
                                            color: Colors.white,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                            SizedBox(height: 20),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget buildReviewCard(String name, String rating, String comment, String time) {
    return Card(
      margin: EdgeInsets.symmetric(vertical: 8),
      child: Padding(
        padding: EdgeInsets.all(15),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  name,
                  style: GoogleFonts.poppins(
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Row(
                  children: [
                    Icon(Icons.star, color: Colors.amber, size: 16),
                    SizedBox(width: 4),
                    Text(rating),
                  ],
                ),
              ],
            ),
            SizedBox(height: 8),
            Text(comment),
            SizedBox(height: 8),
            Text(
              time,
              style: GoogleFonts.poppins(
                color: Colors.grey,
                fontSize: 12,
              ),
            ),
          ],
        ),
      ),
    );
  }
}