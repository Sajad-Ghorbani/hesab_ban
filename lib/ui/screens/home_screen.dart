import 'package:accounting_app/controllers/home_controller.dart';
import 'package:accounting_app/models/customer_model.dart';
import 'package:accounting_app/static_methods.dart';
import 'package:accounting_app/ui/screens/customers_screen.dart';
import 'package:accounting_app/ui/theme/app_colors.dart';
import 'package:accounting_app/ui/widgets/base_widget.dart';
import 'package:accounting_app/ui/widgets/box_container_widget.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:persian_number_utility/persian_number_utility.dart';
import 'package:persistent_bottom_nav_bar/persistent-tab-view.dart';

import '../../controllers/customer_controller.dart';
import '../../routes/app_pages.dart';
import '../widgets/grid_menu_widget.dart';

class HomeScreen extends GetView<HomeController> {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BaseWidget(
      title: 'حساب بان',
      child: CustomScrollView(
        physics: const BouncingScrollPhysics(),
        slivers: [
          SliverPadding(
            padding: const EdgeInsets.all(10.0),
            sliver: SliverList(
              delegate: SliverChildListDelegate(
                [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      GridMenuWidget(
                        title: 'ایجاد حساب جدید',
                        onTap: () {
                          Get.toNamed(Routes.createCustomerScreen);
                        },
                      ),
                      GridMenuWidget(
                        title: 'ورود چک',
                        onTap: () {},
                      ),
                    ],
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  Row(
                    children: const [
                      FaIcon(
                        FontAwesomeIcons.moneyCheck,
                        color: kDarkGreenColor,
                      ),
                      SizedBox(
                        width: 10,
                      ),
                      Text('لیست چک های دریافتی'),
                    ],
                  ),
                ],
              ),
            ),
          ),
          BoxContainerWidget(
            child: SliverList(
              delegate: SliverChildBuilderDelegate(
                (context, index) {
                  return Container(
                    padding: const EdgeInsets.all(20),
                    child: Text('item $index'),
                  );
                },
                childCount: 5,
              ),
            ),
          ),
          SliverPadding(
            padding: const EdgeInsets.all(10),
            sliver: SliverList(
              delegate: SliverChildListDelegate(
                [
                  const SizedBox(
                    height: 10,
                  ),
                  Row(
                    children: const [
                      FaIcon(
                        FontAwesomeIcons.moneyCheck,
                        color: kRedColor,
                      ),
                      SizedBox(
                        width: 10,
                      ),
                      Text('لیست چک های پرداختی'),
                    ],
                  ),
                ],
              ),
            ),
          ),
          BoxContainerWidget(
            child: SliverList(
              delegate: SliverChildBuilderDelegate(
                (context, index) {
                  return Container(
                    padding: const EdgeInsets.all(20),
                    child: Text('item $index'),
                  );
                },
                childCount: 5,
              ),
            ),
          ),
          SliverPadding(
            padding: const EdgeInsets.all(10),
            sliver: SliverList(
              delegate: SliverChildListDelegate(
                [
                  const SizedBox(
                    height: 10,
                  ),
                  Row(
                    children: const [
                      FaIcon(
                        FontAwesomeIcons.addressCard,
                        color: kOrangeColor,
                      ),
                      SizedBox(
                        width: 10,
                      ),
                      Text('لیست مشتریان'),
                    ],
                  ),
                ],
              ),
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
                    sliver: SliverList(
                      delegate: SliverChildListDelegate(
                        [
                          DataTable(
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
                              box.length > 5 ? 5 : box.length,
                              (index) {
                                Customer customer = box.getAt(index);
                                return DataRow(
                                  cells: [
                                    DataCell(Text((index + 1)
                                        .toString()
                                        .toPersianDigit())),
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
                                        Get.find<CustomerController>().deleteCustomer();
                                      },
                                    );
                                  },
                                );
                              },
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.all(10),
                            child: GestureDetector(
                              onTap: () {
                                pushNewScreen(context, screen: const CustomersScreen());
                              },
                              child: const Text('مشاهده همه'),
                            ),
                          ),
                        ],
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
    );
  }
}
