import 'package:flutter/material.dart';
import 'package:hesab_ban/app/config/theme/app_colors.dart';

class DrawerItem extends StatelessWidget {
  const DrawerItem({
    super.key,
    required this.icon,
    required this.title,
    required this.onTap,
  });
  final IconData icon;
  final String title;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    bool isDark = Theme.of(context).brightness == Brightness.dark;
    return Column(
      children: [
        InkWell(
          onTap: onTap,
          borderRadius: const BorderRadius.all(Radius.circular(5)),
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 5),
            height: 50,
            child: Row(
              children: [
                Icon(
                  icon,
                  color: isDark?Colors.grey.shade500:kGreyColor,
                ),
                const SizedBox(width: 10),
                Text(
                  title,
                  style: Theme.of(context)
                      .textTheme
                      .bodyMedium!
                      .copyWith(fontSize: 18),
                ),
              ],
            ),
          ),
        ),
        const SizedBox(height: 5),
      ],
    );
  }
}
