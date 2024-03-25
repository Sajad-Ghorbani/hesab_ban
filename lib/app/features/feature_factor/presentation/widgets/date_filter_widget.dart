import 'package:flutter/material.dart';
import 'package:hesab_ban/app/config/theme/app_colors.dart';

class DateFilterWidget extends StatelessWidget {
  const DateFilterWidget({
    super.key,
    required this.title,
    required this.onTap,
    required this.isSelected,
  });

  final String title;
  final VoidCallback onTap;
  final bool isSelected;

  @override
  Widget build(BuildContext context) {
    bool isDark = Theme.of(context).brightness == Brightness.dark;
    return Material(
      borderRadius: const BorderRadius.all(Radius.circular(10)),
      color: Theme.of(context)
          .colorScheme
          .secondary
          .withOpacity(isSelected ? 1 : 0.3),
      child: InkWell(
        borderRadius: const BorderRadius.all(Radius.circular(10)),
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 3, horizontal: 8),
          child: Text(
            title,
            style: Theme.of(context).textTheme.titleMedium!.copyWith(
                  color: kWhiteBlueColor.withOpacity(isSelected
                      ? 1
                      : isDark
                          ? 0.4
                          : 1),
                ),
          ),
        ),
      ),
    );
  }
}
