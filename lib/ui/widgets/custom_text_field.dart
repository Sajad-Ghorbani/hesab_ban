import 'package:accounting_app/ui/theme/constants_app_styles.dart';
import 'package:flutter/material.dart';

class CustomTextField extends StatelessWidget {
  const CustomTextField({Key? key, this.controller, this.keyboardType})
      : super(key: key);
  final TextEditingController? controller;
  final TextInputType? keyboardType;

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: controller,
      keyboardType: keyboardType,
      decoration: kCustomInputDecoration,
    );
  }
}
