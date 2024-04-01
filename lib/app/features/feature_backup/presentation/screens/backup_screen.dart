import 'dart:io';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:googleapis/drive/v3.dart' as drive;
import 'package:hesab_ban/app/core/utils/static_methods.dart';
import 'package:hesab_ban/app/core/widgets/base_widget.dart';
import 'package:hesab_ban/app/core/widgets/loading.dart';
import 'package:hesab_ban/app/core/widgets/setting_row_widget.dart';
import 'package:hesab_ban/app/core/widgets/sliver_box_container_widget.dart';
import 'package:hesab_ban/app/features/feature_backup/presentation/controller/backup_controller.dart';
import 'package:iconsax/iconsax.dart';

class BackupScreen extends GetView<BackupController> {
  const BackupScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Obx(
      () => Loading(
        showLoading: controller.showLoading.value,
        child: BaseWidget(
          title: const Text('پشتیبان گیری و بازیابی اطلاعات'),
          showLeading: true,
          child: CustomScrollView(
            slivers: [
              const SliverToBoxAdapter(
                child: SizedBox(
                  height: 10,
                ),
              ),
              SliverBoxContainerWidget(
                backBlur: false,
                child: SliverPadding(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                  sliver: SliverToBoxAdapter(
                    child: Column(
                      children: [
                        SettingRowWidget(
                          onTap: () {
                            controller.createBackup(false);
                          },
                          icon: Icons.settings_backup_restore,
                          title: 'پشتیبان گیری داخل گوشی',
                        ),
                        SettingRowWidget(
                          onTap: () {
                            controller.createBackup(true);
                          },
                          icon: Icons.backup_rounded,
                          title: 'پشتیبان گیری آنلاین',
                        ),
                        Visibility(
                          visible: controller.email.value != '-1',
                          child: SettingRowWidget(
                            onTap: () {},
                            icon: Icons.account_circle,
                            title: 'متصل به اکانت',
                            valueWidget: FittedBox(
                              child: Text(
                                controller.email.value,
                              ),
                            ),
                          ),
                        )
                      ],
                    ),
                  ),
                ),
              ),
              const SliverPadding(
                padding: EdgeInsets.fromLTRB(10, 20, 20, 10),
                sliver: SliverToBoxAdapter(
                  child: Text('لیست فایلهای بکاپ داخل گوشی'),
                ),
              ),
              SliverBoxContainerWidget(
                backBlur: false,
                child: SliverPadding(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                  sliver: Obx(
                    () => controller.storageBackupList.isEmpty
                        ? const SliverToBoxAdapter(
                            child: Center(
                              child: Padding(
                                padding: EdgeInsets.all(10),
                                child: Text('لیست خالی می باشد.'),
                              ),
                            ),
                          )
                        : SliverList(
                            delegate: SliverChildBuilderDelegate(
                              (context, index) {
                                FileSystemEntity file =
                                    controller.storageBackupList.value[index];
                                return SettingRowWidget(
                                  onTap: () {
                                    StaticMethods.deleteDialog(
                                      content:
                                          'شما در حال بازیابی اطلاعات قبلی خود هستید. آیا اطمینان دارید؟\n'
                                          'این عمل برگشت پذیر نیست.',
                                      onConfirm: () async {
                                        Get.back();
                                        controller
                                            .setBackup(File(file.path));
                                      },
                                    );
                                  },
                                  icon: Iconsax.layer,
                                  title: file.path.split('/').last,
                                  valueWidget:
                                      const Icon(Icons.restore_rounded),
                                );
                              },
                              childCount:
                                  controller.storageBackupList.value.length,
                            ),
                          ),
                  ),
                ),
              ),
              SliverPadding(
                padding: const EdgeInsets.fromLTRB(10, 20, 20, 10),
                sliver: SliverToBoxAdapter(
                  child: Row(
                    children: [
                      const Text('لیست فایلهای بکاپ در اکانت شما'),
                      const Spacer(),
                      GestureDetector(
                        onTap: () {
                          controller.setOnlineBackupList();
                        },
                        child: const Text('مشاهده لیست'),
                      ),
                    ],
                  ),
                ),
              ),
              SliverBoxContainerWidget(
                backBlur: false,
                child: SliverPadding(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                  sliver: Obx(
                    () => controller.onlineBackupList.isEmpty
                        ? const SliverToBoxAdapter(
                            child: Center(
                              child: Padding(
                                padding: EdgeInsets.all(10),
                                child: Text('لیست خالی می باشد.'),
                              ),
                            ),
                          )
                        : SliverList(
                            delegate: SliverChildBuilderDelegate(
                              (context, index) {
                                drive.File file =
                                    controller.onlineBackupList.value[index];
                                return SettingRowWidget(
                                  onTap: () {
                                    StaticMethods.deleteDialog(
                                      content:
                                          'شما در حال بازیابی اطلاعات قبلی خود هستید. آیا اطمینان دارید؟\n'
                                          'این عمل برگشت پذیر نیست.',
                                      onConfirm: () async {
                                        Get.back();
                                        controller.downloadFile(
                                          file.id!,
                                          file.name!,
                                        );
                                      },
                                    );
                                  },
                                  icon: Iconsax.layer,
                                  title: file.name!,
                                  valueWidget:
                                      const Icon(Icons.restore_rounded),
                                );
                              },
                              childCount:
                                  controller.onlineBackupList.value.length,
                            ),
                          ),
                  ),
                ),
              ),
              const SliverToBoxAdapter(
                child: SizedBox(
                  height: 20,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
