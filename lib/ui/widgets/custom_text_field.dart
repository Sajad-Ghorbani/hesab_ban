import 'package:flutter/services.dart';
import 'package:hesab_ban/ui/theme/constants_app_styles.dart';
import 'package:flutter/material.dart';

class CustomTextField extends StatelessWidget {
  const CustomTextField({Key? key, this.controller, this.keyboardType, this.inputFormatters, this.maxLines = 3})
      : super(key: key);
  final TextEditingController? controller;
  final TextInputType? keyboardType;
  final List<TextInputFormatter>? inputFormatters;
  final int? maxLines;

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: controller,
      keyboardType: keyboardType,
      decoration: kCustomInputDecoration,
      inputFormatters: inputFormatters,
      maxLines: maxLines,
      minLines: 1,
    );
  }
}
