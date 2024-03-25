import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hesab_ban/app/core/widgets/search_container.dart';
import 'package:hesab_ban/app/core/widgets/sliver_box_container_widget.dart';
import 'package:hesab_ban/app/features/feature_cash/domain/entities/cash_entity.dart';
import 'package:hesab_ban/app/features/feature_cash/presentation/widgets/cash_container_widget.dart';
import 'package:hesab_ban/app/features/feature_search/presentation/controller/search_controller.dart';

class SearchCashScreen extends StatelessWidget {
  const SearchCashScreen({Key? key, required this.cashes, required this.type})
      : super(key: key);
  final List<CashEntity> cashes;
  final String type;

  @override
  Widget build(BuildContext context) {
    SearchBarController controller = Get.put(SearchBarController());
    return Scaffold(
      body: SafeArea(
        child: CustomScrollView(
          slivers: [
            SearchContainer(
              textEditingController: controller.searchController,
              onChanged: (value) {
                controller.searchCash(value, cashes);
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
                            child: CashContainerWidget(
                              cashList: controller.cashList,
                              type: type,
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
