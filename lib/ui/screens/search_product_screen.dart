import 'package:hesab_ban/controllers/search_controller.dart';
import 'package:hesab_ban/models/product_model.dart';
import 'package:hesab_ban/ui/widgets/category_widget.dart';
import 'package:hesab_ban/ui/widgets/sliver_box_container_widget.dart';
import 'package:hesab_ban/ui/widgets/product_widget.dart';
import 'package:hesab_ban/ui/widgets/search_container.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../models/category_model.dart';

// ignore: must_be_immutable
class SearchProductScreen extends StatelessWidget {
  SearchProductScreen({Key? key, required this.selectProduct})
      : super(key: key);
  final bool selectProduct;
  SearchController controller = Get.put(SearchController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: CustomScrollView(
          slivers: [
            SearchContainer(
              textEditingController: controller.searchController,
              onChanged: (value) {
                controller.searchProduct(value);
              },
            ),
            Obx(
              () => controller.searchEmpty.value
                  ? const SliverToBoxAdapter(
                      child: Center(
                        child: Text('هیچ موردی پیدا نشد...'),
                      ),
                    )
                  : SliverPadding(
                      padding: const EdgeInsets.only(bottom: 10),
                      sliver: SliverBoxContainerWidget(
                        child: GetBuilder<SearchController>(
                          builder: (controller) {
                            return SliverList(
                              delegate: SliverChildBuilderDelegate(
                                (context, index) {
                                  Category category =
                                      controller.categoryList[index];
                                  return CategoryWidget(
                                    index: index,
                                    category: category,
                                    categoryList: controller.categoryList,
                                    selectProductScreen: selectProduct,
                                    fromSearch: true,
                                  );
                                },
                                childCount: controller.categoryList.length,
                              ),
                            );
                          },
                        ),
                      ),
                    ),
            ),
            Obx(
              () => controller.searchEmpty.value
                  ? const SliverToBoxAdapter()
                  : SliverBoxContainerWidget(
                      child: GetBuilder<SearchController>(
                        builder: (controller) {
                          return SliverList(
                            delegate: SliverChildBuilderDelegate(
                              (context, index) {
                                Product product = controller.productList[index];
                                return ProductWidget(
                                  product: product,
                                  categoryName: product.category!.name!,
                                  productList: controller.productList,
                                  selectProductScreen: selectProduct,
                                  selectProduct: () {
                                    Get.back();
                                    Get.back(result: product);
                                  },
                                );
                              },
                              childCount: controller.productList.length,
                            ),
                          );
                        },
                      ),
                    ),
            ),
          ],
        ),
      ),
    );
  }
}
