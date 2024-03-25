import 'package:flutter/material.dart';

class ConfirmButton extends StatelessWidget {
  const ConfirmButton({Key? key, required this.onTap}) : super(key: key);
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
        decoration: BoxDecoration(
          borderRadius: const BorderRadius.all(
            Radius.circular(15),
          ),
          color: Theme.of(context).cardColor,
        ),
        child: const Icon(Icons.check),
      ),
    );
  }
}
