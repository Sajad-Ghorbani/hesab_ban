import 'package:animated_bottom_navigation/animated_bottom_navigation.dart';
import 'package:animations/animations.dart';
import 'package:hesab_ban/app/config/routes/app_pages.dart';
import 'package:hesab_ban/app/config/theme/app_colors.dart';
import 'package:hesab_ban/app/core/utils/constants.dart';
import 'package:hesab_ban/app/core/utils/static_methods.dart';
import 'package:hesab_ban/app/features/feature_home/presentation/controller/home_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hesab_ban/app/features/feature_setting/presentation/controller/setting_controller.dart';
import 'package:hesab_ban/app/features/feature_setting/presentation/widgets/app_drawer.dart';
import 'package:hesab_ban/app/features/feature_product/presentation/controller/product_controller.dart';
import 'package:iconsax/iconsax.dart';

class MainScreen extends GetView<HomeController> {
  const MainScreen({super.key});

  @override
  Widget build(BuildContext context) {
    bool isDark = Theme.of(context).brightness == Brightness.dark;
    return GetBuilder<HomeController>(
      builder: (_) {
        return PopScope(
          canPop: false,
          onPopInvoked: (didPop) {
            if (didPop) {
              return;
            }
            controller.willPop();
          },
          child: Scaffold(
            drawer: AppDrawer(
              userName: Get.find<SettingController>().storeName,
              // lastSignedIn: '2 دقیقه قبل',
            ),
            drawerEnableOpenDragGesture: false,
            body: Stack(
              fit: StackFit.expand,
              children: [
                PageTransitionSwitcher(
                  duration: const Duration(milliseconds: 400),
                  reverse: controller.reversScreensSlide,
                  transitionBuilder:
                      (child, primaryAnimation, secondaryAnimation) {
                    return SharedAxisTransition(
                      animation: primaryAnimation,
                      secondaryAnimation: secondaryAnimation,
                      transitionType: SharedAxisTransitionType.horizontal,
                      child: child,
                    );
                  },
                  child: controller.screens[controller.currentIndex],
                ),
                Positioned(
                  bottom: 0,
                  width: Get.width,
                  child: AnimatedBottomNavigation(
                    context: context,
                    items: [
                      TabItem(
                        icon: const Icon(Iconsax.home_2),
                        haveChildren: true,
                        activeColor: kGreyColor,
                        inActiveColor: kBlueColor,
                        children: [
                          TabChildrenItem(
                            icon: const Icon(
                              Iconsax.user_add,
                            ),
                            title: 'حساب جدید',
                            color: kBlueColor,
                            onTap: () {
                              Get.toNamed(Routes.createCustomerScreen);
                            },
                          ),
                          TabChildrenItem(
                            icon: const Icon(
                              Iconsax.money_2,
                            ),
                            title: 'ورود چک',
                            color: kBlueColor,
                            onTap: () {
                              Get.toNamed(Routes.createCheckScreen);
                            },
                          ),
                          TabChildrenItem(
                            icon: const Icon(
                              Iconsax.dollar_square,
                            ),
                            title: 'ورود وجه',
                            color: kBlueColor,
                            onTap: () {
                              Get.toNamed(Routes.createCashScreen);
                            },
                          ),
                        ],
                      ),
                      TabItem(
                        icon: const Icon(Iconsax.box_1),
                        haveChildren: true,
                        activeColor: kGreyColor,
                        inActiveColor: kPurpleColor,
                        children: [
                          TabChildrenItem(
                            icon: const Icon(
                              Iconsax.box_add,
                            ),
                            title: 'محصول جدید',
                            color: kPurpleColor,
                            onTap: () {
                              Get.toNamed(
                                Routes.createProductScreen,
                                parameters: {
                                  'categoryName': Constants.defaultCategoryName
                                },
                              );
                            },
                          ),
                          TabChildrenItem(
                            icon: const Icon(
                              Iconsax.folder_add,
                            ),
                            title: 'پوشه جدید',
                            color: kPurpleColor,
                            onTap: () {
                              StaticMethods.showSingleRowDialog(
                                title: 'ساخت پوشه جدید',
                                rowTitle: 'نام پوشه',
                                controller: Get.find<ProductController>()
                                    .categoryNameController,
                                onTap: () {
                                  Get.find<ProductController>()
                                      .addNewCategory();
                                },
                              );
                            },
                          ),
                        ],
                      ),
                      TabItem(
                        icon: const Icon(Iconsax.receipt_text),
                        activeColor: kGreyColor,
                        inActiveColor: kPinkColor,
                      ),
                      // TabItem(
                      //   icon: const Icon(Iconsax.graph),
                      //   haveChildren: true,
                      //   activeColor: kGreyColor,
                      //   inActiveColor: kGreenColor,
                      //   children: [
                      //     TabChildrenItem(
                      //       icon: const Icon(
                      //         Iconsax.chart,
                      //       ),
                      //       title: 'روزانه',
                      //       color: kGreenColor,
                      //       onTap: () {},
                      //     ),
                      //     TabChildrenItem(
                      //       icon: const Icon(
                      //         Iconsax.chart_2,
                      //       ),
                      //       title: 'هفتگی',
                      //       color: kGreenColor,
                      //       onTap: () {},
                      //     ),
                      //     TabChildrenItem(
                      //       icon: const Icon(
                      //         Iconsax.chart_square,
                      //       ),
                      //       title: 'ماهانه',
                      //       color: kGreenColor,
                      //       onTap: () {},
                      //     ),
                      //     TabChildrenItem(
                      //       icon: const Icon(
                      //         Iconsax.status_up,
                      //       ),
                      //       title: 'سالانه',
                      //       color: kGreenColor,
                      //       onTap: () {},
                      //     ),
                      //   ],
                      // ),
                    ],
                    backgroundGradient: LinearGradient(
                      colors: [
                        isDark
                            ? kDarkGreyColor.withOpacity(0.5)
                            : kWhiteBlueColor.withOpacity(0.5),
                        isDark
                            ? kSurfaceColor.withOpacity(0.5)
                            : kWhiteBlueColor.withOpacity(0.5),
                      ],
                    ),
                    borderRadius: const BorderRadius.all(Radius.circular(30)),
                    height: 60,
                    margin: const EdgeInsets.all(10),
                    animationDuration: const Duration(milliseconds: 200),
                    horizontalPadding: 30,
                    letIndexChange: (index) {
                      if (index > 2) {
                        return false;
                      }
                      return true;
                    },
                    onChanged: controller.changeIndex,
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
