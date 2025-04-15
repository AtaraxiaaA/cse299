import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:tourify_sample_project/AuthScreen.dart'; // Import the new AuthScreen
import 'firebase_options.dart';
//main test
void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  runApp(MaterialApp(
    debugShowCheckedModeBanner: false,
    home: AuthScreen(), // Use AuthScreen as the initial screen
  ));
}