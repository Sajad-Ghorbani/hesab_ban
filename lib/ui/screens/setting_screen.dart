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
      child: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(
              height: 10,
            ),
            Center(
              child: ClipRRect(
                borderRadius: const BorderRadius.all(Radius.circular(50)),
                child: Image.asset(
                  'assets/images/hesab_ban.png',
                  width: 200,
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
                      children: const [
                        Icon(Icons.color_lens_rounded),
                        SizedBox(
                          width: 10,
                        ),
                        Text('تغییر تم برنامه'),
                        Spacer(),
                        Text('دارک'),
                        Switch(
                          value: false,
                          onChanged: null,
                        ),
                        Text('لایت'),
                      ],
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
                child: Obx(
                  () => Column(
                    children: [
                      SettingRowWidget(
                        onTap: () {
                          controller.setUserInfo(isName: true);
                        },
                        icon: Icons.text_snippet_rounded,
                        title: 'نام فروشگاه',
                        valueWidget: Text(controller.storeName.value),
                      ),
                      SettingRowWidget(
                        onTap: () {
                          controller.setUserInfo(isAddress: true);
                        },
                        icon: Icons.store_rounded,
                        title: 'آدرس فروشگاه',
                        valueWidget: Text(
                          controller.storeAddress.value.length < 15
                              ? controller.storeAddress.value
                              : '${controller.storeAddress.value.substring(0, 15)} ...',
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
                                width: 50,
                                height: 50,
                                fit: BoxFit.cover,
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
                    Row(
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
