import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hesab_ban/app/config/theme/app_colors.dart';
import 'package:hesab_ban/app/config/theme/constants_app_styles.dart';
import 'package:hesab_ban/app/features/feature_setting/presentation/controller/setting_controller.dart';

class FactorFooterRow extends StatelessWidget {
  const FactorFooterRow({
    Key? key,
    required this.title,
    required this.amount,
    this.onTap,
    this.showMoneyUnit = true,
    this.textOverflow,
    this.amountWidth,
  }) : super(key: key);
  final String title;
  final String amount;
  final VoidCallback? onTap;
  final bool showMoneyUnit;
  final TextOverflow? textOverflow;
  final double? amountWidth;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Text(title),
        const Spacer(),
        Material(
          borderRadius: const BorderRadius.all(
            Radius.circular(10),
          ),
          color: Get.isDarkMode ? kDarkGreyColor : kWhiteGreyColor,
          child: InkWell(
            borderRadius: const BorderRadius.all(
              Radius.circular(10),
            ),
            onTap: onTap,
            child: Padding(
              padding: const EdgeInsets.only(left: 10),
              child: Row(
                children: [
                  Container(
                    width: amountWidth,
                    padding:
                        const EdgeInsets.symmetric(vertical: 5, horizontal: 10),
                    alignment: Alignment.center,
                    child: Text(
                      amount,
                      textDirection: TextDirection.ltr,
                      overflow: textOverflow,
                    ),
                  ),
                  if (showMoneyUnit) ...[
                    const SizedBox(width: 5),
                    Text(
                      Get.find<SettingController>().moneyUnit,
                      style: kRialTextStyle,
                    ),
                  ],
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }
}
