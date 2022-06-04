import 'package:animations/animations.dart';
import 'package:flutter/material.dart';

import '../theme/app_colors.dart';

class SearchBoxWidget extends StatelessWidget {
  const SearchBoxWidget({
    Key? key,
    required this.searchText,
    required this.openBuilderWidget,
    required this.onClosed,
  }) : super(key: key);
  final String searchText;
  final Widget openBuilderWidget;
  final ValueChanged onClosed;

  @override
  Widget build(BuildContext context) {
    bool isDark = Theme.of(context).brightness == Brightness.dark;
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 10),
      child: OpenContainer(
        closedBuilder: (context, action) {
          return Container(
            height: 45,
            width: 20,
            // margin: const EdgeInsets.only(bottom: 10),
            decoration: BoxDecoration(
              borderRadius: const BorderRadius.all(
                Radius.circular(15),
              ),
              border: Border.all(
                color:
                    isDark ? kGreyColor : kSurfaceLightColor.withOpacity(0.4),
                width: 1.5,
              ),
              gradient: LinearGradient(
                colors: [
                  Theme.of(context).cardColor.withOpacity(0.4),
                  Theme.of(context).colorScheme.surface.withOpacity(0.4),
                ],
                begin: Alignment.topRight,
                end: Alignment.bottomLeft,
              ),
            ),
            child: Row(
              children: [
                const Icon(
                  Icons.search,
                  color: kOrangeColor,
                ),
                const SizedBox(
                  width: 20,
                ),
                Text(searchText),
              ],
            ),
            alignment: Alignment.centerRight,
            padding: const EdgeInsets.symmetric(horizontal: 10),
          );
        },
        openBuilder: (context, action) {
          return openBuilderWidget;
        },
        closedElevation: 0,
        closedShape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.all(
            Radius.circular(15),
          ),
        ),
        closedColor: Theme.of(context).colorScheme.background,
        onClosed: onClosed,
      ),
    );
  }
}
