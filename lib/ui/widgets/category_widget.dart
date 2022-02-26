import 'package:accounting_app/controllers/product_controller.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';

import '../../models/category_model.dart';
import '../../static_methods.dart';
import '../theme/app_colors.dart';

class CategoryWidget extends StatelessWidget {
  const CategoryWidget({
    Key? key,
    required this.index,
    required this.category,
    required this.categoryList,
  }) : super(key: key);
  final int index;
  final Category category;
  final List<Category> categoryList;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 10),
      child: ListTile(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(
            top: Radius.circular(index == 1 ? 15 : 0),
            bottom: Radius.circular(category == categoryList.last ? 15 : 0),
          ),
        ),
        title: Text(category.name!),
        leading: const FaIcon(
          FontAwesomeIcons.solidFolder,
          color: kTealColor,
        ),
        onTap: () {
          Get.find<ProductController>().navigateToCategory(
            context,
            category.name!,
          );
        },
        onLongPress: () {
          StaticMethods.productBottomSheet(
            context,
            name: category.name!,
            onEditTap: () {
              Get.back();
              StaticMethods.showFolderDialog(
                title: 'ویرایش ${category.name}',
                controller:
                    Get.find<ProductController>().categoryNameController,
                onTap: () {
                  Get.find<ProductController>().updateCategory(category);
                  Get.back();
                },
              );
            },
            onDeleteTap: () {
              Get.back();
              StaticMethods.deleteDialog(
                content:
                    'در صورت حذف پوشه "${category.name}" تمام کالاهای داخل آن نیز حذف می شوند.'
                    ' این عملیات برگشت پذیر نیست. آیا مطمئن هستید؟',
                onConfirm: () {
                  Get.find<ProductController>().deleteCategory(category);
                  Get.back();
                },
              );
            },
          );
        },
      ),
    );
  }
}
