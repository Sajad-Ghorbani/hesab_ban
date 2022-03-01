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
  }) : super(key: key);
  final String title;
  final Widget? appBarLeading;
  final List<Widget>? appBarActions;
  final Widget child;
  final bool? resizeToAvoidBottomInset;

  @override
  Widget build(BuildContext context) {
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
          Positioned(
            bottom: 30,
            child: CustomPaint(
              size: Size(Get.width, Get.width * 0.65),
              painter: RPSCustomPainter2(),
            ),
          ),
          Positioned(
            bottom: 15,
            child: CustomPaint(
              size: Size(Get.width, Get.width * 0.65),
              painter: RPSCustomPainter1(),
            ),
          ),
          Positioned(
            bottom: 0,
            child: CustomPaint(
              size: Size(Get.width, Get.width * 0.65),
              painter: RPSCustomPainter(),
            ),
          ),
          child,
        ],
      ),
    );
  }
}
