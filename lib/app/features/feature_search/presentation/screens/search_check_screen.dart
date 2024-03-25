import 'package:hesab_ban/app/core/widgets/search_container.dart';
import 'package:hesab_ban/app/core/widgets/sliver_box_container_widget.dart';
import 'package:hesab_ban/app/features/feature_check/data/models/check_model.dart';
import 'package:hesab_ban/app/features/feature_check/presentation/widgets/check_container_widget.dart';
import 'package:hesab_ban/app/features/feature_search/presentation/controller/search_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class SearchCheckScreen extends StatelessWidget {
  const SearchCheckScreen({Key? key, required this.typeOfCheck})
      : super(key: key);
  final TypeOfCheck typeOfCheck;

  @override
  Widget build(BuildContext context) {
    SearchBarController controller =
        Get.put<SearchBarController>(SearchBarController());
    return Scaffold(
      body: SafeArea(
        child: CustomScrollView(
          slivers: [
            SearchContainer(
              textEditingController: controller.searchController,
              onChanged: (value) {
                controller.searchCheck(value, typeOfCheck);
              },
            ),
            Obx(
              () => controller.searchEmpty.value
                  ? const SliverToBoxAdapter(
                      child: Center(
                        child: Text('هیچ موردی پیدا نشد...'),
                      ),
                    )
                  : SliverBoxContainerWidget(
                      backBlur: false,
                      child: GetBuilder<SearchBarController>(
                        builder: (controller) {
                          return SliverToBoxAdapter(
                            child: CheckContainerWidget(
                              typeOfCheck: typeOfCheck,
                              checkList: controller.checkList,
                            ),
                          );
                        },
                      ),
                    ),
            ),
          ],
        ),
      ),
    );
  }
}
