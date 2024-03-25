import 'package:flutter/material.dart';

class PassKeyWidget extends StatelessWidget {
  const PassKeyWidget({super.key, this.num, required this.onTap, this.icon});

  final int? num;
  final Function(int? value) onTap;
  final Widget? icon;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        const SizedBox(width: 10),
        InkWell(
          borderRadius: const BorderRadius.all(Radius.circular(30)),
          onTap: () {
            onTap(num);
          },
          child: Container(
            width: 60,
            height: 60,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: Theme.of(context).colorScheme.secondary.withOpacity(0.6),
            ),
            alignment: Alignment.center,
            child: icon ??
                Text(
                  num.toString(),
                  style: Theme.of(context).textTheme.titleLarge!.copyWith(
                        color: Theme.of(context).colorScheme.onPrimary,
                      ),
                ),
          ),
        ),
        const SizedBox(width: 10),
      ],
    );
  }
}
