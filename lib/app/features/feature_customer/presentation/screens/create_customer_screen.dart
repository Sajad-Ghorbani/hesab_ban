import 'package:currency_text_input_formatter/currency_text_input_formatter.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/services.dart';
import 'package:hesab_ban/app/config/routes/app_pages.dart';
import 'package:hesab_ban/app/config/theme/app_colors.dart';
import 'package:hesab_ban/app/config/theme/constants_app_styles.dart';
import 'package:hesab_ban/app/core/utils/constants.dart';
import 'package:hesab_ban/app/core/widgets/base_widget.dart';
import 'package:hesab_ban/app/core/widgets/custom_text_field.dart';
import 'package:hesab_ban/app/features/feature_customer/domain/entities/customer_entity.dart';
import 'package:hesab_ban/app/features/feature_customer/presentation/controller/customer_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hesab_ban/app/features/feature_setting/presentation/controller/setting_controller.dart';
import 'package:iconsax/iconsax.dart';
import 'package:persian_number_utility/persian_number_utility.dart';

class CreateCustomerScreen extends GetView<CustomerController> {
  const CreateCustomerScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var customer = Get.arguments;
    String? type = Get.parameters['type'];
    if (customer is CustomerEntity? && customer != null) {
      controller.customerNameController.text = customer.name!;
      controller.customerPhoneController.text =
          customer.phoneNumber1 == null ? '' : customer.phoneNumber1.toString();
      controller.customerPhone2Controller.text =
          customer.phoneNumber2 == null ? '' : customer.phoneNumber2.toString();
      controller.customerAddressController.text =
          customer.address == null ? '' : customer.address!;
      controller.customerBalanceController.text =
          customer.initialAccountBalance == null
              ? ''
              : customer.initialAccountBalance!.abs().toString().seRagham();
      controller.customerDescriptionController.text =
          customer.description == null ? '' : customer.description!;
    }
    controller.customerIsDebtor.value =
        type == Constants.debtorType ? true : false;
    return WillPopScope(
      onWillPop: () async {
        controller.resetCustomerScreen(context);
        return true;
      },
      child: BaseWidget(
        titleText: 'ایجاد حساب جدید',
        showLeading: true,
        onLeadingTap: () {
          controller.resetCustomerScreen(context);
        },
        appBarActions: [
          IconButton(
            onPressed: () {
              if (customer == null) {
                controller.saveCustomer(context);
              } //
              else {
                controller.updateCustomer(context, customer.id!);
              }
            },
            icon: const Icon(Iconsax.tick_circle),
            splashRadius: 30,
            color: kGreenColor,
          ),
        ],
        child: SingleChildScrollView(
          child: Card(
            margin: const EdgeInsets.all(20),
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
                      const Text('نام'),
                      const SizedBox(
                        width: 10,
                      ),
                      Expanded(
                        child: CustomTextField(
                          controller: controller.customerNameController,
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
                      Text('شماره تماس 1'.toPersianDigit()),
                      const SizedBox(
                        width: 10,
                      ),
                      Expanded(
                        child: CustomTextField(
                          controller: controller.customerPhoneController,
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
                      Text('شماره تماس 2'.toPersianDigit()),
                      const SizedBox(
                        width: 10,
                      ),
                      Expanded(
                        child: CustomTextField(
                          controller: controller.customerPhone2Controller,
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
                      const Text('آدرس'),
                      const SizedBox(
                        width: 10,
                      ),
                      Expanded(
                        child: CustomTextField(
                          controller: controller.customerAddressController,
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
                      const Text('مانده حساب اولیه'),
                      const SizedBox(
                        width: 10,
                      ),
                      Expanded(
                        child: CustomTextField(
                          controller: controller.customerBalanceController,
                          keyboardType: TextInputType.number,
                          inputFormatters: [
                            FilteringTextInputFormatter.digitsOnly,
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
                  Row(
                    children: [
                      const Text('ماهیت حساب'),
                      const Spacer(),
                      SizedBox(
                        width: 120,
                        child: Obx(
                          () => DropdownButtonFormField<bool>(
                            items: const [
                              DropdownMenuItem(
                                value: true,
                                child: Text('بدهکار'),
                              ),
                              DropdownMenuItem(
                                value: false,
                                child: Text('بستانکار'),
                              ),
                            ],
                            value: controller.customerIsDebtor.value,
                            onChanged: (bool? value) {
                              controller.customerIsDebtor.value = value!;
                            },
                            decoration: kCustomInputDecoration,
                            borderRadius:
                                const BorderRadius.all(Radius.circular(10)),
                            icon: const Icon(Iconsax.arrow_circle_down),
                            iconSize: 18,
                            elevation: 3,
                          ),
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
                      const Text('توضیحات'),
                      const SizedBox(
                        width: 10,
                      ),
                      Expanded(
                        child: CustomTextField(
                          controller: controller.customerDescriptionController,
                          maxLines: 5,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 20),
                  RichText(
                    text: TextSpan(
                      style: TextStyle(
                        fontFamily: 'Yekan',
                        fontSize: 12,
                        color: Theme.of(context).colorScheme.onBackground,
                      ),
                      children: [
                        const TextSpan(text: 'شرایط استفاده از خدمات و '),
                        TextSpan(
                          text: 'حریم خصوصی',
                          style: TextStyle(
                            color: Get.isDarkMode
                                ? Theme.of(context).colorScheme.background
                                : kGreyColor,
                          ),
                          recognizer: TapGestureRecognizer()
                            ..onTap = () {
                              Get.toNamed(Routes.privacyAndPolicyScreen);
                            },
                        ),
                        const TextSpan(text: ' را میپذیرم.'),
                      ],
                    ),
                  ),
                  const SizedBox(height: 10),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
