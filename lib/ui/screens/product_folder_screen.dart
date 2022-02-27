import 'package:accounting_app/controllers/product_controller.dart';
import 'package:accounting_app/ui/widgets/base_widget.dart';
import 'package:accounting_app/ui/widgets/box_container_widget.dart';
import 'package:accounting_app/ui/widgets/product_widget.dart';
import 'package:accounting_app/ui/widgets/scroll_to_up.dart';
import 'package:flutter/material.dart';
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
      child: ScrollToUp(
        showFab: controller.showCategoryProductsFab,
        scrollController: controller.scrollController,
        child: CustomScrollView(
          controller: controller.scrollController,
          physics: const BouncingScrollPhysics(),
          slivers: [
            SliverPadding(
              padding: const EdgeInsets.all(10),
              sliver: SliverToBoxAdapter(
                child: GridMenuWidget(
                  title: 'ساخت محصول جدید',
                  onTap: () {
                    Get.toNamed(Routes.productScreen);
                  },
                ),
              ),
            ),
            Obx(
              () => BoxContainerWidget(
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
    );
  }
}
