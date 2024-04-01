import 'package:currency_text_input_formatter/currency_text_input_formatter.dart';
import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hesab_ban/app/config/theme/app_colors.dart';
import 'package:hesab_ban/app/config/theme/constants_app_styles.dart';
import 'package:hesab_ban/app/core/widgets/base_widget.dart';
import 'package:hesab_ban/app/core/widgets/custom_text_field.dart';
import 'package:hesab_ban/app/core/widgets/grid_menu_widget.dart';
import 'package:hesab_ban/app/features/feature_cash/presentation/controller/cash_controller.dart';
import 'package:hesab_ban/app/features/feature_setting/presentation/controller/setting_controller.dart';
import 'package:iconsax/iconsax.dart';

class CreateCashScreen extends GetView<CashController> {
  const CreateCashScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return PopScope(
      onPopInvoked: (_) async {
        controller.resetCashScreen(context);
      },
      child: BaseWidget(
        titleText: 'ورود وجه نقد',
        resizeToAvoidBottomInset: false,
        showLeading: true,
        onLeadingTap: () {
          controller.resetCashScreen(context);
        },
        appBarActions: [
          IconButton(
            onPressed: () async {
              if (Get.arguments == null) {
                controller.saveCash();
                controller.resetCashScreen(context);
              } //
              else {
                bool status = await controller.updateCash(
                    id: Get.arguments.id, context: context);
                if(status){
                  controller.resetCashScreen(context);
                }
              }
            },
            icon: const Icon(Iconsax.tick_circle),
            splashRadius: 30,
            color: kGreenColor,
          ),
        ],
        child: GetBuilder<CashController>(
          initState: (state) => controller.init(Get.arguments),
          builder: (_) {
            return Card(
              margin: const EdgeInsets.all(20),
              // color: kGreyColor,
              shape: const RoundedRectangleBorder(
                borderRadius: BorderRadius.all(
                  Radius.circular(15),
                ),
              ),
              child: Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 20.0, vertical: 10),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Row(
                      children: [
                        const Text('از طرف'),
                        const Spacer(),
                        SizedBox(
                          width: 120,
                          child: DropdownButtonFormField<bool>(
                            itemHeight: 50,
                            items: const [
                              DropdownMenuItem(
                                value: true,
                                child: Text('خودم'),
                              ),
                              DropdownMenuItem(
                                value: false,
                                child: Text('مشتری'),
                              ),
                            ],
                            onChanged: controller.fromFactor == null
                                ? (bool? value) {
                                    if (value != null) {
                                      controller.setTypeOfCash(value);
                                    }
                                  }
                                : null,
                            value: controller.typeOfCash != null
                                ? controller.typeOfCash == 'send'
                                : true,
                            decoration: kCustomInputDecoration,
                            borderRadius:
                                const BorderRadius.all(Radius.circular(10)),
                            icon: const Icon(Iconsax.arrow_circle_down),
                            iconSize: 18,
                            elevation: 3,
                          ),
                        ),
                      ],
                    ),
                    const Divider(
                      color: kDarkGreyColor,
                      height: 10,
                      thickness: 1.2,
                    ),
                    Row(
                      children: [
                        GetBuilder<CashController>(
                          builder: (_) {
                            return Text(
                              controller.typeOfCash == 'send'
                                  ? 'دریافت کننده'
                                  : 'پرداخت کننده',
                            );
                          },
                        ),
                        const Spacer(),
                        GetBuilder<CashController>(
                          builder: (_) {
                            return Padding(
                              padding: const EdgeInsets.symmetric(vertical: 8),
                              child: DropdownButton2<String>(
                                hint: const Text('انتخاب کنید'),
                                value: controller.cashCustomer?.name,
                                isExpanded: true,
                                items: controller.customerLists,
                                onChanged: controller.fromFactor == null
                                    ? (String? value) {
                                        controller.setCustomerCash(value!);
                                      }
                                    : null,
                                dropdownStyleData: DropdownStyleData(
                                  decoration: const BoxDecoration(
                                    borderRadius:
                                        BorderRadius.all(Radius.circular(10)),
                                  ),
                                  elevation: 3,
                                  scrollbarTheme: ScrollbarThemeData(
                                    radius: const Radius.circular(40),
                                    thickness: MaterialStateProperty.all(6),
                                    trackVisibility:
                                        MaterialStateProperty.all(true),
                                  ),
                                ),
                                iconStyleData: const IconStyleData(
                                  icon: Icon(Iconsax.arrow_circle_down),
                                  iconSize: 18,
                                ),
                                buttonStyleData: const ButtonStyleData(
                                  padding: EdgeInsets.only(left: 10),
                                  width: 195,
                                ),
                                dropdownSearchData: DropdownSearchData<String>(
                                  searchController:
                                      controller.searchCustomerController,
                                  searchInnerWidget: Padding(
                                    padding: const EdgeInsets.only(
                                      top: 8,
                                      bottom: 4,
                                      right: 8,
                                      left: 8,
                                    ),
                                    child: TextFormField(
                                      controller:
                                          controller.searchCustomerController,
                                      decoration: InputDecoration(
                                        isDense: true,
                                        contentPadding:
                                            const EdgeInsets.symmetric(
                                          horizontal: 10,
                                          vertical: 8,
                                        ),
                                        hintText: 'جست و جو...',
                                        hintStyle:
                                            const TextStyle(fontSize: 12),
                                        border: OutlineInputBorder(
                                          borderRadius:
                                              BorderRadius.circular(8),
                                        ),
                                      ),
                                      onTap: () {
                                        if (controller.searchCustomerController
                                                .selection ==
                                            TextSelection.fromPosition(TextPosition(
                                                offset: controller
                                                        .searchCustomerController
                                                        .text
                                                        .length -
                                                    1))) {
                                          controller.searchCustomerController
                                                  .selection =
                                              TextSelection.fromPosition(
                                            TextPosition(
                                              offset: controller
                                                  .searchCustomerController
                                                  .text
                                                  .length,
                                            ),
                                          );
                                        }
                                      },
                                    ),
                                  ),
                                  searchInnerWidgetHeight: 10,
                                  searchMatchFn: (item, searchValue) {
                                    return (item.value
                                        .toString()
                                        .contains(searchValue));
                                  },
                                ),
                                onMenuStateChange: (isOpen) {
                                  if (!isOpen) {
                                    controller.searchCustomerController.clear();
                                  }
                                },
                                underline: const SizedBox(),
                              ),
                            );
                          },
                        ),
                      ],
                    ),
                    const Divider(
                      color: kDarkGreyColor,
                      height: 10,
                      thickness: 1.2,
                    ),
                    Row(
                      children: [
                        const Text('مبلغ'),
                        const SizedBox(
                          width: 10,
                        ),
                        Expanded(
                          child: CustomTextField(
                            controller: controller.cashAmountController,
                            keyboardType: TextInputType.number,
                            inputFormatters: [
                              CurrencyTextInputFormatter(
                                decimalDigits: 0,
                                symbol: '',
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(
                          width: 10,
                        ),
                        Text(
                          Get.find<SettingController>().moneyUnit,
                          style: kRialTextStyle,
                        ),
                      ],
                    ),
                    const Divider(
                      color: kDarkGreyColor,
                      height: 10,
                      thickness: 1.2,
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 8),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            controller.typeOfCash == 'send'
                                ? 'تاریخ دریافت'
                                : 'تاریخ پرداخت',
                          ),
                          GridMenuWidget(
                            title: controller.cashDateLabel == '-1'
                                ? 'انتخاب تاریخ'
                                : controller.cashDateLabel,
                            color: Theme.of(context).colorScheme.surface,
                            width: Get.width / 2 - 25,
                            onTap: () async {
                              controller.setDateOfCash(context);
                            },
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
