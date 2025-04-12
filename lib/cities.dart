// cities.dart
import 'package:flutter/material.dart';

class City {
  final String name;
  final String country;

  City({required this.name, required this.country});
}

class CitiesData {
  static List<City> getCities() {
    return [
      City(name: 'Oslo', country: 'Norway'),
      City(name: 'Stockholm', country: 'Sweden'),
      City(name: 'Dhaka', country: 'Bangladesh'),
      City(name: 'Kathmandu', country: 'Nepal'),
      City(name: 'Copenhagen', country: 'Denmark'),
      City(name: 'Helsinki', country: 'Finland'),
      // Add more cities here
    ];
  }
}
