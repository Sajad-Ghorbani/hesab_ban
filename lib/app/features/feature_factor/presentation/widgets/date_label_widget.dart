import 'package:flutter/material.dart';
import 'package:persian_number_utility/persian_number_utility.dart';

class DateLabelWidget extends StatelessWidget {
  const DateLabelWidget({super.key, this.date, required this.onTap});

  final String? date;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Theme.of(context).colorScheme.primary,
      borderRadius: const BorderRadius.all(Radius.circular(5)),
      child: InkWell(
        borderRadius: const BorderRadius.all(Radius.circular(5)),
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.fromLTRB(5, 3, 5, 0),
          child: Text(
            date ?? DateTime.now().toPersianDate(),
            style: Theme.of(context).textTheme.bodyLarge!.copyWith(
                  color: Theme.of(context).colorScheme.onPrimary,
                ),
          ),
        ),
      ),
    );
  }
}
