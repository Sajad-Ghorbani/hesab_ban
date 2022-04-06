import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hesab_ban/controllers/home_controller.dart';
import 'package:hesab_ban/models/check_model.dart';
import 'package:hesab_ban/ui/theme/constants_app_styles.dart';
import 'package:hesab_ban/ui/widgets/base_widget.dart';
import 'package:hesab_ban/ui/widgets/box_container_widget.dart';
import 'package:persian_number_utility/persian_number_utility.dart';

class CheckDetails extends StatelessWidget {
  const CheckDetails(this.check, {Key? key}) : super(key: key);
  final Check check;

  @override
  Widget build(BuildContext context) {
    return BaseWidget(
      title: 'مشخصات چک',
      appBarLeading: IconButton(
        onPressed: () {
          Get.back();
        },
        icon: const Icon(Icons.arrow_back_ios),
        splashRadius: 30,
      ),
      child: BoxContainerWidget(
        child: Container(
          margin: const EdgeInsets.all(40),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text('شماره چک:'),
                  const SizedBox(
                    height: 30,
                  ),
                  const Text('نام بانک:'),
                  const SizedBox(
                    height: 30,
                  ),
                  Text(check.typeOfCheck == TypeOfCheck.send ? 'به:' : 'از:'),
                  const SizedBox(
                    height: 30,
                  ),
                  const Text('به مبلغ:'),
                  const SizedBox(
                    height: 30,
                  ),
                  const Text('تاریخ تحویل:'),
                  const SizedBox(
                    height: 30,
                  ),
                  const Text('تاریخ سر رسید:'),
                ],
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('${check.checkNumber}'),
                  const SizedBox(
                    height: 30,
                  ),
                  Text(check.bankName!),
                  const SizedBox(
                    height: 30,
                  ),
                  Text('${check.customerCheck!.name}'),
                  const SizedBox(
                    height: 30,
                  ),
                  Row(
                    children: [
                      Text('${check.checkAmount!.abs()}'.seRagham()),
                      const SizedBox(
                        width: 5,
                      ),
                      Text(
                        Get.find<HomeController>().moneyUnit.value,
                        style: kRialTextStyle,
                      )
                    ],
                  ),
                  const SizedBox(
                    height: 30,
                  ),
                  Text('${check.checkDueDate}'.toPersianDate()),
                  const SizedBox(
                    height: 30,
                  ),
                  Text('${check.checkDeliveryDate}'.toPersianDate()),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
