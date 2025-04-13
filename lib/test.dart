import 'package:cloud_firestore/cloud_firestore.dart';

void testFirestoreConnection() async {
  try {
    await FirebaseFirestore.instance.collection('test').add({
      'timestamp': DateTime.now(),
      'message': 'Hello from Flutter!',
    });
    print('✅ Firestore write successful');
  } catch (e) {
    print('❌ Firestore write failed: $e');
  }
}