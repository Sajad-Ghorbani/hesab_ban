import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hesab_ban/app/config/theme/app_colors.dart';
import 'package:hesab_ban/app/config/theme/app_theme.dart';
import 'package:hesab_ban/app/core/utils/static_methods.dart';
import 'package:hesab_ban/app/features/feature_product/domain/entities/category_entity.dart';
import 'package:hesab_ban/app/features/feature_product/presentation/controller/product_controller.dart';
import 'package:iconsax/iconsax.dart';

class CategoryWidget extends StatelessWidget {
  const CategoryWidget({
    super.key,
    required this.index,
    required this.category,
    required this.categoryList,
    this.selectProductScreen = false,
    this.fromSearch = false,
    this.highlighted = false,
  });
  final int index;
  final CategoryEntity category;
  final List<CategoryEntity> categoryList;
  final bool selectProductScreen;
  final bool fromSearch;
  final bool highlighted;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 10),
      decoration: BoxDecoration(
        border: highlighted ? Border.all(
          color: Theme.of(context).colorScheme.secondary,
          width: 1.5,
        ) : null,
        borderRadius: const BorderRadius.all(Radius.circular(15))
      ),
      child: Transform.scale(
        scale: highlighted ? 1.05 : 1.0,
        child: Theme(
          data: AppThemeData.darkTheme.copyWith(
              splashColor: Colors.transparent,
              highlightColor: Colors.transparent),
          child: ListTile(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.vertical(
                top: Radius.circular(index == 1 ? 15 : 0),
                bottom: Radius.circular(category == categoryList.last ? 15 : 0),
              ),
            ),
            title: Text(
              category.name!,
              style: TextStyle(
                color: Theme.of(context).colorScheme.onBackground,
              ),
            ),
            leading: const Icon(
              Iconsax.folder_2,
              color: kTealColor,
            ),
            onTap: () {
              Get.find<ProductController>().navigateToCategory(
                category.name!,
                selectProductScreen,
                fromSearch,
              );
            },
            onLongPress: selectProductScreen
                ? null
                : () {
                    StaticMethods.customBottomSheet(
                      context,
                      name: category.name!,
                      onEditTap: () {
                        Get.back();
                        StaticMethods.showSingleRowDialog(
                          title: 'ویرایش ${category.name}',
                          rowTitle: 'نام پوشه',
                          controller: Get.find<ProductController>()
                              .categoryNameController,
                          onTap: () {
                            Get.find<ProductController>()
                                .updateCategory(category);
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
                            Get.find<ProductController>()
                                .deleteCategory(category);
                            Get.back();
                          },
                        );
                      },
                    );
                  },
          ),
        ),
      ),
    );
  }
}
