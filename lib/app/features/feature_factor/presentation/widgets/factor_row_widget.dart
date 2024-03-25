import 'package:flutter/material.dart';

class FactorRowWidget extends StatelessWidget {
  const FactorRowWidget({
    super.key,
    required this.index,
    required this.title,
    required this.count,
    required this.price,
    required this.sum,
    this.onTap,
    this.isHeader = false,
  });

  final String index;
  final String title;
  final String count;
  final Widget price;
  final Widget sum;
  final VoidCallback? onTap;
  final bool isHeader;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        constraints: const BoxConstraints(minHeight: 46),
        padding: const EdgeInsets.symmetric(horizontal: 20),
        decoration: BoxDecoration(
          border: Border(
            top: isHeader ? BorderSide.none : const BorderSide(
                color: Colors.grey
            ),
          ),
        ),
        child: Row(
          children: [
            SizedBox(
              width: 50,
              child: Text(index),
            ),
            SizedBox(
              width: 120,
              child: Text(title,textAlign: TextAlign.center,),
            ),
            SizedBox(
              width: 120,
              child: Text(count,textAlign: TextAlign.center,),
            ),
            SizedBox(
              width: 120,
              child: price,
            ),
            SizedBox(
              width: 120,
              child: sum,
            ),
          ],
        ),
      ),
    );
  }
}