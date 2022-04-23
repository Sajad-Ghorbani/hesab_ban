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
    return BaseWidget(
      title: 'فاکتور',
      child: SingleChildScrollView(
        padding: const EdgeInsets.only(top: 10,bottom: 75),
        child:Wrap(
          alignment: WrapAlignment.spaceEvenly,
          crossAxisAlignment: WrapCrossAlignment.end,
          runSpacing: 10,
          children: [
            SelectFactorWidget(
              factorName: 'فروش',
              lottieAddress: 'assets/images/saleLottie.json',
              cardColor: kSurfaceColor,
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
            SelectFactorWidget(
              factorName: 'خرید',
              lottieAddress: 'assets/images/buyLottie.json',
              cardColor: kDarkGreyColor,
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
            SelectFactorWidget(
              factorName: 'برگشت از خرید',
              lottieAddress: 'assets/images/buyLottie.json',
              cardColor: kDarkGreyColor,
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
            SelectFactorWidget(
              factorName: 'برگشت از فروش',
              lottieAddress: 'assets/images/saleLottie.json',
              cardColor: kSurfaceColor,
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
            SelectFactorWidget(
              factorName: 'خرده فروشی',
              lottieAddress: 'assets/images/saleLottie.json',
              cardColor: kGreyColor,
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
