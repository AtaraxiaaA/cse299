// HotelHomePage.dart

import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'hotel_details_page.dart';

class HotelHomePage extends StatefulWidget {
  @override
  _HotelHomePageState createState() => _HotelHomePageState();
}

class _HotelHomePageState extends State<HotelHomePage> {
  String selectedLocation = 'Bangladesh';
  Set<String> favoriteHotels = {};
  String? city;
  DateTime? checkInDate;
  DateTime? checkOutDate;
  int rooms = 1;
  int guests = 1;
  List<Map<String, dynamic>> allHotels = [];
  List<Map<String, dynamic>> filteredHotels = [];
  bool isLoading = false;
  int _selectedIndex = 0;

  final Map<String, String> countryFlags = {
    'Norway': '🇳🇴',
    'Sweden': '🇸🇪',
    'Bangladesh': '🇧🇩',
    'Nepal': '🇳🇵',
  };

  final List<Map<String, String>> majorCities = [
    {'city': 'Cox Bazar', 'country': 'Bangladesh'},
    {'city': 'Dhaka', 'country': 'Bangladesh'},
    {'city': 'Stockholm', 'country': 'Sweden'},
    {'city': 'Oslo', 'country': 'Norway'},
    {'city': 'Kathmandu', 'country': 'Nepal'},
    {'city': 'Pokhara', 'country': 'Nepal'},
  ];

  bool get _isSearchApplied =>
      city != null || checkInDate != null || checkOutDate != null || rooms != 1 || guests != 1;

  @override
  void initState() {
    super.initState();
    fetchHotelsFromFirebase();
  }

  Future<void> fetchHotelsFromFirebase() async {
    setState(() => isLoading = true);
    try {
      final snapshot = await FirebaseFirestore.instance
          .collection('Hotels')
          .where('Country', isEqualTo: selectedLocation)
          .get();

      final hotels = snapshot.docs
          .map((doc) {
        final data = doc.data() as Map<String, dynamic>;

        // Extract flat info
        List<dynamic> flatDetails = data['Flat(Guest-Room-Bath)'] ?? [0, 0, 0];

        // Required fields for Home and Details
        data['title'] = data['Name']?.toString() ?? 'No name';
        data['city'] = data['City']?.toString() ?? '';
        data['country'] = data['Country']?.toString() ?? '';

        // Main image for card display
        data['image'] = (data['Image'] is List)
            ? (data['Image'] as List).isNotEmpty ? data['Image'][0].toString() : ''
            : data['Image']?.toString() ?? '';

// Gallery images
        data['All Images'] = data['All Images'] ?? [];
        data['rating'] = data['Rating'] ?? 0;
        data['reviews'] = "${data['Review']?.toString() ?? '0'} reviews";
        data['guest'] = flatDetails.isNotEmpty ? flatDetails[0] : 0;
        data['room'] = flatDetails.length > 1 ? flatDetails[1] : 0;
        data['bath'] = flatDetails.length > 2 ? flatDetails[2] : 0;

        // Booking period
        data['bookingDates'] = {
          'start': data['Booking Start']?.toString() ?? '',
          'end': data['Booking End']?.toString() ?? '2100-01-01',
        };

        // Pricing
        data['oldPrice'] = data['Old Price']?.toString() ?? '';
        data['newPrice'] = data['New Price']?.toString() ?? '';
        data['total'] = "Per night";

        // Additional full data
        data['details'] = data['Is Popular'] == true ? "Popular choice" : "Standard hotel";
        data['Facilities'] = data['Facilities'] ?? [];
        data['Flat Title'] = data['Flat Title'] ?? [];
        data['About'] = data['About']?.toString() ?? '';
        data['Address'] = data['Address']?.toString() ?? '';
        data['Image'] = data['Image'] ?? [];

        return data;
      })
          .where((hotel) => hotel['Is Popular'] == true)
          .toList();

      setState(() {
        allHotels = hotels;
        filteredHotels = List.from(hotels);
        isLoading = false;
      });
    } catch (e) {
      setState(() => isLoading = false);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Failed to load hotels. Check Firebase setup.")),
      );
    }
  }



  void filterHotels() {
    setState(() {
      filteredHotels = allHotels.where((hotel) {
        bool matchesCity = city == null || hotel['city'].toLowerCase() == city!.toLowerCase();
        bool matchesDates = true;
        if (checkInDate != null && checkOutDate != null) {
          DateTime bookingStart = DateTime.tryParse(hotel['bookingDates']['start']) ?? DateTime(2000);
          DateTime bookingEnd = DateTime.tryParse(hotel['bookingDates']['end']) ?? DateTime(2100);
          matchesDates = !checkInDate!.isBefore(bookingStart) && !checkOutDate!.isAfter(bookingEnd);
        }
        bool matchesRooms = hotel['room'] >= rooms;
        bool matchesGuests = hotel['guest'] >= guests;
        return matchesCity && matchesDates && matchesRooms && matchesGuests;
      }).toList();
    });
  }

  void showSearchCityDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => Dialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Text('Select a City', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
              const Divider(),
              Expanded(
                child: ListView.builder(
                  itemCount: majorCities.length,
                  itemBuilder: (context, index) {
                    return ListTile(
                      title: Text('${majorCities[index]['city']}, ${majorCities[index]['country']}'),
                      onTap: () {
                        setState(() {
                          city = majorCities[index]['city'];
                        });
                        Navigator.of(context).pop();
                      },
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _onNavBarTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.all(16),
          children: [
            buildSearchBar(),
            const SizedBox(height: 20),
            if (isLoading)
              const Center(child: CircularProgressIndicator())
            else ...[
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 8),
                child: Text(
                  _isSearchApplied ? 'Filtered Hotels' : 'Popular Hotels',
                  style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                ),
              ),
              if (filteredHotels.isEmpty)
                const Center(
                  child: Padding(
                    padding: EdgeInsets.only(top: 30),
                    child: Text(
                      '❗ No hotels found. Try different filters.',
                      style: TextStyle(fontSize: 16, color: Colors.grey),
                      textAlign: TextAlign.center,
                    ),
                  ),
                )
              else
                ...filteredHotels.map((hotel) => buildHotelCard(hotel)).toList(),
            ],
          ],
        ),
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _selectedIndex,
        onTap: _onNavBarTapped,
        type: BottomNavigationBarType.fixed,
        selectedFontSize: 12,
        unselectedFontSize: 11,
        backgroundColor: Colors.white,
        selectedItemColor: Colors.deepPurple, // Selected icon/text color
        unselectedItemColor: Colors.grey[600], // Unselected icon/text color
        showUnselectedLabels: true,
        elevation: 12,
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.home, color: Colors.teal), // 👈 Custom icon color
            activeIcon: Icon(Icons.home, color: Colors.deepPurple), // 👈 Color when selected
            label: "Home",
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.favorite_border, color: Colors.pink),
            activeIcon: Icon(Icons.favorite, color: Colors.red),
            label: "Favorites",
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.book_outlined, color: Colors.indigo),
            activeIcon: Icon(Icons.book, color: Colors.deepPurple),
            label: "Bookings",
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person_outline, color: Colors.orange),
            activeIcon: Icon(Icons.person, color: Colors.deepPurple),
            label: "Profile",
          ),
        ],
      ),

    );
  }



Widget buildSearchBar() {
    return LayoutBuilder(
      builder: (context, constraints) {
        bool isMobile = constraints.maxWidth < 600;

        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              height: 220,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(24),
                image: const DecorationImage(
                  image: AssetImage('Aimg/images/HotelHomePage-cover.jpg'),
                  fit: BoxFit.cover,
                ),
              ),
              child: Stack(
                children: [
                  Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(24),
                      gradient: const LinearGradient(
                        colors: [Colors.black54, Colors.transparent],
                        begin: Alignment.bottomCenter,
                        end: Alignment.topCenter,
                      ),
                    ),
                  ),
                  Positioned(
                    top: 16,
                    left: 16,
                    child: DropdownButton<String>(
                      value: selectedLocation,
                      dropdownColor: Colors.black87,
                      iconEnabledColor: Colors.white,
                      style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
                      underline: const SizedBox(),
                      onChanged: (value) {
                        setState(() {
                          selectedLocation = value!;
                          city = null;
                          checkInDate = null;
                          checkOutDate = null;
                          rooms = 1;
                          guests = 1;
                        });
                        fetchHotelsFromFirebase();
                      },
                      items: countryFlags.keys.map((location) {
                        return DropdownMenuItem(
                          value: location,
                          child: Text("${countryFlags[location]} $location"),
                        );
                      }).toList(),
                    ),
                  ),
                  Positioned(
                    bottom: 12,
                    left: 12,
                    right: 12,
                    child: buildFilterRow(isMobile),
                  ),
                ],
              ),
            ),
          ],
        );
      },
    );
  }

  Widget buildFilterRow(bool isMobile) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(30),
        border: Border.all(color: Colors.orange, width: 2),
      ),
      child: Row(
        children: [


          Expanded(
            child: DropdownButton<String>(
              value: city,
              isExpanded: true,
              hint: Text("Where", style: TextStyle(color: Colors.black54, fontSize: 14)),
              icon: Icon(Icons.keyboard_arrow_down),
              underline: SizedBox(),
              style: const TextStyle(fontSize: 12, color: Colors.black), // 👈 This makes selected text small
              onChanged: (String? newValue) {
                setState(() {
                  city = newValue;
                });
              },
              items: majorCities
                  .where((c) => c['country'] == selectedLocation)
                  .map<DropdownMenuItem<String>>((Map<String, String> cityData) {
                return DropdownMenuItem<String>(
                  value: cityData['city'],
                  child: Text(cityData['city'] ?? '', style: const TextStyle(color: Colors.black54,fontSize: 12)), // 👈 Small dropdown items
                );
              }).toList(),
              alignment: Alignment.centerLeft,
            ),
          ),


          buildDatePicker("Check-in", checkInDate, (picked) => checkInDate = picked),
          buildDatePicker("Check-out", checkOutDate, (picked) => checkOutDate = picked),
          buildRoomGuestPicker(isMobile),
          Container
            (
            padding: const EdgeInsets.symmetric(horizontal: 1),
            child: ElevatedButton(
              onPressed: filterHotels,
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.blue,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
              ),
              child: const Text("Search", style: TextStyle(fontSize: 12, color: Colors.black)),
            ),
          ),
        ],
      ),
    );
  }

  Widget buildRoomGuestPicker(bool isMobile) {
    return Expanded(
      child: GestureDetector(
        onTap: () {
          showDialog(
            context: context,
            builder: (context) {
              return AlertDialog(
                title: const Text('Select Rooms and Guests'),
                content: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    buildDropdownRow("Rooms: ", rooms, (val) => rooms = val),
                    buildDropdownRow("Guests: ", guests, (val) => guests = val),
                  ],
                ),
                actions: [
                  TextButton(onPressed: () => Navigator.of(context).pop(), child: const Text('Done')),
                ],
              );
            },
          );
        },
        child: Column(
          children: [
            if (!isMobile) const Icon(Icons.group, color: Colors.black54, size: 16),
            const SizedBox(height: 4),
            const Text("Guests  Rooms", style: TextStyle(color: Colors.black54, fontSize: 12)),
          ],
        ),
      ),
    );
  }

  Widget buildDatePicker(String label, DateTime? date, Function(DateTime) onPicked) {
    return Expanded(
      child: GestureDetector(
        onTap: () async {
          final picked = await showDatePicker(
            context: context,
            initialDate: date ?? DateTime.now(),
            firstDate: DateTime(2000),
            lastDate: DateTime(2101),
          );
          if (picked != null) setState(() => onPicked(picked));
        },
        child: Column(
          children: [
            const Icon(Icons.calendar_today, color: Colors.black54, size: 16),
            const SizedBox(height: 4),
            Text(
              date == null ? label : date.toString().split(' ')[0],
              style: const TextStyle(color: Colors.black54, fontSize: 12),
            ),
          ],
        ),
      ),
    );
  }

  Widget buildDropdownRow(String label, int value, Function(int) onChanged) {
    return Row(
      children: [
        Text(label),
        const SizedBox(width: 10),
        DropdownButton<int>(
          value: value,
          onChanged: (val) => setState(() => onChanged(val!)),
          items: List.generate(5, (index) => index + 1)
              .map((val) => DropdownMenuItem(value: val, child: Text('$val')))
              .toList(),
        ),
      ],
    );
  }

  Widget buildHotelCard(Map<String, dynamic> hotel) {
    bool isFavorite = favoriteHotels.contains(hotel['title']);

    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => HotelDetailsPage(hotel: hotel),
          ),
        );
      },
      child: Card(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        elevation: 5,
        margin: const EdgeInsets.only(bottom: 20),
        clipBehavior: Clip.antiAlias,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Stack(
              children: [
                Image.network(
                  hotel['image'],
                  height: 200,
                  width: double.infinity,
                  fit: BoxFit.cover,
                  errorBuilder: (context, error, stackTrace) => Container(
                    height: 200,
                    color: Colors.grey[300],
                    child: const Center(child: Text("Image not available")),
                  ),
                ),
                Positioned(
                  top: 10,
                  right: 10,
                  child: GestureDetector(
                    onTap: () {
                      setState(() {
                        isFavorite
                            ? favoriteHotels.remove(hotel['title'])
                            : favoriteHotels.add(hotel['title']);
                      });
                    },
                    child: CircleAvatar(
                      backgroundColor: Colors.white.withOpacity(0.8),
                      child: Icon(
                        isFavorite ? Icons.favorite : Icons.favorite_border,
                        color: isFavorite ? Colors.red : Colors.grey,
                      ),
                    ),
                  ),
                ),
              ],
            ),
            Padding(
              padding: const EdgeInsets.all(12),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    hotel['title'],
                    style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 6),
                  Row(
                    children: [
                      const Icon(Icons.star, color: Colors.amber, size: 16),
                      const SizedBox(width: 4),
                      Text(
                        "${hotel['rating']} (${hotel['reviews']})",
                        style: const TextStyle(fontSize: 13),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  Row(
                    children: [
                      const Icon(Icons.meeting_room, size: 16, color: Colors.grey),
                      const SizedBox(width: 4),
                      Text("${hotel['room']} rooms, ", style: const TextStyle(fontSize: 12)),
                      const Icon(Icons.group, size: 16, color: Colors.grey),
                      const SizedBox(width: 4),
                      Text("${hotel['guest']} guests, ", style: const TextStyle(fontSize: 12)),
                      const Icon(Icons.bathtub, size: 16, color: Colors.grey),
                      const SizedBox(width: 4),
                      Text("${hotel['bath']} bath", style: const TextStyle(fontSize: 12)),
                    ],
                  ),
                  const SizedBox(height: 6),
                  if (hotel['details'].toString().isNotEmpty)
                    Container(
                      margin: const EdgeInsets.only(top: 6),
                      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                      decoration: BoxDecoration(
                        color: Colors.orange.shade100,
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Text(
                        hotel['details'],
                        style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w500),
                      ),
                    ),
                  const SizedBox(height: 8),
                  Row(
                    children: [
                      Text(
                        "${hotel['oldPrice']}",
                        style: const TextStyle(
                          decoration: TextDecoration.lineThrough,
                          color: Colors.grey,
                          fontSize: 14,
                        ),
                      ),
                      const SizedBox(width: 6),
                      Text(
                        "${hotel['newPrice']}",
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                        ),
                      ),
                      const SizedBox(width: 6),
                      Text(
                        hotel['total'],
                        style: TextStyle(
                          color: Colors.grey.shade600,
                          fontSize: 13,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
