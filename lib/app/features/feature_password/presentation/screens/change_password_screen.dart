import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hesab_ban/app/features/feature_password/presentation/controller/password_controller.dart';
import 'package:hesab_ban/app/features/feature_password/presentation/widgets/pass_bullet_widget.dart';
import 'package:hesab_ban/app/features/feature_password/presentation/widgets/pass_key_widget.dart';
import 'package:hesab_ban/app/features/feature_setting/presentation/controller/setting_controller.dart';
import 'package:iconsax/iconsax.dart';

class ChangePasswordScreen extends StatelessWidget {
  const ChangePasswordScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return GetBuilder<PasswordController>(
      builder: (controller) {
        return PopScope(
          onPopInvoked: (_) async {
            if (controller.password.length < 4) {
              await Get.find<SettingController>().changeShowPassword(false);
            }
          },
          child: Scaffold(
            body: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  'رمز عبور خود را وارد کنید',
                  style: Theme.of(context).textTheme.titleLarge,
                ),
                const SizedBox(height: 40),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: List.generate(
                    4,
                    (index) {
                      return PassBulletWidget(
                        color: index + 1 <= controller.password.length
                            ? Colors.black45
                            : null,
                      );
                    },
                  ),
                ),
                const SizedBox(height: 30),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: List.generate(3, (index) {
                    return PassKeyWidget(
                      num: index + 1,
                      onTap: (value) {
                        controller.createPassword(value!);
                      },
                    );
                  }),
                ),
                const SizedBox(height: 20),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: List.generate(3, (index) {
                    return PassKeyWidget(
                      num: index + 4,
                      onTap: (value) {
                        controller.createPassword(value!);
                      },
                    );
                  }),
                ),
                const SizedBox(height: 20),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: List.generate(3, (index) {
                    return PassKeyWidget(
                      num: index + 7,
                      onTap: (value) {
                        controller.createPassword(value!);
                      },
                    );
                  }),
                ),
                const SizedBox(height: 20),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    PassKeyWidget(
                      icon: Icon(
                        Iconsax.tag_cross,
                        color: Theme.of(context).colorScheme.onPrimary,
                        size: 30,
                      ),
                      onTap: (value) {
                        if (controller.password.isNotEmpty) {
                          controller.password.removeLast();
                          controller.update();
                        }
                      },
                    ),
                    PassKeyWidget(
                      num: 0,
                      onTap: (value) {
                        controller.createPassword(value!);
                      },
                    ),
                    const SizedBox(width: 80, height: 60),
                  ],
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
