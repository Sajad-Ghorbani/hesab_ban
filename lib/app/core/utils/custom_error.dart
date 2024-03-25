import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

class CustomError extends StatelessWidget {
  const CustomError({super.key, required this.errorDetails});

  final FlutterErrorDetails errorDetails;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            kDebugMode ? errorDetails.summary.toString() : 'خطایی رخ داده است!',
            textAlign: TextAlign.center,
            style: const TextStyle(
              color: kDebugMode ? Colors.red : Colors.black,
              fontWeight: FontWeight.bold,
              fontSize: 21,
            ),
          ),
          const SizedBox(height: 12),
          const Text(
            kDebugMode
                ? 'https://docs.flutter.dev/testing/errors'
                : "ما با خطایی مواجه شدیم و تیم مهندسی خود را در مورد آن مطلع کردیم. پوزش بابت ناراحتی پیش آمده",
            textAlign: TextAlign.center,
            style: TextStyle(color: Colors.black, fontSize: 14),
          ),
        ],
      ),
    );
  }
}