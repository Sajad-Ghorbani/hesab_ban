import 'package:accounting_app/controllers/customer_controller.dart';
import 'package:accounting_app/routes/app_pages.dart';
import 'package:accounting_app/ui/screens/search_customer_screen.dart';
import 'package:accounting_app/ui/widgets/base_widget.dart';
import 'package:accounting_app/ui/widgets/box_container_widget.dart';
import 'package:accounting_app/ui/widgets/grid_menu_widget.dart';
import 'package:accounting_app/ui/widgets/scroll_to_up.dart';
import 'package:accounting_app/ui/widgets/search_box_widget.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:persian_number_utility/persian_number_utility.dart';

import '../../controllers/search_controller.dart';
import '../../models/customer_model.dart';
import '../../static_methods.dart';

class CustomersScreen extends GetView<CustomerController> {
  const CustomersScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
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
        scrollController: controller.scrollController,
        child: CustomScrollView(
          controller: controller.scrollController,
          physics: const BouncingScrollPhysics(),
          slivers: [
            SliverPadding(
              padding: const EdgeInsets.all(10),
              sliver: SliverToBoxAdapter(
                child: GridMenuWidget(
                  title: 'ایجاد حساب جدید',
                  onTap: () {
                    Get.toNamed(Routes.createCustomerScreen);
                  },
                ),
              ),
            ),
            SliverToBoxAdapter(
              child: SearchBoxWidget(
                searchText: 'جست و جو',
                openBuilderWidget: SearchCustomerScreen(),
                onClosed: (value) {
                  Get.find<SearchController>().clearScreen();
                },
              ),
            ),
            BoxContainerWidget(
              child: ValueListenableBuilder(
                valueListenable: controller.customerBox.listenable(),
                builder: (context, Box box, _) {
                  if (box.isEmpty) {
                    return SliverToBoxAdapter(
                      child: Column(
                        children: [
                          const SizedBox(
                            height: 20,
                          ),
                          const Text('لیست مشتریان خالی می باشد.'),
                          const SizedBox(
                            height: 10,
                          ),
                          GridMenuWidget(
                            title: 'ایجاد حساب جدید',
                            onTap: () {
                              Get.toNamed(Routes.createCustomerScreen);
                            },
                          ),
                          const SizedBox(
                            height: 20,
                          ),
                        ],
                      ),
                    );
                  } //
                  else {
                    return SliverPadding(
                      padding: const EdgeInsets.symmetric(horizontal: 10.0),
                      sliver: SliverToBoxAdapter(
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
                            box.length,
                            (index) {
                              Customer customer = box.getAt(index);
                              return DataRow(
                                cells: [
                                  DataCell(Text(
                                      (index + 1).toString().toPersianDigit())),
                                  DataCell(Text(customer.name!)),
                                  DataCell(Text((customer.phoneNumber1)
                                      .toString()
                                      .toPersianDigit())),
                                ],
                                onSelectChanged: (bool? selected) {
                                  Get.toNamed(Routes.customerBalanceScreen);
                                },
                                onLongPress: () {
                                  StaticMethods.productBottomSheet(
                                    context,
                                    name: customer.name!,
                                    onEditTap: () {
                                      Get.toNamed(Routes.createCustomerScreen,arguments: customer);
                                    },
                                    onDeleteTap: () {
                                      controller.deleteCustomer();
                                    },
                                  );
                                },
                              );
                            },
                          ),
                        ),
                      ),
                    );
                  }
                },
              ),
            ),
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
