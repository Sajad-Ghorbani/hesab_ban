import 'package:flutter/material.dart';

class BottomSheetRow extends StatelessWidget {
  const BottomSheetRow({
    super.key,
    required this.title,
    this.value,
    this.valueWidget,
  });

  final String title;
  final String? value;
  final Widget? valueWidget;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Row(
        children: [
          Text(
            title,
            style: TextStyle(
              color:
                  Theme.of(context).colorScheme.onBackground.withOpacity(0.6),
            ),
          ),
          const SizedBox(width: 6),
          const Expanded(
            child: Text(
              '----------------------------------------------------',
              maxLines: 1,
            ),
          ),
          const SizedBox(width: 6),
          if (value != null) Text(value!),
          if (valueWidget != null) valueWidget!
        ],
      ),
    );
  }
}
