import 'package:shared_preferences/shared_preferences.dart';

class DiscountForBusTicket {
  static const String couponCode = "TOURTIME";
  static const double discountPercentage = 0.10; // 10% discount

  static Future<bool> isDiscountActive() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getBool('discountActive') ?? true; // Default to true
  }

  static Future<void> setDiscountActive(bool active) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setBool('discountActive', active);
  }

  static bool isCodeValid(String enteredCode) {
    return enteredCode == couponCode; // Case-sensitive comparison
  }
}