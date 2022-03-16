// ignore_for_file: must_be_immutable

import 'package:hesab_ban/ui/widgets/customers_container_widget.dart';
import 'package:hesab_ban/ui/widgets/search_container.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../controllers/search_controller.dart';
import '../widgets/sliver_box_container_widget.dart';

class SearchCustomerScreen extends StatelessWidget {
  SearchCustomerScreen(this.selectCustomer,{Key? key}) : super(key: key);
  SearchController controller = Get.put(SearchController());
  final bool selectCustomer;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: CustomScrollView(
          slivers: [
            SearchContainer(
              textEditingController: controller.searchController,
              onChanged: (value) {
                controller.searchCustomer(value);
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
                      child: GetBuilder<SearchController>(
                        builder: (controller) {
                          return CustomersContainerWidget(
                            isBox: false,
                            customerList: controller.customerList,
                            miniDataTable: false,
                            selectCustomer: selectCustomer,
                            fromSearch: true,
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
