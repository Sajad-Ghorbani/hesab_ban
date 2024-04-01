import 'package:hesab_ban/app/core/widgets/search_container.dart';
import 'package:hesab_ban/app/core/widgets/sliver_box_container_widget.dart';
import 'package:hesab_ban/app/features/feature_product/domain/entities/category_entity.dart';
import 'package:hesab_ban/app/features/feature_product/domain/entities/product_entity.dart';
import 'package:hesab_ban/app/features/feature_product/presentation/widgets/category_widget.dart';
import 'package:hesab_ban/app/features/feature_product/presentation/widgets/product_widget.dart';
import 'package:hesab_ban/app/features/feature_search/presentation/controller/search_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class SearchProductScreen extends StatelessWidget {
  const SearchProductScreen({super.key, required this.selectProduct});
  final bool selectProduct;

  @override
  Widget build(BuildContext context) {
  SearchBarController controller = Get.put(SearchBarController());
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
                        backBlur: false,
                        child: GetBuilder<SearchBarController>(
                          builder: (controller) {
                            return SliverList(
                              delegate: SliverChildBuilderDelegate(
                                (context, index) {
                                  CategoryEntity category =
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
                      backBlur: false,
                      child: GetBuilder<SearchBarController>(
                        builder: (controller) {
                          return SliverList(
                            delegate: SliverChildBuilderDelegate(
                              (context, index) {
                                ProductEntity product =
                                    controller.productList[index];
                                return ProductWidget(
                                  product: product,
                                  categoryName: product.category!.name!,
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
