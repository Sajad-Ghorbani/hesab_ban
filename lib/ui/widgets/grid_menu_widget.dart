import 'package:flutter/material.dart';

import '../theme/app_colors.dart';

class GridMenuWidget extends StatelessWidget {
  const GridMenuWidget({
    Key? key,
    required this.title,
    required this.onTap,
    this.color = kGreyColor,
    this.width,
  }) : super(key: key);
  final String title;
  final VoidCallback onTap;
  final Color color;
  final double? width;

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Card(
          margin: EdgeInsets.zero,
          color: color,
          shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.all(
              Radius.circular(15),
            ),
          ),
          child: Container(
            height: 45,
            width: width,
            padding: width == null
                ? const EdgeInsets.symmetric(horizontal: 10)
                : null,
            child: Center(
              child: Text(title),
            ),
          ),
        ),
        Positioned.fill(
          child: Material(
            color: Colors.transparent,
            borderRadius: const BorderRadius.all(
              Radius.circular(15),
            ),
            child: InkWell(
              onTap: onTap,
              borderRadius: const BorderRadius.all(
                Radius.circular(15),
              ),
            ),
          ),
        ),
      ],
    );
  }
}
