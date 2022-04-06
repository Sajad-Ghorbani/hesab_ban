import 'package:flutter/material.dart';

import '../theme/app_colors.dart';

class ConfirmButton extends StatelessWidget {
  const ConfirmButton({Key? key, required this.onTap}) : super(key: key);
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
        decoration: const BoxDecoration(
          borderRadius: BorderRadius.all(
            Radius.circular(15),
          ),
          color: kGreyColor,
        ),
        child: const Icon(Icons.check),
      ),
    );
  }
}
