import 'package:hesab_ban/app/config/routes/app_pages.dart';
import 'package:hesab_ban/app/core/utils/constants.dart';
import 'package:hesab_ban/app/core/utils/static_methods.dart';
import 'package:hesab_ban/app/core/widgets/base_widget.dart';
import 'package:hesab_ban/app/core/widgets/scroll_to_up.dart';
import 'package:hesab_ban/app/core/widgets/search_box_widget.dart';
import 'package:hesab_ban/app/core/widgets/sliver_box_container_widget.dart';
import 'package:hesab_ban/app/features/feature_product/domain/entities/category_entity.dart';
import 'package:hesab_ban/app/features/feature_product/domain/entities/product_entity.dart';
import 'package:hesab_ban/app/features/feature_product/presentation/controller/product_controller.dart';
import 'package:hesab_ban/app/features/feature_product/presentation/widgets/category_widget.dart';
import 'package:hesab_ban/app/features/feature_product/presentation/widgets/product_widget.dart';
import 'package:hesab_ban/app/features/feature_search/presentation/controller/search_controller.dart';
import 'package:hesab_ban/app/features/feature_search/presentation/screens/search_product_screen.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:iconsax/iconsax.dart';

class AllProductScreen extends StatelessWidget {
  const AllProductScreen({super.key});

  @override
  Widget build(BuildContext context) {
    bool selectProduct = Get.arguments ?? false;
    return GetBuilder<ProductController>(
      builder: (controller) {
        return BaseWidget(
          titleText: 'کالاها',
          showLeading: selectProduct,
          showPaint: true,
          appBarLeading: selectProduct
              ? IconButton(
                  onPressed: () {
                    Get.back();
                  },
                  icon: const Icon(Icons.arrow_back_ios),
                  color: Colors.white,
                  splashRadius: 30,
                )
              : null,
          child: ScrollToUp(
            showFab: controller.showProductsFab,
            scrollController: controller.productScreenScrollController,
            hideBottomSheet: selectProduct,
            showLeftButton: selectProduct,
            leftIcon: const Icon(Iconsax.add_square),
            showMultiLeftButton: true,
            firstIcon: Iconsax.box_add,
            secondIcon: Iconsax.folder_add,
            firstIconOnTap: () {
              Get.toNamed(
                Routes.createProductScreen,
                parameters: {'categoryName': Constants.defaultCategoryName},
              );
            },
            secondIconOnTap: () {
              StaticMethods.showSingleRowDialog(
                title: 'ساخت پوشه جدید',
                rowTitle: 'نام پوشه',
                controller: controller.categoryNameController,
                onTap: () {
                  controller.addNewCategory();
                },
              );
            },
            child: CustomScrollView(
              controller: controller.productScreenScrollController,
              slivers: [
                const SliverToBoxAdapter(
                  child: SizedBox(
                    height: 10,
                  ),
                ),
                SliverList(
                  delegate: SliverChildListDelegate(
                    [
                      Row(
                        children: [
                          Expanded(
                            child: SearchBoxWidget(
                              openBuilderWidget: SearchProductScreen(
                                  selectProduct: selectProduct),
                              onClosed: (value) {
                                Get.find<SearchBarController>().clearScreen();
                              },
                            ),
                          ),
                          PopupMenuButton(
                            splashRadius: 1,
                            offset: const Offset(-10, 40),
                            shape: const RoundedRectangleBorder(
                                borderRadius:
                                    BorderRadius.all(Radius.circular(7))),
                            iconSize: 26,
                            tooltip: 'چیدمان لیست',
                            itemBuilder: (context) {
                              List sortsLabel = [
                                'حروف الفبا',
                                'کمترین موجودی',
                                'بیشترین موجودی',
                              ];
                              return List.generate(3, (index) {
                                return PopupMenuItem(
                                  onTap: () {
                                    controller.sortProducts(index);
                                  },
                                  height: 40,
                                  child: Text(sortsLabel[index]),
                                );
                              });
                            },
                            icon: const Icon(Iconsax.sort),
                          ),
                          const SizedBox(width: 10),
                        ],
                      ),
                      const SizedBox(
                        height: 10,
                      ),
                    ],
                  ),
                ),
                SliverBoxContainerWidget(
                  child: SliverList(
                    delegate: SliverChildBuilderDelegate(
                      (context, index) {
                        CategoryEntity category = controller.categories[index];
                        return Visibility(
                          visible:
                              category.name != Constants.defaultCategoryName,
                          child: DragTarget<ProductEntity>(
                            builder: (context, candidateData, rejectedData) {
                              return CategoryWidget(
                                index: index,
                                category: category,
                                categoryList: controller.categories,
                                selectProductScreen: selectProduct,
                                highlighted: candidateData.isNotEmpty,
                              );
                            },
                            onAcceptWithDetails:
                                (DragTargetDetails<ProductEntity> details) {
                              controller.moveProductToCategory(
                                  details.data, category);
                            },
                          ),
                        );
                      },
                      childCount: controller.categories.length,
                    ),
                  ),
                ),
                const SliverToBoxAdapter(
                  child: SizedBox(
                    height: 10,
                  ),
                ),
                GetBuilder<ProductController>(
                  builder: (_) {
                    List<ProductEntity> products = controller.products
                        .where((element) =>
                            element.category!.name ==
                            Constants.defaultCategoryName)
                        .toList();
                    return SliverBoxContainerWidget(
                      child: SliverList(
                        delegate: SliverChildBuilderDelegate(
                          (context, index) {
                            ProductEntity product = products[index];
                            return LongPressDraggable<ProductEntity>(
                              data: product,
                              axis: Axis.vertical,
                              dragAnchorStrategy:
                                  (draggable, context, position) {
                                final RenderBox renderObject =
                                    context.findRenderObject()! as RenderBox;
                                return renderObject.globalToLocal(
                                    Offset(position.dx - 20, position.dy));
                              },
                              onDragUpdate: (details) {
                                if (details.localPosition.dy < 160) {
                                  controller.productScreenScrollController
                                      .animateTo(
                                    0,
                                    duration: const Duration(milliseconds: 400),
                                    curve: Curves.fastOutSlowIn,
                                  );
                                }
                              },
                              feedback: Opacity(
                                opacity: 0.6,
                                child: Material(
                                  borderRadius: const BorderRadius.all(
                                      Radius.circular(15)),
                                  child: SizedBox(
                                    width:
                                        MediaQuery.of(context).size.width - 40,
                                    child: ProductWidget(
                                      product: product,
                                      categoryName:
                                          Constants.defaultCategoryName,
                                    ),
                                  ),
                                ),
                              ),
                              child: ProductWidget(
                                product: product,
                                selectProductScreen: selectProduct,
                                selectProduct: () {
                                  Get.back(result: product);
                                },
                                categoryName: Constants.defaultCategoryName,
                              ),
                            );
                          },
                          childCount: products.length,
                        ),
                      ),
                    );
                  },
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
      },
    );
  }
}
