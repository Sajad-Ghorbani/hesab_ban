import 'package:get/get.dart';
import 'package:hesab_ban/controllers/product_controller.dart';

class ProductBinding implements Bindings{
  @override
  void dependencies() {
    Get.put<ProductController>(ProductController());
  }
}