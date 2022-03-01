import 'package:accounting_app/controllers/search_controller.dart';
import 'package:accounting_app/models/check_model.dart';
import 'package:accounting_app/ui/widgets/check_container_widget.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../widgets/box_container_widget.dart';
import '../widgets/search_container.dart';

// ignore: must_be_immutable
class SearchCheckScreen extends StatelessWidget {
  SearchCheckScreen({Key? key, required this.typeOfCheck}) : super(key: key);
  final TypeOfCheck typeOfCheck;
  SearchController controller = Get.put<SearchController>(SearchController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: CustomScrollView(
          slivers: [
            SearchContainer(
              textEditingController: controller.searchController,
              onChanged: (value) {
                controller.searchCheck(value,typeOfCheck);
              },
            ),
            Obx(
              () => controller.searchEmpty.value
                  ? const SliverToBoxAdapter(
                      child: Center(
                        child: Text('هیچ موردی پیدا نشد...'),
                      ),
                    )
                  : BoxContainerWidget(
                      child: GetBuilder<SearchController>(
                        builder: (controller) {
                          return CheckContainerWidget(
                            typeOfCheck: typeOfCheck,
                            onRowTapped: (selected) {},
                            miniDataTable: false,
                            isBox: false,
                            checkList: controller.checkList,
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
