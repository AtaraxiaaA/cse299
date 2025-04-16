import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher_string.dart';

class HotelDetailsPage extends StatefulWidget {
  final Map<String, dynamic> hotel;

  const HotelDetailsPage({super.key, required this.hotel});

  @override
  State<HotelDetailsPage> createState() => _HotelDetailsPageState();
}

class _HotelDetailsPageState extends State<HotelDetailsPage> {
  int _selectedIndex = 0;

  void _onNavBarTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    final hotel = widget.hotel;

    final List<String> galleryImages = hotel['All Images'] is List
        ? List<String>.from(hotel['All Images'])
        : hotel['All Images'] != null
        ? [hotel['All Images'].toString()]
        : [];

    final List<String> facilities =
        (hotel['Facilities'] as List<dynamic>?)?.map((e) => e.toString()).toList() ?? [];
    final List<dynamic> flats = hotel['Flats'] ?? [];

    return Scaffold(
      backgroundColor: Colors.grey.shade50,
      body: SafeArea(
        child: LayoutBuilder(
          builder: (context, constraints) {
            bool isWide = constraints.maxWidth > 800;
            return SingleChildScrollView(
              padding: const EdgeInsets.all(24),
              child: Center(
                child: ConstrainedBox(
                  constraints: const BoxConstraints(maxWidth: 1000),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      ClipRRect(
                        borderRadius: BorderRadius.circular(18),
                        child: SizedBox(
                          width: double.infinity,
                          height: 320,
                          child: Image.network(
                            hotel['image'] ?? '',
                            fit: BoxFit.cover,
                            errorBuilder: (_, __, ___) => Container(
                              color: Colors.grey[300],
                              child: const Center(child: Text("Image not available")),
                            ),
                          ),
                        ),
                      ),

                      const SizedBox(height: 24),
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(hotel['title'] ?? 'Hotel Name',
                                    style: Theme.of(context).textTheme.headlineSmall?.copyWith(fontWeight: FontWeight.bold)),
                                const SizedBox(height: 6),
                                Text("${hotel['city']}, ${hotel['country']}", style: const TextStyle(color: Colors.grey)),
                              ],
                            ),
                          ),
                          if (hotel['isPopular'] == true)
                            Container(
                              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                              decoration: BoxDecoration(
                                color: Colors.orange.shade700,
                                borderRadius: BorderRadius.circular(20),
                              ),
                              child: const Text("★ Popular", style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
                            ),
                        ],
                      ),
                      const SizedBox(height: 12),
                      Row(
                        children: [
                          Icon(Icons.star, color: Colors.amber.shade600),
                          const SizedBox(width: 4),
                          Text("${hotel['rating'] ?? ''}"),
                          const SizedBox(width: 10),
                          Text(hotel['reviews'] ?? "")
                        ],
                      ),
                      const SizedBox(height: 20),
                      if (hotel['Address'] != null)
                        Row(children: [
                          const Icon(Icons.location_on, color: Colors.red),
                          const SizedBox(width: 6),
                          Expanded(child: Text(hotel['Address'], style: const TextStyle(fontSize: 14)))
                        ]),
                      const SizedBox(height: 20),
                      Wrap(
                        spacing: 20,
                        runSpacing: 20,
                        children: [
                          infoBox(Icons.group, "Guests", "${hotel['guest'] ?? '-'}"),
                          infoBox(Icons.meeting_room, "Rooms", "${hotel['room'] ?? '-'}"),
                          infoBox(Icons.bathtub, "Bath", "${hotel['bath'] ?? '-'}"),
                        ],
                      ),
                      const SizedBox(height: 20),
                      if (hotel['oldPrice'] != null || hotel['newPrice'] != null)
                        Row(
                          children: [
                            if (hotel['oldPrice'] != null)
                              Text("\$${hotel['oldPrice']}",
                                  style: const TextStyle(decoration: TextDecoration.lineThrough, fontSize: 16, color: Colors.grey)),
                            const SizedBox(width: 10),
                            if (hotel['newPrice'] != null)
                              Text("\$${hotel['newPrice']}",
                                  style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold, color: Colors.black)),
                          ],
                        ),
                      if (hotel['Booking Start'] != null && hotel['Booking End'] != null) ...[
                        const SizedBox(height: 20),
                        Container(
                          padding: const EdgeInsets.all(14),
                          decoration: BoxDecoration(
                            gradient: LinearGradient(colors: [Colors.indigo.shade50, Colors.blue.shade50]),
                            borderRadius: BorderRadius.circular(16),
                            border: Border.all(color: Colors.indigo.shade100),
                          ),
                          child: Row(
                            children: [
                              const Icon(Icons.calendar_today_rounded, color: Colors.indigo),
                              const SizedBox(width: 8),
                              RichText(
                                text: TextSpan(
                                  style: const TextStyle(fontSize: 14, color: Colors.black87),
                                  children: [
                                    const TextSpan(text: "Booking Period: ", style: TextStyle(fontWeight: FontWeight.bold)),
                                    TextSpan(text: "${hotel['Booking Start']} → ${hotel['Booking End']}")
                                  ],
                                ),
                              ),
                            ],
                          ),
                        )
                      ],
                      if (facilities.isNotEmpty) ...[
                        const SizedBox(height: 24),
                        const Text("✅ Facilities", style: TextStyle(fontWeight: FontWeight.bold)),
                        const SizedBox(height: 10),
                        Wrap(spacing: 10, runSpacing: 10, children: facilities.map((f) => facilityChip(f)).toList()),
                      ],
                      if (flats.isNotEmpty) ...[
                        const SizedBox(height: 24),
                        const Text("🛏️ Available Rooms", style: TextStyle(fontWeight: FontWeight.bold)),
                        const SizedBox(height: 10),
                        Column(
                          children: flats.map((flat) {
                            final f = flat as Map<String, dynamic>;
                            return Card(
                              margin: const EdgeInsets.only(bottom: 12),
                              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                              elevation: 2,
                              child: ListTile(
                                leading: ClipRRect(
                                  borderRadius: BorderRadius.circular(8),
                                  child: Image.network(
                                    f['Image'] ?? '',
                                    width: 60,
                                    height: 60,
                                    fit: BoxFit.cover,
                                    errorBuilder: (_, __, ___) => const Icon(Icons.image_not_supported),
                                  ),
                                ),
                                title: Text(f['Flat Title'] ?? '', style: const TextStyle(fontWeight: FontWeight.bold)),
                                subtitle: Text("${f['Flat Name'] ?? ''} • ${f['Flat'][0]} Guests • ${f['Flat'][1]} Rooms • ${f['Flat'][2]} Baths"),
                                trailing: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    if (f['Old Price'] != null)
                                      Text("\$${f['Old Price']}", style: const TextStyle(decoration: TextDecoration.lineThrough, fontSize: 12, color: Colors.grey)),
                                    if (f['New Price'] != null)
                                      Text("\$${f['New Price']}", style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14)),
                                  ],
                                ),
                              ),
                            );
                          }).toList(),
                        ),
                      ],
                      if (galleryImages.isNotEmpty) ...[
                        const SizedBox(height: 24),
                        const Text("📸 Gallery", style: TextStyle(fontWeight: FontWeight.bold)),
                        const SizedBox(height: 10),
                        SizedBox(
                          height: 200,
                          child: ListView.builder(
                            scrollDirection: Axis.horizontal,
                            itemCount: galleryImages.length,
                            itemBuilder: (context, index) => Container(
                              margin: const EdgeInsets.only(right: 12),
                              child: ClipRRect(
                                borderRadius: BorderRadius.circular(16),
                                child: Image.network(
                                  galleryImages[index],
                                  width: 240,
                                  fit: BoxFit.cover,
                                  errorBuilder: (_, __, ___) => Container(
                                    width: 240,
                                    color: Colors.grey[300],
                                    child: const Center(child: Icon(Icons.broken_image)),
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ),
                      ],
                      const SizedBox(height: 40),
                      Center(
                        child: ElevatedButton.icon(
                          onPressed: () => ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("Booking coming soon..."))),
                          icon: const Icon(Icons.hotel),
                          label: const Text("Book Now"),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.indigo,
                            foregroundColor: Colors.white,
                            padding: const EdgeInsets.symmetric(horizontal: 28, vertical: 16),
                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                          ),
                        ),
                      ),
                      const SizedBox(height: 60),
                    ],
                  ),
                ),
              ),
            );
          },
        ),
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _selectedIndex,
        onTap: _onNavBarTapped,
        type: BottomNavigationBarType.fixed,
        selectedFontSize: 12,
        unselectedFontSize: 11,
        backgroundColor: Colors.white,
        selectedItemColor: Colors.deepPurple,
        unselectedItemColor: Colors.grey[600],
        showUnselectedLabels: true,
        elevation: 12,
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.home), label: "Home"),
          BottomNavigationBarItem(icon: Icon(Icons.favorite_border), label: "Favorites"),
          BottomNavigationBarItem(icon: Icon(Icons.book_outlined), label: "Bookings"),
          BottomNavigationBarItem(icon: Icon(Icons.person_outline), label: "Profile"),
        ],
      ),
    );
  }

  Widget infoBox(IconData icon, String label, String value) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [BoxShadow(color: Colors.black12, blurRadius: 4)],
      ),
      child: Column(
        children: [
          Icon(icon, size: 28, color: Colors.indigo),
          const SizedBox(height: 4),
          Text(label, style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w500)),
          Text(value, style: const TextStyle(fontSize: 12)),
        ],
      ),
    );
  }

  Widget facilityChip(String name) {
    IconData icon;
    switch (name.toLowerCase()) {
      case 'internet access':
        icon = Icons.wifi;
        break;
      case 'swimming pool':
        icon = Icons.pool;
        break;
      case 'car park':
        icon = Icons.local_parking;
        break;
      case 'spa':
        icon = Icons.spa;
        break;
      case 'fitness center':
        icon = Icons.fitness_center;
        break;
      case 'restaurant':
        icon = Icons.restaurant;
        break;
      default:
        icon = Icons.check;
    }
    return Chip(
      avatar: Icon(icon, size: 16, color: Colors.blueGrey),
      label: Text(name),
      backgroundColor: Colors.white,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
      elevation: 2,
    );
  }
}