import 'package:shared_preferences/shared_preferences.dart';

class DiscountForCarRental {
  static const String couponCode = "DRIVEAWAY";
  static const double discountPercentage = 0.15; // 15% discount

  static Future<bool> isDiscountActive() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getBool('carRentalDiscountActive') ?? true; // Default to true
  }

  static Future<void> setDiscountActive(bool active) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setBool('carRentalDiscountActive', active);
  }

  static bool isCodeValid(String enteredCode) {
    return enteredCode == couponCode; // Case-sensitive comparison
  }

  static double getDiscount(int rentalDays, bool isCouponValid) {
    double discount = 0.0;
    if (rentalDays > 7) {
      discount = 0.1; // 10% discount for rentals over 7 days
    }

    if(isCouponValid){
      discount += discountPercentage;
    }
    return discount;
  }
}