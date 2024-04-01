import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hesab_ban/app/core/widgets/search_container.dart';
import 'package:hesab_ban/app/core/widgets/sliver_box_container_widget.dart';
import 'package:hesab_ban/app/features/feature_customer/domain/entities/customer_entity.dart';
import 'package:hesab_ban/app/features/feature_customer/presentation/widgets/customers_container_widget.dart';
import 'package:hesab_ban/app/features/feature_search/presentation/controller/search_controller.dart';

class SearchCustomerScreen extends StatelessWidget {
  const SearchCustomerScreen(this.selectCustomer,
      {super.key, required this.customers});
  final bool selectCustomer;
  final List<CustomerEntity> customers;

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
                controller.searchCustomer(value, customers);
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
                            child: CustomersContainerWidget(
                              customerList: controller.customerList,
                              selectCustomer: selectCustomer,
                              fromSearch: true,
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
