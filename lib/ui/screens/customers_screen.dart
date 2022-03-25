import 'package:hesab_ban/controllers/home_controller.dart';
import 'package:hesab_ban/routes/app_pages.dart';
import 'package:hesab_ban/ui/screens/search_customer_screen.dart';
import 'package:hesab_ban/ui/widgets/base_widget.dart';
import 'package:hesab_ban/ui/widgets/sliver_box_container_widget.dart';
import 'package:hesab_ban/ui/widgets/customers_container_widget.dart';
import 'package:hesab_ban/ui/widgets/grid_menu_widget.dart';
import 'package:hesab_ban/ui/widgets/scroll_to_up.dart';
import 'package:hesab_ban/ui/widgets/search_box_widget.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../controllers/search_controller.dart';

class CustomersScreen extends GetView<HomeController> {
  const CustomersScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    bool selectCustomer = Get.arguments ?? false;
    return BaseWidget(
      title: 'لیست مشتریان',
      appBarLeading: IconButton(
        onPressed: () {
          Navigator.pop(context);
        },
        icon: const Icon(Icons.arrow_back_ios),
        splashRadius: 30,
      ),
      child: ScrollToUp(
        showFab: controller.showCustomersFab,
        scrollController: controller.customerScreenScrollController,
        hideBottomSheet: selectCustomer,
        child: CustomScrollView(
          controller: controller.customerScreenScrollController,
          physics: const BouncingScrollPhysics(),
          slivers: [
            if (selectCustomer)
              const SliverToBoxAdapter(
                child: SizedBox(
                  height: 10,
                ),
              )
            else
              SliverPadding(
                padding: const EdgeInsets.all(10),
                sliver: SliverToBoxAdapter(
                  child: GridMenuWidget(
                    title: 'ایجاد حساب جدید',
                    onTap: () {
                      Get.toNamed(Routes.createCustomerScreen);
                    },
                    width: MediaQuery.of(context).size.width / 2 - 25,
                  ),
                ),
              ),
            SliverToBoxAdapter(
              child: SearchBoxWidget(
                searchText: 'جست و جو',
                openBuilderWidget: SearchCustomerScreen(selectCustomer),
                onClosed: (value) {
                  Get.find<SearchController>().clearScreen();
                },
              ),
            ),
            GetBuilder<HomeController>(builder: (myController) {
              return SliverBoxContainerWidget(
                child: CustomersContainerWidget(
                  miniDataTable: false,
                  selectCustomer: selectCustomer,
                ),
              );
            }),
            const SliverToBoxAdapter(
              child: SizedBox(
                height: 75,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
