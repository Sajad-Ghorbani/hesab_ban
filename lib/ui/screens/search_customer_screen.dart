// ignore_for_file: must_be_immutable

import 'package:accounting_app/controllers/customer_controller.dart';
import 'package:accounting_app/models/customer_model.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:persian_number_utility/persian_number_utility.dart';

import '../../controllers/search_controller.dart';
import '../../routes/app_pages.dart';
import '../../static_methods.dart';
import '../theme/app_colors.dart';
import '../theme/constants_app_styles.dart';
import '../widgets/box_container_widget.dart';

class SearchCustomerScreen extends StatelessWidget {
  SearchCustomerScreen({Key? key}) : super(key: key);
  SearchController controller = Get.put(SearchController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 10),
          child: CustomScrollView(
            slivers: [
              SliverList(
                delegate: SliverChildListDelegate(
                  [
                    const SizedBox(
                      height: 10,
                    ),
                    Container(
                      height: 45,
                      width: MediaQuery.of(context).size.width,
                      margin: const EdgeInsets.only(bottom: 10),
                      decoration: BoxDecoration(
                        borderRadius: const BorderRadius.all(
                          Radius.circular(15),
                        ),
                        border: Border.all(
                          color: kGreyColor,
                          width: 1.5,
                        ),
                        gradient: LinearGradient(
                          colors: [
                            kGreyColor.withOpacity(0.4),
                            kSurfaceColor.withOpacity(0.4),
                          ],
                          begin: Alignment.topRight,
                          end: Alignment.bottomLeft,
                        ),
                      ),
                      child: Row(
                        children: [
                          const Icon(
                            Icons.search,
                            color: kOrangeColor,
                          ),
                          const SizedBox(
                            width: 20,
                          ),
                          Expanded(
                            child: TextField(
                              controller: controller.searchController,
                              decoration: customInputDecoration,
                              autofocus: true,
                              onChanged: (value) {
                                controller.searchCustomer(value);
                              },
                            ),
                          ),
                        ],
                      ),
                      alignment: Alignment.centerRight,
                      padding: const EdgeInsets.symmetric(horizontal: 10),
                    ),
                  ],
                ),
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
                            return SliverToBoxAdapter(
                              child: Padding(
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 10.0),
                                child: DataTable(
                                  columnSpacing: 20,
                                  showCheckboxColumn: false,
                                  columns: const [
                                    DataColumn(
                                      label: Text('ردیف'),
                                      numeric: true,
                                    ),
                                    DataColumn(label: Text('نام')),
                                    DataColumn(label: Text('شماره تماس')),
                                  ],
                                  rows: List<DataRow>.generate(
                                    controller.customerList.length,
                                    (index) {
                                      Customer customer =
                                          controller.customerList[index];
                                      return DataRow(
                                        cells: [
                                          DataCell(
                                            Text(
                                              (index + 1)
                                                  .toString()
                                                  .toPersianDigit(),
                                            ),
                                          ),
                                          DataCell(
                                            Text(customer.name!),
                                          ),
                                          DataCell(
                                            Text(
                                              (customer.phoneNumber1)
                                                  .toString()
                                                  .toPersianDigit(),
                                            ),
                                          ),
                                        ],
                                        onSelectChanged: (bool? selected) {
                                          Get.toNamed(
                                              Routes.customerBalanceScreen);
                                        },
                                        onLongPress: () {
                                          StaticMethods.productBottomSheet(
                                            context,
                                            name: customer.name!,
                                            onEditTap: () {
                                              Get.toNamed(Routes.createCustomerScreen,arguments: customer);
                                            },
                                            onDeleteTap: () {
                                              Get.find<CustomerController>().deleteCustomer();
                                            },
                                          );
                                        },
                                      );
                                    },
                                  ),
                                ),
                              ),
                            );
                          },
                        ),
                      ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
