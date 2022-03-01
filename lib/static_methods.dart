import 'dart:ui';

import 'package:hesab_ban/ui/theme/app_colors.dart';
import 'package:hesab_ban/ui/theme/constants_app_styles.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class StaticMethods {
  static void showSnackBar({
    required String title,
    required String description,
    Color? color,
    Duration? duration,
  }) {
    Get.snackbar(
      '',
      '',
      titleText: Text(
        title,
      ),
      messageText: Text(
        description,
        style: const TextStyle(height: 1.5),
      ),
      backgroundColor:
          color == null ? kRedColor.withOpacity(0.3) : color.withOpacity(0.3),
      duration: duration ?? const Duration(seconds: 3),
    );
  }

  static void showFolderDialog(
      {required String title,
      required TextEditingController controller,
      required VoidCallback onTap}) {
    Get.defaultDialog(
      title: title,
      content: Row(
        children: [
          const Text('نام پوشه'),
          const SizedBox(
            width: 30,
          ),
          Expanded(
            child: TextField(
              controller: controller,
            ),
          ),
        ],
      ),
      confirm: InkWell(
        onTap: onTap,
        borderRadius: const BorderRadius.all(
          Radius.circular(10),
        ),
        child: Container(
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              colors: [
                kGreenColor,
                kLightGreenColor,
              ],
              begin: Alignment.topRight,
              end: Alignment.bottomLeft,
            ),
            borderRadius: BorderRadius.all(
              Radius.circular(10),
            ),
          ),
          height: 35,
          width: 80,
          alignment: Alignment.center,
          child: const Text('تایید'),
        ),
      ),
    );
  }

  static Future<void> productBottomSheet(
    BuildContext context, {
    required String name,
    required VoidCallback onEditTap,
    required VoidCallback onDeleteTap,
  }) async {
    await Get.bottomSheet(
      Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          ClipRect(
            child: BackdropFilter(
              filter: ImageFilter.blur(sigmaX: 3.0, sigmaY: 3.0),
              child: Container(
                width: Get.width - 80,
                padding:
                    const EdgeInsets.symmetric(vertical: 10, horizontal: 10),
                decoration: BoxDecoration(
                  color: Theme.of(context).cardColor.withOpacity(0.5),
                  borderRadius: const BorderRadius.all(
                    Radius.circular(10),
                  ),
                ),
                alignment: Alignment.center,
                child: Column(
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Text(
                        name,
                        style: const TextStyle(
                          color: kOrangeColor,
                        ),
                      ),
                    ),
                    const Divider(),
                    GestureDetector(
                      onTap: onEditTap,
                      child: const Padding(
                        padding: EdgeInsets.all(8.0),
                        child: Text('ویرایش'),
                      ),
                    ),
                    const Divider(),
                    GestureDetector(
                      onTap: onDeleteTap,
                      child: const Padding(
                        padding: EdgeInsets.all(8.0),
                        child: Text('حذف'),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
          const SizedBox(
            height: 20,
          ),
        ],
      ),
    );
  }

  static deleteDialog(
      {required String content, required VoidCallback onConfirm}) {
    Get.defaultDialog(
      title: 'احتیاط',
      content: Text(
        content,
        style: const TextStyle(
          height: 1.5,
        ),
        textAlign: TextAlign.center,
      ),
      confirm: InkWell(
        onTap: onConfirm,
        borderRadius: const BorderRadius.all(
          Radius.circular(10),
        ),
        child: Container(
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              colors: [
                kGreenColor,
                kLightGreenColor,
              ],
              begin: Alignment.topRight,
              end: Alignment.bottomLeft,
            ),
            borderRadius: BorderRadius.all(
              Radius.circular(10),
            ),
          ),
          height: 35,
          width: 80,
          alignment: Alignment.center,
          child: const Text('تایید'),
        ),
      ),
      cancel: InkWell(
        onTap: () {
          Get.back();
        },
        borderRadius: const BorderRadius.all(
          Radius.circular(10),
        ),
        child: Container(
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              colors: [
                kRedColor,
                Colors.redAccent,
              ],
              begin: Alignment.topRight,
              end: Alignment.bottomLeft,
            ),
            borderRadius: BorderRadius.all(
              Radius.circular(10),
            ),
          ),
          height: 35,
          width: 80,
          alignment: Alignment.center,
          child: const Text('لغو'),
        ),
      ),
    );
  }

  static Future<void> selectCheckDetails({
    required VoidCallback onMeTap,
    required VoidCallback onCustomerTap,
  }) async {
    await Get.bottomSheet(
      Builder(
        builder: (context) {
          return Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              ClipRect(
                child: BackdropFilter(
                  filter: ImageFilter.blur(sigmaX: 3.0, sigmaY: 3.0),
                  child: Container(
                    width: Get.width - 80,
                    padding:
                        const EdgeInsets.symmetric(vertical: 10, horizontal: 10),
                    decoration: BoxDecoration(
                      color: Theme.of(context).cardColor.withOpacity(0.5),
                      borderRadius: const BorderRadius.all(
                        Radius.circular(10),
                      ),
                    ),
                    alignment: Alignment.center,
                    child: Column(
                      children: [
                        const Padding(
                          padding: EdgeInsets.all(8.0),
                          child: Text(
                            'صادر کننده چک را انتخاب کنید.',
                          ),
                        ),
                        const Divider(),
                        GestureDetector(
                          onTap: onMeTap,
                          child: const Padding(
                            padding: EdgeInsets.all(8.0),
                            child: Text('خودم'),
                          ),
                        ),
                        const Divider(),
                        GestureDetector(
                          onTap: onCustomerTap,
                          child: const Padding(
                            padding: EdgeInsets.all(8.0),
                            child: Text('مشتری'),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              const SizedBox(
                height: 20,
              ),
            ],
          );
        }
      ),
      isDismissible: false,
    );
  }

  static Future<void> selectCustomerCheck({
    required String title,
    required List<DropdownMenuItem<int>> dropDownList,
    required ValueChanged<int?> onSelectCustomer,
  }) async {
    await Get.bottomSheet(
      Builder(
        builder: (context) {
          return Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              ClipRect(
                child: BackdropFilter(
                  filter: ImageFilter.blur(sigmaX: 3.0, sigmaY: 3.0),
                  child: Container(
                    width: Get.width - 80,
                    padding:
                        const EdgeInsets.symmetric(vertical: 10, horizontal: 10),
                    decoration: BoxDecoration(
                      color: Theme.of(context).cardColor.withOpacity(0.5),
                      borderRadius: const BorderRadius.all(
                        Radius.circular(10),
                      ),
                    ),
                    alignment: Alignment.center,
                    child: Column(
                      children: [
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Text(
                            title,
                          ),
                        ),
                        const Divider(),
                        DropdownButtonFormField<int>(
                          items: dropDownList,
                          onChanged: onSelectCustomer,
                          value: 0,
                          decoration: kCustomInputDecoration,
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              const SizedBox(
                height: 20,
              ),
            ],
          );
        }
      ),
      isDismissible: false,
    );
  }
}
