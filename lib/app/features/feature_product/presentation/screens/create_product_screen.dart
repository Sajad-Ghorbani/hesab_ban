import 'package:currency_text_input_formatter/currency_text_input_formatter.dart';
import 'package:hesab_ban/app/config/theme/app_colors.dart';
import 'package:hesab_ban/app/config/theme/constants_app_styles.dart';
import 'package:hesab_ban/app/core/widgets/base_widget.dart';
import 'package:hesab_ban/app/core/widgets/custom_text_field.dart';
import 'package:hesab_ban/app/features/feature_product/domain/entities/product_entity.dart';
import 'package:hesab_ban/app/features/feature_product/presentation/controller/product_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hesab_ban/app/features/feature_setting/presentation/controller/setting_controller.dart';
import 'package:iconsax/iconsax.dart';
import 'package:hesab_ban/app/core/utils/extensions.dart';

class CreateProductScreen extends GetView<ProductController> {
  const CreateProductScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    String? productCategoryName = Get.parameters['categoryName'];
    ProductEntity? product = Get.arguments;
    if (product != null) {
      controller.productNameController.text = product.name!;
      controller.productBuyController.text = product.priceOfBuy == null
          ? ''
          : product.priceOfBuy!.formatPrice();
      controller.productOneSaleController.text = product.priceOfOneSale == null
          ? ''
          : product.priceOfOneSale!.formatPrice();
      controller.productMajorSaleController.text =
          product.priceOfMajorSale == null
              ? ''
              : product.priceOfMajorSale!.formatPrice();
      controller.productCountController.text =
          product.count == null ? '' : product.count!.formatPrice();
    }
    return WillPopScope(
      onWillPop: () async {
        controller.resetProductScreen(context);
        return true;
      },
      child: BaseWidget(
        titleText: product == null ? 'کالای جدید' : 'ویرایش ${product.name}',
        showLeading: true,
        onLeadingTap: (){
          controller.resetProductScreen(context);
        },
        appBarActions: [
          IconButton(
            onPressed: () {
              if (product == null) {
                controller.saveProduct(context, productCategoryName!);
              } //
              else {
                controller.updateProductUI(context, product);
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
              padding: const EdgeInsets.symmetric(
                  horizontal: 20.0, vertical: 10),
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
                  Row(
                    children: [
                      const Text('قیمت خرده'),
                      const SizedBox(
                        width: 10,
                      ),
                      Expanded(
                        child: CustomTextField(
                          controller: controller.productOneSaleController,
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
                  Row(
                    children: [
                      const Text('قیمت عمده'),
                      const SizedBox(
                        width: 10,
                      ),
                      Expanded(
                        child: CustomTextField(
                          controller: controller.productMajorSaleController,
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
                  Row(
                    children: [
                      const Text('واحد کالا'),
                      const SizedBox(width: 40),
                      Expanded(
                        child: DropdownButtonHideUnderline(
                          child: DropdownButtonFormField(
                            items: controller.productUnitList,
                            value: product != null
                                ? controller.units
                                    .indexOf(product.mainUnit!)
                                : 0,
                            onChanged: (int? value) {
                              controller.productMainUnit = value!;
                            },
                            decoration: kCustomInputDecoration,
                            menuMaxHeight: 200,
                            borderRadius:
                                const BorderRadius.all(Radius.circular(10)),
                            icon: const Icon(
                                Iconsax.arrow_circle_down),
                            iconSize: 18,
                            elevation: 3,
                          ),
                        ),
                      ),
                    ],
                  ),
                  // const Divider(
                  //   color: kDarkGreyColor,
                  //   height: 10,
                  //   thickness: 1.2,
                  // ),
                  // Row(
                  //   children: [
                  //     const Text('واحد فرعی'),
                  //     const SizedBox(
                  //       width: 10,
                  //     ),
                  //     Expanded(
                  //       child: DropdownButtonFormField(
                  //         items: controller.productUnitList,
                  //         hint: const Text('یک گزینه را انتخاب کنید.'),
                  //         value: product != null &&
                  //                 product.subCountingUnit != null
                  //             ? product.subCountingUnit!.index
                  //             : null,
                  //         onChanged: (int? value) {
                  //           controller.productSubCountingUnit = value;
                  //         },
                  //         decoration: kCustomInputDecoration,
                  //       ),
                  //     ),
                  //   ],
                  // ),
                  // SingleChildScrollView(
                  //   scrollDirection: Axis.horizontal,
                  //   child: Row(
                  //     crossAxisAlignment: CrossAxisAlignment.end,
                  //     children: [
                  //       const Text('هر مقدار از واحد اصلی برابر با'),
                  //       const SizedBox(
                  //         width: 5,
                  //       ),
                  //       SizedBox(
                  //         width: 50,
                  //         child: SizedBox(
                  //           height: 30,
                  //           child: TextField(
                  //             controller:
                  //                 controller.productUnitRatioController,
                  //             maxLength: 5,
                  //             keyboardType: TextInputType.number,
                  //             decoration:
                  //                 const InputDecoration(counterText: ''),
                  //           ),
                  //         ),
                  //       ),
                  //       const SizedBox(
                  //         width: 5,
                  //       ),
                  //       const Text('از واحد اصلی می باشد.'),
                  //     ],
                  //   ),
                  // ),
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
                          keyboardType:
                              const TextInputType.numberWithOptions(),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
