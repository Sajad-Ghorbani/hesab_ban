import 'dart:ui';

import 'package:accounting_app/ui/theme/app_colors.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class StaticMethods {
  static void showSnackBar(
      {required String title, required String description}) {
    Get.snackbar(
      '',
      '',
      titleText: Text(
        title,
      ),
      messageText: Text(
        description,
      ),
      backgroundColor: kRedColor.withOpacity(0.4),
    );
  }

  static void showFolderDialog(
      {required String title, required TextEditingController controller, required VoidCallback onTap}) {
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

  static void productBottomSheet(BuildContext context,
      {required String name,
      required VoidCallback onEditTap,
      required VoidCallback onDeleteTap}) {
    Get.bottomSheet(
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

  static deleteDialog({required String content, required VoidCallback onConfirm}){
    Get.defaultDialog(
      title: 'احتیاط',
      content: Text(content,
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
}
