import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:get/get.dart';

class ScrollToUp extends StatelessWidget {
  const ScrollToUp({
    Key? key,
    required this.showFab,
    required this.scrollController,
    required this.child,
    this.hideBottomSheet = false,
  }) : super(key: key);
  final ScrollController scrollController;
  final Widget child;
  final RxBool showFab;
  final bool hideBottomSheet;

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        NotificationListener<UserScrollNotification>(
          onNotification: (notification) {
            if (notification.direction == ScrollDirection.forward) {
              showFab.value = true;
            } //
            else if (notification.direction == ScrollDirection.reverse) {
              showFab.value = false;
            }
            return true;
          },
          child: child,
        ),
        Positioned(
          bottom: hideBottomSheet ? 10 : 70,
          right: 10,
          child: Obx(
            () => AnimatedScale(
              duration: const Duration(milliseconds: 200),
              scale: showFab.value ? 1 : 0,
              child: FloatingActionButton(
                onPressed: () {
                  scrollController.animateTo(
                    0,
                    duration: const Duration(milliseconds: 200),
                    curve: Curves.fastOutSlowIn,
                  );
                },
                child: const Icon(Icons.arrow_upward_rounded),
                mini: true,
              ),
            ),
          ),
        ),
      ],
    );
  }
}
