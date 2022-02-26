import 'package:accounting_app/controllers/product_controller.dart';
import 'package:accounting_app/ui/widgets/base_widget.dart';
import 'package:accounting_app/ui/widgets/product_list.dart';
import 'package:accounting_app/ui/widgets/product_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:get/get.dart';

import '../../models/product_model.dart';
import '../../routes/app_pages.dart';
import '../widgets/grid_menu_widget.dart';

class ProductFolderScreen extends GetView<ProductController> {
  const ProductFolderScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BaseWidget(
      title: controller.productCategoryName,
      appBarLeading: IconButton(
        onPressed: () {
          controller.backToHome(context);
        },
        icon: const Icon(Icons.arrow_back_ios),
        splashRadius: 30,
      ),
      child: Stack(
        children: [
          NotificationListener<UserScrollNotification>(
            onNotification: (notification) {
              if (notification.direction == ScrollDirection.forward) {
                controller.showCategoryProductsFab.value = true;
              } //
              else if (notification.direction == ScrollDirection.reverse) {
                controller.showCategoryProductsFab.value = false;
              }
              return true;
            },
            child: CustomScrollView(
              controller: controller.scrollController,
              physics: const BouncingScrollPhysics(),
              slivers: [
                SliverPadding(
                  padding: const EdgeInsets.all(10),
                  sliver: SliverToBoxAdapter(
                    child: Wrap(
                      children: [
                        GridMenuWidget(
                          title: 'ساخت محصول جدید',
                          onTap: () {
                            Get.toNamed(Routes.productScreen);
                          },
                        ),
                      ],
                    ),
                  ),
                ),
                Obx(
                  () => ProductListWidget(
                    child: SliverList(
                      delegate: SliverChildBuilderDelegate(
                        (context, index) {
                          Product product =
                              controller.allProductCategory.value[index];
                          return ProductWidget(
                            product: product,
                            productList: controller.allProductCategory.value,
                          );
                        },
                        childCount: controller.allProductCategory.value.length,
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
                scale: controller.showCategoryProductsFab.value ? 1 : 0,
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
