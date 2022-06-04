import 'package:currency_text_input_formatter/currency_text_input_formatter.dart';
import 'package:hesab_ban/controllers/check_controller.dart';
import 'package:hesab_ban/ui/widgets/base_widget.dart';
import 'package:hesab_ban/ui/widgets/custom_text_field.dart';
import 'package:hesab_ban/ui/widgets/grid_menu_widget.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';

import '../../controllers/home_controller.dart';
import '../theme/app_colors.dart';
import '../theme/constants_app_styles.dart';

class CreateCheckScreen extends GetView<CheckController> {
  const CreateCheckScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    if (controller.check != null) {
      controller.checkNumberController.text = controller.check!.checkNumber!;
      controller.checkAmountController.text =
          controller.check!.checkAmount.toString();
      controller.checkDueDateLabel.value =
          controller.check!.checkDueDate.toString();
      controller.checkDeliveryDateLabel.value =
          controller.check!.checkDeliveryDate.toString();
    }
    return BaseWidget(
      title: 'ورود چک',
      resizeToAvoidBottomInset: false,
      appBarLeading: IconButton(
        onPressed: () {
          Get.back();
          controller.resetCheckScreen(context);
        },
        icon: const Icon(Icons.arrow_back_ios),
        splashRadius: 30,
      ),
      appBarActions: [
        IconButton(
          onPressed: () {
            if (controller.check == null) {
              controller.saveCheck(context);
            } //
            else {
              controller.updateCheck(context, controller.check!);
              Get.back();
              controller.resetCheckScreen(context);
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
                      const Text('نام بانک'),
                      const SizedBox(
                        width: 10,
                      ),
                      Expanded(
                        child: Obx(
                          () => DropdownButtonFormField<String>(
                            decoration: const InputDecoration(
                              border: OutlineInputBorder(
                                borderSide: BorderSide.none,
                              ),
                            ),
                            itemHeight: 50,
                            items: controller.bankLists,
                            value: controller.checkBankName.value,
                            onChanged: (String? value) {
                              controller.checkBankName.value = value!;
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
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text('تاریخ تحویل'),
                      Obx(
                        () => GridMenuWidget(
                          title: controller.checkDueDateLabel.value == '-1'
                              ? 'انتخاب تاریخ'
                              : controller.checkDueDateLabel.value,
                          color: Theme.of(context).colorScheme.surface,
                          width: MediaQuery.of(context).size.width / 2 - 25,
                          onTap: () async {
                            controller.setDateOfCheck(context, false);
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
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text('تاریخ سر رسید'),
                      Obx(
                        () => GridMenuWidget(
                          title: controller.checkDeliveryDateLabel.value == '-1'
                              ? 'انتخاب تاریخ'
                              : controller.checkDeliveryDateLabel.value,
                          color: Theme.of(context).colorScheme.surface,
                          width: MediaQuery.of(context).size.width / 2 - 25,
                          onTap: () {
                            controller.setDateOfCheck(context, true);
                          },
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
