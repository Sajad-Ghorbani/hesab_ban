import 'package:flutter/material.dart';
import 'package:hesab_ban/app/core/widgets/base_widget.dart';
import 'package:hesab_ban/app/core/widgets/box_container_widget.dart';

class PrivacyAndPolicyScreen extends StatelessWidget {
  const PrivacyAndPolicyScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BaseWidget(
      title: const Text('حریم خصوصی'),
      showLeading: true,
      child: BoxContainerWidget(
        backBlur: false,
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: SingleChildScrollView(
            physics: const BouncingScrollPhysics(),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'سیاست نامه حریم خصوصی',
                  style: Theme.of(context).textTheme.titleLarge,
                ),
                const SizedBox(
                  height: 10,
                ),
                const Text(
                  '«حساب بان» به حریم خصوصی کاربران خود احترام می گذارد و متعهد به حفاظت از اطلاعات شخصی است که شما در اختیار آن می گذارید.',
                  style: TextStyle(height: 1.5),
                ),
                const SizedBox(
                  height: 25,
                ),
                Text(
                  'چه اطلاعاتی توسط حساب بان از کاربر دریافت می شود؟',
                  style: Theme.of(context).textTheme.titleLarge,
                ),
                const SizedBox(
                  height: 10,
                ),
                const Text(
                  '- در این برنامه اطلاعات شخصی اشخاص طرف حساب شما از جمله نام و شماره تماس و آدرس آنها دریافت می شود.',
                  style: TextStyle(height: 1.5),
                ),
                const Text(
                  '- اطلاعات مالی و دریافت و پرداخت وجه توسط شما نیز دریافت می شود.',
                  style: TextStyle(height: 1.5),
                ),
                const SizedBox(
                  height: 25,
                ),
                Text(
                  'چه استفاده ای از این اطلاعات می شود؟',
                  style: Theme.of(context).textTheme.titleLarge,
                ),
                const SizedBox(
                  height: 10,
                ),
                const Text(
                  'این اطلاعات برای نمایش قسمت های مختلف برنامه استفاده می شود از جمله:',
                  style: TextStyle(height: 1.5),
                ),
                const Text(
                  '- صورتحساب مشتریان و گردش حساب',
                  style: TextStyle(height: 1.5),
                ),
                const Text(
                  '- ثبت فاکتور به نام اشخاص',
                  style: TextStyle(height: 1.5),
                ),
                const Text(
                  '- ثبت چک',
                  style: TextStyle(height: 1.5),
                ),
                const Text(
                  '- ثبت وجه نقد',
                  style: TextStyle(height: 1.5),
                ),
                const Text(
                  'لازم به ذکر است که این اطلاعات به هیچ وجه در اختیار اشخاص ثالث و سازمان و شرکتی قرار نمی گیرد و حساب بان در رعایت حریم خصوصی کاربران متعهد می باشد.',
                  style: TextStyle(height: 1.5),
                ),
                const Text(
                  'این اطلاعات تنها در گوشی کاربر ذخیره شده و قابل مشاهده می باشد.',
                  style: TextStyle(height: 1.5),
                ),
                const SizedBox(
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
