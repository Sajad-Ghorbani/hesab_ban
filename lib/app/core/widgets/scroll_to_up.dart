import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:get/get.dart';
import 'package:hesab_ban/app/core/widgets/expandable_fab.dart';

class ScrollToUp extends StatelessWidget {
  const ScrollToUp({
    Key? key,
    required this.showFab,
    required this.scrollController,
    required this.child,
    this.hideBottomSheet = true,
    this.onLeftPressed,
    this.leftIcon,
    this.showLeftButton = false,
    this.showMultiLeftButton,
    this.firstIcon,
    this.secondIcon,
    this.firstIconOnTap,
    this.secondIconOnTap,
  }) : super(key: key);
  final ScrollController scrollController;
  final Widget child;
  final RxBool showFab;
  final bool hideBottomSheet;
  final VoidCallback? onLeftPressed;
  final Widget? leftIcon;

  /// If its value is true, it will display a [FloatingActionButton] at the bottom left. Default is false.
  final bool showLeftButton;

  /// if showLeftButton is true, this item is shown
  final bool? showMultiLeftButton;
  final IconData? firstIcon;
  final IconData? secondIcon;
  final VoidCallback? firstIconOnTap;
  final VoidCallback? secondIconOnTap;

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
                heroTag: 'upButton',
                onPressed: () {
                  scrollController.animateTo(
                    0,
                    duration: const Duration(milliseconds: 200),
                    curve: Curves.fastOutSlowIn,
                  );
                },
                mini: true,
                child: const Icon(Icons.arrow_upward_rounded),
              ),
            ),
          ),
        ),
        if (showLeftButton)
          Positioned(
            bottom: hideBottomSheet ? 10 : 70,
            left: 10,
            child: Obx(
              () => AnimatedScale(
                duration: const Duration(milliseconds: 200),
                scale: showFab.value ? 1 : 0,
                child: showMultiLeftButton == true
                    ? ExpandableFab(
                        icon: leftIcon!,
                        distance: 80,
                        children: [
                          ActionButton(
                            icon: firstIcon!,
                            onPressed: firstIconOnTap,
                          ),
                          ActionButton(
                            icon: secondIcon!,
                            onPressed: secondIconOnTap,
                          ),
                        ],
                      )
                    : FloatingActionButton(
                        heroTag: 'addButton',
                        onPressed: onLeftPressed,
                        mini: true,
                        child: leftIcon,
                      ),
              ),
            ),
          ),
      ],
    );
  }
}

@immutable
class ActionButton extends StatelessWidget {
  const ActionButton({
    super.key,
    this.onPressed,
    required this.icon,
  });

  final VoidCallback? onPressed;
  final IconData icon;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return SizedBox(
      width: 40,
      height: 40,
      child: Material(
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(12)),
        ),
        color: theme.colorScheme.surface,
        elevation: 4.0,
        child: InkWell(
          borderRadius: const BorderRadius.all(Radius.circular(12)),
          splashColor: Colors.white.withOpacity(0.2),
          onTap: onPressed,
          child: Icon(
            icon,
            color: theme.colorScheme.onPrimary,
          ),
        ),
      ),
    );
  }
}
