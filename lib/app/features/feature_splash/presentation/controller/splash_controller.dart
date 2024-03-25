import 'package:flutter/material.dart';
import 'package:hesab_ban/app/config/routes/app_pages.dart';
import 'package:hesab_ban/app/core/use_case/use_case.dart';
import 'package:hesab_ban/app/features/feature_setting/domain/use_cases/setting/save_setting_use_case.dart';
import 'package:get/get.dart';
import 'package:hesab_ban/app/features/feature_setting/presentation/controller/setting_controller.dart';

class SplashController extends GetxController with GetTickerProviderStateMixin {
  final SaveSettingUseCase _saveSettingUseCase;

  SplashController(this._saveSettingUseCase);

  double fontSize = 2;
  double containerSize = 1.5;
  double textOpacity = 0.0;
  double containerOpacity = 0.0;

  late AnimationController animationController;
  late Animation<double> animation;

  @override
  void onInit() {
    super.onInit();
    Future.delayed(const Duration(seconds: 2), () async {
      await _saveSettingUseCase(NoParams());
    });
    animationController =
        AnimationController(vsync: this, duration: const Duration(seconds: 3));

    animation = Tween<double>(begin: 50, end: 30).animate(CurvedAnimation(
        parent: animationController, curve: Curves.fastLinearToSlowEaseIn))
      ..addListener(() {
        textOpacity = 1.0;
        update();
      });

    animationController.forward();

    Future.delayed(const Duration(seconds: 2), () {
      fontSize = 1.06;
      update();
    });

    Future.delayed(const Duration(seconds: 2), () {
      containerSize = 2;
      containerOpacity = 1;
      update();
    });

    Future.delayed(const Duration(seconds: 4), () {
      bool showPasswordScreen =
          Get.find<SettingController>().showPasswordScreen;
      if (showPasswordScreen) {
        Get.offNamed(Routes.passwordScreen);
      } //
      else {
        Get.offAllNamed(Routes.mainScreen);
      }
    });
  }

  @override
  void onClose() {
    super.onClose();
    animationController.dispose();
  }
}
