import 'package:hesab_ban/app/config/routes/app_pages.dart';
import 'package:hesab_ban/app/core/utils/constants.dart';
import 'package:hesab_ban/app/core/widgets/base_widget.dart';
import 'package:hesab_ban/app/core/widgets/box_container_widget.dart';
import 'package:hesab_ban/app/features/feature_customer/presentation/widgets/customers_container_widget.dart';
import 'package:hesab_ban/app/core/widgets/scroll_to_up.dart';
import 'package:hesab_ban/app/core/widgets/search_box_widget.dart';
import 'package:hesab_ban/app/features/feature_customer/presentation/controller/customer_controller.dart';
import 'package:hesab_ban/app/features/feature_search/presentation/controller/search_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hesab_ban/app/features/feature_search/presentation/screens/search_customer_screen.dart';
import 'package:iconsax/iconsax.dart';

class AllCustomerScreen extends GetView<CustomerController> {
  const AllCustomerScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    bool selectCustomer = Get.arguments ?? false;
    String? type = Get.parameters['type'];
    return BaseWidget(
      titleText:
          'لیست ${type == null ? 'مشتریان' : type == Constants.debtorType ? 'بدهکاران' : 'بستانکاران'}',
      showPaint: true,
      showLeading: true,
      child: ScrollToUp(
        showFab: controller.showCustomersFab,
        showLeftButton: true,
        leftIcon: const Icon(
          Iconsax.user_add,
        ),
        onLeftPressed: () {
          Get.toNamed(Routes.createCustomerScreen,
              parameters: {'type': type ?? ''});
        },
        scrollController: controller.customerScreenScrollController,
        child: GetBuilder<CustomerController>(
            initState: controller.setCustomerList(type),
            builder: (context) {
              return CustomScrollView(
                controller: controller.customerScreenScrollController,
                physics: const BouncingScrollPhysics(),
                slivers: [
                  SliverList(
                    delegate: SliverChildListDelegate(
                      [
                        const SizedBox(height: 10),
                        SearchBoxWidget(
                          openBuilderWidget: SearchCustomerScreen(
                            selectCustomer,
                            customers: controller.customersFiltered,
                          ),
                          onClosed: (value) {
                            Get.find<SearchBarController>().clearScreen();
                          },
                        ),
                        const SizedBox(height: 10),
                        BoxContainerWidget(
                          child: CustomersContainerWidget(
                            customerList: controller.customersFiltered,
                            selectCustomer: selectCustomer,
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
