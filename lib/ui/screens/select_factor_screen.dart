import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hesab_ban/controllers/home_controller.dart';
import 'package:hesab_ban/models/factor_model.dart';
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
      child: Column(
        children: [
          const SizedBox(
            height: 30,
          ),
          Text(
            'لطفا فاکتور خود را انتحاب کنید.',
            style: Theme.of(context).textTheme.headline5,
          ),
          const SizedBox(
            height: 30,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              Obx(
                () => SelectFactorWidget(
                  factorName: 'فروش',
                  cardColor: kSurfaceColor,
                  detailList: const [
                    'ایجاد فاکتور فروش با طرف حساب',
                    'قابلیت پرداخت نقدی و مدت دار',
                    'فاکتور سربرگ دار',
                  ],
                  showHelp: controller.showSellHelp.value,
                  onFactorTap: () {
                    Get.toNamed(
                      Routes.factorScreen,
                      arguments: TypeOfFactor.sell,
                    );
                  },
                  showChanged: (value) {
                    controller.changeShowHelp(
                        'sellFactorHelp', controller.showSellHelp);
                  },
                ),
              ),
              Obx(
                () => SelectFactorWidget(
                  factorName: 'خرید',
                  cardColor: kDarkGreyColor,
                  detailList: const [
                    'ایجاد فاکتور خرید با طرف حساب',
                    'قابلیت پرداخت نقدی و مدت دار',
                    'فاکتور سربرگ دار',
                  ],
                  showHelp: controller.showBuyHelp.value,
                  onFactorTap: () {
                    Get.toNamed(
                      Routes.factorScreen,
                      arguments: TypeOfFactor.buy,
                    );
                  },
                  showChanged: (value) {
                    controller.changeShowHelp(
                        'buyFactorHelp', controller.showBuyHelp);
                  },
                ),
              ),
            ],
          ),
          const SizedBox(
            height: 10,
          ),
          Obx(
            () => SelectFactorWidget(
              factorName: 'خرده فروشی',
              cardColor: kGreyColor,
              detailList: const [
                'ایجاد فاکتور فروش بدون طرف حساب',
                'پرداخت فقط بصورت نقدی',
                'استفاده برای فروش سریع',
              ],
              showHelp: controller.showOneSellHelp.value,
              onFactorTap: () {
                Get.toNamed(
                  Routes.oneSellFactorScreen,
                  arguments: TypeOfFactor.oneSell,
                );
              },
              showChanged: (value) {
                controller.changeShowHelp(
                    'OneSellFactorHelp', controller.showOneSellHelp);
              },
            ),
          ),
        ],
      ),
    );
  }
}
