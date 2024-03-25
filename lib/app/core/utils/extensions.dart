import 'package:persian_number_utility/persian_number_utility.dart';

extension NumExtensions on double {
  String removeDot() {
    return (toString().split('.')[1] == '0'
        ? toString().split('.')[0]
        : toString());
  }
}

extension Numoration on num{
  String formatPrice() {
    if(this is double){
      double n = this as double;
      return n.removeDot().seRagham();
    }
    return '$this'.seRagham();
  }
}

extension DateHelpers on DateTime {
  bool isToday() {
    final now = DateTime.now();
    return now.day == day &&
        now.month == month &&
        now.year == year;
  }

  bool isYesterday() {
    final yesterday = DateTime.now().subtract(const Duration(days: 1));
    return yesterday.day == day &&
        yesterday.month == month &&
        yesterday.year == year;
  }
}