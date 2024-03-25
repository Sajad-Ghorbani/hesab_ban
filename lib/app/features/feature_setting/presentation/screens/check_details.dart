import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hesab_ban/app/config/theme/app_colors.dart';
import 'package:hesab_ban/app/config/theme/constants_app_styles.dart';
import 'package:hesab_ban/app/core/widgets/base_widget.dart';
import 'package:hesab_ban/app/core/widgets/box_container_widget.dart';
import 'package:hesab_ban/app/features/feature_check/data/models/check_model.dart';
import 'package:hesab_ban/app/features/feature_check/domain/entities/bank_entity.dart';
import 'package:hesab_ban/app/features/feature_check/domain/entities/check_entity.dart';
import 'package:hesab_ban/app/features/feature_setting/presentation/controller/setting_controller.dart';
import 'package:persian_number_utility/persian_number_utility.dart';

class CheckDetails extends StatelessWidget {
  const CheckDetails(this.check, {Key? key}) : super(key: key);
  final CheckEntity check;

  @override
  Widget build(BuildContext context) {
    return BaseWidget(
      titleText: 'مشخصات چک',
      showLeading: true,
      child: BoxContainerWidget(
        backBlur: false,
        child: Container(
          margin: const EdgeInsets.symmetric(vertical: 40, horizontal: 20),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text('شماره چک:'),
                  const SizedBox(
                    height: 10,
                  ),
                  Text('${check.checkNumber}'),
                  const SizedBox(
                    height: 30,
                  ),
                  Row(
                    children: [
                      Text(check.typeOfCheck == TypeOfCheck.send
                          ? 'به:'
                          : 'از:'),
                      const SizedBox(width: 10,),
                      SizedBox(
                        width: (Get.width-70)/2,
                        child: Text('${check.customerCheck!.name}'),
                      ),
                    ],
                  ),
                  const SizedBox(
                    height: 30,
                  ),
                  const Text('به مبلغ:'),
                  const SizedBox(
                    height: 10,
                  ),
                  Row(
                    children: [
                      Text('${check.checkAmount!.abs()}'.seRagham()),
                      const SizedBox(
                        width: 5,
                      ),
                      Text(
                        Get.find<SettingController>().moneyUnit,
                        style: kRialTextStyle,
                      )
                    ],
                  ),
                  const SizedBox(
                    height: 30,
                  ),
                  const Text('تاریخ تحویل:'),
                  const SizedBox(
                    height: 10,
                  ),
                  Text('${check.checkDueDate}'.toPersianDate()),
                  const SizedBox(
                    height: 30,
                  ),
                  const Text('تاریخ سر رسید:'),
                  const SizedBox(
                    height: 10,
                  ),
                  Text('${check.checkDeliveryDate}'.toPersianDate()),
                ],
              ),
              showCheckBank(check),
            ],
          ),
        ),
      ),
    );
  }

  Widget showCheckBank(CheckEntity check) {
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
    return Column(
      children: [
        const Text('بانک:'),
        const SizedBox(
          height: 10,
        ),
        Text(check.bankName ?? check.checkBank!.name!),
        imageAddress == '-1'
            ? const SizedBox.shrink()
            : Column(
                children: [
                  const SizedBox(
                    height: 10,
                  ),
                  Container(
                    padding: const EdgeInsets.all(10),
                    decoration: const BoxDecoration(
                      borderRadius: BorderRadius.all(Radius.circular(10)),
                      color: kWhiteColor,
                    ),
                    child: Image.asset(imageAddress, width: 100, height: 100),
                  ),
                ],
              ),
      ],
    );
  }
}
