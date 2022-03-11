import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import 'package:hesab_ban/controllers/customer_controller.dart';
import 'package:hesab_ban/models/cash_model.dart';
import 'package:hesab_ban/models/factor_model.dart';
import 'package:hesab_ban/ui/theme/app_colors.dart';
import 'package:hesab_ban/ui/theme/app_text_theme.dart';
import 'package:hesab_ban/ui/theme/constants_app_styles.dart';
import 'package:hesab_ban/ui/widgets/base_widget.dart';
import 'package:flutter/material.dart';
import 'package:hesab_ban/ui/widgets/bill_box_container.dart';
import 'package:hesab_ban/ui/widgets/scroll_to_up.dart';
import 'package:persian_number_utility/persian_number_utility.dart';

import '../../controllers/home_controller.dart';
import '../../models/check_model.dart';

class CustomerBalanceScreen extends GetView<CustomerController> {
  const CustomerBalanceScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 3,
      child: BaseWidget(
        title: 'صورتحساب ${controller.customer!.name}',
        appBarLeading: IconButton(
          onPressed: () {
            Navigator.pop(context);
          },
          icon: const Icon(Icons.arrow_back_ios),
          splashRadius: 30,
        ),
        child: ScrollToUp(
          showFab: controller.showFab,
          scrollController: controller.scrollController,
          hideBottomSheet: true,
          child: CustomScrollView(
            controller: controller.scrollController,
            slivers: [
              SliverToBoxAdapter(
                child: Padding(
                  padding: const EdgeInsets.all(10),
                  child: Row(
                    children: [
                      CircleAvatar(
                        backgroundColor: kBrownColor,
                        radius: 35,
                        child: CircleAvatar(
                          radius: 32,
                          backgroundColor:
                              Theme.of(context).colorScheme.secondary,
                          child: const FaIcon(
                            FontAwesomeIcons.solidUser,
                            size: 40,
                            color: kWhiteColor,
                          ),
                        ),
                      ),
                      const SizedBox(
                        width: 20,
                      ),
                      Expanded(
                        child: Column(
                          children: [
                            Row(
                              children: [
                                const Text('شماره تماس 1:'),
                                const Spacer(),
                                Text(controller.customer!.phoneNumber1!),
                              ],
                            ),
                            const SizedBox(
                              height: 10,
                            ),
                            Visibility(
                              visible: controller.customer!.phoneNumber2 != '',
                              child: Column(
                                children: [
                                  Row(
                                    children: [
                                      const Text('شماره تماس 2:'),
                                      const Spacer(),
                                      Text(controller.customer!.phoneNumber2!),
                                    ],
                                  ),
                                  const SizedBox(
                                    height: 10,
                                  ),
                                ],
                              ),
                            ),
                            Row(
                              children: [
                                const Text('آدرس:'),
                                const SizedBox(
                                  width: 10,
                                ),
                                Expanded(
                                  child: Text(
                                    controller.customer!.address!,
                                    style: kBodyText.copyWith(fontSize: 14),
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(
                              height: 10,
                            ),
                            GetBuilder<CustomerController>(
                              builder: (myController) {
                                if (myController.customerBill == null) {
                                  return const SizedBox.shrink();
                                } //
                                else {
                                  return Row(
                                    children: [
                                      const Text('مانده حساب'),
                                      const Spacer(),
                                      Column(
                                        children: [
                                          Row(
                                            children: [
                                              Text(
                                                '${myController.customerBill!.cashPayment! < 0 ? -myController.customerBill!.cashPayment! : myController.customerBill!.cashPayment}'
                                                    .seRagham(),
                                                style: kBodyMedium.copyWith(
                                                  color: myController
                                                              .customerBill!
                                                              .cashPayment! <
                                                          0
                                                      ? kRedColor
                                                      : kGreenColor,
                                                ),
                                              ),
                                              const SizedBox(
                                                width: 5,
                                              ),
                                              Text(
                                                Get.find<HomeController>().moneyUnit.value,
                                                style: kRialTextStyle,
                                              ),
                                            ],
                                          ),
                                          const SizedBox(
                                            height: 5,
                                          ),
                                          Visibility(
                                            visible: myController.customerBill!
                                                    .cashPayment! != 0,
                                            child: Text(
                                              myController.customerBill!
                                                          .cashPayment! <
                                                      0
                                                  ? 'بدهکار'
                                                  : 'بستانکار',
                                              style: TextStyle(
                                                color: myController
                                                            .customerBill!
                                                            .cashPayment! <
                                                        0
                                                    ? kRedColor
                                                    : kGreenColor,
                                                fontSize: 12,
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ],
                                  );
                                }
                              },
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              SliverPersistentHeader(
                pinned: true,
                delegate: StickyTabBarDelegate(
                  child: Container(
                    constraints:
                        const BoxConstraints(maxHeight: 48, minHeight: 48),
                    color: kBackgroundColor,
                    child: const TabBar(
                      // labelColor: Colors.black,
                      tabs: [
                        Tab(text: 'فاکتور'),
                        Tab(text: 'چک'),
                        Tab(text: 'وجه نقد'),
                      ],
                    ),
                  ),
                ),
              ),
              SliverFillRemaining(
                child: GetBuilder<CustomerController>(
                  builder: (myController) {
                    if (myController.customerBill == null) {
                      return const SizedBox.shrink();
                    } //
                    else {
                      return TabBarView(
                        children: [
                          BillBoxContainer(
                            child: Padding(
                              padding: const EdgeInsets.all(20),
                              child: SingleChildScrollView(
                                scrollDirection: Axis.horizontal,
                                child: DataTable(
                                  columnSpacing: 30,
                                  showCheckboxColumn: false,
                                  columns: const [
                                    DataColumn(
                                      label: Text('ردیف'),
                                      numeric: true,
                                    ),
                                    DataColumn(label: Text('تاریخ')),
                                    DataColumn(label: Text('شرح')),
                                    DataColumn(label: Text('مبلغ')),
                                  ],
                                  rows: List<DataRow>.generate(
                                    controller.customerBill!.factor!.length,
                                    (index) {
                                      Factor factor = controller
                                          .customerBill!.factor![index];
                                      String type = factor.typeOfFactor ==
                                              TypeOfFactor.buy
                                          ? 'خرید'
                                          : 'فروش';
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
                                            Text(factor.factorDate
                                                .toString()
                                                .toPersianDate()),
                                          ),
                                          DataCell(
                                            Text(
                                                'فاکتور $type به شماره فاکتور "${factor.id}"'),
                                          ),
                                          DataCell(
                                            Row(
                                              children: [
                                                Text(
                                                    '${factor.factorSum! < 0 ? -factor.factorSum! : factor.factorSum}'
                                                        .seRagham()),
                                                const SizedBox(
                                                  width: 5,
                                                ),
                                                Text(
                                                  Get.find<HomeController>().moneyUnit.value,
                                                  style: kRialTextStyle,
                                                ),
                                              ],
                                            ),
                                          ),
                                        ],
                                      );
                                    },
                                  ),
                                ),
                              ),
                            ),
                          ),
                          BillBoxContainer(
                            child: Padding(
                              padding: const EdgeInsets.all(20),
                              child: SingleChildScrollView(
                                scrollDirection: Axis.horizontal,
                                child: DataTable(
                                  columnSpacing: 30,
                                  showCheckboxColumn: false,
                                  columns: const [
                                    DataColumn(
                                      label: Text('ردیف'),
                                      numeric: true,
                                    ),
                                    DataColumn(label: Text('تاریخ')),
                                    DataColumn(label: Text('شرح')),
                                    DataColumn(label: Text('مبلغ')),
                                    DataColumn(label: Text('تاریخ سررسید')),
                                  ],
                                  rows: List<DataRow>.generate(
                                    controller.customerBill!.check!.length,
                                    (index) {
                                      Check check = controller
                                          .customerBill!.check![index];
                                      String type = check.typeOfCheck ==
                                              TypeOfCheck.received
                                          ? 'دریافت'
                                          : 'پرداخت';
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
                                            Center(
                                              child: Text(
                                                (check.checkDueDate)
                                                    .toString()
                                                    .toPersianDate(),
                                              ),
                                            ),
                                          ),
                                          DataCell(
                                            Text(
                                                '$type چک بانک ${check.bankName} به شماره ${check.checkNumber}'),
                                          ),
                                          DataCell(
                                            Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment
                                                      .spaceBetween,
                                              children: [
                                                Text(
                                                    '${check.checkAmount! < 0 ? -check.checkAmount! : check.checkAmount}'
                                                        .toPersianDigit()
                                                        .seRagham()),
                                                const SizedBox(
                                                  width: 5,
                                                ),
                                                Text(
                                                  Get.find<HomeController>().moneyUnit.value,
                                                  style: kRialTextStyle,
                                                ),
                                              ],
                                            ),
                                          ),
                                          DataCell(
                                            Center(
                                              child: Text(
                                                (check.checkDeliveryDate)
                                                    .toString()
                                                    .toPersianDate(),
                                              ),
                                            ),
                                          ),
                                        ],
                                      );
                                    },
                                  ),
                                ),
                              ),
                            ),
                          ),
                          BillBoxContainer(
                            child: Padding(
                              padding: const EdgeInsets.all(20),
                              child: SingleChildScrollView(
                                scrollDirection: Axis.horizontal,
                                child: DataTable(
                                  columnSpacing: 30,
                                  showCheckboxColumn: false,
                                  columns: const [
                                    DataColumn(
                                      label: Text('ردیف'),
                                      numeric: true,
                                    ),
                                    DataColumn(label: Text('تاریخ')),
                                    DataColumn(label: Text('شرح')),
                                    DataColumn(label: Text('مبلغ')),
                                  ],
                                  rows: List<DataRow>.generate(
                                    controller.customerBill!.cash!.length,
                                    (index) {
                                      Cash cash =
                                          controller.customerBill!.cash![index];
                                      String type = cash.cashAmount! > 0
                                          ? 'پرداخت'
                                          : 'دریافت';
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
                                            Center(
                                              child: Text(
                                                cash.cashDate
                                                    .toString()
                                                    .toPersianDate(),
                                              ),
                                            ),
                                          ),
                                          DataCell(
                                            Text('$type وجه نقد'),
                                          ),
                                          DataCell(
                                            Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment
                                                      .spaceBetween,
                                              children: [
                                                Text(
                                                    '${cash.cashAmount! < 0 ? -cash.cashAmount! : cash.cashAmount}'
                                                        .seRagham()),
                                                const SizedBox(
                                                  width: 5,
                                                ),
                                                Text(
                                                  Get.find<HomeController>().moneyUnit.value,
                                                  style: kRialTextStyle,
                                                ),
                                              ],
                                            ),
                                          ),
                                        ],
                                      );
                                    },
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ],
                      );
                    }
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class StickyTabBarDelegate extends SliverPersistentHeaderDelegate {
  final Container child;

  StickyTabBarDelegate({required this.child});

  @override
  Widget build(
      BuildContext context, double shrinkOffset, bool overlapsContent) {
    return child;
  }

  @override
  double get maxExtent => child.constraints!.maxHeight;

  @override
  double get minExtent => child.constraints!.minHeight;

  @override
  bool shouldRebuild(SliverPersistentHeaderDelegate oldDelegate) {
    return true;
  }
}
