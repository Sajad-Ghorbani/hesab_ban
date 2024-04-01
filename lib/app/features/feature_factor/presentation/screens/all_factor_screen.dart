import 'package:animations/animations.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hesab_ban/app/core/utils/static_methods.dart';
import 'package:hesab_ban/app/core/widgets/base_widget.dart';
import 'package:hesab_ban/app/core/widgets/scroll_to_up.dart';
import 'package:hesab_ban/app/features/feature_factor/presentation/controller/factor_controller.dart';
import 'package:hesab_ban/app/features/feature_factor/presentation/widgets/factor_tab_widget.dart';
import 'package:hesab_ban/app/features/feature_factor/presentation/widgets/date_filter_widget.dart';
import 'package:hesab_ban/app/features/feature_factor/presentation/widgets/date_label_widget.dart';
import 'package:hesab_ban/app/features/feature_factor/presentation/widgets/not_factor.dart';
import 'package:hesab_ban/app/features/feature_search/presentation/controller/search_controller.dart';
import 'package:hesab_ban/app/features/feature_search/presentation/screens/search_factor_screen.dart';
import 'package:iconsax/iconsax.dart';

class AllFactorScreen extends GetView<FactorController> {
  const AllFactorScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final String typeOfFactor = Get.arguments;
    return GetBuilder<FactorController>(
      initState: (state) => controller.initializeFactors(typeOfFactor),
      builder: (_) {
        return BaseWidget(
          titleText: StaticMethods.setTypeFactorString(typeOfFactor),
          showLeading: true,
          appBarActions: [
            OpenContainer(
              closedBuilder: (context, action) {
                return const Icon(
                  Iconsax.search_normal_1,
                );
              },
              closedColor: Theme.of(context).appBarTheme.backgroundColor!,
              closedElevation: 0,
              openBuilder: (context, action) {
                return SearchFactorScreen(factors: controller.factors);
              },
              onClosed: (data) {
                Get.find<SearchBarController>().clearScreen();
              },
            ),
            const SizedBox(width: 10),
          ],
          child: ScrollToUp(
            showFab: controller.allFactorScreenShowFab,
            scrollController: controller.allFactorScreenScrollController,
            child: Column(
              children: [
                Padding(
                  padding:
                      const EdgeInsets.symmetric(vertical: 5, horizontal: 10),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: List.generate(4, (index) {
                      List<String> labels = [
                        'امروز',
                        'یک هفته',
                        'یک ماه',
                        'سه ماه',
                      ];
                      return Row(
                        children: [
                          DateFilterWidget(
                            title: labels[index],
                            onTap: () {
                              controller.filterTapped(index);
                            },
                            isSelected: index == controller.filterIndex,
                          ),
                          if (index != 3) const SizedBox(width: 10),
                        ],
                      );
                    }),
                  ),
                ),
                Padding(
                  padding:
                      const EdgeInsets.symmetric(vertical: 5, horizontal: 10),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      DateLabelWidget(
                        date: controller.startDateFilterLabel,
                        onTap: () {
                          controller.filterDateTapped(true, context);
                        },
                      ),
                      const SizedBox(width: 10),
                      const Text('تا'),
                      const SizedBox(width: 10),
                      DateLabelWidget(
                        date: controller.endDateFilterLabel,
                        onTap: () {
                          controller.filterDateTapped(false, context);
                        },
                      ),
                    ],
                  ),
                ),
                Expanded(
                  child: controller.factorsFiltered.isEmpty
                      ? const NotFactor()
                      : ListView.separated(
                          itemCount: controller.factorsFiltered.length,
                          padding: const EdgeInsets.fromLTRB(10, 5, 10, 30),
                          controller:
                              controller.allFactorScreenScrollController,
                          itemBuilder: (context, index) {
                            var factor = controller.factorsFiltered[index];
                            return FactorTabWidget(factor: factor);
                          },
                          separatorBuilder: (BuildContext context, int index) {
                            return const SizedBox(height: 10);
                          },
                        ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
