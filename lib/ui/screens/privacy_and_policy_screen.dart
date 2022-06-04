import 'package:flutter/material.dart';
import 'package:hesab_ban/ui/theme/app_text_theme.dart';
import 'package:hesab_ban/ui/widgets/base_widget.dart';
import 'package:hesab_ban/ui/widgets/box_container_widget.dart';

class PrivacyAndPolicyScreen extends StatelessWidget {
  const PrivacyAndPolicyScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BaseWidget(
      title: 'حریم خصوصی',
      showPaint: true,
      appBarLeading: IconButton(
        onPressed: () {
          Navigator.pop(context);
        },
        icon: const Icon(Icons.arrow_back_ios),
        splashRadius: 30,
      ),
      child: BoxContainerWidget(
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: SingleChildScrollView(
            physics: const BouncingScrollPhysics(),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: const [
                Text(
                  'سیاست نامه حریم خصوصی',
                  style: kBodyMedium,
                ),
                SizedBox(
                  height: 10,
                ),
                Text(
                  '«حساب بان» به حریم خصوصی کاربران خود احترام می گذارد و متعهد به حفاظت از اطلاعات شخصی است که شما در اختیار آن می گذارید.',
                  style: TextStyle(height: 1.5),
                ),
                SizedBox(
                  height: 25,
                ),
                Text(
                  'چه اطلاعاتی توسط حساب بان از کاربر دریافت می شود؟',
                  style: kBodyMedium,
                ),
                SizedBox(
                  height: 10,
                ),
                Text(
                  '- در این برنامه اطلاعات شخصی اشخاص طرف حساب شما از جمله نام و شماره تماس و آدرس آنها دریافت می شود.',
                  style: TextStyle(height: 1.5),
                ),
                Text(
                  '- اطلاعات مالی و دریافت و پرداخت وجه توسط شما نیز دریافت می شود.',
                  style: TextStyle(height: 1.5),
                ),
                SizedBox(
                  height: 25,
                ),
                Text(
                  'چه استفاده ای از این اطلاعات می شود؟',
                  style: kBodyMedium,
                ),
                SizedBox(
                  height: 10,
                ),
                Text(
                  'این اطلاعات برای نمایش قسمت های مختلف برنامه استفاده می شود از جمله:',
                  style: TextStyle(height: 1.5),
                ),
                Text(
                  '- صورتحساب مشتریان و گردش حساب',
                  style: TextStyle(height: 1.5),
                ),
                Text(
                  '- ثبت فاکتور به نام اشخاص',
                  style: TextStyle(height: 1.5),
                ),
                Text(
                  '- ثبت چک',
                  style: TextStyle(height: 1.5),
                ),
                Text(
                  '- ثبت وجه نقد',
                  style: TextStyle(height: 1.5),
                ),
                Text(
                  'لازم به ذکر است که این اطلاعات به هیچ وجه در اختیار اشخاص ثالث و سازمان و شرکتی قرار نمی گیرد و حساب بان در رعایت حریم خصوصی کاربران متعهد می باشد.',
                  style: TextStyle(height: 1.5),
                ),
                Text(
                  'این اطلاعات تنها در گوشی کاربر ذخیره شده و قابل مشاهده می باشد.',
                  style: TextStyle(height: 1.5),
                ),
                SizedBox(
                  height: 25,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
