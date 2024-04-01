import 'package:flutter/material.dart';
import 'package:flutter_flavor/flutter_flavor.dart';
import 'package:get/get.dart';
import 'package:hesab_ban/app/config/routes/app_pages.dart';
import 'package:hesab_ban/app/config/theme/app_colors.dart';
import 'package:hesab_ban/app/features/feature_setting/presentation/controller/setting_controller.dart';
import 'package:hesab_ban/app/features/feature_setting/presentation/widgets/drawer_item.dart';
import 'package:iconsax/iconsax.dart';
import 'package:share_plus/share_plus.dart';

class AppDrawer extends StatelessWidget {
  const AppDrawer({
    super.key,
    required this.userName,
    // required this.lastSignedIn,
  });
  final String userName;

  // final String lastSignedIn;

  @override
  Widget build(BuildContext context) {
    bool isDark = Theme.of(context).brightness == Brightness.dark;
    String appLink = FlavorConfig.instance.variables['appLink'];
    return Drawer(
      backgroundColor: isDark ? kSurfaceColor : kWhiteGreyColor,
      child: SafeArea(
        child: GetBuilder<SettingController>(
          builder: (controller) {
            return Padding(
              padding: const EdgeInsets.all(10),
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      GestureDetector(
                        onTap: () {
                          Scaffold.of(context).closeDrawer();
                        },
                        child: Icon(
                          Iconsax.close_circle5,
                          color: isDark ? Colors.grey.shade500 : kGreyColor,
                          size: 28,
                        ),
                      ),
                      Image.asset(
                        'assets/images/hesab_ban.png',
                        height: 30,
                      ),
                      GestureDetector(
                        onTap: () {
                          controller.changeTheme(
                              Theme.of(context).brightness != Brightness.light);
                        },
                        child: AnimatedCrossFade(
                          firstChild: const Icon(
                            Iconsax.moon5,
                            color: kGreyColor,
                            size: 28,
                          ),
                          secondChild: Icon(
                            Iconsax.sun_15,
                            color: Colors.grey.shade500,
                            size: 28,
                          ),
                          crossFadeState: controller.isLightTheme
                              ? CrossFadeState.showFirst
                              : CrossFadeState.showSecond,
                          duration: const Duration(milliseconds: 300),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 20),
                  Row(
                    children: [
                      ClipRRect(
                        borderRadius:
                            const BorderRadius.all(Radius.circular(12)),
                        child: controller.storeLogo.path == '-1'
                            ? Image.asset(
                                'assets/images/hesab_ban.png',
                                height: 50,
                              )
                            : Image.file(
                                controller.storeLogo,
                                height: 50,
                              ),
                      ),
                      const SizedBox(width: 10),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(userName),
                          const SizedBox(height: 10),
                          // Text('زمان آخرین ورود: $lastSignedIn'),
                        ],
                      ),
                    ],
                  ),
                  const SizedBox(height: 10),
                  const Divider(thickness: 2),
                  const SizedBox(height: 10),
                  DrawerItem(
                    icon: Iconsax.people,
                    title: 'دعوت از دوستان',
                    onTap: () {
                      Share.share(
                        'اپلیکیشن حسابداری حساب بان، مناسب برای افرادی که دسترسی به کامپیوتر یا لپتاپ ندارند.\n'
                        'میتوانید با موبایل فاکتور زده، چک ثبت کنید و حساب مشتری را چک کنید.\n'
                        'لینک دانلود:\n'
                        '$appLink\n'
                        'حساب بان حسابداری همراه',
                      );
                    },
                  ),
                  DrawerItem(
                    icon: Iconsax.teacher,
                    title: 'آکادمی',
                    onTap: () {
                      controller.showAcademy();
                    },
                  ),
                  DrawerItem(
                    icon: Iconsax.setting_2,
                    title: 'تنظیمات',
                    onTap: () {
                      Get.back();
                      Get.toNamed(Routes.settingScreen);
                    },
                  ),
                  DrawerItem(
                    icon: Iconsax.security_safe,
                    title: 'حریم خصوصی',
                    onTap: () {
                      Get.back();
                      Get.toNamed(Routes.privacyAndPolicyScreen);
                    },
                  ),
                  DrawerItem(
                    icon: Iconsax.headphone,
                    title: 'پشتیبانی',
                    onTap: () {
                      Get.back();
                      Get.defaultDialog(
                        title: 'ارتباط با پشتیبانی',
                        content: Column(
                          children: [
                            const Text(
                              'برای ارسال پیشنهادات و انتقادات خود\nمی توانید از طریق اپلیکیشن های زیر با ما\nدر ارتباط باشید.',
                              textAlign: TextAlign.center,
                              style: TextStyle(height: 1.5),
                            ),
                            const SizedBox(
                              height: 10,
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                GestureDetector(
                                  onTap: () {
                                    controller.openWhatsApp();
                                  },
                                  child: Image.asset(
                                    'assets/images/whatsapp_logo.png',
                                    width: 35,
                                  ),
                                ),
                                const SizedBox(width: 30),
                                GestureDetector(
                                  onTap: () {
                                    controller.openTelegram();
                                  },
                                  child: Image.asset(
                                    'assets/images/Telegram_logo.png',
                                    width: 35,
                                  ),
                                ),
                                const SizedBox(width: 30),
                                GestureDetector(
                                  onTap: () {
                                    controller.openBale();
                                  },
                                  child: Image.asset(
                                    'assets/images/Bale_logo.png',
                                    width: 35,
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      );
                    },
                  ),
                  const Spacer(),
                  Text(
                    'نسخه برنامه: ${controller.appVersion}',
                    style: Theme.of(context)
                        .textTheme
                        .bodyMedium!
                        .copyWith(color: kGreyColor),
                  ),
                  const SizedBox(height: 10),
                ],
              ),
            );
          },
        ),
      ),
    );
  }
}
