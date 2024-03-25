import 'package:currency_text_input_formatter/currency_text_input_formatter.dart';
import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:hesab_ban/app/config/theme/app_colors.dart';
import 'package:hesab_ban/app/config/theme/constants_app_styles.dart';
import 'package:hesab_ban/app/core/widgets/base_widget.dart';
import 'package:hesab_ban/app/core/widgets/custom_text_field.dart';
import 'package:hesab_ban/app/core/widgets/grid_menu_widget.dart';
import 'package:hesab_ban/app/features/feature_check/presentation/controller/check_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hesab_ban/app/features/feature_setting/presentation/controller/setting_controller.dart';
import 'package:iconsax/iconsax.dart';

class CreateCheckScreen extends GetView<CheckController> {
  const CreateCheckScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        controller.resetCheckScreen(context);
        return true;
      },
      child: BaseWidget(
        titleText: 'ورود چک',
        resizeToAvoidBottomInset: false,
        showLeading: true,
        onLeadingTap: () {
          controller.resetCheckScreen(context);
        },
        appBarActions: [
          IconButton(
            onPressed: () {
              if (Get.arguments == null) {
                controller.registerCheck();
              } //
              else {
                controller.updateCheck(Get.arguments);
              }
              controller.resetCheckScreen(context);
            },
            icon: const Icon(Iconsax.tick_circle),
            splashRadius: 30,
            color: kGreenColor,
          ),
        ],
        child: GetBuilder<CheckController>(
          initState: (state) => controller.initCreateScreen(Get.arguments),
          builder: (_) {
            return SingleChildScrollView(
              child: Card(
                margin: const EdgeInsets.all(20),
                // color: kGreyColor,
                shape: const RoundedRectangleBorder(
                  borderRadius: BorderRadius.all(
                    Radius.circular(15),
                  ),
                ),
                child: Padding(
                  padding: const EdgeInsets.symmetric(
                      horizontal: 20.0, vertical: 10),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Row(
                        children: [
                          const Text('صادر کننده چک'),
                          const Spacer(),
                          SizedBox(
                            width: 140,
                            child: DropdownButtonFormField<bool>(
                              itemHeight: 50,
                              hint: const Text('انتخاب کنید'),
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
                                        controller.setTypeOfCheck(value);
                                      }
                                    }
                                  : null,
                              value: controller.typeOfCheck != null
                                  ? controller.typeOfCheck == 'send'
                                  : null,
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
                          GetBuilder<CheckController>(
                            builder: (_) {
                              return Text(controller.typeOfCheck == 'received'
                                  ? 'صادر کننده'
                                  : 'گیرنده');
                            },
                          ),
                          const Spacer(),
                          GetBuilder<CheckController>(
                            builder: (_) {
                              return Padding(
                                padding:
                                    const EdgeInsets.symmetric(vertical: 6),
                                child: DropdownButton2<String>(
                                  hint: const Text('انتخاب کنید'),
                                  value: controller.checkCustomer?.name,
                                  isExpanded: true,
                                  items: controller.customerLists,
                                  onChanged: controller.fromFactor == null
                                      ? Get.arguments == null
                                          ? (String? value) {
                                              controller
                                                  .setCustomerCheck(value!);
                                            }
                                          : null
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
                                  dropdownSearchData: DropdownSearchData(
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
                                          if (controller
                                                  .searchCustomerController
                                                  .selection ==
                                              TextSelection.fromPosition(
                                                  TextPosition(
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
                                      controller.searchCustomerController
                                          .clear();
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
                          const Text('نام بانک'),
                          const Spacer(),
                          SizedBox(
                            width: 210,
                            child: GetBuilder<CheckController>(
                              builder: (controller) {
                                return DropdownButtonFormField<String>(
                                  itemHeight: 50,
                                  items: controller.bankLists,
                                  value: controller.checkBankName,
                                  onChanged: (String? value) {
                                    controller.checkBankName = value!;
                                  },
                                  decoration: kCustomInputDecoration,
                                  menuMaxHeight: 500,
                                  borderRadius: const BorderRadius.all(
                                      Radius.circular(10)),
                                  icon: const Icon(Iconsax.arrow_circle_down),
                                  iconSize: 18,
                                  elevation: 3,
                                );
                              },
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
                          const Text('شماره چک'),
                          const SizedBox(
                            width: 10,
                          ),
                          Expanded(
                            child: CustomTextField(
                              controller: controller.checkNumberController,
                              keyboardType: TextInputType.number,
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
                          const Text('مبلغ چک'),
                          const SizedBox(
                            width: 10,
                          ),
                          Expanded(
                            child: CustomTextField(
                              controller: controller.checkAmountController,
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
                            const Text('تاریخ تحویل'),
                            GridMenuWidget(
                              title: controller.checkDueDateLabel == '-1'
                                  ? 'انتخاب تاریخ'
                                  : controller.checkDueDateLabel,
                              color: Theme.of(context).colorScheme.surface,
                              width: Get.width / 2 - 25,
                              onTap: () async {
                                controller.setDateOfCheck(context, false);
                              },
                            ),
                          ],
                        ),
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
                            const Text('تاریخ سر رسید'),
                            GridMenuWidget(
                              title: controller.checkDeliveryDateLabel == '-1'
                                  ? 'انتخاب تاریخ'
                                  : controller.checkDeliveryDateLabel,
                              color: Theme.of(context).colorScheme.surface,
                              width: Get.width / 2 - 25,
                              onTap: () {
                                controller.setDateOfCheck(context, true);
                              },
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
