import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hesab_ban/controllers/factor_controller.dart';
import 'package:hesab_ban/controllers/home_controller.dart';
import 'package:persian_number_utility/persian_number_utility.dart';

import '../../models/factor_row.dart';
import '../theme/constants_app_styles.dart';
import 'box_container_widget.dart';

class FactorContainerWidget extends GetView<FactorController> {
  const FactorContainerWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BoxContainerWidget(
      child: SliverPadding(
        padding: const EdgeInsets.all(10),
        sliver: SliverList(
          delegate: SliverChildListDelegate(
            [
              SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: Obx(
                  () => Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 5),
                    child: DataTable(
                      columnSpacing: 30,
                      showCheckboxColumn: false,
                      columns: [
                        const DataColumn(
                          label: Text('ردیف'),
                          numeric: true,
                        ),
                        const DataColumn(
                          label: Text('شرح کالا'),
                        ),
                        const DataColumn(
                          label: Text('تعداد'),
                        ),
                        DataColumn(
                          label: Row(
                            children: [
                              const Text('قیمت'),
                              const SizedBox(
                                width: 5,
                              ),
                              Text(
                                '(${Get.find<HomeController>().moneyUnit.value})',
                                style: kRialTextStyle,
                              ),
                            ],
                          ),
                        ),
                        DataColumn(
                          label: Row(
                            children: [
                              const Text('قیمت کل'),
                              const SizedBox(
                                width: 5,
                              ),
                              Text(
                                '(${Get.find<HomeController>().moneyUnit.value})',
                                style: kRialTextStyle,
                              ),
                            ],
                          ),
                        ),
                      ],
                      rows: List.generate(
                        controller.listFactorRow.length,
                        (index) {
                          FactorRow row = controller.listFactorRow[index];
                          return DataRow(
                            onSelectChanged: (selected) {
                              controller.onRowTapped(row, index);
                            },
                            onLongPress: () {
                              controller.onRowLongPressed(context, row, index);
                            },
                            cells: [
                              DataCell(
                                Text('${index + 1}'),
                              ),
                              DataCell(
                                Text(row.productName),
                              ),
                              DataCell(
                                Text(
                                    '${row.productCount.toString().seRagham()} ${row.productUnit}'),
                              ),
                              DataCell(
                                Text('${row.productPrice}'.seRagham()),
                              ),
                              DataCell(
                                Text('${row.productSum}'.seRagham()),
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
          ),
        ),
      ),
    );
  }
}
