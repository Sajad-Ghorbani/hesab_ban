import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hesab_ban/app/core/widgets/search_container.dart';
import 'package:hesab_ban/app/core/widgets/sliver_box_container_widget.dart';
import 'package:hesab_ban/app/features/feature_factor/domain/entities/factor_entity.dart';
import 'package:hesab_ban/app/features/feature_factor/presentation/widgets/factor_tab_widget.dart';
import 'package:hesab_ban/app/features/feature_search/presentation/controller/search_controller.dart';

class SearchFactorScreen extends StatelessWidget {
  const SearchFactorScreen({Key? key, required this.factors}) : super(key: key);
  final List<FactorEntity> factors;

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
                controller.searchFactor(value, factors);
              },
            ),
            Obx(
              () => controller.searchEmpty.value
                  ? const SliverToBoxAdapter(
                      child: Center(
                        child: Text('هیچ موردی پیدا نشد...'),
                      ),
                    )
                  : GetBuilder<SearchBarController>(
                      builder: (controller) {
                        if (controller.factorList.isEmpty) {
                          return const SliverBoxContainerWidget(
                            child: SliverToBoxAdapter(
                              child: Center(
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    SizedBox(
                                      height: 20,
                                    ),
                                    Text('لیست فاکتور ها خالی می باشد.'),
                                    SizedBox(
                                      height: 20,
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          );
                        } //
                        return SliverList(
                          delegate: SliverChildBuilderDelegate(
                            (context, index) {
                              return Column(
                                children: [
                                  FactorTabWidget(
                                      factor: controller.factorList[index]),
                                  const SizedBox(height: 10),
                                ],
                              );
                            },
                            childCount: controller.factorList.length,
                          ),
                        );
                      },
                    ),
            ),
          ],
        ),
      ),
    );
  }
}
