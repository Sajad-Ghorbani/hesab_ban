import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:hesab_ban/app/config/theme/app_colors.dart';
import 'package:sliver_tools/sliver_tools.dart';

class SliverBoxContainerWidget extends StatelessWidget {
  const SliverBoxContainerWidget({
    super.key,
    this.backBlur = true,
    required this.child,
  });
  final Widget child;
  final bool backBlur;

  @override
  Widget build(BuildContext context) {
    return SliverStack(
      children: [
        SliverPositioned.fill(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 10),
            child: ClipRRect(
              borderRadius: const BorderRadius.all(
                Radius.circular(15),
              ),
              child: backBlur
                  ? BackdropFilter(
                      filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
                      child: Container(
                        decoration: BoxDecoration(
                          color: kGreyColor.withOpacity(0.2),
                          borderRadius: const BorderRadius.all(
                            Radius.circular(15),
                          ),
                        ),
                      ),
                    )
                  : Container(
                      decoration: BoxDecoration(
                        color: kGreyColor.withOpacity(0.2),
                        borderRadius: const BorderRadius.all(
                          Radius.circular(15),
                        ),
                      ),
                    ),
            ),
          ),
        ),
        child,
      ],
    );
  }
}
