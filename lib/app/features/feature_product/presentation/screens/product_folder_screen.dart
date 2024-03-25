import 'package:hesab_ban/app/config/routes/app_pages.dart';
import 'package:hesab_ban/app/core/widgets/base_widget.dart';
import 'package:hesab_ban/app/core/widgets/scroll_to_up.dart';
import 'package:hesab_ban/app/core/widgets/sliver_box_container_widget.dart';
import 'package:hesab_ban/app/features/feature_product/domain/entities/product_entity.dart';
import 'package:hesab_ban/app/features/feature_product/presentation/controller/product_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hesab_ban/app/features/feature_product/presentation/widgets/product_widget.dart';
import 'package:iconsax/iconsax.dart';

class ProductFolderScreen extends GetView<ProductController> {
  const ProductFolderScreen({
    Key? key,
    required this.categoryName,
    this.selectProduct = false,
    this.fromSearch = false,
  }) : super(key: key);
  final bool selectProduct;
  final bool fromSearch;
  final String categoryName;

  @override
  Widget build(BuildContext context) {
    return BaseWidget(
      titleText: categoryName,
      showPaint: true,
      showLeading: true,
      child: ScrollToUp(
        showFab: controller.showCategoryProductsFab,
        showLeftButton: true,
        leftIcon: const Icon(
          Iconsax.box_add,
        ),
        onLeftPressed: () {
          Get.toNamed(
            Routes.createProductScreen,
            parameters: {'categoryName': categoryName},
          );
        },
        scrollController: controller.productScreenScrollController,
        child: CustomScrollView(
          controller: controller.productScreenScrollController,
          physics: const BouncingScrollPhysics(),
          slivers: [
            const SliverToBoxAdapter(
              child: SizedBox(
                height: 10,
              ),
            ),
            GetBuilder<ProductController>(
              builder: (_) {
                List<ProductEntity> productList = controller.products
                    .where((element) => element.category!.name == categoryName)
                    .toList();
                return SliverBoxContainerWidget(
                  child: SliverList(
                    delegate: SliverChildBuilderDelegate(
                      (context, index) {
                        ProductEntity product = productList[index];
                        return ProductWidget(
                          product: product,
                          categoryName: categoryName,
                          selectProductScreen: selectProduct,
                          selectProduct: () {
                            if (fromSearch) Navigator.pop(context);
                            Navigator.pop(context);
                            Get.back(result: product);
                          },
                        );
                      },
                      childCount: productList.length,
                    ),
                  ),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
