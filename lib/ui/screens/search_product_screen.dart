import 'package:accounting_app/controllers/search_controller.dart';
import 'package:accounting_app/models/product_model.dart';
import 'package:accounting_app/ui/widgets/category_widget.dart';
import 'package:accounting_app/ui/widgets/box_container_widget.dart';
import 'package:accounting_app/ui/widgets/product_widget.dart';
import 'package:accounting_app/ui/widgets/search_container.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../models/category_model.dart';

// ignore: must_be_immutable
class SearchProductScreen extends StatelessWidget {
  SearchProductScreen({Key? key}) : super(key: key);
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
                      sliver: BoxContainerWidget(
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
                  : BoxContainerWidget(
                      child: GetBuilder<SearchController>(
                        builder: (controller) {
                          return SliverList(
                            delegate: SliverChildBuilderDelegate(
                              (context, index) {
                                Product product =
                                    controller.productList[index];
                                return ProductWidget(
                                  product: product,
                                  productList: controller.productList,
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
