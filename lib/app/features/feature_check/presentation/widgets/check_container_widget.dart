import 'package:get/get.dart';
import 'package:hesab_ban/app/config/routes/app_pages.dart';
import 'package:hesab_ban/app/config/theme/app_colors.dart';
import 'package:hesab_ban/app/core/utils/extensions.dart';
import 'package:hesab_ban/app/core/utils/static_methods.dart';
import 'package:hesab_ban/app/core/widgets/data_table.dart';
import 'package:hesab_ban/app/core/widgets/price_widget.dart';
import 'package:hesab_ban/app/features/feature_check/data/models/check_model.dart';
import 'package:hesab_ban/app/features/feature_check/domain/entities/bank_entity.dart';
import 'package:flutter/material.dart';
import 'package:hesab_ban/app/features/feature_check/domain/entities/check_entity.dart';
import 'package:hesab_ban/app/features/feature_check/presentation/controller/check_controller.dart';
import 'package:persian_number_utility/persian_number_utility.dart';

class CheckContainerWidget extends StatelessWidget {
  const CheckContainerWidget({
    super.key,
    required this.typeOfCheck,
    required this.checkList,
  });
  final TypeOfCheck typeOfCheck;
  final List<CheckEntity> checkList;

  @override
  Widget build(BuildContext context) {
    return GetBuilder<CheckController>(
      builder: (controller) {
        List<CheckEntity> listOfCheckFromToday = [];
        for (var check in checkList) {
          if (check.checkDeliveryDate!.isAfter(DateTime.now()) ||
              check.checkDeliveryDate!.isToday()) {
            listOfCheckFromToday.add(check);
          }
        }
        if (listOfCheckFromToday.isEmpty) {
          return const Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                SizedBox(
                  height: 20,
                ),
                Text('لیست چک ها خالی می باشد.'),
                SizedBox(
                  height: 20,
                ),
              ],
            ),
          );
        } //
        listOfCheckFromToday.sort((a, b) {
          return a.checkDeliveryDate!.compareTo(b.checkDeliveryDate!);
        });
        return Padding(
          padding: const EdgeInsets.symmetric(horizontal: 15.0),
          child: SingleChildScrollView(
            physics: const NeverScrollableScrollPhysics(),
            child: DataTableWidget(
              dataList: listOfCheckFromToday,
              source: CheckDataTableSource(
                context,
                listOfCheck: listOfCheckFromToday,
              ),
              dataColumnList: const [
                DataColumn(
                  label: Text('ردیف'),
                  numeric: true,
                ),
                DataColumn(label: Text('نام مشتری')),
                DataColumn(label: Text('تاریخ تحویل')),
                DataColumn(label: Text('تاریخ سررسید')),
                DataColumn(label: Text('مبلغ')),
                DataColumn(label: Text('بانک')),
                DataColumn(label: Text('شماره چک')),
              ],
            ),
          ),
        );
      },
    );
  }
}

class CheckDataTableSource extends DataTableSource {
  CheckDataTableSource(
    this.context, {
    required this.listOfCheck,
  });

  final List<CheckEntity> listOfCheck;
  final BuildContext context;

  @override
  DataRow? getRow(int index) {
    assert(index >= 0);
    if (index >= listOfCheck.length) {
      return null;
    }
    CheckEntity check = listOfCheck[index];
    return DataRow.byIndex(
      index: index,
      onSelectChanged: (_) {
        Get.toNamed(
          Routes.createCheckScreen,
          arguments: check,
        );
      },
      onLongPress: () {
        StaticMethods.customBottomSheet(
          context,
          name: 'شماره چک: ${check.checkNumber}',
          onEditTap: () {
            Get.back();
            Get.toNamed(
              Routes.createCheckScreen,
              arguments: check,
            );
          },
          showDelete: true,
          onDeleteTap: () {
            Get.back();
            StaticMethods.deleteDialog(
              content:
                  'شما در حال حذف چک هستید. با این عملیات موافق هستید؟'
                  ' این عملیات برگشت پذیر نیست.',
              onConfirm: () {
                Get.find<CheckController>().deleteCheck(check.id!);
                Get.back();
              },
            );
          },
        );
      },
      cells: [
        DataCell(
          Text(
            (index + 1).toString().toPersianDigit(),
          ),
        ),
        DataCell(
          Text(check.customerCheck!.name!),
        ),
        DataCell(
          Center(
            child: Text(
              (check.checkDueDate).toString().toPersianDate(),
            ),
          ),
        ),
        DataCell(
          Center(
            child: Text(
              (check.checkDeliveryDate).toString().toPersianDate(),
            ),
          ),
        ),
        DataCell(
          PriceWidget(price: check.checkAmount!.abs().formatPrice()),
        ),
        DataCell(
          showBankImage(check),
        ),
        DataCell(
          Text(
            check.checkNumber!.toPersianDigit(),
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

  static Widget showBankImage(CheckEntity check) {
    String imageAddress = '-1';
    if (check.bankName == null) {
      imageAddress = check.checkBank!.imageAddress!;
    } //
    else {
      for (var item in bankList) {
        if (item.name!.contains(check.bankName!)) {
          imageAddress = item.imageAddress!;
        }
      }
    }
    return Row(
      children: [
        imageAddress == '-1'
            ? const SizedBox.shrink()
            : Row(
                children: [
                  Container(
                    padding: const EdgeInsets.all(2),
                    decoration: const BoxDecoration(
                      borderRadius: BorderRadius.all(Radius.circular(3)),
                      color: kWhiteColor,
                    ),
                    child: Image.asset(
                      imageAddress,
                      width: 30,
                      height: 30,
                    ),
                  ),
                  const SizedBox(
                    width: 8,
                  ),
                ],
              ),
        check.bankName == null
            ? Text(check.checkBank!.name!)
            : Text(check.bankName!),
      ],
    );
  }
}
