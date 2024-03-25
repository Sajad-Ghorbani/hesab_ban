import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hesab_ban/app/config/theme/constants_app_styles.dart';
import 'package:hesab_ban/app/features/feature_setting/presentation/controller/setting_controller.dart';

class PriceWidget extends StatelessWidget {
  const PriceWidget({
    super.key,
    required this.price,
    this.color,
  });

  final String price;
  final Color? color;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          price,
          style: TextStyle(
            color: color,
          ),
        ),
        const SizedBox(width: 5),
        Text(
          Get.find<SettingController>().moneyUnit,
          style: kRialTextStyle,
        ),
      ],
    );
  }
}
