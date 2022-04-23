import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import 'package:hesab_ban/controllers/customer_controller.dart';
import 'package:hesab_ban/data/models/cash_model.dart';
import 'package:hesab_ban/data/models/factor_model.dart';
import 'package:hesab_ban/static_methods.dart';
import 'package:hesab_ban/ui/theme/app_colors.dart';
import 'package:hesab_ban/ui/theme/app_text_theme.dart';
import 'package:hesab_ban/ui/theme/constants_app_styles.dart';
import 'package:hesab_ban/ui/widgets/base_widget.dart';
import 'package:flutter/material.dart';
import 'package:hesab_ban/ui/widgets/box_container_widget.dart';
import 'package:hesab_ban/ui/widgets/data_table.dart';
import 'package:hesab_ban/ui/widgets/scroll_to_up.dart';
import 'package:persian_number_utility/persian_number_utility.dart';

import '../../controllers/home_controller.dart';
import '../../data/models/check_model.dart';

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
                                                '${myController.customerBill!.cashPayment!.abs()}'
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
                                                Get.find<HomeController>()
                                                    .moneyUnit
                                                    .value,
                                                style: kRialTextStyle,
                                              ),
                                            ],
                                          ),
                                          const SizedBox(
                                            height: 5,
                                          ),
                                          Visibility(
                                            visible: myController.customerBill!
                                                    .cashPayment! !=
                                                0,
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
                          BoxContainerWidget(
                            child: controller.customerBill!.factor!.isEmpty
                                ? const SizedBox.shrink()
                                : Padding(
                                    padding: const EdgeInsets.all(20),
                                    child: SingleChildScrollView(
                                      child: DataTableWidget(
                                        dataList:
                                            controller.customerBill!.factor!,
                                        dataColumnList: const [
                                          DataColumn(
                                            label: Text('ردیف'),
                                            numeric: true,
                                          ),
                                          DataColumn(label: Text('تاریخ')),
                                          DataColumn(label: Text('شرح')),
                                          DataColumn(label: Text('مبلغ')),
                                        ],
                                        source: FactorDataTableSource(
                                            listOfFactor: controller
                                                .customerBill!.factor!),
                                      ),
                                    ),
                                  ),
                          ),
                          BoxContainerWidget(
                            child: controller.customerBill!.check!.isEmpty
                                ? const SizedBox.shrink()
                                : Padding(
                                    padding: const EdgeInsets.all(20),
                                    child: SingleChildScrollView(
                                      child: DataTableWidget(
                                        dataList:
                                            controller.customerBill!.check!,
                                        dataColumnList: const [
                                          DataColumn(
                                            label: Text('ردیف'),
                                            numeric: true,
                                          ),
                                          DataColumn(label: Text('تاریخ')),
                                          DataColumn(label: Text('شرح')),
                                          DataColumn(label: Text('مبلغ')),
                                          DataColumn(
                                              label: Text('تاریخ سررسید')),
                                        ],
                                        source: CheckDataTableSource(
                                          listOfCheck:
                                              controller.customerBill!.check!,
                                        ),
                                      ),
                                    ),
                                  ),
                          ),
                          BoxContainerWidget(
                            child: controller.customerBill!.cash!.isEmpty
                                ? const SizedBox.shrink()
                                : Padding(
                                    padding: const EdgeInsets.all(20),
                                    child: SingleChildScrollView(
                                      child: DataTableWidget(
                                        dataList:
                                            controller.customerBill!.cash!,
                                        dataColumnList: const [
                                          DataColumn(
                                            label: Text('ردیف'),
                                            numeric: true,
                                          ),
                                          DataColumn(label: Text('تاریخ')),
                                          DataColumn(label: Text('شرح')),
                                          DataColumn(label: Text('مبلغ')),
                                        ],
                                        source: CashDataTableSource(
                                          listOfCash:
                                              controller.customerBill!.cash!,
                                          customerName:
                                              controller.customer!.name!,
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
// TODO: use nested scroll view for this page
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

class FactorDataTableSource extends DataTableSource {
  FactorDataTableSource({
    required this.listOfFactor,
  });

  final List<Factor> listOfFactor;

  @override
  DataRow? getRow(int index) {
    assert(index >= 0);
    if (index >= listOfFactor.length) {
      return null;
    }
    Factor factor = listOfFactor[index];
    String type = StaticMethods.setTypeFactorString(factor.typeOfFactor!);
    return DataRow.byIndex(
      index: index,
      onSelectChanged: (_) {
        Get.find<CustomerController>().showFactor(
          factor,
          type,
        );
      },
      cells: [
        DataCell(
          Text(
            (index + 1).toString().toPersianDigit(),
          ),
        ),
        DataCell(
          Text(factor.factorDate.toString().toPersianDate()),
        ),
        DataCell(
          Text('$type به شماره فاکتور "${factor.id}"'),
        ),
        DataCell(
          Row(
            children: [
              Text('${factor.factorSum!.abs()}'.seRagham()),
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
  }

  @override
  bool get isRowCountApproximate => false;

  @override
  int get rowCount => listOfFactor.length;

  @override
  int get selectedRowCount => 0;
}

class CheckDataTableSource extends DataTableSource {
  CheckDataTableSource({
    required this.listOfCheck,
  });

  final List<Check> listOfCheck;

  @override
  DataRow? getRow(int index) {
    assert(index >= 0);
    if (index >= listOfCheck.length) {
      return null;
    }
    Check check = listOfCheck[index];
    String type =
        check.typeOfCheck == TypeOfCheck.received ? 'دریافت' : 'پرداخت';
    return DataRow.byIndex(
      index: index,
      cells: [
        DataCell(
          Text(
            (index + 1).toString().toPersianDigit(),
          ),
        ),
        DataCell(
          Center(
            child: Text(
              (check.checkDueDate).toString().toPersianDate(),
            ),
          ),
        ),
        DataCell(
          Text(
              '$type چک ${check.bankName == null ? check.checkBank!.name : 'بانک ${check.bankName}'} به شماره ${check.checkNumber}'),
        ),
        DataCell(
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text('${check.checkAmount!.abs()}'.toPersianDigit().seRagham()),
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
              (check.checkDeliveryDate).toString().toPersianDate(),
            ),
          ),
        ),
      ],
    );
  }

  @override
  bool get isRowCountApproximate => false;

  @override
  int get rowCount => listOfCheck.length;

  @override
  int get selectedRowCount => 0;
}

class CashDataTableSource extends DataTableSource {
  CashDataTableSource({
    required this.listOfCash,
    required this.customerName,
  });

  final List<Cash> listOfCash;
  final String customerName;

  @override
  DataRow? getRow(int index) {
    assert(index >= 0);
    if (index >= listOfCash.length) {
      return null;
    }
    Cash cash = listOfCash[index];
    String cashDescription = cash.cashAmount! < 0
        ? 'پرداخت وجه نقد به $customerName'
        : 'دریافت وجه نقد از $customerName';
    return DataRow.byIndex(
      index: index,
      cells: [
        DataCell(
          Text(
            (index + 1).toString().toPersianDigit(),
          ),
        ),
        DataCell(
          Center(
            child: Text(
              cash.cashDate.toString().toPersianDate(),
            ),
          ),
        ),
        DataCell(
          Text(cashDescription),
        ),
        DataCell(
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text('${cash.cashAmount!.abs()}'.seRagham()),
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
  }

  @override
  bool get isRowCountApproximate => false;

  @override
  int get rowCount => listOfCash.length;

  @override
  int get selectedRowCount => 0;
}
