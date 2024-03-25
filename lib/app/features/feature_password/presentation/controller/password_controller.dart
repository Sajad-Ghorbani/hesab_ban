import 'dart:async';
import 'dart:convert';

import 'package:crypto/crypto.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hesab_ban/app/config/routes/app_pages.dart';
import 'package:hesab_ban/app/config/theme/app_colors.dart';
import 'package:hesab_ban/app/core/params/user_params.dart';
import 'package:hesab_ban/app/core/utils/static_methods.dart';
import 'package:hesab_ban/app/features/feature_setting/domain/use_cases/user/get_user_by_id_use_case.dart';
import 'package:hesab_ban/app/features/feature_setting/domain/use_cases/user/update_user_use_case.dart';
import 'package:hesab_ban/app/features/feature_setting/presentation/controller/setting_controller.dart';
import 'package:local_auth/local_auth.dart';
import 'package:local_auth_android/local_auth_android.dart';

class PasswordController extends GetxController
    with GetTickerProviderStateMixin {
  final UpdateUserUseCase _updateUserUseCase;
  final GetUserByIdUseCase _getUserByIdUseCase;

  PasswordController(this._updateUserUseCase, this._getUserByIdUseCase);

  List<int> password = [];
  late AnimationController animationController;
  late AnimationController failedAnimationController;
  bool passCorrected = false;
  bool passFailed = false;
  String hashPassword = Get.find<SettingController>().hashPassword;

  @override
  void onInit() {
    super.onInit();
    animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 2000),
    );
    failedAnimationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 400),
    );
  }

  @override
  void onClose() {
    animationController.reset();
    animationController.dispose();
    failedAnimationController.dispose();
    super.onClose();
  }

  void checkPassword(int value) {
    if (password.length <= 3) {
      password.add(value);
      update();
    }
    if (password.length == 4 &&
        (animationController.status != AnimationStatus.forward &&
            failedAnimationController.status != AnimationStatus.forward)) {
      String pass = createHashPassword();
      if (pass == hashPassword) {
        passCorrected = true;
        update();
        Timer(const Duration(milliseconds: 200), () {
          animationController.forward();
        });
        Timer(const Duration(milliseconds: 1500), () {
          passCorrected = false;
          password.clear();
          update();
          Get.offAllNamed(Routes.mainScreen);
        });
      } //
      else {
        passFailed = true;
        failedAnimationController.forward(from: 0.0);
        update();
        Timer(const Duration(milliseconds: 800), () {
          passFailed = false;
          password.clear();
          update();
        });
      }
    }
  }

  Future<void> localAuth() async {
    final localAuth = LocalAuthentication();
    final bool canAuthenticateWithBiometrics =
        await localAuth.canCheckBiometrics;
    final bool canAuthenticate =
        canAuthenticateWithBiometrics || await localAuth.isDeviceSupported();
    if (!canAuthenticate) {
      StaticMethods.showSnackBar(
        title: 'خطا',
        description: 'گوشی شما ورود بیومتریک را پشتیبانی نمی کند',
      );
    } //
    else {
      final didAuthenticate = await localAuth.authenticate(
        localizedReason: 'حساب بان',
        authMessages: const [
          AndroidAuthMessages(
            signInTitle: 'ورود بیومتریک به',
            biometricHint: '',
            cancelButton: 'ورود با رمز عبور',
          ),
        ],
        options: const AuthenticationOptions(
          biometricOnly: true,
        ),
      );
      if (didAuthenticate) {
        passCorrected = true;
        update();
        Timer(const Duration(milliseconds: 200), () {
          animationController.forward();
        });
        Timer(const Duration(milliseconds: 1500), () {
          passCorrected = false;
          password.clear();
          update();
          Get.offAllNamed(Routes.mainScreen);
        });
      }
    }
  }

  String createHashPassword() {
    var bytes = utf8.encode(password.join());
    var pass = sha1.convert(bytes);
    return pass.toString();
  }

  createPassword(int value) async {
    if (password.length <= 3) {
      password.add(value);
      update();
    }
    if (password.length == 4) {
      int? userId = await getUserId();
      if (userId != null) {
        String pass = createHashPassword();
        var response = await _updateUserUseCase(UserParams(
          id: userId,
          hashedPassword: pass,
        ));
        if (response.data == null) {
          StaticMethods.showSnackBar(
            title: 'خطا!',
            description: 'خطایی در ثبت رمز عبور به وجود آمده است',
          );
          password.clear();
          update();
          return;
        } //
        else {
          Get.back();
          StaticMethods.showSnackBar(
            title: 'تبریک!',
            description: 'رمز عبور با موفقیت بروزرسانی شد',
            color: kLightGreenColor,
          );
        }
      } //
      else {
        password.clear();
        await Get.find<SettingController>().changeShowPassword(false);
        update();
        Get.back();
        StaticMethods.showSnackBar(
          title: 'خطا',
          description: 'ابتدا اطلاعات فروشگاه را وارد کنید',
        );
      }
    }
  }

  Future<int?> getUserId() async {
    var response = await _getUserByIdUseCase(0);
    return response.data?.id;
  }
}
