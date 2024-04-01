import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hesab_ban/app/config/routes/app_pages.dart';
import 'package:hesab_ban/app/config/theme/app_colors.dart';
import 'package:hesab_ban/app/core/widgets/base_widget.dart';
import 'package:hesab_ban/app/features/feature_factor/presentation/widgets/select_factor_widget.dart';

class SelectFactorScreen extends StatelessWidget {
  const SelectFactorScreen({super.key});

  @override
  Widget build(BuildContext context) {
    bool isDark = Theme.of(context).brightness == Brightness.dark;
    return BaseWidget(
      titleText: 'فاکتور',
      showPaint: true,
      child: SingleChildScrollView(
        padding: const EdgeInsets.all(10),
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
                  parameters: {'type': 'sale'},
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
                  parameters: {'type': 'buy'},
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
                  parameters: {'type': 'returnOfSale'},
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
                  parameters: {'type': 'returnOfBuy'},
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
                  parameters: {'type': 'oneSale'},
                );
              },
            ),
            const SizedBox(height: 75),
          ],
        ),
      ),
    );
  }
}
