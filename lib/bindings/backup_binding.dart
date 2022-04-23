import 'package:get/get.dart';
import 'package:hesab_ban/controllers/backup_controller.dart';

class BackupBinding implements Bindings{
  @override
  void dependencies() {
    Get.put<BackupController>(BackupController());
  }
}