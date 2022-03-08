import 'package:hesab_ban/models/product_model.dart';
import 'package:hesab_ban/ui/theme/app_theme.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';

import '../../controllers/product_controller.dart';
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
  }) : super(key: key);
  final Product product;
  final List<Product> productList;
  final bool selectProductScreen;
  final VoidCallback? selectProduct;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 10),
      child: Theme(
        data: AppThemeData.darkTheme.copyWith(
            splashColor: Colors.transparent,
            highlightColor: Colors.transparent),
        child: ListTile(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.vertical(
              top: Radius.circular(product == productList.first ? 15 : 0),
              bottom: Radius.circular(product == productList.last ? 15 : 0),
            ),
          ),
          title: Text(product.name!),
          leading: const FaIcon(
            FontAwesomeIcons.boxOpen,
            color: kLightPurpleColor,
          ),
          trailing: SizedBox(
            width: MediaQuery.of(context).size.width * 0.27,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text('موجودی'),
                Text('${product.count}'),
              ],
            ),
          ),
          onTap: selectProductScreen
              ? selectProduct
              : () {
                  Get.toNamed(Routes.createProductScreen, arguments: product);
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
                          Get.find<ProductController>().deleteProduct(product);
                          Get.back();
                        },
                      );
                    },
                  );
                },
        ),
      ),
    );
  }
}
