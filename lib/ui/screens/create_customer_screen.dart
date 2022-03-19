import 'package:currency_text_input_formatter/currency_text_input_formatter.dart';
import 'package:flutter/gestures.dart';
import 'package:hesab_ban/controllers/customer_controller.dart';
import 'package:hesab_ban/models/customer_model.dart';
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
    Customer? customer = Get.arguments;
    if (customer != null) {
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
              : customer.initialAccountBalance.toString().seRagham();
    }
    return BaseWidget(
      title: 'ایجاد حساب جدید',
      resizeToAvoidBottomInset: false,
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
            if (customer == null) {
              controller.saveCustomer(context);
            } //
            else {
              controller.updateCustomer(context, customer);
            }
          },
          icon: const Icon(FontAwesomeIcons.check),
          splashRadius: 30,
          color: kGreenColor,
        ),
      ],
      child: Column(
        children: [
          Card(
            margin: const EdgeInsets.all(20),
            color: kGreyColor,
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
                ],
              ),
            ),
          ),
          const Spacer(),
          RichText(
            text: TextSpan(
              style: const TextStyle(fontFamily: 'Yekan', fontSize: 12),
              children: [
                const TextSpan(text: 'شرایط استفاده از خدمات و '),
                TextSpan(
                  text: 'حریم خصوصی',
                  style: const TextStyle(
                    color: kBackgroundColor,
                  ),
                  recognizer: TapGestureRecognizer()..onTap = (){
                    Get.toNamed(Routes.privacyAndPolicyScreen);
                  },
                ),
                const TextSpan(text: ' را میپذیرم.'),
              ],
            ),
          ),
          const SizedBox(
            height: 20,
          ),
        ],
      ),
    );
  }
}
