import 'package:currency_text_input_formatter/currency_text_input_formatter.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/services.dart';
import 'package:hesab_ban/controllers/customer_controller.dart';
import 'package:hesab_ban/routes/app_pages.dart';
import 'package:hesab_ban/ui/widgets/base_widget.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import 'package:persian_number_utility/persian_number_utility.dart';

import '../../controllers/home_controller.dart';
import '../theme/app_colors.dart';
import '../theme/constants_app_styles.dart';
import '../widgets/custom_text_field.dart';

class CreateCustomerScreen extends GetView<CustomerController> {
  const CreateCustomerScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // Customer? customer = Get.arguments;
    if (controller.customer != null) {
      controller.customerNameController.text = controller.customer!.name!;
      controller.customerPhoneController.text =
          controller.customer!.phoneNumber1 == null
              ? ''
              : controller.customer!.phoneNumber1.toString();
      controller.customerPhone2Controller.text =
          controller.customer!.phoneNumber2 == null
              ? ''
              : controller.customer!.phoneNumber2.toString();
      controller.customerAddressController.text =
          controller.customer!.address == null
              ? ''
              : controller.customer!.address!;
      controller.customerBalanceController.text =
          controller.customer!.initialAccountBalance == null
              ? ''
              : controller.customer!.initialAccountBalance
                  .toString()
                  .seRagham();
      controller.customerDescriptionController.text =
          controller.customer!.description == null
              ? ''
              : controller.customer!.description!;
    }
    return BaseWidget(
      title: 'ایجاد حساب جدید',
      appBarLeading: IconButton(
        onPressed: () {
          Get.back();
          controller.resetCustomerScreen(context);
        },
        icon: const Icon(Icons.arrow_back_ios),
        splashRadius: 30,
      ),
      appBarActions: [
        IconButton(
          onPressed: () {
            if (controller.customer == null) {
              controller.saveCustomer(context);
            } //
            else {
              controller.updateCustomer(context, controller.customer!);
            }
          },
          icon: const Icon(FontAwesomeIcons.check),
          splashRadius: 30,
          color: kGreenColor,
        ),
      ],
      child: SingleChildScrollView(
        child: Column(
          children: [
            Card(
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
                          Get.find<HomeController>().moneyUnit.value,
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
                        const Text('نوع'),
                        const Spacer(),
                        SizedBox(
                          width: 120,
                          child: Obx(
                            () => DropdownButtonFormField<bool>(
                              decoration: const InputDecoration(
                                  border: OutlineInputBorder(
                                      borderSide: BorderSide.none)),
                              items: const [
                                DropdownMenuItem(
                                  child: Text('بدهکار'),
                                  value: true,
                                ),
                                DropdownMenuItem(
                                  child: Text('بستانکار'),
                                  value: false,
                                ),
                              ],
                              value: controller.customerIsDebtor.value,
                              onChanged: (bool? value) {
                                controller.customerIsDebtor.value = value!;
                              },
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
                            controller:
                                controller.customerDescriptionController,
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
            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }
}
