import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class BusSearchScreen extends StatefulWidget {
  const BusSearchScreen({super.key});

  @override
  _BusSearchScreenState createState() => _BusSearchScreenState();
}

class _BusSearchScreenState extends State<BusSearchScreen> {
  final TextEditingController _fromLocationController = TextEditingController();
  final TextEditingController _toLocationController = TextEditingController();
  final TextEditingController _departureDateController = TextEditingController();

  DateTime _departureDate = DateTime.now();
  String? _selectedBusType;
  bool _isLoading = false;
  List<QueryDocumentSnapshot> _searchResults = [];

  final List<String> busTypeOptions = [
    'All',
    'AC',
    'Non-AC',
    'Sleeper Coach AC',
    'Sleeper Coach Non-AC',
  ];

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: _departureDate,
      firstDate: DateTime.now(),
      lastDate: DateTime(2026),
      builder: (BuildContext context, Widget? child) {
        return Theme(
          data: ThemeData.light().copyWith(
            colorScheme: const ColorScheme.light(primary: Colors.blue),
          ),
          child: child!,
        );
      },
    );
    if (picked != null) {
      setState(() {
        _departureDate = picked;
        _departureDateController.text = DateFormat('yyyy-MM-dd').format(picked);
      });
    }
  }

  Future<void> _searchBuses(BuildContext context) async {
    setState(() {
      _isLoading = true;
      _searchResults.clear();
    });

    try {
      Query query = FirebaseFirestore.instance.collection('bus'); // Use correct collection name

      if (_fromLocationController.text.isNotEmpty) {
        query = query.where('from', isEqualTo: _fromLocationController.text);
      }
      if (_toLocationController.text.isNotEmpty) {
        query = query.where('to', isEqualTo: _toLocationController.text);
      }
      if (_departureDateController.text.isNotEmpty) {
        query = query.where('date', isEqualTo: _departureDateController.text);
      }
      if (_selectedBusType != null && _selectedBusType != 'All') {
        query = query.where('type', isEqualTo: _selectedBusType);
      }

      QuerySnapshot querySnapshot = await query.get();

      setState(() {
        _isLoading = false;
        _searchResults = querySnapshot.docs;
      });

      if (_searchResults.isEmpty) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('No buses found matching your criteria.')),
        );
      }

    } on FirebaseException catch (e) {
      debugPrint('FirebaseException [${e.code}]: ${e.message}');
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Firebase Error: ${e.message ?? 'Unknown error'}')),
        );
      }
      setState(() {
        _isLoading = false;
      });
    } catch (e) {
      debugPrint('Unexpected error: ${e.toString()}');
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('An unexpected error occurred. Please try again.')),
        );
      }
      setState(() {
        _isLoading = false;
      });
    }
  }

  InputDecoration _inputDecoration(String hint, IconData icon) {
    return InputDecoration(
      hintText: hint,
      hintStyle: const TextStyle(color: Colors.black),
      prefixIcon: Icon(icon, color: Colors.black),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      filled: true,
      fillColor: Colors.white.withOpacity(0.9),  // Fixed the color opacity issue
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Search for Buses",
          style: GoogleFonts.poppins(
            fontWeight: FontWeight.w600,
            color: Colors.white,
          ),
        ),
        backgroundColor: const Color(0xFF007E95),
      ),
      body: Stack(
        children: [
          LayoutBuilder(
            builder: (BuildContext context, BoxConstraints viewportConstraints) {
              return SingleChildScrollView(
                child: ConstrainedBox(
                  constraints: BoxConstraints(minHeight: viewportConstraints.maxHeight),
                  child: Container(
                    decoration: BoxDecoration(
                      image: DecorationImage(
                        image: const AssetImage('images/busimage1.jpg'),
                        fit: BoxFit.cover,
                        colorFilter: ColorFilter.mode(
                          Colors.black.withOpacity(0.4),
                          BlendMode.darken,
                        ),
                      ),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Column(
                        children: [
                          const SizedBox(height: 20),
                          TextField(
                            controller: _fromLocationController,
                            decoration: _inputDecoration('Enter pick-up location', Icons.location_on),
                            style: const TextStyle(color: Colors.black),
                          ),
                          const SizedBox(height: 10),
                          TextField(
                            controller: _toLocationController,
                            decoration: _inputDecoration('Enter drop-off location', Icons.location_on),
                            style: const TextStyle(color: Colors.black),
                          ),
                          const SizedBox(height: 10),
                          GestureDetector(
                            onTap: () => _selectDate(context),
                            child: AbsorbPointer(
                              child: TextField(
                                controller: _departureDateController,
                                decoration: _inputDecoration('Select a pick-up date', Icons.calendar_today),
                                style: const TextStyle(color: Colors.black),
                              ),
                            ),
                          ),
                          const SizedBox(height: 10),
                          DropdownButtonFormField<String>(
                            value: _selectedBusType,
                            items: busTypeOptions.map((type) {
                              return DropdownMenuItem<String>(
                                value: type,
                                child: Text(type, style: const TextStyle(color: Colors.black)),
                              );
                            }).toList(),
                            onChanged: (value) {
                              setState(() {
                                _selectedBusType = value;
                              });
                            },
                            decoration: InputDecoration(
                              labelText: 'Bus Type',
                              labelStyle: const TextStyle(color: Colors.black),
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(12),
                              ),
                              filled: true,
                              fillColor: Colors.white.withOpacity(0.9),
                            ),
                            style: const TextStyle(color: Colors.black),
                          ),
                          const SizedBox(height: 20),
                          Center(
                            child: ElevatedButton(
                              onPressed: () => _searchBuses(context),
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.white,
                                padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 16),
                              ),
                              child: const Text(
                                'Search Buses',
                                style: TextStyle(color: Colors.black),
                              ),
                            ),
                          ),
                          const SizedBox(height: 20),
                          if (_searchResults.isNotEmpty)
                            Column(
                              children: [
                                const Text(
                                  'Search Results:',
                                  style: TextStyle(
                                    fontSize: 18,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.white,
                                  ),
                                ),
                                const SizedBox(height: 10),
                                ListView.builder(
                                  shrinkWrap: true,
                                  physics: const NeverScrollableScrollPhysics(),
                                  itemCount: _searchResults.length,
                                  itemBuilder: (context, index) {
                                    final data = _searchResults[index].data() as Map<String, dynamic>;
                                    return Card(
                                      color: Colors.white.withOpacity(0.9),
                                      margin: const EdgeInsets.symmetric(vertical: 5),
                                      child: ListTile(
                                        title: Text('Bus: ${data['bus'] ?? 'N/A'}', style: const TextStyle(color: Colors.black)),
                                        subtitle: Column(
                                          crossAxisAlignment: CrossAxisAlignment.start,
                                          children: [
                                            Text('From: ${data['from'] ?? 'N/A'}, To: ${data['to'] ?? 'N/A'}', style: const TextStyle(color: Colors.black)),
                                            Text('Date: ${data['date'] ?? 'N/A'}, Type: ${data['type'] ?? 'N/A'}', style: const TextStyle(color: Colors.black)),
                                            Text('Price: ${data['price'] ?? 'N/A'}', style: const TextStyle(color: Colors.black)),
                                          ],
                                        ),
                                      ),
                                    );
                                  },
                                ),
                              ],
                            ),
                        ],
                      ),
                    ),
                  ),
                ),
              );
            },
          ),
          if (_isLoading)
            Container(
              color: Colors.black.withOpacity(0.5),
              child: const Center(
                child: CircularProgressIndicator(),
              ),
            ),
        ],
      ),
    );
  }
}