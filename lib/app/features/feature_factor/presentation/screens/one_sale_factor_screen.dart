import 'dart:ui';

import 'package:currency_text_input_formatter/currency_text_input_formatter.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hesab_ban/app/config/theme/app_colors.dart';
import 'package:hesab_ban/app/config/theme/constants_app_styles.dart';
import 'package:hesab_ban/app/core/utils/extensions.dart';
import 'package:hesab_ban/app/core/utils/primitive_factor.dart';
import 'package:hesab_ban/app/core/utils/static_methods.dart';
import 'package:hesab_ban/app/core/widgets/base_widget.dart';
import 'package:hesab_ban/app/core/widgets/confirm_button.dart';
import 'package:hesab_ban/app/features/feature_factor/domain/entities/factor_entity.dart';
import 'package:hesab_ban/app/features/feature_factor/presentation/controller/factor_controller.dart';
import 'package:hesab_ban/app/features/feature_factor/presentation/widgets/factor_container_widget.dart';
import 'package:hesab_ban/app/features/feature_factor/presentation/widgets/factor_footer_row.dart';
import 'package:hesab_ban/app/features/feature_setting/presentation/controller/setting_controller.dart';
import 'package:iconsax/iconsax.dart';
import 'package:persian_number_utility/persian_number_utility.dart';

class OneSaleFactorScreen extends StatefulWidget {
  const OneSaleFactorScreen({super.key});

  @override
  State<OneSaleFactorScreen> createState() => _OneSaleFactorScreenState();
}

class _OneSaleFactorScreenState extends State<OneSaleFactorScreen> {
  String typeOfFactor = '';
  FactorEntity? factor;
  FactorController controller = Get.put(
    FactorController(
      Get.find(),
      Get.find(),
      Get.find(),
      Get.find(),
    ),
  );

  PrimitiveFactor? _primitiveFactor;

  @override
  void initState() {
    super.initState();
    typeOfFactor = Get.parameters['type']!;
    factor = Get.arguments;
    if (factor != null) {
      controller.initialForUpdate(factor!);
      _primitiveFactor = PrimitiveFactor.fromEntity(factor!);
    }
  }

  @override
  Widget build(BuildContext context) {
    return GetBuilder<FactorController>(
      builder: (controller) {
        return PopScope(
          canPop: false,
          onPopInvoked: (didPop) {
            if (didPop) {
              return;
            }
            controller.backFactorScreen(factor, _primitiveFactor);
          },
          child: BaseWidget(
            titleText: 'فاکتور خرده فروشی',
            showLeading: true,
            appBarLeading: IconButton(
              onPressed: () {
                controller.backFactorScreen(factor, _primitiveFactor);
              },
              icon: const Icon(Iconsax.arrow_right_3),
              color: Colors.white,
              splashRadius: 30,
            ),
            appBarActions: [
              GestureDetector(
                onTap: () async {
                  await controller.selectProduct(context, typeOfFactor);
                },
                child: const Icon(
                  Iconsax.add_circle,
                  color: kGreenColor,
                ),
              ),
              IconButton(
                onPressed: () {
                  if (factor != null) {
                    controller.updateFactor(
                      _primitiveFactor!,
                      typeOfFactor,
                      factor!,
                    );
                  } //
                  else {
                    controller.saveFactor(typeOfFactor);
                  }
                },
                icon: const Icon(Iconsax.tick_circle),
                splashRadius: 30,
                color: kGreenColor,
              ),
            ],
            child: Stack(
              fit: StackFit.expand,
              children: [
                Column(
                  children: [
                    Container(
                      height: 80,
                      padding: const EdgeInsets.all(10),
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                            colors: [
                              kBlueColor,
                              Get.isDarkMode ? kDarkGreyColor : kWhiteGreyColor,
                            ],
                            begin: Alignment.centerRight,
                            end: Alignment.centerLeft,
                            stops: const [0, 0.7]),
                      ),
                      child: Row(
                        children: [
                          const Text('شماره فاکتور:'),
                          const SizedBox(width: 10),
                          Text('#${controller.factorNumber}'),
                          const Spacer(),
                          const Text('تاریخ:'),
                          const SizedBox(width: 10),
                          GetBuilder<FactorController>(
                            builder: (_) {
                              return GestureDetector(
                                onTap: () {
                                  controller.selectDate(context);
                                },
                                child: Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Text(
                                    controller.factorDateLabel == '-1'
                                        ? DateTime.now().toPersianDate()
                                        : controller.factorDateLabel,
                                  ),
                                ),
                              );
                            },
                          ),
                        ],
                      ),
                    ),
                    Expanded(
                      child: SingleChildScrollView(
                        child: Column(
                          children: [
                            FactorContainerWidget(typeOfFactor),
                            SizedBox(
                              height: 165 - controller.getFooterHeight(),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
                controller.factorSum <= 0
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
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 15, vertical: 10),
                              decoration: BoxDecoration(
                                color: kGreyColor.withOpacity(0.3),
                                borderRadius: const BorderRadius.all(
                                  Radius.circular(15),
                                ),
                              ),
                              child: Column(
                                children: [
                                  if (controller.showTax) ...[
                                    FactorFooterRow(
                                      title: 'مالیات',
                                      amount: controller.tax.formatPrice(),
                                      onTap: () {
                                        StaticMethods.showSingleRowDialog(
                                          title: 'مالیات',
                                          rowTitle: 'درصد مالیات',
                                          controller: controller.taxController,
                                          keyboardType: TextInputType.number,
                                          onTap: () {
                                            controller.setTax();
                                            Get.back();
                                          },
                                        );
                                      },
                                    ),
                                    const SizedBox(height: 3),
                                  ],
                                  if (controller.showCosts) ...[
                                    FactorFooterRow(
                                      title:
                                          controller.costs.label ?? 'هزینه ها',
                                      amount:
                                          controller.costs.cost!.formatPrice(),
                                      onTap: () {
                                        Get.defaultDialog(
                                          title: 'سایر هزینه ها',
                                          content: Column(
                                            children: [
                                              Row(
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.end,
                                                mainAxisAlignment:
                                                    MainAxisAlignment.center,
                                                mainAxisSize: MainAxisSize.min,
                                                children: [
                                                  const SizedBox(width: 20),
                                                  const Text('عنوان'),
                                                  const SizedBox(width: 20),
                                                  SizedBox(
                                                    height: 40,
                                                    width: 120,
                                                    child: TextField(
                                                      controller: controller
                                                          .costsTitleController,
                                                      onTap: () {
                                                        StaticMethods
                                                            .textFieldOnTap(
                                                                controller
                                                                    .costsTitleController);
                                                      },
                                                    ),
                                                  ),
                                                ],
                                              ),
                                              const SizedBox(height: 10),
                                              Row(
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.end,
                                                mainAxisAlignment:
                                                    MainAxisAlignment.center,
                                                mainAxisSize: MainAxisSize.min,
                                                children: [
                                                  const SizedBox(width: 20),
                                                  const Text('مقدار'),
                                                  const SizedBox(width: 20),
                                                  SizedBox(
                                                    height: 40,
                                                    width: 80,
                                                    child: TextField(
                                                      controller: controller
                                                          .costsCountController,
                                                      keyboardType:
                                                          TextInputType.number,
                                                      inputFormatters: [
                                                        CurrencyTextInputFormatter(
                                                          decimalDigits: 0,
                                                          symbol: '',
                                                        ),
                                                      ],
                                                    ),
                                                  ),
                                                  const SizedBox(width: 5),
                                                  Text(
                                                    Get.find<
                                                            SettingController>()
                                                        .moneyUnit,
                                                    style: kRialTextStyle,
                                                  ),
                                                ],
                                              ),
                                            ],
                                          ),
                                          confirm: ConfirmButton(onTap: () {
                                            controller.setCosts();
                                          }),
                                        );
                                      },
                                    ),
                                    const SizedBox(height: 3),
                                  ],
                                  if (controller.showOffer) ...[
                                    FactorFooterRow(
                                      title: 'تخفیف',
                                      amount: controller.offer.formatPrice(),
                                      onTap: () {
                                        Get.defaultDialog(
                                          title: 'تخفیف',
                                          content: Row(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.end,
                                            mainAxisSize: MainAxisSize.min,
                                            mainAxisAlignment:
                                                MainAxisAlignment.center,
                                            children: [
                                              const Text('مبلغ تخفیف'),
                                              const SizedBox(width: 20),
                                              SizedBox(
                                                height: 40,
                                                width: 80,
                                                child: TextField(
                                                  controller: controller
                                                      .offerController,
                                                  onTap: () {
                                                    StaticMethods.textFieldOnTap(
                                                        controller
                                                            .offerController);
                                                  },
                                                  keyboardType:
                                                      TextInputType.number,
                                                  inputFormatters: [
                                                    CurrencyTextInputFormatter(
                                                      decimalDigits: 0,
                                                      symbol: '',
                                                    ),
                                                  ],
                                                ),
                                              ),
                                              const SizedBox(width: 10),
                                              Text(
                                                Get.find<SettingController>()
                                                    .moneyUnit,
                                                style: kRialTextStyle,
                                              ),
                                            ],
                                          ),
                                          confirm: ConfirmButton(onTap: () {
                                            controller.setOffer();
                                          }),
                                        );
                                      },
                                    ),
                                    const SizedBox(height: 3),
                                  ],
                                  FactorFooterRow(
                                    title: 'جمع کل',
                                    amount: controller.factorSum.formatPrice(),
                                  ),
                                ],
                              ),
                            ),
                          ),
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
