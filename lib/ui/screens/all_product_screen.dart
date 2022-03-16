import 'package:hesab_ban/constants.dart';
import 'package:hesab_ban/controllers/home_controller.dart';
import 'package:hesab_ban/controllers/search_controller.dart';
import 'package:hesab_ban/routes/app_pages.dart';
import 'package:hesab_ban/ui/screens/search_product_screen.dart';
import 'package:hesab_ban/ui/widgets/base_widget.dart';
import 'package:hesab_ban/ui/widgets/category_widget.dart';
import 'package:hesab_ban/ui/widgets/grid_menu_widget.dart';
import 'package:hesab_ban/ui/widgets/sliver_box_container_widget.dart';
import 'package:hesab_ban/ui/widgets/product_widget.dart';
import 'package:hesab_ban/ui/widgets/scroll_to_up.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hive_flutter/hive_flutter.dart';

import '../../models/category_model.dart';
import '../../models/product_model.dart';
import '../../static_methods.dart';
import '../widgets/search_box_widget.dart';

class AllProductScreen extends GetView<HomeController> {
  const AllProductScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    bool selectProduct = Get.arguments ?? false;
    return BaseWidget(
      title: 'کالاها',
      appBarLeading: selectProduct
          ? IconButton(
              onPressed: () {
                Navigator.pop(context);
              },
              icon: const Icon(Icons.arrow_back_ios),
              splashRadius: 30,
            )
          : null,
      child: ScrollToUp(
        showFab: controller.showProductsFab,
        scrollController: controller.productScreenScrollController,
        hideBottomSheet: selectProduct,
        child: CustomScrollView(
          controller: controller.productScreenScrollController,
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
                          Get.toNamed(
                            Routes.createProductScreen,
                            parameters: {'categoryName': defaultCategoryName},
                          );
                        },
                      ),
                      GridMenuWidget(
                        title: 'ساخت پوشه جدید',
                        onTap: () {
                          StaticMethods.showFolderDialog(
                            title: 'ساخت پوشه جدید',
                            controller: controller.categoryNameController,
                            onTap: () {
                              controller.addNewCategory();
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
                openBuilderWidget:
                    SearchProductScreen(selectProduct: selectProduct),
                onClosed: (value) {
                  Get.find<SearchController>().clearScreen();
                },
              ),
            ),
            SliverBoxContainerWidget(
              child: ValueListenableBuilder(
                valueListenable: controller.categoryBox.listenable(),
                builder: (context, Box<Category> box, _) {
                  return SliverList(
                    delegate: SliverChildBuilderDelegate(
                      (context, index) {
                        List<Category> list =
                            box.values.toList().reversed.toList();
                        Category category = list[index];
                        return Visibility(
                          visible: category.name != defaultCategoryName,
                          child: CategoryWidget(
                            index: index,
                            category: category,
                            categoryList: list,
                            selectProductScreen: selectProduct,
                          ),
                        );
                      },
                      childCount: box.length,
                    ),
                  );
                },
              ),
            ),
            const SliverToBoxAdapter(
              child: SizedBox(
                height: 10,
              ),
            ),
            SliverBoxContainerWidget(
              child: ValueListenableBuilder(
                valueListenable: controller.productBox.listenable(),
                builder: (context, Box<Product> box, _) {
                  List<Product> list = controller.productBox.values
                      .where((element) =>
                          element.category!.name == defaultCategoryName)
                      .toList();
                  return SliverList(
                    delegate: SliverChildBuilderDelegate(
                      (context, index) {
                        Product product = list[index];
                        return ProductWidget(
                          product: product,
                          productList: list,
                          selectProductScreen: selectProduct,
                          selectProduct: () {
                            Get.back(result: product);
                          },
                          categoryName: defaultCategoryName,
                        );
                      },
                      childCount: list.length,
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
