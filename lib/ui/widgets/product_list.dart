import 'package:flutter/material.dart';
import 'package:sliver_tools/sliver_tools.dart';

import '../theme/app_colors.dart';

class ProductListWidget extends StatelessWidget {
  const ProductListWidget({Key? key, required this.child}) : super(key: key);
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return SliverStack(
      children: [
        SliverPositioned.fill(
          child: Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  kGreyColor.withOpacity(0.4),
                  kSurfaceColor.withOpacity(0.4),
                ],
                begin: Alignment.topRight,
                end: Alignment.bottomLeft,
              ),
              borderRadius: const BorderRadius.all(
                Radius.circular(15),
              ),
            ),
            margin: const EdgeInsets.symmetric(horizontal: 10),
          ),
        ),
        child,
      ],
    );
  }
}
