import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hesab_ban/app/core/widgets/painted_widgets.dart';
import 'package:iconsax/iconsax.dart';

class BaseWidget extends StatelessWidget {
  const BaseWidget({
    Key? key,
    this.title,
    this.titleText,
    this.appBarLeading,
    this.appBarActions,
    required this.child,
    this.resizeToAvoidBottomInset,
    this.showPaint = false,
    this.automaticallyImplyLeading = true,
    this.onLeadingTap,
    this.showLeading = false,
  }) : super(key: key);
  final String? titleText;
  final bool showLeading;
  final Widget? appBarLeading;
  final VoidCallback? onLeadingTap;
  final List<Widget>? appBarActions;
  final Widget child;
  final bool? resizeToAvoidBottomInset;
  final bool showPaint;
  final Widget? title;
  final bool automaticallyImplyLeading;

  @override
  Widget build(BuildContext context) {
    bool isDark = Theme.of(context).brightness == Brightness.dark;
    return Scaffold(
      resizeToAvoidBottomInset: resizeToAvoidBottomInset,
      appBar: AppBar(
        title: title ?? Text(titleText!),
        centerTitle: true,
        leading: showLeading
            ? appBarLeading ??
                IconButton(
                  onPressed: () {
                    Get.back();
                    if (onLeadingTap != null) onLeadingTap!();
                  },
                  icon: const Icon(Iconsax.arrow_right_3),
                  color: Colors.white,
                  splashRadius: 30,
                )
            : null,
        actions: appBarActions,
        automaticallyImplyLeading: automaticallyImplyLeading,
      ),
      body: Stack(
        children: [
          if (showPaint)
            Positioned(
              bottom: 0,
              child: CustomPaint(
                size: Size(Get.width, Get.width * 0.55),
                painter: RPSCustomPainter(isDark: isDark),
              ),
            ),
          child,
        ],
      ),
    );
  }
}
