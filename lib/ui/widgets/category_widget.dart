import 'package:hesab_ban/controllers/home_controller.dart';
import 'package:hesab_ban/ui/theme/app_theme.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';

import '../../data/models/category_model.dart';
import '../../static_methods.dart';
import '../theme/app_colors.dart';

class CategoryWidget extends StatelessWidget {
  const CategoryWidget({
    Key? key,
    required this.index,
    required this.category,
    required this.categoryList,
    this.selectProductScreen = false,
    this.fromSearch = false,
  }) : super(key: key);
  final int index;
  final Category category;
  final List<Category> categoryList;
  final bool selectProductScreen;
  final bool fromSearch;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 10),
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
          leading: const FaIcon(
            FontAwesomeIcons.solidFolder,
            color: kTealColor,
          ),
          onTap: () {
            Get.find<HomeController>().navigateToCategory(
              context,
              category.name!,
              selectProductScreen,
              fromSearch,
            );
          },
          onLongPress: selectProductScreen
              ? null
              : () {
                  StaticMethods.productBottomSheet(
                    context,
                    name: category.name!,
                    onEditTap: () {
                      Get.back();
                      StaticMethods.showFolderDialog(
                        title: 'ویرایش ${category.name}',
                        controller:
                            Get.find<HomeController>().categoryNameController,
                        onTap: () {
                          Get.find<HomeController>().updateCategory(category);
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
                          Get.find<HomeController>().deleteCategory(category);
                          Get.back();
                        },
                      );
                    },
                  );
                },
        ),
      ),
    );
  }
}
