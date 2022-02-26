import 'package:accounting_app/constants.dart';
import 'package:accounting_app/controllers/product_controller.dart';
import 'package:accounting_app/controllers/search_controller.dart';
import 'package:accounting_app/routes/app_pages.dart';
import 'package:accounting_app/ui/screens/search_screen.dart';
import 'package:accounting_app/ui/theme/app_colors.dart';
import 'package:accounting_app/ui/widgets/base_widget.dart';
import 'package:accounting_app/ui/widgets/category_widget.dart';
import 'package:accounting_app/ui/widgets/grid_menu_widget.dart';
import 'package:accounting_app/ui/widgets/product_list.dart';
import 'package:accounting_app/ui/widgets/product_widget.dart';
import 'package:animations/animations.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:get/get.dart';

import '../../models/category_model.dart';
import '../../models/product_model.dart';
import '../../static_methods.dart';

class AllProductScreen extends GetView<ProductController> {
  const AllProductScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BaseWidget(
      title: 'کالاها',
      child: Stack(
        children: [
          NotificationListener<UserScrollNotification>(
            onNotification: (notification) {
              if (notification.direction == ScrollDirection.forward) {
                controller.showProductsFab.value = true;
              } //
              else if (notification.direction == ScrollDirection.reverse) {
                controller.showProductsFab.value = false;
              }
              return true;
            },
            child: CustomScrollView(
              controller: controller.scrollController,
              physics: const BouncingScrollPhysics(),
              slivers: [
                SliverToBoxAdapter(
                  child: Padding(
                    padding: const EdgeInsets.all(10.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        GridMenuWidget(
                            title: 'ساخت محصول جدید',
                            onTap: () {
                              Get.toNamed(Routes.productScreen);
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
                SliverToBoxAdapter(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 10),
                    child: OpenContainer(
                      closedBuilder: (context, action) {
                        return Container(
                          height: 45,
                          width: 20,
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
                            children: const [
                              Icon(Icons.search,color: kOrangeColor,),
                              SizedBox(width: 20,),
                              Text('جست و جوی کالا'),
                            ],
                          ),
                          alignment: Alignment.centerRight,
                          padding: const EdgeInsets.symmetric(horizontal: 10),
                        );
                      },
                      openBuilder: (context, action) {
                        return SearchScreen();
                      },
                      closedElevation: 0,
                      closedColor: Colors.transparent,
                      onClosed: (value){
                        Get.find<SearchController>().clearScreen();
                      },
                    ),
                  ),
                ),
                ProductListWidget(
                  child: Obx(
                    () => SliverList(
                      delegate: SliverChildBuilderDelegate(
                        (context, index) {
                          List<Category> list = controller
                              .productCategory.value.reversed
                              .toList();
                          Category category = list[index];
                          return Visibility(
                            visible: category.name != defaultCategoryName,
                            child: CategoryWidget(
                              index: index,
                              category: category,
                              categoryList: list,
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
                ProductListWidget(
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
          Positioned(
            bottom: 70,
            right: 10,
            child: Obx(
              () => AnimatedScale(
                duration: const Duration(milliseconds: 200),
                scale: controller.showProductsFab.value ? 1 : 0,
                child: FloatingActionButton(
                  onPressed: () {
                    controller.scrollController.animateTo(
                      0,
                      duration: const Duration(milliseconds: 200),
                      curve: Curves.fastOutSlowIn,
                    );
                  },
                  child: const Icon(Icons.arrow_upward_rounded),
                  mini: true,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
