import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hesab_ban/controllers/home_controller.dart';
import 'package:hesab_ban/data/models/factor_model.dart';
import 'package:hesab_ban/routes/app_pages.dart';
import 'package:hesab_ban/ui/widgets/base_widget.dart';
import 'package:hesab_ban/ui/widgets/select_factor_widget.dart';

import '../theme/app_colors.dart';

class SelectFactorScreen extends GetView<HomeController> {
  const SelectFactorScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    bool isDark = Theme.of(context).brightness == Brightness.dark;
    return BaseWidget(
      title: 'فاکتور',
      showPaint: true,
      child: SingleChildScrollView(
        padding: const EdgeInsets.fromLTRB(10, 10, 10, 75),
        child: Column(
          children: [
            SelectFactorWidget(
              factorName: 'فروش',
              cardColor: isDark ? kSurfaceColor : kWhiteBlueColor,
              detailList: const [
                'ایجاد فاکتور فروش با طرف حساب',
                'قابلیت پرداخت نقدی و مدت دار',
                'فاکتور سربرگ دار',
              ],
              onFactorTap: () {
                Get.toNamed(
                  Routes.factorScreen,
                  arguments: TypeOfFactor.sale,
                );
              },
            ),
            const SizedBox(height: 20),
            SelectFactorWidget(
              factorName: 'خرید',
              cardColor: isDark ? kDarkGreyColor : kWhiteRedColor,
              detailList: const [
                'ایجاد فاکتور خرید با طرف حساب',
                'قابلیت پرداخت نقدی و مدت دار',
                'فاکتور سربرگ دار',
              ],
              onFactorTap: () {
                Get.toNamed(
                  Routes.factorScreen,
                  arguments: TypeOfFactor.buy,
                );
              },
            ),
            const SizedBox(height: 20),
            SelectFactorWidget(
              factorName: 'برگشت از فروش',
              cardColor: isDark ? kSurfaceColor : kWhiteBlueColor,
              detailList: const [
                'ایجاد فاکتور برگشت از فروش',
                'قابلیت پرداخت نقدی و مدت دار',
                'فاکتور سربرگ دار',
              ],
              onFactorTap: () {
                Get.toNamed(
                  Routes.factorScreen,
                  arguments: TypeOfFactor.returnOfSale,
                );
              },
            ),
            const SizedBox(height: 20),
            SelectFactorWidget(
              factorName: 'برگشت از خرید',
              cardColor: isDark ? kDarkGreyColor : kWhiteRedColor,
              detailList: const [
                'ایجاد فاکتور برگشت از خرید',
                'قابلیت پرداخت نقدی و مدت دار',
                'فاکتور سربرگ دار',
              ],
              onFactorTap: () {
                Get.toNamed(
                  Routes.factorScreen,
                  arguments: TypeOfFactor.returnOfBuy,
                );
              },
            ),
            const SizedBox(height: 20),
            SelectFactorWidget(
              factorName: 'خرده فروشی',
              cardColor: isDark ? kSurfaceColor : kWhiteBlueColor,
              detailList: const [
                'ایجاد فاکتور فروش بدون طرف حساب',
                'پرداخت فقط بصورت نقدی',
                'استفاده برای فروش سریع',
              ],
              onFactorTap: () {
                Get.toNamed(
                  Routes.oneSaleFactorScreen,
                  arguments: TypeOfFactor.oneSale,
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
