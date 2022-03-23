import 'package:flutter/material.dart';

class SettingRowWidget extends StatelessWidget {
  const SettingRowWidget({
    Key? key,
    required this.onTap,
    required this.icon,
    required this.title,
    this.valueWidget,
  }) : super(key: key);
  final VoidCallback onTap;
  final IconData icon;
  final String title;
  final Widget? valueWidget;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10.0),
      child: GestureDetector(
        onTap: onTap,
        child: Row(
          children: [
            Icon(icon),
            const SizedBox(
              width: 10,
            ),
            Text(title),
            const Spacer(),
            valueWidget ?? const SizedBox.shrink(),
          ],
        ),
      ),
    );
  }
}
