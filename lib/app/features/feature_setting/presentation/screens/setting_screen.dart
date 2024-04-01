import 'package:barcode_widget/barcode_widget.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hesab_ban/app/config/routes/app_pages.dart';
import 'package:hesab_ban/app/config/theme/app_colors.dart';
import 'package:hesab_ban/app/core/widgets/base_widget.dart';
import 'package:hesab_ban/app/core/widgets/box_container_widget.dart';
import 'package:hesab_ban/app/core/widgets/setting_row_widget.dart';
import 'package:hesab_ban/app/features/feature_setting/presentation/controller/setting_controller.dart';
import 'package:iconsax/iconsax.dart';

class SettingScreen extends StatelessWidget {
  const SettingScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return GetBuilder<SettingController>(
      builder: (controller) {
        return BaseWidget(
          titleText: 'تنظیمات',
          showLeading: true,
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                BoxContainerWidget(
                  backBlur: false,
                  child: Container(
                    margin: const EdgeInsets.symmetric(
                        horizontal: 20, vertical: 20),
                    child: Column(
                      children: [
                        SettingRowWidget(
                          icon: Iconsax.heart,
                          titleWidget: SizedBox(
                            width: Get.width - 84,
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  'کاربران عزیز حساب بان',
                                  style: Theme.of(context).textTheme.titleLarge,
                                ),
                                const Text(
                                  'این برنامه کاملا رایگان بوده و استفاده از امکانات آن محدودیتی ندارد. '
                                      'اگر از برنامه رضایت دارید میتوانید با استفاده از صفحه پرداخت به '
                                      'مبلغ دلخواه از سازندگان برنامه حمایت کنید.',
                                ),
                                MaterialButton(
                                  shape: const RoundedRectangleBorder(
                                    borderRadius:
                                        BorderRadius.all(Radius.circular(10)),
                                  ),
                                  onPressed: () {
                                    controller.openPayLink();
                                  },
                                  color: Theme.of(context).colorScheme.surface,
                                  child: const Text('صفحه پرداخت'),
                                )
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(
                  height: 10,
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 10),
                  child: Text(
                    'تنظیمات عمومی',
                    style: TextStyle(
                      fontSize: 14,
                      color: Theme.of(context)
                          .colorScheme
                          .onBackground
                          .withOpacity(0.6),
                    ),
                  ),
                ),
                BoxContainerWidget(
                  backBlur: false,
                  child: Container(
                    margin: const EdgeInsets.symmetric(
                        horizontal: 20, vertical: 10),
                    child: Column(
                      children: [
                        Row(
                          children: [
                            const Icon(
                              Iconsax.dollar_circle,
                              size: 24,
                            ),
                            const SizedBox(
                              width: 7,
                            ),
                            const Text('واحد پول'),
                            const Spacer(),
                            const Text('تومان'),
                            SizedBox(
                              height: 40,
                              child: Transform.scale(
                                scale: 0.75,
                                child: Directionality(
                                  textDirection: TextDirection.ltr,
                                  child: Switch(
                                    value: controller.moneyUnitChange,
                                    activeColor: kTealColor,
                                    inactiveThumbColor: kTealColor,
                                    inactiveTrackColor:
                                        kWhiteColor.withOpacity(0.8),
                                    activeTrackColor:
                                        kWhiteColor.withOpacity(0.5),
                                    onChanged: (value) {
                                      controller.changeMoneyUnit(value);
                                    },
                                  ),
                                ),
                              ),
                            ),
                            const Text('ریال'),
                          ],
                        ),
                        SettingRowWidget(
                          onTap: () {
                            controller.setNotificationTime(context);
                          },
                          icon: Iconsax.notification_bing,
                          title: 'زمان دریافت اعلان چک',
                          valueWidget: Text(
                            '${controller.minutesNotification} : ${controller.hoursNotification}',
                          ),
                        ),
                        SettingRowWidget(
                          onTap: () {
                            Get.toNamed(Routes.passwordSettingScreen);
                          },
                          icon: Iconsax.lock_circle,
                          title: 'رمز عبور',
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(
                  height: 10,
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 10),
                  child: Text(
                    'تنظیمات فاکتور',
                    style: TextStyle(
                      fontSize: 14,
                      color: Theme.of(context)
                          .colorScheme
                          .onBackground
                          .withOpacity(0.6),
                    ),
                  ),
                ),
                BoxContainerWidget(
                  backBlur: false,
                  child: Container(
                    margin: const EdgeInsets.symmetric(
                        horizontal: 20, vertical: 10),
                    child: Column(
                      children: [
                        SettingRowWidget(
                          verticalPadding: 0,
                          icon: Iconsax.box,
                          titleWidget: Text(
                            'بررسی موجودی انبار هنگام\nفاکتور زدن',
                            style: Theme.of(context).textTheme.titleSmall,
                          ),
                          valueWidget: Checkbox(
                            value: controller.productCountCheck,
                            onChanged: (value) {
                              controller.changeFactorSetting(
                                  'productCountCheck', value!);
                            },
                          ),
                        ),
                        SettingRowWidget(
                          verticalPadding: 0,
                          icon: Iconsax.coin_1,
                          titleWidget: const Text('نمایش مانده حساب مشتری'),
                          valueWidget: Checkbox(
                            value: controller.showCustomerBalance,
                            onChanged: (value) {
                              controller.changeFactorSetting(
                                  'showCustomerBalance', value!);
                            },
                          ),
                        ),
                        SettingRowWidget(
                          verticalPadding: 0,
                          icon: Iconsax.receipt_text,
                          titleWidget: const Text('نمایش وجه دریافتی/پرداختی'),
                          valueWidget: Checkbox(
                            value: controller.showPaymentOrReceipt,
                            onChanged: (value) {
                              controller.changeFactorSetting(
                                  'showPaymentOrReceipt', value!);
                            },
                          ),
                        ),
                        SettingRowWidget(
                          verticalPadding: 0,
                          icon: Iconsax.receipt_disscount,
                          titleWidget: const Text('نمایش مالیات'),
                          valueWidget: Checkbox(
                            value: controller.showFactorTax,
                            onChanged: (value) {
                              controller.changeFactorSetting(
                                  'showFactorTax', value!);
                            },
                          ),
                        ),
                        SettingRowWidget(
                          verticalPadding: 0,
                          icon: Iconsax.discount_shape,
                          titleWidget: const Text('نمایش تخفیف'),
                          valueWidget: Checkbox(
                            value: controller.showFactorOffer,
                            onChanged: (value) {
                              controller.changeFactorSetting(
                                  'showFactorOffer', value!);
                            },
                          ),
                        ),
                        SettingRowWidget(
                          verticalPadding: 0,
                          icon: Iconsax.money_send,
                          titleWidget: const Text('نمایش هزینه ها'),
                          valueWidget: Checkbox(
                            value: controller.showFactorCosts,
                            onChanged: (value) {
                              controller.changeFactorSetting(
                                  'showFactorCosts', value!);
                            },
                          ),
                        ),
                        SettingRowWidget(
                          onTap: () {
                            controller.showFactorCosts
                                ? controller.changeCostsLabel()
                                : null;
                          },
                          icon: Iconsax.card_coin,
                          titleWidget: Text(
                            'تغییر عنوان هزینه ها',
                            style: TextStyle(
                              color: !controller.showFactorCosts
                                  ? Theme.of(context).disabledColor
                                  : null,
                            ),
                          ),
                          valueWidget: Expanded(
                            flex: 3,
                            child: Text(
                              controller.costsLabel ?? '',
                              overflow: TextOverflow.ellipsis,
                              textAlign: TextAlign.left,
                            ),
                          ),
                        ),
                        SettingRowWidget(
                          onTap: () {
                            controller.changeFactorDescription(context);
                          },
                          icon: Iconsax.firstline,
                          titleWidget: const Text('توضیحات فاکتور'),
                          valueWidget: Expanded(
                            flex: 3,
                            child: ConstrainedBox(
                              constraints: const BoxConstraints(maxHeight: 70),
                              child: SingleChildScrollView(
                                child: Text(
                                  controller.factorDescription ?? '',
                                  overflow: TextOverflow.ellipsis,
                                  textAlign: TextAlign.left,
                                ),
                              ),
                            ),
                          ),
                        ),
                        SettingRowWidget(
                          onTap: () {
                            controller.setStampPicture();
                          },
                          icon: Iconsax.gallery,
                          titleWidget: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Text('تصویر مهر در فاکتور'),
                              if (controller.stampLogo.path != '-1') ...[
                                TextButton.icon(
                                  onPressed: () {
                                    controller.deleteStampLogo();
                                  },
                                  icon: const Icon(
                                    Iconsax.trash,
                                    color: kRedColor,
                                    size: 18,
                                  ),
                                  style: ButtonStyle(
                                    padding: MaterialStateProperty.all(
                                        EdgeInsets.zero),
                                  ),
                                  label: Text(
                                    'حذف',
                                    style: Theme.of(context)
                                        .textTheme
                                        .titleSmall!
                                        .copyWith(color: kRedColor),
                                  ),
                                ),
                              ],
                            ],
                          ),
                          valueWidget: controller.stampLogo.path == '-1'
                              ? const SizedBox.shrink()
                              : Image.file(
                                  controller.stampLogo,
                                  width: 70,
                                  height: 70,
                                  fit: BoxFit.contain,
                                ),
                        ),
                        SettingRowWidget(
                          onTap: () {
                            Get.toNamed(Routes.signatureScreen);
                          },
                          icon: Iconsax.edit_2,
                          titleWidget: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Text('تصویر امضا در فاکتور'),
                              if (controller.signLogo.path != '-1') ...[
                                TextButton.icon(
                                  onPressed: () {
                                    controller.deleteStampLogo(false);
                                  },
                                  icon: const Icon(
                                    Iconsax.trash,
                                    color: kRedColor,
                                    size: 18,
                                  ),
                                  style: ButtonStyle(
                                    padding: MaterialStateProperty.all(
                                        EdgeInsets.zero),
                                  ),
                                  label: Text(
                                    'حذف',
                                    style: Theme.of(context)
                                        .textTheme
                                        .titleSmall!
                                        .copyWith(color: kRedColor),
                                  ),
                                ),
                              ],
                            ],
                          ),
                          valueWidget: controller.signLogo.path == '-1'
                              ? const SizedBox.shrink()
                              : Image.file(
                                  controller.signLogo,
                                  width: 70,
                                  height: 70,
                                  fit: BoxFit.contain,
                                  color: Theme.of(context)
                                      .colorScheme
                                      .onBackground,
                                ),
                        ),
                        SettingRowWidget(
                          onTap: () {
                            controller.setBarcodeUrl();
                          },
                          icon: Iconsax.scan_barcode,
                          titleWidget: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Text('بارکد اختصاصی در فاکتور'),
                              if (controller.barcodeUrl != '-1') ...[
                                TextButton.icon(
                                  onPressed: () {
                                    controller.deleteBarcodeUrl();
                                  },
                                  icon: const Icon(
                                    Iconsax.trash,
                                    color: kRedColor,
                                    size: 18,
                                  ),
                                  style: ButtonStyle(
                                    padding: MaterialStateProperty.all(
                                        EdgeInsets.zero),
                                  ),
                                  label: Text(
                                    'حذف',
                                    style: Theme.of(context)
                                        .textTheme
                                        .titleSmall!
                                        .copyWith(color: kRedColor),
                                  ),
                                ),
                              ],
                            ],
                          ),
                          valueWidget: controller.barcodeUrl == '-1'
                              ? const SizedBox.shrink()
                              : BarcodeWidget(
                                  barcode: Barcode.qrCode(
                                    errorCorrectLevel:
                                        BarcodeQRCorrectionLevel.high,
                                  ),
                                  data: controller.barcodeUrl,
                                  width: 100,
                                  height: 100,
                                ),
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(
                  height: 10,
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 10),
                  child: Text(
                    'تنظیمات فروشگاه',
                    style: TextStyle(
                      fontSize: 14,
                      color: Theme.of(context)
                          .colorScheme
                          .onBackground
                          .withOpacity(0.6),
                    ),
                  ),
                ),
                BoxContainerWidget(
                  backBlur: false,
                  child: Container(
                    margin: const EdgeInsets.symmetric(
                        horizontal: 20, vertical: 20),
                    child: Column(
                      children: [
                        SettingRowWidget(
                          onTap: () {
                            controller.setUserInfo(isName: true);
                          },
                          icon: Iconsax.text,
                          title: 'نام فروشگاه',
                          valueWidget: Expanded(
                            flex: 3,
                            child: Text(
                              controller.storeName,
                              overflow: TextOverflow.ellipsis,
                              textAlign: TextAlign.left,
                            ),
                          ),
                        ),
                        SettingRowWidget(
                          onTap: () {
                            controller.setUserInfo(isAddress: true);
                          },
                          icon: Iconsax.shop,
                          title: 'آدرس فروشگاه',
                          valueWidget: Expanded(
                            flex: 3,
                            child: Text(
                              controller.storeAddress,
                              overflow: TextOverflow.ellipsis,
                              textAlign: TextAlign.left,
                            ),
                          ),
                        ),
                        SettingRowWidget(
                          onTap: () {
                            controller.setUserInfo(isLogo: true);
                          },
                          icon: Iconsax.gallery,
                          titleWidget: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              const Text('لوگو فروشگاه'),
                              if (controller.storeLogo.path != '-1') ...[
                                TextButton.icon(
                                  onPressed: () {
                                    controller.deleteStoreLogo();
                                  },
                                  icon: const Icon(
                                    Iconsax.trash,
                                    color: kRedColor,
                                    size: 18,
                                  ),
                                  style: ButtonStyle(
                                    padding: MaterialStateProperty.all(
                                        EdgeInsets.zero),
                                  ),
                                  label: Text(
                                    'حذف',
                                    style: Theme.of(context)
                                        .textTheme
                                        .titleSmall!
                                        .copyWith(color: kRedColor),
                                  ),
                                ),
                              ],
                            ],
                          ),
                          valueWidget: controller.storeLogo.path == '-1'
                              ? const SizedBox.shrink()
                              : Image.file(
                                  controller.storeLogo,
                                  width: 70,
                                  height: 70,
                                  fit: BoxFit.contain,
                                ),
                        ),
                      ],
                    ),
                  ),
                ),
                BoxContainerWidget(
                  backBlur: false,
                  child: Container(
                    margin: const EdgeInsets.symmetric(
                        horizontal: 20, vertical: 20),
                    child: Column(
                      children: [
                        SettingRowWidget(
                          onTap: () {
                            Get.toNamed(Routes.backupScreen);
                          },
                          icon: Iconsax.cloud_change,
                          title: 'پشتیبان گیری و بازیابی اطلاعات',
                        ),
                      ],
                    ),
                  ),
                ),
                BoxContainerWidget(
                  backBlur: false,
                  child: Container(
                    margin: const EdgeInsets.symmetric(
                        horizontal: 20, vertical: 20),
                    child: Column(
                      children: [
                        SettingRowWidget(
                          onTap: () {
                            Get.toNamed(Routes.manageUnitsScreen);
                          },
                          icon: Iconsax.convert_3d_cube,
                          title: 'مدیریت واحد کالا',
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
