import 'package:flutter_svg/flutter_svg.dart';
import 'package:hesab_ban/app/config/routes/app_pages.dart';
import 'package:hesab_ban/app/core/widgets/base_widget.dart';
import 'package:hesab_ban/app/core/widgets/box_container_widget.dart';
import 'package:hesab_ban/app/features/feature_cash/domain/entities/cash_entity.dart';
import 'package:hesab_ban/app/features/feature_cash/presentation/controller/cash_controller.dart';
import 'package:hesab_ban/app/features/feature_cash/presentation/widgets/cash_container_widget.dart';
import 'package:hesab_ban/app/core/widgets/scroll_to_up.dart';
import 'package:hesab_ban/app/core/widgets/search_box_widget.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hesab_ban/app/features/feature_search/presentation/controller/search_controller.dart';
import 'package:hesab_ban/app/features/feature_search/presentation/screens/search_cash_screen.dart';

class AllCashScreen extends GetView<CashController> {
  const AllCashScreen({super.key});

  @override
  Widget build(BuildContext context) {
    String type = Get.arguments;
    return BaseWidget(
      titleText:
          type == 'send' ? 'لیست پرداختی های نقدی' : 'لیست دریافتی های نقدی',
      showPaint: true,
      showLeading: true,
      child: ScrollToUp(
        showFab: controller.showCashFab,
        scrollController: controller.cashScreenScrollController,
        showLeftButton: true,
        leftIcon: SvgPicture.asset(
          'assets/images/coin-plus.svg',
          colorFilter: const ColorFilter.mode(Colors.white, BlendMode.srcIn),
        ),
        onLeftPressed: () {
          Get.toNamed(Routes.createCashScreen);
        },
        child: GetBuilder<CashController>(builder: (controller) {
          List<CashEntity> cashes = controller.cashes
              .where((element) => type == 'send'
                  ? element.cashAmount! < 0
                  : element.cashAmount! >= 0)
              .toList();
          return CustomScrollView(
            controller: controller.cashScreenScrollController,
            slivers: [
              SliverList(
                delegate: SliverChildListDelegate(
                  [
                    const SizedBox(height: 10),
                    SearchBoxWidget(
                      openBuilderWidget: SearchCashScreen(
                        cashes: cashes,
                        type: type,
                      ),
                      onClosed: (value) {
                        Get.find<SearchBarController>().clearScreen();
                      },
                    ),
                    const SizedBox(height: 10),
                    BoxContainerWidget(
                      child: CashContainerWidget(
                        cashList: cashes,
                        type: type,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          );
        }),
      ),
    );
  }
}
