import 'package:hesab_ban/app/config/routes/app_pages.dart';
import 'package:hesab_ban/app/core/widgets/base_widget.dart';
import 'package:hesab_ban/app/core/widgets/box_container_widget.dart';
import 'package:hesab_ban/app/features/feature_check/presentation/widgets/check_container_widget.dart';
import 'package:hesab_ban/app/core/widgets/scroll_to_up.dart';
import 'package:hesab_ban/app/core/widgets/search_box_widget.dart';
import 'package:hesab_ban/app/features/feature_check/data/models/check_model.dart';
import 'package:hesab_ban/app/features/feature_check/presentation/controller/check_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hesab_ban/app/features/feature_search/presentation/controller/search_controller.dart';
import 'package:hesab_ban/app/features/feature_search/presentation/screens/search_check_screen.dart';
import 'package:iconsax/iconsax.dart';

class AllCheckScreen extends GetView<CheckController> {
  const AllCheckScreen({super.key});

  @override
  Widget build(BuildContext context) {
    TypeOfCheck typeOfCheck = Get.arguments;
    return BaseWidget(
      titleText: typeOfCheck == TypeOfCheck.send
          ? 'لیست چکهای پرداختی'
          : 'لیست چکهای دریافتی',
      showPaint: true,
      showLeading: true,
      child: ScrollToUp(
        showFab: controller.showCheckFab,
        scrollController: controller.checkScreenScrollController,
        showLeftButton: true,
        leftIcon: const Icon(
          Iconsax.money_add,
        ),
        onLeftPressed: () {
          Get.toNamed(Routes.createCheckScreen);
        },
        child: CustomScrollView(
          controller: controller.checkScreenScrollController,
          physics: const BouncingScrollPhysics(),
          slivers: [
            SliverList(
              delegate: SliverChildListDelegate(
                [
                  const SizedBox(height: 10),
                  SearchBoxWidget(
                    openBuilderWidget: SearchCheckScreen(
                      typeOfCheck: typeOfCheck,
                    ),
                    onClosed: (value) {
                      Get.find<SearchBarController>().clearScreen();
                    },
                  ),
                  const SizedBox(height: 10),
                  GetBuilder<CheckController>(
                    builder: (controller) {
                      return BoxContainerWidget(
                        child: CheckContainerWidget(
                          typeOfCheck: typeOfCheck,
                          checkList: controller.checks
                              .where((element) =>
                                  element.typeOfCheck == typeOfCheck)
                              .toList(),
                        ),
                      );
                    },
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
