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
      String title, TextEditingController controller, VoidCallback onTap) {
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
}
