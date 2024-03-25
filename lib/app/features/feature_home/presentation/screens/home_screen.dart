import 'package:hesab_ban/app/config/routes/app_pages.dart';
import 'package:hesab_ban/app/config/theme/app_colors.dart';
import 'package:hesab_ban/app/core/utils/constants.dart';
import 'package:hesab_ban/app/core/widgets/base_widget.dart';
import 'package:hesab_ban/app/features/feature_check/data/models/check_model.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hesab_ban/app/features/feature_home/presentation/widgets/home_tab_widget.dart';
import 'package:hesab_ban/app/features/feature_home/presentation/controller/home_controller.dart';
import 'package:hesab_ban/app/features/feature_setting/presentation/controller/setting_controller.dart';
import 'package:iconsax/iconsax.dart';

class HomeScreen extends GetView<HomeController> {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    bool isDark = Theme.of(context).brightness == Brightness.dark;
    return GetBuilder<HomeController>(
      initState: (state) => Get.find<SettingController>().getAppVersion(),
      builder: (_) {
        return BaseWidget(
          title: Row(
            children: [
              GestureDetector(
                onTap: () {
                  Scaffold.of(context).openDrawer();
                },
                child: const Icon(Iconsax.category),
              ),
              const SizedBox(width: 10),
              Image.asset(
                'assets/images/hesab_ban.png',
                height: 24,
              ),
              const SizedBox(width: 10),
              const Text('حساب بان'),
            ],
          ),
          automaticallyImplyLeading: false,
          showPaint: true,
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(10),
            child: Column(
              children: [
                ClipRRect(
                  borderRadius: const BorderRadius.all(Radius.circular(12)),
                  child: AspectRatio(
                    aspectRatio: 16 / 9,
                    child: Image.asset(
                      'assets/images/hesab_ban_banner.jpg',
                      height: 200,
                      width: Get.width,
                    ),
                  ),
                ),
                const SizedBox(height: 20),
                Row(
                  children: [
                    Text(
                      'حواله ها',
                      style: Theme.of(context).textTheme.titleLarge,
                    ),
                    const SizedBox(width: 5),
                    Expanded(
                      child: Divider(
                        color: isDark ? Colors.white : Colors.black,
                        thickness: 1.2,
                      ),
                    )
                  ],
                ),
                const SizedBox(height: 10),
                Row(
                  children: [
                    HomeTabWidget(
                      title: 'چک های پرداختی',
                      color: isDark ? kDarkGreyColor : kWhiteRedColor,
                      onTap: () {
                        Get.toNamed(
                          Routes.allCheckScreen,
                          arguments: TypeOfCheck.send,
                        );
                      },
                    ),
                    const SizedBox(width: 10),
                    HomeTabWidget(
                      title: 'چک های دریافتی',
                      color: isDark ? kDarkGreyColor : kWhiteRedColor,
                      onTap: () {
                        Get.toNamed(
                          Routes.allCheckScreen,
                          arguments: TypeOfCheck.received,
                        );
                      },
                    ),
                  ],
                ),
                const SizedBox(height: 20),
                Row(
                  children: [
                    HomeTabWidget(
                      title: 'پرداخت های نقدی',
                      color: isDark ? kSurfaceColor : kWhiteBlueColor,
                      onTap: () {
                        Get.toNamed(
                          Routes.allCashScreen,
                          arguments: 'send',
                        );
                      },
                    ),
                    const SizedBox(width: 10),
                    HomeTabWidget(
                      title: 'دریافت های نقدی',
                      color: isDark ? kSurfaceColor : kWhiteBlueColor,
                      onTap: () {
                        Get.toNamed(
                          Routes.allCashScreen,
                          arguments: 'receive',
                        );
                      },
                    ),
                  ],
                ),
                const SizedBox(height: 20),
                Row(
                  children: [
                    Text(
                      'مشاهده فاکتورها',
                      style: Theme.of(context).textTheme.titleLarge,
                    ),
                    const SizedBox(width: 5),
                    Expanded(
                      child: Divider(
                        color: isDark ? Colors.white : Colors.black,
                        thickness: 1.2,
                      ),
                    )
                  ],
                ),
                const SizedBox(height: 10),
                Row(
                  children: [
                    HomeTabWidget(
                      title: 'فروش',
                      color: isDark ? kDarkGreyColor : kWhiteRedColor,
                      onTap: () {
                        Get.toNamed(Routes.allFactorScreen, arguments: 'sale');
                      },
                    ),
                    const SizedBox(width: 10),
                    HomeTabWidget(
                      title: 'خرید',
                      color: isDark ? kDarkGreyColor : kWhiteRedColor,
                      onTap: () {
                        Get.toNamed(Routes.allFactorScreen, arguments: 'buy');
                      },
                    ),
                  ],
                ),
                const SizedBox(height: 20),
                Row(
                  children: [
                    HomeTabWidget(
                      title: 'برگشت از فروش',
                      color: isDark ? kSurfaceColor : kWhiteBlueColor,
                      onTap: () {
                        Get.toNamed(Routes.allFactorScreen,
                            arguments: 'returnOfSale');
                      },
                    ),
                    const SizedBox(width: 10),
                    HomeTabWidget(
                      title: 'برگشت از خرید',
                      color: isDark ? kSurfaceColor : kWhiteBlueColor,
                      onTap: () {
                        Get.toNamed(Routes.allFactorScreen,
                            arguments: 'returnOfBuy');
                      },
                    ),
                  ],
                ),
                const SizedBox(height: 20),
                Row(
                  children: [
                    HomeTabWidget(
                      title: 'خرده فروشی',
                      color: isDark ? kDarkGreyColor : kWhiteRedColor,
                      onTap: () {
                        Get.toNamed(Routes.allFactorScreen,
                            arguments: 'oneSale');
                      },
                    ),
                  ],
                ),
                const SizedBox(height: 20),
                Row(
                  children: [
                    Text(
                      'مشتریان',
                      style: Theme.of(context).textTheme.titleLarge,
                    ),
                    const SizedBox(width: 5),
                    Expanded(
                      child: Divider(
                        color: isDark ? Colors.white : Colors.black,
                        thickness: 1.2,
                      ),
                    )
                  ],
                ),
                const SizedBox(height: 10),
                Row(
                  children: [
                    HomeTabWidget(
                      title: 'بدهکاران',
                      color: isDark ? kSurfaceColor : kWhiteBlueColor,
                      onTap: () {
                        Get.toNamed(
                          Routes.allCustomerScreen,
                          parameters: {'type': Constants.debtorType},
                        );
                      },
                    ),
                    const SizedBox(width: 10),
                    HomeTabWidget(
                      title: 'بستانکاران',
                      color: isDark ? kSurfaceColor : kWhiteBlueColor,
                      onTap: () {
                        Get.toNamed(
                          Routes.allCustomerScreen,
                          parameters: {'type': Constants.creditorType},
                        );
                      },
                    ),
                  ],
                ),
                const SizedBox(height: 75),
              ],
            ),
          ),
        );
      },
    );
  }
}
