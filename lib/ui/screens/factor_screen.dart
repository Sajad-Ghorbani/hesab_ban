import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import 'package:hesab_ban/controllers/factor_controller.dart';
import 'package:hesab_ban/models/factor_model.dart';
import 'package:hesab_ban/static_methods.dart';
import 'package:hesab_ban/ui/widgets/base_widget.dart';
import 'package:persian_number_utility/persian_number_utility.dart';

import '../../controllers/home_controller.dart';
import '../theme/app_colors.dart';
import '../theme/constants_app_styles.dart';
import '../widgets/factor_container_widget.dart';
import '../widgets/grid_menu_widget.dart';

class FactorScreen extends GetView<FactorController> {
  const FactorScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        return controller.willPop();
      },
      child: BaseWidget(
        title: StaticMethods.setTypeFactorString(controller.typeOfFactor),
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
              controller.saveToBill();
            },
            icon: const Icon(FontAwesomeIcons.check),
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
                        height: 120,
                        padding: const EdgeInsets.symmetric(
                            horizontal: 10, vertical: 20),
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                              colors: [
                                controller.typeOfFactor == TypeOfFactor.buy ||
                                        controller.typeOfFactor ==
                                            TypeOfFactor.returnOfSale
                                    ? kRedColor
                                    : kDarkGreenColor,
                                kDarkGreyColor,
                              ],
                              begin: Alignment.centerRight,
                              end: Alignment.centerLeft,
                              stops: const [0, 0.7]),
                        ),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Row(
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
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(controller.typeOfFactor ==
                                            TypeOfFactor.buy ||
                                        controller.typeOfFactor ==
                                            TypeOfFactor.returnOfBuy
                                    ? 'فروشنده:'
                                    : 'خریدار:'),
                                Obx(
                                  () => GestureDetector(
                                    onTap: () {
                                      controller.selectCustomer();
                                    },
                                    child: controller.customerSelected.value
                                        ? Text(controller.customer.value.name!)
                                        : Container(
                                            padding: const EdgeInsets.symmetric(
                                                vertical: 5, horizontal: 10),
                                            decoration: const BoxDecoration(
                                              color: kPinkColor,
                                              borderRadius: BorderRadius.all(
                                                Radius.circular(15),
                                              ),
                                            ),
                                            child: Row(
                                              children: const [
                                                Icon(Icons.add),
                                                Text('افزودن')
                                              ],
                                            ),
                                          ),
                                  ),
                                ),
                              ],
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
                    height: 150,
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
                            child: Column(
                              children: [
                                Row(
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
                                      Get.find<HomeController>()
                                          .moneyUnit
                                          .value,
                                      style: kRialTextStyle,
                                    ),
                                  ],
                                ),
                                const SizedBox(
                                  height: 10,
                                ),
                                Row(
                                  children: [
                                    const Text('پرداخت نقدی'),
                                    const Spacer(),
                                    Material(
                                      borderRadius: const BorderRadius.all(
                                        Radius.circular(10),
                                      ),
                                      color: kDarkGreyColor,
                                      child: InkWell(
                                        borderRadius: const BorderRadius.all(
                                          Radius.circular(10),
                                        ),
                                        onTap: () {
                                          controller.cashPaymentTapped();
                                        },
                                        child: Container(
                                          padding: const EdgeInsets.symmetric(
                                              vertical: 5, horizontal: 10),
                                          alignment: Alignment.center,
                                          child: Text(
                                            controller.cashAmount.value
                                                .toString()
                                                .seRagham(),
                                            textDirection: TextDirection.ltr,
                                          ),
                                        ),
                                      ),
                                    ),
                                    const SizedBox(
                                      width: 5,
                                    ),
                                    Text(
                                      Get.find<HomeController>()
                                          .moneyUnit
                                          .value,
                                      style: kRialTextStyle,
                                    ),
                                  ],
                                ),
                                const SizedBox(
                                  height: 10,
                                ),
                                Row(
                                  children: [
                                    const Text('پرداخت چکی'),
                                    const Spacer(),
                                    Material(
                                      borderRadius: const BorderRadius.all(
                                        Radius.circular(10),
                                      ),
                                      color: kDarkGreyColor,
                                      child: InkWell(
                                        borderRadius: const BorderRadius.all(
                                          Radius.circular(10),
                                        ),
                                        onTap: () {
                                          controller.checkPaymentTapped();
                                        },
                                        child: Container(
                                          padding: const EdgeInsets.symmetric(
                                              vertical: 5, horizontal: 10),
                                          alignment: Alignment.center,
                                          child: Text(
                                            controller.checkAmount.value
                                                .toString()
                                                .seRagham(),
                                            textDirection: TextDirection.ltr,
                                          ),
                                        ),
                                      ),
                                    ),
                                    const SizedBox(
                                      width: 5,
                                    ),
                                    Text(
                                      Get.find<HomeController>()
                                          .moneyUnit
                                          .value,
                                      style: kRialTextStyle,
                                    ),
                                  ],
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
