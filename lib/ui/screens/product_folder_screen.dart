import 'package:hesab_ban/controllers/home_controller.dart';
import 'package:hesab_ban/ui/widgets/base_widget.dart';
import 'package:hesab_ban/ui/widgets/sliver_box_container_widget.dart';
import 'package:hesab_ban/ui/widgets/product_widget.dart';
import 'package:hesab_ban/ui/widgets/scroll_to_up.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hive_flutter/hive_flutter.dart';

import '../../data/models/product_model.dart';
import '../../routes/app_pages.dart';
import '../widgets/grid_menu_widget.dart';

class ProductFolderScreen extends GetView<HomeController> {
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
      title: categoryName,
      appBarLeading: IconButton(
        onPressed: () {
          Navigator.pop(context);
        },
        icon: const Icon(Icons.arrow_back_ios),
        splashRadius: 30,
      ),
      child: ScrollToUp(
        showFab: controller.showCategoryProductsFab,
        scrollController: controller.productScreenScrollController,
        hideBottomSheet: selectProduct,
        child: CustomScrollView(
          controller: controller.productScreenScrollController,
          physics: const BouncingScrollPhysics(),
          slivers: [
            if (!selectProduct)
              SliverPadding(
                padding: const EdgeInsets.all(10),
                sliver: SliverToBoxAdapter(
                  child: GridMenuWidget(
                    title: 'ساخت محصول جدید',
                    onTap: () {
                      Get.toNamed(
                        Routes.createProductScreen,
                        parameters: {'categoryName': categoryName},
                      );
                    },
                    width: MediaQuery.of(context).size.width / 2 - 25,
                  ),
                ),
              )
            else
              const SliverToBoxAdapter(
                child: SizedBox(
                  height: 10,
                ),
              ),
            SliverBoxContainerWidget(
              child: ValueListenableBuilder(
                valueListenable: controller.productBox.listenable(),
                builder: (context, box, _) {
                  List<Product> productList = controller.productBox.values
                      .where(
                          (element) => element.category!.name == categoryName)
                      .toList();
                  return SliverList(
                    delegate: SliverChildBuilderDelegate(
                      (context, index) {
                        Product product = productList[index];
                        return ProductWidget(
                          product: product,
                          categoryName: categoryName,
                          productList: productList,
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
                  );
                },
              ),
            ),
            const SliverToBoxAdapter(
              child: SizedBox(
                height: 75,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
