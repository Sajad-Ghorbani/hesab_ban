import 'package:flutter/services.dart';
import 'package:flutter/material.dart';
import 'package:hesab_ban/app/config/theme/constants_app_styles.dart';
import 'package:hesab_ban/app/core/utils/static_methods.dart';

class CustomTextField extends StatelessWidget {
  const CustomTextField({
    super.key,
    this.controller,
    this.keyboardType,
    this.inputFormatters,
    this.maxLines = 3,
    this.focusNode,
  });
  final TextEditingController? controller;
  final TextInputType? keyboardType;
  final List<TextInputFormatter>? inputFormatters;
  final int? maxLines;
  final FocusNode? focusNode;

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: controller,
      keyboardType: keyboardType,
      decoration: kCustomInputDecoration,
      inputFormatters: inputFormatters,
      maxLines: maxLines,
      minLines: 1,
      focusNode: focusNode,
      onTap: () {
        StaticMethods.textFieldOnTap(controller!);
      },
    );
  }
}
