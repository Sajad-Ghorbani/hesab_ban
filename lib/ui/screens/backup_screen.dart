import 'dart:io';

import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import 'package:googleapis/drive/v3.dart' as drive;
import 'package:hesab_ban/controllers/backup_controller.dart';
import 'package:hesab_ban/static_methods.dart';
import 'package:hesab_ban/ui/widgets/base_widget.dart';
import 'package:hesab_ban/ui/widgets/loading.dart';
import 'package:hesab_ban/ui/widgets/setting_row_widget.dart';
import 'package:hesab_ban/ui/widgets/sliver_box_container_widget.dart';

class BackupScreen extends GetView<BackupController> {
  const BackupScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Obx(
      () => Loading(
        showLoading: controller.showLoading.value,
        child: BaseWidget(
          title: 'پشتیبان گیری و بازیابی اطلاعات',
          appBarLeading: IconButton(
            onPressed: () {
              Get.back();
            },
            icon: const Icon(Icons.arrow_back_ios),
            splashRadius: 30,
          ),
          child: CustomScrollView(
            slivers: [
              const SliverToBoxAdapter(
                child: SizedBox(
                  height: 10,
                ),
              ),
              SliverBoxContainerWidget(
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
                                            .restoreBackup(File(file.path));
                                      },
                                    );
                                  },
                                  icon: FontAwesomeIcons.database,
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
                                  icon: FontAwesomeIcons.database,
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
