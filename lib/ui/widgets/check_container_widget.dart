import 'package:get/get.dart';
import 'package:hesab_ban/constants.dart';
import 'package:hesab_ban/models/check_model.dart';
import 'package:hesab_ban/ui/theme/app_colors.dart';
import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:persian_number_utility/persian_number_utility.dart';

import '../../controllers/home_controller.dart';
import '../theme/constants_app_styles.dart';

class CheckContainerWidget extends StatelessWidget {
  const CheckContainerWidget({
    Key? key,
    required this.typeOfCheck,
    required this.onRowTapped,
    this.onSeeAll,
    this.miniDataTable = true,
    this.isBox = true,
    this.checkList,
  }) : super(key: key);
  final TypeOfCheck typeOfCheck;
  final ValueChanged<bool?> onRowTapped;
  final VoidCallback? onSeeAll;
  final bool miniDataTable;
  final bool isBox;
  final List<Check>? checkList;

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder(
      valueListenable: Hive.box<Check>(checksBox).listenable(),
      builder: (context, Box<Check> box, _) {
        List<Check> checks = isBox
            ? box.values
                .where((element) => element.typeOfCheck == typeOfCheck)
                .toList()
            : checkList!;
        if (checks.isEmpty) {
          return SliverToBoxAdapter(
            child: Column(
              children: const [
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
        else {
          List<Check> listOfCheckFromToday = [];
          for (var check in checks) {
            if (check.checkDeliveryDate!.day >= DateTime.now().day) {
              listOfCheckFromToday.add(check);
            }
          }
          listOfCheckFromToday.sort((a, b) {
            return a.checkDeliveryDate!.compareTo(b.checkDeliveryDate!);
          });
          return SliverPadding(
            padding: const EdgeInsets.symmetric(horizontal: 15.0),
            sliver: SliverList(
              delegate: SliverChildListDelegate(
                [
                  SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    child: DataTable(
                      columnSpacing: 30,
                      showCheckboxColumn: false,
                      columns: [
                        const DataColumn(
                          label: Text('ردیف'),
                          numeric: true,
                        ),
                        const DataColumn(label: Text('نام مشتری')),
                        if (!miniDataTable)
                          const DataColumn(label: Text('تاریخ تحویل')),
                        const DataColumn(label: Text('تاریخ سررسید')),
                        const DataColumn(label: Text('مبلغ')),
                        const DataColumn(label: Text('بانک')),
                        if (!miniDataTable)
                          const DataColumn(label: Text('شماره چک')),
                      ],
                      rows: List<DataRow>.generate(
                        miniDataTable
                            ? listOfCheckFromToday.length > 5
                                ? 5
                                : listOfCheckFromToday.length
                            : listOfCheckFromToday.length,
                        (index) {
                          Check check = listOfCheckFromToday[index];
                          return DataRow(
                            cells: [
                              DataCell(
                                Text(
                                  (index + 1).toString().toPersianDigit(),
                                ),
                              ),
                              DataCell(
                                Text(check.customerCheck!.name!),
                              ),
                              if (!miniDataTable)
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
                                Center(
                                  child: Text(
                                    (check.checkDeliveryDate)
                                        .toString()
                                        .toPersianDate(),
                                  ),
                                ),
                              ),
                              DataCell(
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text(
                                        '${check.checkAmount! < 0 ? -check.checkAmount! : check.checkAmount}'
                                            .toPersianDigit()
                                            .seRagham()),
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
                              ),
                              DataCell(
                                Text(check.bankName!),
                              ),
                              if (!miniDataTable)
                                DataCell(
                                  Text(
                                    check.checkNumber!.toPersianDigit(),
                                  ),
                                ),
                            ],
                            onSelectChanged: onRowTapped,
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
                                onTap: onSeeAll,
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
