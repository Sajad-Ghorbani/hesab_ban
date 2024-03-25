import 'package:get/get.dart';
import 'package:hesab_ban/app/features/feature_backup/presentation/controller/backup_controller.dart';

class BackupBinding implements Bindings{
  @override
  void dependencies() {
    Get.put<BackupController>(BackupController());
  }
}