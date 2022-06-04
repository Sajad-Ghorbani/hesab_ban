import 'package:hesab_ban/ui/widgets/painted_widgets.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class BaseWidget extends StatelessWidget {
  const BaseWidget({
    Key? key,
    required this.title,
    this.appBarLeading,
    this.appBarActions,
    required this.child,
    this.resizeToAvoidBottomInset,
    this.showPaint = false,
  }) : super(key: key);
  final String title;
  final Widget? appBarLeading;
  final List<Widget>? appBarActions;
  final Widget child;
  final bool? resizeToAvoidBottomInset;
  final bool showPaint;

  @override
  Widget build(BuildContext context) {
    bool isDark = Theme.of(context).brightness == Brightness.dark;
    return Scaffold(
      resizeToAvoidBottomInset: resizeToAvoidBottomInset,
      appBar: AppBar(
        title: Text(title),
        centerTitle: true,
        leading: appBarLeading,
        actions: appBarActions,
      ),
      body: Stack(
        fit: StackFit.expand,
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
