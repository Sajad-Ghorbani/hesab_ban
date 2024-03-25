import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hesab_ban/app/core/params/check_params.dart';
import 'package:hesab_ban/app/core/widgets/base_widget.dart';
import 'package:hesab_ban/app/core/widgets/box_container_widget.dart';
import 'package:hesab_ban/app/core/widgets/scroll_to_up.dart';
import 'package:hesab_ban/app/features/feature_factor/presentation/controller/factor_controller.dart';
import 'package:hesab_ban/app/features/feature_factor/presentation/widgets/cash_widget.dart';
import 'package:hesab_ban/app/features/feature_factor/presentation/widgets/check_widget.dart';
import 'package:iconsax/iconsax.dart';

class AmountsScreen extends GetView<FactorController> {
  const AmountsScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    String typeOfAmounts = Get.parameters['type_of_amounts']!;
    bool type = typeOfAmounts == 'send';
    return BaseWidget(
      titleText: type ? 'پرداختی ها' : 'دریافتی ها',
      showLeading: true,
      appBarLeading: IconButton(
        onPressed: () {
          Get.back();
        },
        icon: const Icon(Iconsax.arrow_right_3),
        color: Colors.white,
        splashRadius: 30,
      ),
      child: ScrollToUp(
        showFab: controller.amountScreenShowFab,
        scrollController: controller.amountScreenScrollController,
        showLeftButton: true,
        hideBottomSheet: true,
        showMultiLeftButton: true,
        firstIconOnTap: () {
          controller.addCheck(typeOfAmounts);
        },
        secondIconOnTap: () {
          controller.addCash(typeOfAmounts);
        },
        firstIcon: Iconsax.money_2,
        secondIcon: Iconsax.dollar_square,
        leftIcon: const Icon(Iconsax.add_square),
        child: GetBuilder<FactorController>(
          builder: (controller) {
            if (controller.cashList.isEmpty && controller.checkList.isEmpty) {
              return Center(
                child: BoxContainerWidget(
                  child: Container(
                    padding: const EdgeInsets.symmetric(vertical: 30),
                    width: Get.width,
                    child: Text(
                      'هیچ مبلغ ${type ? 'پرداختی' : 'دریافتی'} وارد نشده است.',
                      textAlign: TextAlign.center,
                    ),
                  ),
                ),
              );
            }
            List moneys = [
              ...controller.checkList,
              ...controller.cashList,
            ];
            return CustomScrollView(
              controller: controller.amountScreenScrollController,
              slivers: [
                SliverList(
                  delegate: SliverChildBuilderDelegate(
                    childCount: moneys.length,
                    (context, index) {
                      var money = moneys[index];
                      bool isCheck = money is CheckParams;
                      return body(
                        money,
                        isCheck: isCheck,
                        type: type,
                        typeOfAmounts: typeOfAmounts,
                      );
                    },
                  ),
                ),
              ],
            );
          },
        ),
      ),
    );
  }

  Widget body(money,
      {required bool isCheck,
      required bool type,
      required String typeOfAmounts}) {
    if (isCheck) {
      String imageAddress = controller.getImageAddress(money.checkBank!);
      return CheckWidget(
        type: type,
        customerName: controller.customer.name!,
        check: money,
        imageAddress: imageAddress,
        onEditMenuTap: () {
          controller.onEditeMenuTap(money, typeOfAmounts);
        },
        onDeleteMenuTap: () {
          controller.onDeleteMenuTap(money);
        },
      );
    }
    return CashWidget(
      type: type,
      customerName: controller.customer.name!,
      money: money,
      onEditMenuTap: () {
        controller.onEditeMenuTap(money, typeOfAmounts);
      },
      onDeleteMenuTap: () {
        controller.onDeleteMenuTap(money);
      },
    );
  }
}
