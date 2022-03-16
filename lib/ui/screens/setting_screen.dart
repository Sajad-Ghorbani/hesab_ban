import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import 'package:hesab_ban/controllers/home_controller.dart';
import 'package:hesab_ban/routes/app_pages.dart';
import 'package:hesab_ban/ui/theme/app_colors.dart';
import 'package:hesab_ban/ui/widgets/base_widget.dart';
import 'package:hesab_ban/ui/widgets/box_container_widget.dart';

class SettingScreen extends GetView<HomeController> {
  const SettingScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BaseWidget(
      title: 'تنظیمات',
      child: Column(
        children: [
          const SizedBox(
            height: 10,
          ),
          ClipRRect(
            borderRadius: const BorderRadius.all(Radius.circular(50)),
            child: Image.asset(
              'assets/images/hesab_ban.png',
              width: 200,
            ),
          ),
          BoxContainerWidget(
            child: Container(
              margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
              child: Column(
                children: [
                  Row(
                    children: [
                      const Icon(FontAwesomeIcons.dollarSign,size: 24,),
                      const SizedBox(width: 7,),
                      const Text('واحد پول'),
                      const Spacer(),
                      const Text('تومان'),
                      Obx(
                        () => Switch(
                          value: controller.moneyUnitChange.value,
                          activeColor: kTealColor,
                          inactiveThumbColor: kTealColor,
                          inactiveTrackColor: kWhiteColor.withOpacity(0.8),
                          activeTrackColor: kWhiteColor.withOpacity(0.5),
                          onChanged: (value) {
                            controller.changeMoneyUnit(value);
                          },
                        ),
                      ),
                      const Text('ریال'),
                    ],
                  ),
                  Row(
                    children: const [
                      Icon(Icons.color_lens_rounded),
                      SizedBox(width: 10,),
                      Text('تغییر تم برنامه'),
                      Spacer(),
                      Text('دارک'),
                      Switch(
                        value: false,
                        onChanged: null,
                      ),
                      Text('لایت'),
                    ],
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 10),
                    child: GestureDetector(
                      onTap: (){
                        Get.toNamed(Routes.privacyAndPolicyScreen);
                      },
                      child: Row(
                        children: const [
                          Icon(Icons.privacy_tip_rounded),
                          SizedBox(width: 10,),
                          Text('حریم خصوصی'),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
          BoxContainerWidget(
            child: Container(
              margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
              child: Column(
                children: [
                  Row(
                    children: [
                      const Expanded(
                        child: Text(
                          'برای ارسال پیشنهادات و انتقادات خود می توانید از طریق واتساپ با ما در ارتباط باشید.',
                          style: TextStyle(height: 1.5),
                        ),
                      ),
                      const SizedBox(
                        width: 20,
                      ),
                      GestureDetector(
                        onTap: (){
                          controller.openWhatsApp();
                        },
                        child: Image.asset(
                          'assets/images/whatsapp.png',
                          width: 35,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
