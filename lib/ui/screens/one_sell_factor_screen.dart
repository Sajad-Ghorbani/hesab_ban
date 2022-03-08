import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import 'package:hesab_ban/controllers/factor_controller.dart';
import 'package:hesab_ban/models/factor_row.dart';
import 'package:hesab_ban/ui/theme/constants_app_styles.dart';
import 'package:hesab_ban/ui/widgets/base_widget.dart';
import 'package:hesab_ban/ui/widgets/box_container_widget.dart';
import 'package:hesab_ban/ui/widgets/grid_menu_widget.dart';
import 'package:persian_number_utility/persian_number_utility.dart';

import '../theme/app_colors.dart';

class OneSellFactorScreen extends GetView<FactorController> {
  const OneSellFactorScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        return controller.willPop();
      },
      child: BaseWidget(
        title: 'فاکتور خرده فروشی',
        appBarLeading: IconButton(
          onPressed: () {
            Get.back();
          },
          icon: const Icon(Icons.arrow_back_ios),
          splashRadius: 30,
        ),
        appBarActions: [
          IconButton(
            onPressed: () {
              controller.saveFactor(context);
            },
            icon: const Icon(FontAwesomeIcons.solidSave),
            splashRadius: 30,
            color: kGreenColor,
          ),
        ],
        child: Stack(
          fit: StackFit.expand,
          children: [
            CustomScrollView(
              slivers: [
                SliverToBoxAdapter(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        height: 80,
                        padding: const EdgeInsets.all(10),
                        decoration: const BoxDecoration(color: kGreyColor),
                        child: Row(
                          children: [
                            const Text('شماره فاکتور:'),
                            const SizedBox(
                              width: 10,
                            ),
                            Text('#${controller.factorNumber}'),
                            const Spacer(),
                            const Text('تاریخ:'),
                            const SizedBox(
                              width: 10,
                            ),
                            Text(
                              DateTime.now().toPersianDate(),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(
                        height: 10,
                      ),
                      Container(
                        margin: const EdgeInsets.symmetric(horizontal: 10),
                        child: GridMenuWidget(
                          title: 'انتخاب کالا',
                          onTap: () {
                            controller.selectProduct(context);
                          },
                        ),
                      ),
                      const SizedBox(
                        height: 10,
                      ),
                    ],
                  ),
                ),
                BoxContainerWidget(
                  child: SliverPadding(
                    padding: const EdgeInsets.all(10),
                    sliver: SliverList(
                      delegate: SliverChildListDelegate(
                        [
                          SingleChildScrollView(
                            scrollDirection: Axis.horizontal,
                            child: Obx(
                              () => Padding(
                                padding:
                                    const EdgeInsets.symmetric(horizontal: 5),
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
                                        children: const [
                                          Text('قیمت'),
                                          SizedBox(
                                            width: 5,
                                          ),
                                          Text(
                                            '(ریال)',
                                            style: kRialTextStyle,
                                          ),
                                        ],
                                      ),
                                    ),
                                    DataColumn(
                                      label: Row(
                                        children: const [
                                          Text('قیمت کل'),
                                          SizedBox(
                                            width: 5,
                                          ),
                                          Text(
                                            '(ریال)',
                                            style: kRialTextStyle,
                                          ),
                                        ],
                                      ),
                                    ),
                                  ],
                                  rows: List.generate(
                                    controller.listFactorRow.length,
                                    (index) {
                                      FactorRow row =
                                          controller.listFactorRow[index];
                                      return DataRow(
                                        onSelectChanged: (selected){
                                          controller.onRowTapped(row,index);
                                        },
                                        onLongPress: (){
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
                                            Text('${row.productPrice}'
                                                .seRagham()),
                                          ),
                                          DataCell(
                                            Text(
                                                '${row.productSum}'.seRagham()),
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
                ),
                const SliverToBoxAdapter(
                  child: SizedBox(
                    height: 75,
                  ),
                ),
              ],
            ),
            Obx(
              () => controller.factorSum.value == '-1'
                  ? const SizedBox.shrink()
                  : Positioned(
                      bottom: 10,
                      right: 10,
                      left: 10,
                      child: Container(
                        padding: const EdgeInsets.all(15),
                        decoration: const BoxDecoration(
                          color: kGreyColor,
                          borderRadius: BorderRadius.all(
                            Radius.circular(15),
                          ),
                        ),
                        child: Row(
                          children: [
                            const Text('#'),
                            const SizedBox(
                              width: 5,
                            ),
                            const Text('جمع کل'),
                            const Spacer(),
                            Text(controller.factorSum.value.seRagham()),
                            const SizedBox(
                              width: 5,
                            ),
                            const Text(
                              'ریال',
                              style: kRialTextStyle,
                            ),
                          ],
                        ),
                      ),
                    ),
            ),
          ],
        ),
      ),
    );
  }
}
