import 'package:get/get.dart';
import 'package:flutter/material.dart';
import 'package:hesab_ban/app/config/theme/app_colors.dart';
import 'package:hesab_ban/app/config/theme/constants_app_styles.dart';
import 'package:hesab_ban/app/core/utils/extensions.dart';
import 'package:hesab_ban/app/core/utils/static_methods.dart';
import 'package:hesab_ban/app/core/widgets/base_widget.dart';
import 'package:hesab_ban/app/core/widgets/box_container_widget.dart';
import 'package:hesab_ban/app/core/widgets/data_table.dart';
import 'package:hesab_ban/app/core/widgets/loading.dart';
import 'package:hesab_ban/app/core/widgets/price_widget.dart';
import 'package:hesab_ban/app/core/widgets/scroll_to_up.dart';
import 'package:hesab_ban/app/features/feature_bill/presentation/controller/bill_controller.dart';
import 'package:hesab_ban/app/features/feature_cash/domain/entities/cash_entity.dart';
import 'package:hesab_ban/app/features/feature_check/data/models/check_model.dart';
import 'package:hesab_ban/app/features/feature_check/domain/entities/check_entity.dart';
import 'package:hesab_ban/app/features/feature_factor/data/models/factor_model.dart';
import 'package:hesab_ban/app/features/feature_factor/domain/entities/factor_entity.dart';
import 'package:hesab_ban/app/features/feature_setting/presentation/controller/setting_controller.dart';
import 'package:iconsax/iconsax.dart';
import 'package:persian_number_utility/persian_number_utility.dart';

class CustomerBalanceScreen extends StatelessWidget {
  const CustomerBalanceScreen({super.key});

  @override
  Widget build(BuildContext context) {
    int id = int.parse(Get.parameters['id']!);
    return DefaultTabController(
      length: 3,
      child: GetBuilder<BillController>(
        initState: (_) => Get.find<BillController>().getCustomer(id),
        builder: (controller) {
          return Loading(
            showLoading: controller.customer == null,
            child: BaseWidget(
              title: Text('صورتحساب ${controller.customer?.name}'),
              showLeading: true,
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
                                child: const Icon(
                                  Iconsax.user,
                                  size: 40,
                                  color: kWhiteColor,
                                ),
                              ),
                            ),
                            const SizedBox(width: 20),
                            Expanded(
                              child: Column(
                                children: [
                                  Row(
                                    children: [
                                      const Text('شماره تماس 1:'),
                                      const Spacer(),
                                      Text(
                                          '${controller.customer!.phoneNumber1}'),
                                    ],
                                  ),
                                  const SizedBox(height: 10),
                                  Visibility(
                                    visible:
                                        controller.customer!.phoneNumber2 != '',
                                    child: Column(
                                      children: [
                                        Row(
                                          children: [
                                            const Text('شماره تماس 2:'),
                                            const Spacer(),
                                            Text(
                                                '${controller.customer!.phoneNumber2}'),
                                          ],
                                        ),
                                        const SizedBox(height: 10),
                                      ],
                                    ),
                                  ),
                                  Row(
                                    children: [
                                      const Text('آدرس:'),
                                      const SizedBox(width: 10),
                                      Expanded(
                                        child: Text(
                                          '${controller.customer!.address}',
                                          style: Theme.of(context)
                                              .textTheme
                                              .bodyMedium!
                                              .copyWith(fontSize: 14),
                                        ),
                                      ),
                                    ],
                                  ),
                                  const SizedBox(height: 10),
                                  controller.customer!.description != '' &&
                                          controller.customer!.description !=
                                              null
                                      ? Column(
                                          children: [
                                            Row(
                                              children: [
                                                const Text('توضیحات:'),
                                                const SizedBox(width: 10),
                                                Expanded(
                                                  child: Text(
                                                    '${controller.customer!.description}',
                                                    style: Theme.of(context)
                                                        .textTheme
                                                        .bodyMedium!
                                                        .copyWith(fontSize: 14),
                                                  ),
                                                ),
                                              ],
                                            ),
                                            const SizedBox(height: 10),
                                          ],
                                        )
                                      : const SizedBox.shrink(),
                                  GetBuilder<BillController>(
                                    initState: (_) => Get.find<BillController>()
                                        .getBillById(id),
                                    builder: (myController) {
                                      if (myController.billEntity == null) {
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
                                                      '${myController.billEntity!.cashPayment?.abs()}'
                                                          .seRagham(),
                                                      style: Theme.of(context)
                                                          .textTheme
                                                          .titleLarge!
                                                          .copyWith(
                                                            color: myController
                                                                    .billEntity!
                                                                    .cashPayment!
                                                                    .isNegative
                                                                ? kRedColor
                                                                : kGreenColor,
                                                          ),
                                                    ),
                                                    const SizedBox(width: 5),
                                                    Text(
                                                      Get.find<
                                                              SettingController>()
                                                          .moneyUnit,
                                                      style: kRialTextStyle,
                                                    ),
                                                  ],
                                                ),
                                                const SizedBox(height: 5),
                                                Visibility(
                                                  visible: myController
                                                          .billEntity!
                                                          .cashPayment! !=
                                                      0,
                                                  child: Text(
                                                    myController
                                                            .billEntity!
                                                            .cashPayment!
                                                            .isNegative
                                                        ? 'بدهکار'
                                                        : 'بستانکار',
                                                    style: TextStyle(
                                                      color: myController
                                                              .billEntity!
                                                              .cashPayment!
                                                              .isNegative
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
                          constraints: const BoxConstraints(
                              maxHeight: 48, minHeight: 48),
                          color: Theme.of(context).scaffoldBackgroundColor,
                          child: TabBar(
                            labelColor: !Get.isDarkMode
                                ? kDarkGreyColor
                                : kWhiteGreyColor,
                            tabs: const [
                              Tab(text: 'فاکتور'),
                              Tab(text: 'چک'),
                              Tab(text: 'وجه نقد'),
                            ],
                          ),
                        ),
                      ),
                    ),
                    SliverFillRemaining(
                      child: GetBuilder<BillController>(
                        builder: (myController) {
                          if (myController.billEntity == null) {
                            return const SizedBox.shrink();
                          } //
                          else {
                            return TabBarView(
                              children: [
                                BoxContainerWidget(
                                  backBlur: false,
                                  child: controller.billEntity!.factor!.isEmpty
                                      ? const SizedBox.shrink()
                                      : Padding(
                                          padding: const EdgeInsets.all(20),
                                          child: SingleChildScrollView(
                                            controller:
                                                controller.scrollController,
                                            child: DataTableWidget(
                                              dataList: controller
                                                  .billEntity!.factor!,
                                              dataColumnList: const [
                                                DataColumn(
                                                  label: Text('ردیف'),
                                                  numeric: true,
                                                ),
                                                DataColumn(
                                                    label: Text('تاریخ')),
                                                DataColumn(label: Text('شرح')),
                                                DataColumn(label: Text('مبلغ')),
                                              ],
                                              source: FactorDataTableSource(
                                                context,
                                                listOfFactor: controller
                                                    .billEntity!.factor!,
                                              ),
                                            ),
                                          ),
                                        ),
                                ),
                                BoxContainerWidget(
                                  backBlur: false,
                                  child: controller.billEntity!.check!.isEmpty
                                      ? const SizedBox.shrink()
                                      : Padding(
                                          padding: const EdgeInsets.all(20),
                                          child: SingleChildScrollView(
                                            controller:  controller.scrollController,
                                            child: DataTableWidget(
                                              dataList:
                                                  controller.billEntity!.check!,
                                              dataColumnList: const [
                                                DataColumn(
                                                  label: Text('ردیف'),
                                                  numeric: true,
                                                ),
                                                DataColumn(
                                                    label: Text('تاریخ')),
                                                DataColumn(label: Text('شرح')),
                                                DataColumn(label: Text('مبلغ')),
                                                DataColumn(
                                                    label:
                                                        Text('تاریخ سررسید')),
                                              ],
                                              source: CheckDataTableSource(
                                                listOfCheck: controller
                                                    .billEntity!.check!,
                                              ),
                                            ),
                                          ),
                                        ),
                                ),
                                BoxContainerWidget(
                                  backBlur: false,
                                  child: controller.billEntity!.cash!.isEmpty
                                      ? const SizedBox.shrink()
                                      : Padding(
                                          padding: const EdgeInsets.all(20),
                                          child: SingleChildScrollView(
                                            controller:  controller.scrollController,
                                            child: DataTableWidget(
                                              dataList:
                                                  controller.billEntity!.cash!,
                                              dataColumnList: const [
                                                DataColumn(
                                                  label: Text('ردیف'),
                                                  numeric: true,
                                                ),
                                                DataColumn(
                                                    label: Text('تاریخ')),
                                                DataColumn(label: Text('شرح')),
                                                DataColumn(label: Text('مبلغ')),
                                              ],
                                              source: CashDataTableSource(
                                                listOfCash: controller
                                                    .billEntity!.cash!,
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
        },
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

class FactorDataTableSource extends DataTableSource {
  FactorDataTableSource(
    this.context, {
    required this.listOfFactor,
  });

  final List<FactorEntity> listOfFactor;
  final BuildContext context;

  @override
  DataRow? getRow(int index) {
    assert(index >= 0);
    if (index >= listOfFactor.length) {
      return null;
    }
    FactorEntity factor = listOfFactor[index];
    String type = StaticMethods.setTypeFactorString(factor.typeOfFactor!.name);
    return DataRow.byIndex(
      index: index,
      onSelectChanged: (_) {
        StaticMethods.showFactor(context, factor);
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
          PriceWidget(
            price: factor.factorSum!.abs().formatPrice(),
            color: factor.typeOfFactor == TypeOfFactor.buy ||
                    factor.typeOfFactor == TypeOfFactor.returnOfSale
                ? kRedColor
                : kGreenColor,
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

  final List<CheckEntity> listOfCheck;

  @override
  DataRow? getRow(int index) {
    assert(index >= 0);
    if (index >= listOfCheck.length) {
      return null;
    }
    CheckEntity check = listOfCheck[index];
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
          PriceWidget(
            price: check.checkAmount!.abs().formatPrice(),
            color:
                check.typeOfCheck == TypeOfCheck.send ? kRedColor : kGreenColor,
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

  final List<CashEntity> listOfCash;
  final String customerName;

  @override
  DataRow? getRow(int index) {
    assert(index >= 0);
    if (index >= listOfCash.length) {
      return null;
    }
    CashEntity cash = listOfCash[index];
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
          PriceWidget(
            price: cash.cashAmount!.abs().formatPrice(),
            color: cash.cashAmount! < 0 ? kRedColor : kGreenColor,
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
