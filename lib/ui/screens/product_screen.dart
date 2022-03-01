import 'package:accounting_app/controllers/product_controller.dart';
import 'package:accounting_app/ui/theme/app_colors.dart';
import 'package:accounting_app/ui/theme/constants_app_styles.dart';
import 'package:accounting_app/ui/widgets/base_widget.dart';
import 'package:accounting_app/ui/widgets/custom_text_field.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';

import '../../models/product_model.dart';

class ProductScreen extends GetView<ProductController> {
  const ProductScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Product? product = Get.arguments;
    if (product != null) {
      controller.productNameController.text = product.name!;
      controller.productBuyController.text =
          product.priceOfBuy == null ? '' : product.priceOfBuy.toString();
      controller.productOneSellController.text = product.priceOfOneSell == null
          ? ''
          : product.priceOfOneSell.toString();
      controller.productMajorSellController.text =
          product.priceOfMajorSell == null
              ? ''
              : product.priceOfMajorSell.toString();
      controller.productCountController.text =
          product.count == null ? '' : product.count.toString();
      controller.productUnitRatioController.text =
          product.unitRatio == null ? '' : product.unitRatio.toString();
    }
    return BaseWidget(
      title: product == null ? 'کالای جدید' : 'ویرایش ${product.name}',
      appBarLeading: IconButton(
        onPressed: () {
          Get.back();
          controller.resetProductScreen(context);
        },
        icon: const Icon(Icons.arrow_back_ios),
        splashRadius: 30,
      ),
      appBarActions: [
        IconButton(
          onPressed: () {
            if (product == null) {
              controller.saveProduct(context);
            } //
            else {
              controller.updateProduct(context, product);
              Get.back();
              controller.resetProductScreen(context);
            }
          },
          icon: const Icon(FontAwesomeIcons.solidSave),
          splashRadius: 30,
          color: kGreenColor,
        ),
      ],
      child: SingleChildScrollView(
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
                            controller: controller.productNameController,
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
                        const Text('قیمت خرید'),
                        const SizedBox(
                          width: 10,
                        ),
                        Expanded(
                          child: CustomTextField(
                            controller: controller.productBuyController,
                            keyboardType: TextInputType.number,
                          ),
                        ),
                        const SizedBox(
                          width: 10,
                        ),
                        const Text(
                          'ریال',
                          style: rialTextStyle,
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
                        const Text('قیمت خرده'),
                        const SizedBox(
                          width: 10,
                        ),
                        Expanded(
                          child: CustomTextField(
                            controller: controller.productOneSellController,
                            keyboardType: TextInputType.number,
                          ),
                        ),
                        const SizedBox(
                          width: 10,
                        ),
                        const Text(
                          'ریال',
                          style: rialTextStyle,
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
                        const Text('قیمت عمده'),
                        const SizedBox(
                          width: 10,
                        ),
                        Expanded(
                          child: CustomTextField(
                            controller: controller.productMajorSellController,
                            keyboardType: TextInputType.number,
                          ),
                        ),
                        const SizedBox(
                          width: 10,
                        ),
                        const Text(
                          'ریال',
                          style: rialTextStyle,
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
                        const Text('واحد اصلی'),
                        const SizedBox(
                          width: 10,
                        ),
                        Expanded(
                          child: DropdownButtonFormField(
                            items: controller.productUnitList,
                            value:
                                product != null ? product.mainUnit!.index : 0,
                            onChanged: (int? value) {
                              controller.productMainUnit = value!;
                            },
                            decoration: kCustomInputDecoration,
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
                        const Text('واحد فرعی'),
                        const SizedBox(
                          width: 10,
                        ),
                        Expanded(
                          child: DropdownButtonFormField(
                            items: controller.productUnitList,
                            hint: const Text('یک گزینه را انتخاب کنید.'),
                            value: product != null &&
                                    product.subCountingUnit != null
                                ? product.subCountingUnit!.index
                                : null,
                            onChanged: (int? value) {
                              controller.productSubCountingUnit = value;
                            },
                            decoration: kCustomInputDecoration,
                          ),
                        ),
                      ],
                    ),
                    SingleChildScrollView(
                      scrollDirection: Axis.horizontal,
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          const Text('هر مقدار از واحد اصلی برابر با'),
                          const SizedBox(
                            width: 5,
                          ),
                          SizedBox(
                            width: 50,
                            child: SizedBox(
                              height: 30,
                              child: TextField(
                                controller:
                                    controller.productUnitRatioController,
                                maxLength: 5,
                                keyboardType: TextInputType.number,
                                decoration:
                                    const InputDecoration(counterText: ''),
                              ),
                            ),
                          ),
                          const SizedBox(
                            width: 5,
                          ),
                          const Text('از واحد اصلی می باشد.'),
                        ],
                      ),
                    ),
                    const Divider(
                      color: kDarkGreyColor,
                      height: 10,
                      thickness: 1.2,
                    ),
                    Row(
                      children: [
                        const Text('موجودی اولیه'),
                        const SizedBox(
                          width: 10,
                        ),
                        Expanded(
                          child: CustomTextField(
                            controller: controller.productCountController,
                            keyboardType: TextInputType.number,
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
      ),
    );
  }
}
