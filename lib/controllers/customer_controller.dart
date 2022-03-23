import 'package:hesab_ban/constants.dart';
import 'package:hesab_ban/controllers/print_controller.dart';
import 'package:hesab_ban/models/bill_model.dart';
import 'package:hesab_ban/models/customer_model.dart';
import 'package:hesab_ban/models/factor_model.dart';
import 'package:hesab_ban/ui/theme/app_colors.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hesab_ban/ui/theme/constants_app_styles.dart';
import 'package:hesab_ban/ui/widgets/grid_menu_widget.dart';
import 'package:hive/hive.dart';
import 'package:persian_number_utility/persian_number_utility.dart';

import '../models/factor_row.dart';
import '../static_methods.dart';
import 'home_controller.dart';

class CustomerController extends GetxController {
  TextEditingController customerNameController = TextEditingController();
  TextEditingController customerPhoneController = TextEditingController();
  TextEditingController customerPhone2Controller = TextEditingController();
  TextEditingController customerAddressController = TextEditingController();
  TextEditingController customerBalanceController = TextEditingController();
  late ScrollController scrollController;

  late final Box customerBox;
  Bill? customerBill;
  Customer? customer = Get.arguments;
  RxBool showFab = true.obs;
  late final LazyBox billBox;

  @override
  void onInit() {
    super.onInit();
    customerBox = Hive.box<Customer>(customersBox);
    billBox = Hive.lazyBox<Bill>(billsBox);
    scrollController = ScrollController();
    getCustomerBill();
  }

  @override
  void onClose() {
    super.onClose();
    customerNameController.dispose();
    customerPhoneController.dispose();
    customerPhone2Controller.dispose();
    customerAddressController.dispose();
    customerBalanceController.dispose();
  }

  saveBill(Customer customer) async {
    Bill newBill = Bill(
      id: customer.id,
      customer: customer,
      factor: [],
      check: [],
      cash: [],
    );
    await billBox.put(customer.id, newBill);
  }

  updateBill(Customer customer) async {
    Bill? newBill = await billBox.get(customer.id);
    newBill!.customer = customer;
    await newBill.save();
  }

  void saveCustomer(BuildContext context) async {
    var customerBox = Hive.box<Customer>(customersBox);
    if (customerNameController.text.trim().isEmpty) {
      StaticMethods.showSnackBar(
          title: 'خطا', description: 'لطفا نام را وارد کنید.');
    } //
    else {
      Customer newCustomer = Customer(
        name: customerNameController.text.trim(),
        phoneNumber1: customerPhoneController.text.trim(),
        phoneNumber2: customerPhone2Controller.text.trim(),
        address: customerAddressController.text.trim(),
        initialAccountBalance: customerBalanceController.text.trim().isEmpty
            ? 0
            : StaticMethods.removeSeparatorFromNumber(
                customerBalanceController),
      );
      final int key = await customerBox.add(newCustomer);
      newCustomer.id = key;
      await newCustomer.save();
      await saveBill(newCustomer);
      StaticMethods.showSnackBar(
        title: 'تبریک',
        description: 'کاربر ${newCustomer.name} با موفقیت ثبت شد.',
        color: kLightGreenColor,
      );
      resetCustomerScreen(context);
    }

    update();
  }

  void updateCustomer(BuildContext context, Customer customer) async {
    if (customerNameController.text.isEmpty) {
      StaticMethods.showSnackBar(
          title: 'خطا', description: 'لطفا نام را وارد کنید.');
    } //
    else {
      customer.name = customerNameController.text;
      customer.phoneNumber1 = customerPhoneController.text.trim();
      customer.phoneNumber2 = customerPhone2Controller.text.trim();
      customer.address = customerAddressController.text.trim();
      customer.initialAccountBalance = customerBalanceController.text
              .trim()
              .isEmpty
          ? 0
          : StaticMethods.removeSeparatorFromNumber(customerBalanceController);
      await customer.save();
      await updateBill(customer);
      Get.back();
      StaticMethods.showSnackBar(
        title: 'تبریک',
        description: 'کاربر ${customer.name} با موفقیت ویرایش شد.',
        color: kLightGreenColor,
      );
      resetCustomerScreen(context);
    }

    update();
  }

  void resetCustomerScreen(BuildContext context) {
    FocusScope.of(context).unfocus();
    customerNameController.clear();
    customerPhoneController.clear();
    customerPhone2Controller.clear();
    customerAddressController.clear();
    customerBalanceController.clear();
  }

  getCustomerBill() async {
    if (customer != null) {
      var billBox = Hive.lazyBox<Bill>(billsBox);
      int key = billBox.keys.firstWhere((key) => key == customer!.id);
      customerBill = await billBox.get(key);
    }
    update();
  }

  void showFactor(
    Factor factor,
    String typeFactor,
  ) {
    Get.defaultDialog(
      title: typeFactor,
      content: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: Obx(
          () => Padding(
            padding: const EdgeInsets.symmetric(horizontal: 5),
            child: DataTable(
              columnSpacing: 20,
              columns: [
                const DataColumn(
                  label: Text('ردیف'),
                  numeric: true,
                ),
                const DataColumn(
                  label: Text('شرح کالا'),
                ),
                const DataColumn(
                  label: Text('تعداد'),
                ),
                DataColumn(
                  label: Row(
                    children: [
                      const Text('قیمت'),
                      const SizedBox(
                        width: 5,
                      ),
                      Text(
                        '(${Get.find<HomeController>().moneyUnit.value})',
                        style: kRialTextStyle,
                      ),
                    ],
                  ),
                ),
                DataColumn(
                  label: Row(
                    children: [
                      const Text('قیمت کل'),
                      const SizedBox(
                        width: 5,
                      ),
                      Text(
                        '(${Get.find<HomeController>().moneyUnit.value})',
                        style: kRialTextStyle,
                      ),
                    ],
                  ),
                ),
              ],
              rows: List.generate(
                factor.factorRows!.length,
                (index) {
                  FactorRow row = factor.factorRows![index];
                  return DataRow(
                    cells: [
                      DataCell(
                        Text('${index + 1}'),
                      ),
                      DataCell(
                        Text(row.productName),
                      ),
                      DataCell(
                        Text(
                            '${row.productCount.toString().seRagham()} ${row.productUnit}'),
                      ),
                      DataCell(
                        Text('${row.productPrice}'.seRagham()),
                      ),
                      DataCell(
                        Text('${row.productSum}'.seRagham()),
                      ),
                    ],
                  );
                },
              ),
            ),
          ),
        ),
      ),
      confirm: GridMenuWidget(
        title: 'اشتراک گذاری',
        onTap: () {
          shareFactor(factor);
        },
      ),
    );
  }

  void shareFactor(Factor factor) async {
    var box = Hive.lazyBox(settingBox);
    String storeName = await box.get('storeName',defaultValue: '');
    String storeAddress = await box.get('storeAddress',defaultValue: '');
    if (storeName == '' || storeAddress == '') {
      StaticMethods.showSnackBar(
        title: 'توجه',
        description:
            'برای ارسال فاکتور اطلاعات فروشگاه در تنظیمات برنامه را تکمیل کنید.',
      );
    } //
    else {
      await Get.find<PrintController>()
          .generate(factor, customerBill!.cashPayment!);
    }
  }
}
