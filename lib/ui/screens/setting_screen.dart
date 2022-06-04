import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import 'package:hesab_ban/controllers/home_controller.dart';
import 'package:hesab_ban/routes/app_pages.dart';
import 'package:hesab_ban/ui/theme/app_colors.dart';
import 'package:hesab_ban/ui/widgets/base_widget.dart';
import 'package:hesab_ban/ui/widgets/box_container_widget.dart';
import 'package:hesab_ban/ui/widgets/setting_row_widget.dart';

class SettingScreen extends GetView<HomeController> {
  const SettingScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BaseWidget(
      title: 'تنظیمات',
      showPaint: true,
      child: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(
              height: 10,
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 10),
              child: Text(
                'تنظیمات عمومی',
                style: TextStyle(
                  fontSize: 14,
                  color: Theme.of(context)
                      .colorScheme
                      .onBackground
                      .withOpacity(0.6),
                ),
              ),
            ),
            BoxContainerWidget(
              child: Container(
                margin:
                    const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                child: Column(
                  children: [
                    Row(
                      children: [
                        const Icon(
                          FontAwesomeIcons.dollarSign,
                          size: 24,
                        ),
                        const SizedBox(
                          width: 7,
                        ),
                        const Text('واحد پول'),
                        const Spacer(),
                        const Text('تومان'),
                        Obx(
                          () => Switch(
                            value: controller.moneyUnitChange.value,
                            activeColor: kTealColor,
                            inactiveThumbColor: kTealColor,
                            inactiveTrackColor: kWhiteColor.withOpacity(0.8),
                            activeTrackColor: kWhiteColor.withOpacity(0.5),
                            onChanged: (value) {
                              controller.changeMoneyUnit(value);
                            },
                          ),
                        ),
                        const Text('ریال'),
                      ],
                    ),
                    Row(
                      children: [
                        const Icon(Icons.color_lens_rounded),
                        const SizedBox(
                          width: 10,
                        ),
                        const Text('تغییر تم برنامه'),
                        const Spacer(),
                        const Text('دارک'),
                        Obx(
                          () => Switch(
                            value: controller.theme.value,
                            activeColor: kTealColor,
                            inactiveThumbColor: kTealColor,
                            inactiveTrackColor: kWhiteColor.withOpacity(0.8),
                            activeTrackColor: kWhiteColor.withOpacity(0.5),
                            onChanged: (bool value){
                              controller.changeTheme(value);
                            },
                          ),
                        ),
                        const Text('لایت'),
                      ],
                    ),
                    Obx(
                      () => SettingRowWidget(
                        onTap: () {
                          controller.setNotificationTime(context);
                        },
                        icon: Icons.notifications_active,
                        title: 'زمان دریافت اعلان چک',
                        valueWidget: Text(
                            '${controller.minutesNotification.value} : ${controller.hoursNotification.value}'),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(
              height: 10,
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 10),
              child: Text(
                'تنظیمات فروشگاه',
                style: TextStyle(
                  fontSize: 14,
                  color: Theme.of(context)
                      .colorScheme
                      .onBackground
                      .withOpacity(0.6),
                ),
              ),
            ),
            BoxContainerWidget(
              child: Container(
                margin:
                    const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
                child: Obx(
                  () => Column(
                    children: [
                      SettingRowWidget(
                        onTap: () {
                          controller.setUserInfo(isName: true);
                        },
                        icon: Icons.text_snippet_rounded,
                        title: 'نام فروشگاه',
                        valueWidget: Expanded(
                          flex: 3,
                          child: Text(
                            controller.storeName.value,
                            overflow: TextOverflow.ellipsis,
                            textAlign: TextAlign.left,
                          ),
                        ),
                      ),
                      SettingRowWidget(
                        onTap: () {
                          controller.setUserInfo(isAddress: true);
                        },
                        icon: Icons.store_rounded,
                        title: 'آدرس فروشگاه',
                        valueWidget: Expanded(
                          flex: 3,
                          child: Text(
                            controller.storeAddress.value,
                            overflow: TextOverflow.ellipsis,
                            textAlign: TextAlign.left,
                          ),
                        ),
                      ),
                      SettingRowWidget(
                        onTap: () {
                          controller.setUserInfo(isLogo: true);
                        },
                        icon: Icons.image_rounded,
                        title: 'لوگو فروشگاه',
                        valueWidget: controller.storeLogo.value.path == '-1'
                            ? const SizedBox.shrink()
                            : Image.file(
                                controller.storeLogo.value,
                                width: 80,
                                height: 80,
                                fit: BoxFit.contain,
                              ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
            BoxContainerWidget(
              child: Container(
                margin:
                    const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
                child: Column(
                  children: [
                    SettingRowWidget(
                      onTap: () {
                        Get.toNamed(Routes.backupScreen);
                      },
                      icon: Icons.restore,
                      title: 'پشتیبان گیری و بازیابی اطلاعات',
                    ),
                    SettingRowWidget(
                      onTap: () {
                        Get.toNamed(Routes.privacyAndPolicyScreen);
                      },
                      icon: Icons.privacy_tip_rounded,
                      title: 'حریم خصوصی',
                    ),
                  ],
                ),
              ),
            ),
            BoxContainerWidget(
              child: Container(
                margin:
                    const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
                child: Row(
                  children: [
                    const Expanded(
                      child: Text(
                        'برای ارسال پیشنهادات و انتقادات خود می توانید از طریق واتساپ با ما در ارتباط باشید.',
                        style: TextStyle(height: 1.5),
                      ),
                    ),
                    const SizedBox(
                      width: 20,
                    ),
                    GestureDetector(
                      onTap: () {
                        controller.openWhatsApp();
                      },
                      child: Image.asset(
                        'assets/images/whatsapp.png',
                        width: 35,
                      ),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(
              height: 75,
            ),
          ],
        ),
      ),
    );
  }
}
