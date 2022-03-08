import 'package:hesab_ban/constants.dart';
import 'package:hesab_ban/controllers/product_controller.dart';
import 'package:hesab_ban/controllers/search_controller.dart';
import 'package:hesab_ban/routes/app_pages.dart';
import 'package:hesab_ban/ui/screens/search_product_screen.dart';
import 'package:hesab_ban/ui/widgets/base_widget.dart';
import 'package:hesab_ban/ui/widgets/category_widget.dart';
import 'package:hesab_ban/ui/widgets/grid_menu_widget.dart';
import 'package:hesab_ban/ui/widgets/box_container_widget.dart';
import 'package:hesab_ban/ui/widgets/product_widget.dart';
import 'package:hesab_ban/ui/widgets/scroll_to_up.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../models/category_model.dart';
import '../../models/product_model.dart';
import '../../static_methods.dart';
import '../widgets/search_box_widget.dart';

class AllProductScreen extends GetView<ProductController> {
  const AllProductScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    bool selectProduct = Get.arguments ?? false;
    return BaseWidget(
      title: 'کالاها',
      appBarLeading: selectProduct
          ? IconButton(
              onPressed: () {
                controller.backToHome(context);
              },
              icon: const Icon(Icons.arrow_back_ios),
              splashRadius: 30,
            )
          : null,
      child: ScrollToUp(
        showFab: controller.showProductsFab,
        scrollController: controller.scrollController,
        selectProductScreen: selectProduct,
        child: CustomScrollView(
          controller: controller.scrollController,
          physics: const BouncingScrollPhysics(),
          slivers: [
            if (!selectProduct) ...[
              SliverToBoxAdapter(
                child: Padding(
                  padding: const EdgeInsets.all(10.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      GridMenuWidget(
                          title: 'ساخت محصول جدید',
                          onTap: () {
                            Get.toNamed(Routes.createProductScreen);
                          }),
                      GridMenuWidget(
                        title: 'ساخت پوشه جدید',
                        onTap: () {
                          StaticMethods.showFolderDialog(
                            title: 'ساخت پوشه جدید',
                            controller: controller.categoryNameController,
                            onTap: () {
                              controller.addNewCategory();
                              Get.back();
                            },
                          );
                        },
                      ),
                    ],
                  ),
                ),
              ),
            ] else ...[
              const SliverToBoxAdapter(
                child: SizedBox(
                  height: 10,
                ),
              )
            ],
            SliverToBoxAdapter(
              child: SearchBoxWidget(
                searchText: 'جست و جو',
                openBuilderWidget: SearchProductScreen(),
                onClosed: (value) {
                  Get.find<SearchController>().clearScreen();
                },
              ),
            ),
            BoxContainerWidget(
              child: Obx(
                () => SliverList(
                  delegate: SliverChildBuilderDelegate(
                    (context, index) {
                      List<Category> list =
                          controller.productCategory.value.reversed.toList();
                      Category category = list[index];
                      return Visibility(
                        visible: category.name != defaultCategoryName,
                        child: CategoryWidget(
                          index: index,
                          category: category,
                          categoryList: list,
                          selectProductScreen: selectProduct,
                          openCategory: () {
                            controller.navigateToCategorySelectProduct(
                                category.name!);
                          },
                        ),
                      );
                    },
                    childCount: controller.productCategory.value.length,
                  ),
                ),
              ),
            ),
            const SliverToBoxAdapter(
              child: SizedBox(
                height: 10,
              ),
            ),
            BoxContainerWidget(
              child: Obx(
                () => SliverList(
                  delegate: SliverChildBuilderDelegate(
                    (context, index) {
                      List<Product> list =
                          controller.mainProduct.value.reversed.toList();
                      Product product = list[index];
                      return ProductWidget(
                        product: product,
                        productList: list,
                        selectProductScreen: selectProduct,
                        selectProduct: () {
                          Get.back(result: product);
                        },
                      );
                    },
                    childCount: controller.mainProduct.value.length,
                  ),
                ),
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
