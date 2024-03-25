import 'package:flutter/material.dart';

class PassBulletWidget extends StatelessWidget {
  const PassBulletWidget({super.key, this.color});

  final Color? color;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 10),
      width: 15,
      height: 15,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: color,
        border: color == null
            ? Border.all(width: 1.5, color: Colors.black87)
            : null,
      ),
    );
  }
}
