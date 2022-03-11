import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import 'package:hesab_ban/controllers/factor_controller.dart';
import 'package:hesab_ban/ui/theme/constants_app_styles.dart';
import 'package:hesab_ban/ui/widgets/base_widget.dart';
import 'package:hesab_ban/ui/widgets/factor_container_widget.dart';
import 'package:hesab_ban/ui/widgets/grid_menu_widget.dart';
import 'package:persian_number_utility/persian_number_utility.dart';

import '../../controllers/home_controller.dart';
import '../theme/app_colors.dart';

class OneSellFactorScreen extends GetView<FactorController> {
  const OneSellFactorScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        return controller.willPop();
      },
      child: BaseWidget(
        title: 'فاکتور خرده فروشی',
        appBarLeading: IconButton(
          onPressed: () {
            if (controller.willPop()) Get.back();
          },
          icon: const Icon(Icons.arrow_back_ios),
          splashRadius: 30,
        ),
        appBarActions: [
          IconButton(
            onPressed: () {
              controller.saveFactor();
            },
            icon: const Icon(FontAwesomeIcons.solidSave),
            splashRadius: 30,
            color: kGreenColor,
          ),
        ],
        child: Stack(
          fit: StackFit.expand,
          children: [
            CustomScrollView(
              slivers: [
                SliverToBoxAdapter(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        height: 80,
                        padding: const EdgeInsets.all(10),
                        decoration: const BoxDecoration(
                          gradient: LinearGradient(
                              colors: [
                                kBlueColor,
                                kDarkGreyColor,
                              ],
                              begin: Alignment.centerRight,
                              end: Alignment.centerLeft,
                              stops: [0, 0.7]),
                        ),
                        child: Row(
                          children: [
                            const Text('شماره فاکتور:'),
                            const SizedBox(
                              width: 10,
                            ),
                            Text('#${controller.factorNumber}'),
                            const Spacer(),
                            const Text('تاریخ:'),
                            const SizedBox(
                              width: 10,
                            ),
                            Text(
                              DateTime.now().toPersianDate(),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(
                        height: 10,
                      ),
                      Container(
                        margin: const EdgeInsets.symmetric(horizontal: 10),
                        child: GridMenuWidget(
                          title: 'انتخاب کالا',
                          onTap: () {
                            controller.selectProduct(context);
                          },
                        ),
                      ),
                      const SizedBox(
                        height: 10,
                      ),
                    ],
                  ),
                ),
                const FactorContainerWidget(),
                const SliverToBoxAdapter(
                  child: SizedBox(
                    height: 75,
                  ),
                ),
              ],
            ),
            Obx(
              () => controller.factorSum.value == '-1'
                  ? const SizedBox.shrink()
                  : Positioned(
                      bottom: 10,
                      right: 10,
                      left: 10,
                      child: ClipRRect(
                        borderRadius: const BorderRadius.all(
                          Radius.circular(15),
                        ),
                        child: BackdropFilter(
                          filter: ImageFilter.blur(sigmaY: 5, sigmaX: 5),
                          child: Container(
                            padding: const EdgeInsets.all(15),
                            decoration: BoxDecoration(
                              color: kGreyColor.withOpacity(0.3),
                              borderRadius: const BorderRadius.all(
                                Radius.circular(15),
                              ),
                            ),
                            child: Row(
                              children: [
                                const Text('#'),
                                const SizedBox(
                                  width: 5,
                                ),
                                const Text('جمع کل'),
                                const Spacer(),
                                Text(controller.factorSum.value.seRagham()),
                                const SizedBox(
                                  width: 5,
                                ),
                                Text(
                                  Get.find<HomeController>().moneyUnit.value,
                                  style: kRialTextStyle,
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ),
            ),
          ],
        ),
      ),
    );
  }
}
