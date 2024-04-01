import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hesab_ban/app/config/theme/constants_app_styles.dart';
import 'package:hesab_ban/app/core/utils/extensions.dart';
import 'package:hesab_ban/app/core/widgets/box_container_widget.dart';
import 'package:hesab_ban/app/features/feature_factor/domain/entities/factor_row_entity.dart';
import 'package:hesab_ban/app/features/feature_factor/presentation/controller/factor_controller.dart';
import 'package:hesab_ban/app/features/feature_factor/presentation/widgets/factor_row_widget.dart';
import 'package:hesab_ban/app/features/feature_setting/presentation/controller/setting_controller.dart';
import 'package:reorderables/reorderables.dart';

class FactorContainerWidget extends GetView<FactorController> {
  const FactorContainerWidget(this.typeOfFactor, {super.key});
  final String typeOfFactor;

  @override
  Widget build(BuildContext context) {
    return GetBuilder<FactorController>(
      builder: (_) {
        return BoxContainerWidget(
          backBlur: false,
          child: Padding(
            padding: const EdgeInsets.all(20),
            child: SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: ReorderableColumn(
                header: FactorRowWidget(
                  isHeader: true,
                  index: 'ردیف',
                  title: 'شرح کالا',
                  count: 'تعداد',
                  price: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Text('قیمت'),
                      const SizedBox(
                        width: 5,
                      ),
                      Text(
                        '(${Get.find<SettingController>().moneyUnit})',
                        style: kRialTextStyle,
                      ),
                    ],
                  ),
                  sum: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Text('قیمت کل'),
                      const SizedBox(
                        width: 5,
                      ),
                      Text(
                        '(${Get.find<SettingController>().moneyUnit})',
                        style: kRialTextStyle,
                      ),
                    ],
                  ),
                ),
                children:
                    controller.listFactorRow.asMap().entries.map((entity) {
                  FactorRowEntity row = entity.value;
                  return FactorRowWidget(
                    key: ValueKey(row),
                    index: (entity.key + 1).toString(),
                    title: row.productName,
                    count:
                        '${row.productCount.formatPrice()} ${row.productUnit}',
                    price: Text(typeOfFactor == 'buy'
                        ? row.priceOfBuy!.formatPrice()
                        : row.productPriceOfSale.formatPrice(),textAlign: TextAlign.center,),
                    sum: Text(row.productSum.formatPrice(),textAlign: TextAlign.center,),
                    onTap: () {
                      controller.onRowLongPressed(
                          context, row, entity.key, typeOfFactor);
                    },
                  );
                }).toList(),
                onReorder: (oldIndex, newIndex) {
                  final item = controller.listFactorRow.removeAt(oldIndex);
                  controller.listFactorRow.insert(newIndex, item);
                  controller.update();
                },
              ),
            ),
          ),
        );
      },
    );
  }
}
