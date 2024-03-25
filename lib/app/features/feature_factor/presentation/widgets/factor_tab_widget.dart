import 'dart:math';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hesab_ban/app/config/theme/app_colors.dart';
import 'package:hesab_ban/app/config/theme/app_text_theme.dart';
import 'package:hesab_ban/app/core/utils/static_methods.dart';
import 'package:hesab_ban/app/features/feature_factor/domain/entities/factor_entity.dart';
import 'package:hesab_ban/app/features/feature_setting/presentation/controller/setting_controller.dart';
import 'package:iconsax/iconsax.dart';
import 'package:persian_number_utility/persian_number_utility.dart';

class FactorTabWidget extends StatelessWidget {
  const FactorTabWidget({
    super.key,
    required this.factor,
  });

  final FactorEntity factor;

  @override
  Widget build(BuildContext context) {
    bool isDark = Theme.of(context).brightness == Brightness.dark;
    String dateToString(DateTime date) {
      String d = date.toString().split(' ')[1].split('.')[0].toPersianDigit();
      List<String> lst = d.split(':')..removeAt(2);
      String sDate = '${lst.join(':')} - ${date.toPersianDate()}';
      return sDate;
    }

    return Material(
      color: isDark ? kSurfaceColor : kWhiteBlueColor,
      borderRadius: const BorderRadius.all(Radius.circular(10)),
      child: InkWell(
        borderRadius: const BorderRadius.all(Radius.circular(10)),
        onTap: () {
          StaticMethods.showFactor(context, factor, true);
        },
        child: Padding(
          padding: const EdgeInsets.all(10),
          child: Row(
            children: [
              SizedBox(
                width: 50,
                child: Column(
                  children: [
                    Text(
                      'ش. فاکتور',
                      style: Theme.of(context)
                          .textTheme
                          .bodySmall!
                          .copyWith(fontSize: 10),
                    ),
                    const SizedBox(height: 5),
                    FittedBox(
                      child: Text(
                        factor.id.toString(),
                        style: const TextStyle(
                          fontWeight: kWeightBold,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 10),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  if (factor.customer?.name != null) ...[
                    Row(
                      children: [
                        Container(
                          decoration: BoxDecoration(
                            borderRadius:
                                const BorderRadius.all(Radius.circular(5)),
                            color: Colors.primaries[
                                Random().nextInt(Colors.primaries.length)],
                          ),
                          padding: const EdgeInsets.all(3),
                          margin: const EdgeInsets.only(left: 5),
                          child: const Icon(
                            Iconsax.user,
                            size: 14,
                            color: kWhiteColor,
                          ),
                        ),
                        Text(
                          factor.customer!.name!,
                          style: Theme.of(context).textTheme.bodyLarge,
                        ),
                      ],
                    ),
                    const SizedBox(height: 10),
                    Text(dateToString(factor.factorDate!)),
                  ] //
                  else ...[
                    Text(dateToString(factor.factorDate!)),
                  ],
                ],
              ),
              const Spacer(),
              Column(
                children: [
                  Text('${factor.factorSum!.abs()}'.seRagham()),
                  Text(
                    Get.find<SettingController>().moneyUnit,
                    style: Theme.of(context).textTheme.bodySmall,
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
