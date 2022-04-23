import 'package:hesab_ban/data/models/product_model.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import 'package:persian_number_utility/persian_number_utility.dart';

import '../../routes/app_pages.dart';
import '../../static_methods.dart';
import '../theme/app_colors.dart';

class ProductWidget extends StatelessWidget {
  const ProductWidget({
    Key? key,
    required this.product,
    required this.productList,
    this.selectProductScreen = false,
    this.selectProduct,
    required this.categoryName,
  }) : super(key: key);
  final Product product;
  final List<Product> productList;
  final bool selectProductScreen;
  final VoidCallback? selectProduct;
  final String categoryName;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 10),
      padding: const EdgeInsets.all(10),
      child: InkWell(
        splashColor: Colors.transparent,
        highlightColor: Colors.transparent,
        onTap: selectProductScreen
            ? selectProduct
            : () {
          Get.toNamed(
            Routes.createProductScreen,
            arguments: product,
            parameters: {'categoryName': categoryName},
          );
        },
        onLongPress: selectProductScreen
            ? null
            : () {
          StaticMethods.productBottomSheet(
            context,
            name: product.name!,
            onEditTap: () {
              Get.toNamed(Routes.createProductScreen,
                  arguments: product);
            },
            onDeleteTap: () {
              Get.back();
              StaticMethods.deleteDialog(
                content: 'با حذف کالای "${product.name}" موافق هستید؟'
                    ' این عملیات برگشت پذیر نیست.',
                onConfirm: () {
                  product.delete();
                  Get.back();
                },
              );
            },
          );
        },
        child: Row(
          children: [
            const FaIcon(
              FontAwesomeIcons.boxOpen,
              color: kLightPurpleColor,
            ),
            const SizedBox(
              width: 10,
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(product.name!),
                const SizedBox(
                  height: 5,
                ),
                Text(
                  'قیمت خرید: ' + '${product.priceOfBuy}'.seRagham(),
                  style: TextStyle(fontSize: 12,color: kWhiteColor.withOpacity(0.8)),
                ),
                const SizedBox(
                  height: 5,
                ),
                Text(
                  'قیمت فروش: ' + '${product.priceOfMajorSale}'.seRagham(),
                  style: TextStyle(fontSize: 12,color: kWhiteColor.withOpacity(0.8)),
                ),
                const SizedBox(
                  height: 5,
                ),
                Text(
                  'قیمت خرده فروشی: ' + '${product.priceOfOneSale}'.seRagham(),
                  style: TextStyle(fontSize: 12,color: kWhiteColor.withOpacity(0.8)),
                ),
              ],
            ),
            const Spacer(),
            Column(
              children: [
                const Text('موجودی'),
                const SizedBox(
                  height: 5,
                ),
                Text(
                  ('${product.count}'.split('.')[1] == '0'
                          ? '${product.count}'.split('.')[0]
                          : '${product.count}')
                      .seRagham(),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
