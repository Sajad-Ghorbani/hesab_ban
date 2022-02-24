import 'dart:ui';

import 'package:accounting_app/controllers/product_controller.dart';
import 'package:accounting_app/models/product_model.dart';
import 'package:accounting_app/routes/app_pages.dart';
import 'package:accounting_app/ui/theme/app_colors.dart';
import 'package:accounting_app/ui/widgets/base_widget.dart';
import 'package:accounting_app/ui/widgets/grid_menu_widget.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';

import '../../static_methods.dart';

class AllProductScreen extends GetView<ProductController> {
  const AllProductScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BaseWidget(
      title: 'کالاها',
      child: CustomScrollView(
        slivers: [
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.all(10.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  GridMenuWidget(
                      title: 'ساخت محصول جدید',
                      onTap: () {
                        Get.toNamed(Routes.productScreen);
                      }),
                  GridMenuWidget(
                    title: 'ساخت پوشه جدید',
                    onTap: () {
                      StaticMethods.showFolderDialog(
                        'ساخت پوشه جدید',
                        controller.folderNameController,
                        () {
                          controller.addNewFolder();
                          Get.back();
                        },
                      );
                    },
                  ),
                ],
              ),
            ),
          ),
          Obx(
            () => SliverList(
              delegate: SliverChildListDelegate(
                controller.productFolder.value.map((String folderName) {
                  String name = folderName.split('/').first;
                  int folderNumber = int.parse(folderName.split('/').last);
                  return ListTile(
                    title: Text(name),
                    leading: const FaIcon(
                      FontAwesomeIcons.solidFolder,
                      color: kTealColor,
                    ),
                    onTap: () {

                      controller.getFolderProduct(context,folderNumber);
                    },
                    onLongPress: () {
                      Get.bottomSheet(
                        Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            ClipRect(
                              child: BackdropFilter(
                                filter:
                                    ImageFilter.blur(sigmaX: 3.0, sigmaY: 3.0),
                                child: Container(
                                  width: Get.width - 80,
                                  padding: const EdgeInsets.symmetric(
                                      vertical: 10, horizontal: 10),
                                  decoration: BoxDecoration(
                                    color: Theme.of(context)
                                        .cardColor
                                        .withOpacity(0.5),
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
                                        onTap: () {
                                          Get.back();
                                          StaticMethods.showFolderDialog(
                                            'ویرایش $name',
                                            controller.folderNameController,
                                            () {
                                              controller.updateNewFolder(
                                                  folderNumber);
                                              Get.back();
                                            },
                                          );
                                        },
                                        child: const Padding(
                                          padding: EdgeInsets.all(8.0),
                                          child: Text('ویرایش'),
                                        ),
                                      ),
                                      const Divider(),
                                      GestureDetector(
                                        onTap: () {
                                          Get.back();
                                          Get.defaultDialog(
                                            title: 'احتیاط',
                                            content: Text(
                                              'در صورت حذف پوشه "$name" تمام کالاهای داخل آن نیز حذف می شوند.'
                                              ' این عملیات برگشت پذیر نیست. آیا مطمئن هستید؟',
                                              style: const TextStyle(
                                                height: 1.5,
                                              ),
                                              textAlign: TextAlign.center,
                                            ),
                                            confirm: InkWell(
                                              onTap: () {
                                                controller
                                                    .deleteFolder(folderNumber);
                                                Get.back();
                                              },
                                              borderRadius:
                                                  const BorderRadius.all(
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
                                                  borderRadius:
                                                      BorderRadius.all(
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
                                              borderRadius:
                                                  const BorderRadius.all(
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
                                                  borderRadius:
                                                      BorderRadius.all(
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
                                        },
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
                    },
                  );
                }).toList(),
              ),
            ),
          ),
          Obx(
            () => SliverList(
              delegate: SliverChildListDelegate(
                controller.allProducts.value.map((Product product) {
                  return ListTile(
                    title: Text(product.name!),
                    leading: const FaIcon(
                      FontAwesomeIcons.boxOpen,
                      color: kLightPurpleColor,
                    ),
                    onTap: () {},
                  );
                }).toList(),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
