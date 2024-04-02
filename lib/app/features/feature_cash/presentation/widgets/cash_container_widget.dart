import 'dart:ui';

import 'package:hesab_ban/app/config/routes/app_pages.dart';
import 'package:hesab_ban/app/core/utils/extensions.dart';
import 'package:hesab_ban/app/core/utils/static_methods.dart';
import 'package:hesab_ban/app/core/widgets/bottom_sheet_row.dart';
import 'package:hesab_ban/app/core/widgets/data_table.dart';
import 'package:hesab_ban/app/core/widgets/price_widget.dart';
import 'package:hesab_ban/app/features/feature_cash/domain/entities/cash_entity.dart';
import 'package:hesab_ban/app/features/feature_cash/presentation/controller/cash_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:persian_number_utility/persian_number_utility.dart';

class CashContainerWidget extends StatelessWidget {
  const CashContainerWidget({
    super.key,
    required this.cashList,
    required this.type,
  });

  final List<CashEntity> cashList;
  final String type;

  @override
  Widget build(BuildContext context) {
    return GetBuilder<CashController>(
      builder: (controller) {
        cashList.sort((b, a) {
          return a.cashDate!.compareTo(b.cashDate!);
        });
        if (cashList.isEmpty) {
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const SizedBox(
                  height: 20,
                ),
                Text('لیست ${type == 'send' ? 'پرداختی های' : 'دریافتی های'}'
                    ' نقدی خالی می باشد.'),
                const SizedBox(
                  height: 20,
                ),
              ],
            ),
          );
        } //
        return Padding(
          padding: const EdgeInsets.symmetric(horizontal: 15.0),
          child: SingleChildScrollView(
            physics: const NeverScrollableScrollPhysics(),
            child: DataTableWidget(
              dataList: cashList,
              dataColumnList: const [
                DataColumn(
                  label: Text('ردیف'),
                  numeric: true,
                ),
                DataColumn(label: Text('نام مشتری')),
                DataColumn(label: Text('مبلغ')),
                DataColumn(label: Text('تاریخ')),
              ],
              source: CashDataTableSource(
                context,
                type: type,
                listOfCash: cashList,
              ),
            ),
          ),
        );
      },
    );
  }
}

class CashDataTableSource extends DataTableSource {
  CashDataTableSource(
    this.context, {
    required this.type,
    required this.listOfCash,
  });

  final BuildContext context;
  final List<CashEntity> listOfCash;
  final String type;

  @override
  DataRow? getRow(int index) {
    assert(index >= 0);
    if (index >= listOfCash.length) {
      return null;
    }
    CashEntity cash = listOfCash[index];
    final controller = Get.find<CashController>();
    return DataRow.byIndex(
      index: index,
      cells: [
        DataCell(
          Text((index + 1).toString().toPersianDigit()),
        ),
        DataCell(
          Text(cash.customer!.name!),
        ),
        DataCell(
          PriceWidget(price: cash.cashAmount!.abs().formatPrice()),
        ),
        DataCell(
          Text(cash.cashDate.toString().toPersianDate()),
        ),
      ],
      onSelectChanged: (bool? selected) {
        Get.bottomSheet(
          GetBuilder<CashController>(
            builder: (controller) {
              return Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  ClipRect(
                    child: RepaintBoundary(
                      key: controller.globalKey,
                      child: Container(
                        width: Get.width - 80,
                        padding: const EdgeInsets.symmetric(
                            vertical: 10, horizontal: 10),
                        decoration: BoxDecoration(
                          color: Theme.of(context).cardColor,
                          borderRadius: const BorderRadius.all(
                            Radius.circular(10),
                          ),
                        ),
                        alignment: Alignment.center,
                        child: Column(
                          children: [
                            BottomSheetRow(
                              title: 'نوع وجه:',
                              value: type == 'send' ? 'پرداختی' : 'دریافتی',
                            ),
                            BottomSheetRow(
                              title: type == 'send' ? 'به:' : 'از طرف:',
                              value: cash.customer!.name!,
                            ),
                            BottomSheetRow(
                              title: 'مبلغ:',
                              valueWidget: PriceWidget(
                                price: cash.cashAmount!.abs().formatPrice(),
                              ),
                            ),
                            BottomSheetRow(
                              title: 'تاریخ دریافت:',
                              value: cash.cashDate.toString().toPersianDate(),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 5),
                  ClipRect(
                    child: BackdropFilter(
                      filter: ImageFilter.blur(sigmaX: 3.0, sigmaY: 3.0),
                      child: Container(
                        width: Get.width - 80,
                        padding: const EdgeInsets.symmetric(
                            vertical: 10, horizontal: 10),
                        decoration: BoxDecoration(
                          color: Theme.of(context).cardColor.withOpacity(0.5),
                          borderRadius: const BorderRadius.all(
                            Radius.circular(10),
                          ),
                        ),
                        alignment: Alignment.center,
                        child: GestureDetector(
                          onTap: () {
                            Get.back();
                            controller.shareCash();
                          },
                          child: const Padding(
                            padding: EdgeInsets.all(8.0),
                            child: Row(
                              children: [
                                Expanded(
                                  child: Text(
                                    'اشتراک گذاری',
                                    textAlign: TextAlign.center,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 20),
                ],
              );
            },
          ),
        );
      },
      onLongPress: () {
        StaticMethods.customBottomSheet(
          context,
          name: 'وجه نقد',
          onEditTap: () {
            Get.back();
            Get.toNamed(
              Routes.createCashScreen,
              arguments: cash,
            );
          },
          showDelete: true,
          onDeleteTap: () {
            Get.back();
            StaticMethods.deleteDialog(
              content:
                  'شما در حال حذف وجه نقد هستید. با این عملیات موافق هستید؟'
                  ' این عملیات برگشت پذیر نیست.',
              onConfirm: () {
                controller.deleteCash(cash.id!);
                Get.back();
              },
            );
          },
        );
      },
    );
  }

  @override
  bool get isRowCountApproximate => false;

  @override
  int get rowCount => listOfCash.length;

  @override
  int get selectedRowCount => 0;
}
