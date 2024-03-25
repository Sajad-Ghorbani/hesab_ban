import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hesab_ban/app/config/routes/app_pages.dart';
import 'package:hesab_ban/app/config/theme/app_colors.dart';
import 'package:hesab_ban/app/core/utils/extensions.dart';
import 'package:hesab_ban/app/core/utils/static_methods.dart';
import 'package:hesab_ban/app/features/feature_product/domain/entities/product_entity.dart';
import 'package:hesab_ban/app/features/feature_product/presentation/controller/product_controller.dart';
import 'package:iconsax/iconsax.dart';
import 'package:persian_number_utility/persian_number_utility.dart';

class ProductWidget extends GetView<ProductController> {
  const ProductWidget({
    Key? key,
    required this.product,
    this.selectProductScreen = false,
    this.selectProduct,
    required this.categoryName,
  }) : super(key: key);
  final ProductEntity product;
  final bool selectProductScreen;
  final VoidCallback? selectProduct;
  final String categoryName;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: selectProductScreen
          ? selectProduct
          : () {
        StaticMethods.customBottomSheet(
          context,
          name: product.name!,
          onEditTap: () {
            Get.toNamed(Routes.createProductScreen, arguments: product);
          },
          onDeleteTap: () {
            Get.back();
            StaticMethods.deleteDialog(
              content: 'با حذف کالای "${product.name}" موافق هستید؟'
                  ' این عملیات برگشت پذیر نیست.',
              onConfirm: () {
                controller.deleteProduct(product.id!);
                Get.back();
              },
            );
          },
        );
      },
      child: Container(
        color: Colors.transparent,
        margin: const EdgeInsets.symmetric(horizontal: 10),
        padding: const EdgeInsets.all(10),
        child: Row(
          children: [
            const Icon(
              Iconsax.box,
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
                  'قیمت خرید: ${'${product.priceOfBuy}'.seRagham()}',
                  style: TextStyle(
                    fontSize: 12,
                    color: Theme.of(context)
                        .colorScheme
                        .onBackground
                        .withOpacity(0.8),
                  ),
                ),
                const SizedBox(
                  height: 5,
                ),
                Text(
                  'قیمت فروش: ${'${product.priceOfMajorSale}'.seRagham()}',
                  style: TextStyle(
                    fontSize: 12,
                    color: Theme.of(context)
                        .colorScheme
                        .onBackground
                        .withOpacity(0.8),
                  ),
                ),
                const SizedBox(
                  height: 5,
                ),
                Text(
                  'قیمت خرده فروشی: ${'${product.priceOfOneSale}'.seRagham()}',
                  style: TextStyle(
                    fontSize: 12,
                    color: Theme.of(context)
                        .colorScheme
                        .onBackground
                        .withOpacity(0.8),
                  ),
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
                Text(product.count!.formatPrice()),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
