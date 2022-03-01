import 'package:hesab_ban/constants.dart';
import 'package:hesab_ban/models/customer_model.dart';
import 'package:hesab_ban/ui/widgets/grid_menu_widget.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:persian_number_utility/persian_number_utility.dart';
import 'package:persistent_bottom_nav_bar/persistent-tab-view.dart';

import '../../routes/app_pages.dart';
import '../../static_methods.dart';
import '../screens/customers_screen.dart';
import '../theme/app_colors.dart';

class CustomersContainerWidget extends StatelessWidget {
  const CustomersContainerWidget({
    Key? key,
    this.miniDataTable = true,
    this.isBox = true,
    this.customerList,
  }) : super(key: key);
  final bool miniDataTable;
  final bool isBox;
  final List<Customer>? customerList;

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder(
      valueListenable: Hive.box<Customer>(customersBox).listenable(),
      builder: (context, Box<Customer> box, _) {
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
          List<Customer> list = isBox ? box.values.toList() : customerList!;
          list.sort((a, b) {
            return a.name!.compareTo(b.name!);
          });
          return SliverPadding(
            padding: const EdgeInsets.symmetric(horizontal: 15.0),
            sliver: SliverList(
              delegate: SliverChildListDelegate(
                [
                  SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    child: DataTable(
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
                        miniDataTable
                            ? list.length > 5
                                ? 5
                                : list.length
                            : list.length,
                        (index) {
                          Customer customer = list[index];
                          return DataRow(
                            cells: [
                              DataCell(
                                Text(
                                  (index + 1).toString().toPersianDigit(),
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
                              Get.toNamed(Routes.customerBalanceScreen);
                            },
                            onLongPress: () {
                              StaticMethods.productBottomSheet(
                                context,
                                name: customer.name!,
                                onEditTap: () {
                                  Get.toNamed(
                                    Routes.createCustomerScreen,
                                    arguments: customer,
                                  );
                                },
                                onDeleteTap: () {},
                              );
                            },
                          );
                        },
                      ),
                    ),
                  ),
                  miniDataTable
                      ? Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Divider(
                              color: kBrownColor,
                              indent: 30,
                              endIndent: 30,
                              thickness: 1.5,
                            ),
                            Padding(
                              padding: const EdgeInsets.all(10),
                              child: GestureDetector(
                                onTap: () {
                                  pushNewScreen(context,
                                      screen: const CustomersScreen());
                                },
                                child: Container(
                                  padding: const EdgeInsets.all(10),
                                  decoration: const BoxDecoration(
                                      color: kGreyColor,
                                      borderRadius: BorderRadius.all(
                                          Radius.circular(10))),
                                  child: const Text('مشاهده همه'),
                                ),
                              ),
                            ),
                            const SizedBox(
                              height: 10,
                            ),
                          ],
                        )
                      : const SizedBox.shrink(),
                ],
              ),
            ),
          );
        }
      },
    );
  }
}
