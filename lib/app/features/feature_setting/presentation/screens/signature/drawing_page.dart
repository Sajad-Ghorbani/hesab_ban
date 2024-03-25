import 'package:get/get.dart';
import 'package:hesab_ban/app/config/theme/app_colors.dart';
import 'package:flutter/material.dart';
import 'package:hesab_ban/app/features/feature_setting/presentation/controller/setting_controller.dart';
import 'package:hesab_ban/app/features/feature_setting/presentation/screens/signature/drawn_line.dart';
import 'package:hesab_ban/app/features/feature_setting/presentation/screens/signature/sketcher.dart';
import 'package:iconsax/iconsax.dart';

class DrawingPage extends GetView<SettingController> {
  const DrawingPage({super.key});

  Widget buildCurrentPath(BuildContext context, Size size) {
    return GestureDetector(
      onPanStart: (details) {
        controller.onPanStart(details, context);
      },
      onPanUpdate: (details) {
        controller.onPanUpdate(details, context);
      },
      onPanEnd: controller.onPanEnd,
      child: RepaintBoundary(
        child: Container(
          color: Colors.transparent,
          width: size.width,
          height: size.height,
          child: StreamBuilder<DrawnLine>(
            stream: controller.currentLineStreamController.stream,
            builder: (context, snapshot) {
              return CustomPaint(
                painter: Sketcher(
                  lines: [controller.line],
                ),
              );
            },
          ),
        ),
      ),
    );
  }

  Widget buildAllPaths(BuildContext context, Size size) {
    return RepaintBoundary(
      key: controller.globalKey,
      child: SizedBox(
        width: size.width,
        height: size.height,
        child: StreamBuilder<List<DrawnLine>>(
          stream: controller.linesStreamController.stream,
          builder: (context, snapshot) {
            return CustomPaint(
              painter: Sketcher(
                lines: controller.lines,
              ),
            );
          },
        ),
      ),
    );
  }

  Widget buildSaveButton(BuildContext context) {
    return GestureDetector(
      onTap: () {
        controller.saveSignature(context);
      },
      child: const Icon(
        Iconsax.tick_circle,
        color: kGreenColor,
      ),
    );
  }

  Widget buildClearButton() {
    return GestureDetector(
      onTap: controller.clearSignBox,
      child: const Icon(
        Iconsax.trash,
        color: Colors.white,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.sizeOf(context);
    return GetBuilder<SettingController>(
      initState: (state) => controller.permission(),
      builder: (_) {
        return Scaffold(
          body: Stack(
            alignment: Alignment.center,
            children: [
              Container(
                width: size.width,
                height: size.width,
                margin: const EdgeInsets.symmetric(horizontal: 10),
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(Get.isDarkMode ? 0.3 : 1),
                  border: Border.all(
                    width: 2,
                    color: Theme.of(context).colorScheme.onBackground,
                  ),
                ),
              ),
              buildAllPaths(context, size),
              buildCurrentPath(context, size),
              Column(
                children: [
                  AppBar(
                    title: const Text('ایجاد امضا'),
                    centerTitle: true,
                    leading: IconButton(
                      onPressed: () {
                        Get.back();
                        controller.clearSignBox();
                      },
                      icon: const Icon(Iconsax.arrow_right_3),
                      color: Colors.white,
                      splashRadius: 30,
                    ),
                    actions: [
                      buildClearButton(),
                      const SizedBox(width: 15),
                      buildSaveButton(context),
                      const SizedBox(width: 10),
                    ],
                  ),
                  const Padding(
                    padding: EdgeInsets.all(20),
                    child: Text(
                      'نمونه امضا خود را در کادر زیر بکشید.\n(توجه: خارج از محدوده کادر ثبت نمیشود)',
                      textAlign: TextAlign.center,
                    ),
                  ),
                  const Spacer(),
                  const Text('از این قسمت میزان ضخامت خط را انتخاب کنید.'),
                  const SizedBox(height: 25),
                  SizedBox(
                    width: size.width * 0.7,
                    child: Slider(
                      value: controller.selectedWidth,
                      onChanged: (value) {
                        controller.selectedWidth = value;
                        controller.update();
                      },
                      max: 10,
                      min: 2,
                      label: controller.selectedWidth.toStringAsFixed(0),
                      divisions: 4,

                    ),
                  ),
                  const SizedBox(height: 10),
                ],
              ),
            ],
          ),
        );
      },
    );
  }
}
