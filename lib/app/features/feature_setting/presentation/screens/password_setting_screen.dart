import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hesab_ban/app/config/routes/app_pages.dart';
import 'package:hesab_ban/app/core/widgets/base_widget.dart';
import 'package:hesab_ban/app/core/widgets/box_container_widget.dart';
import 'package:hesab_ban/app/core/widgets/setting_row_widget.dart';
import 'package:hesab_ban/app/features/feature_setting/presentation/controller/setting_controller.dart';
import 'package:iconsax/iconsax.dart';

class PasswordSettingScreen extends StatelessWidget {
  const PasswordSettingScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return GetBuilder<SettingController>(
      builder: (controller) {
        return BaseWidget(
          showLeading: true,
          title: const Text('تنظیمات رمز عبور'),
          child: Column(
            children: [
              BoxContainerWidget(
                backBlur: false,
                child: Padding(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                  child: Column(
                    children: [
                      SettingRowWidget(
                        icon: Iconsax.key_square,
                        title: 'رمز عبور برای ورود به برنامه',
                        valueWidget: Checkbox(
                          value: controller.showPasswordScreen,
                          onChanged: (value) {
                            controller.changeShowPassword(value!);
                          },
                        ),
                      ),
                      SettingRowWidget(
                        onTap: () {
                          Get.toNamed(Routes.changePasswordScreen);
                        },
                        icon: Iconsax.lock,
                        title: 'تغییر رمز عبور',
                        isActive: controller.showPasswordScreen,
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
