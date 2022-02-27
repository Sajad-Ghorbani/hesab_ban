import 'package:accounting_app/controllers/search_controller.dart';
import 'package:accounting_app/models/product_model.dart';
import 'package:accounting_app/ui/widgets/category_widget.dart';
import 'package:accounting_app/ui/widgets/box_container_widget.dart';
import 'package:accounting_app/ui/widgets/product_widget.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../models/category_model.dart';
import '../theme/app_colors.dart';
import '../theme/constants_app_styles.dart';

// ignore: must_be_immutable
class SearchProductScreen extends StatelessWidget {
  SearchProductScreen({Key? key}) : super(key: key);
  SearchController controller = Get.put(SearchController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 10.0),
          child: CustomScrollView(
            slivers: [
              SliverList(
                delegate: SliverChildListDelegate(
                  [
                    const SizedBox(
                      height: 10,
                    ),
                    Container(
                      height: 45,
                      width: MediaQuery.of(context).size.width,
                      margin: const EdgeInsets.only(bottom: 10),
                      decoration: BoxDecoration(
                        borderRadius: const BorderRadius.all(
                          Radius.circular(15),
                        ),
                        border: Border.all(
                          color: kGreyColor,
                          width: 1.5,
                        ),
                        gradient: LinearGradient(
                          colors: [
                            kGreyColor.withOpacity(0.4),
                            kSurfaceColor.withOpacity(0.4),
                          ],
                          begin: Alignment.topRight,
                          end: Alignment.bottomLeft,
                        ),
                      ),
                      child: Row(
                        children: [
                          const Icon(
                            Icons.search,
                            color: kOrangeColor,
                          ),
                          const SizedBox(
                            width: 20,
                          ),
                          Expanded(
                            child: TextField(
                              controller: controller.searchController,
                              decoration: customInputDecoration,
                              autofocus: true,
                              onChanged: (value) {
                                controller.searchProduct(value);
                              },
                            ),
                          ),
                        ],
                      ),
                      alignment: Alignment.centerRight,
                      padding: const EdgeInsets.symmetric(horizontal: 10),
                    ),
                  ],
                ),
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
      ),
    );
  }
}
