import 'package:flutter/material.dart';

class HomeTabWidget extends StatelessWidget {
  const HomeTabWidget({
    Key? key,
    required this.title,
    required this.color,
    required this.onTap,
  }) : super(key: key);
  final String title;
  final Color color;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Material(
        borderRadius: const BorderRadius.all(Radius.circular(15)),
        color: color,
        child: InkWell(
          onTap: onTap,
          borderRadius: const BorderRadius.all(Radius.circular(15)),
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 10),
            child: Text(
              title,
              textAlign: TextAlign.center,
            ),
          ),
        ),
      ),
    );
  }
}
