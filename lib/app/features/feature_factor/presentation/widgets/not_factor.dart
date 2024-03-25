import 'package:flutter/material.dart';
import 'package:iconsax/iconsax.dart';

class NotFactor extends StatefulWidget {
  const NotFactor({super.key});

  @override
  State<NotFactor> createState() => _NotFactorState();
}

class _NotFactorState extends State<NotFactor> with TickerProviderStateMixin {
  late AnimationController _animationController;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
        duration: const Duration(milliseconds: 300),
        vsync: this,
        animationBehavior: AnimationBehavior.preserve);
    _animationController.forward();
  }

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.sizeOf(context).width;
    final dividerAnimation =
        Tween(begin: 50.0, end: 5.0).animate(_animationController);
    final slideAnimation =
        Tween(begin: 0.0, end: 1.0).animate(_animationController);
    return Stack(
      alignment: Alignment.center,
      children: [
        AnimatedBuilder(
            animation: slideAnimation,
            builder: (context, child) {
              return AnimatedSlide(
                offset: Offset(0, -slideAnimation.value * 0.7),
                duration: const Duration(milliseconds: 300),
                curve: Curves.easeInOut,
                child: Icon(
                  Iconsax.warning_2,
                  size: 80,
                  color: Theme.of(context).colorScheme.onSurface,
                ),
              );
            }),
        AnimatedBuilder(
          animation: dividerAnimation,
          builder: (context, child) {
            return Divider(
              endIndent: width * 0.25,
              indent: width * 0.25,
              height: dividerAnimation.value,
              thickness: dividerAnimation.value,
              color: Theme.of(context).colorScheme.onSurface,
            );
          },
        ),
        AnimatedBuilder(
            animation: slideAnimation,
            builder: (context, child) {
              return AnimatedSlide(
                offset: Offset(0, slideAnimation.value),
                duration: const Duration(milliseconds: 500),
                curve: Curves.easeInOut,
                child: Text(
                  'لیست خالی می باشد',
                  style: Theme.of(context)
                      .textTheme
                      .titleLarge!
                      .copyWith(color: Theme.of(context).colorScheme.onSurface),
                ),
              );
            }),
      ],
    );
  }
}
