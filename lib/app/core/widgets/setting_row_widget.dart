import 'package:flutter/material.dart';

class SettingRowWidget extends StatelessWidget {
  const SettingRowWidget({
    super.key,
    this.onTap,
    this.icon,
    this.title = '',
    this.valueWidget,
    this.titleWidget,
    this.iconWidget,
    this.verticalPadding = 10.0,
    this.isActive = true,
  });
  final VoidCallback? onTap;
  final IconData? icon;
  final Widget? iconWidget;
  final String title;
  final Widget? valueWidget;
  final Widget? titleWidget;
  final double verticalPadding;
  final bool isActive;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: isActive ? onTap : null,
      child: Padding(
        padding: EdgeInsets.symmetric(vertical: verticalPadding),
        child: Row(
          children: [
            icon != null
                ? Icon(
                    icon,
                    color: isActive ? null : Theme.of(context).disabledColor,
                  )
                : iconWidget!,
            const SizedBox(
              width: 10,
            ),
            titleWidget ??
                Text(
                  title,
                  style: TextStyle(
                    color: isActive ? null : Theme.of(context).disabledColor,
                  ),
                ),
            const Spacer(flex: 1),
            valueWidget ?? const SizedBox.shrink(),
          ],
        ),
      ),
    );
  }
}
