import 'dart:io';

import 'package:awesome_notifications/awesome_notifications.dart';
import 'package:flutter_time_picker_spinner/flutter_time_picker_spinner.dart';
import 'package:hesab_ban/constants.dart';
import 'package:hesab_ban/models/bill_model.dart';
import 'package:hesab_ban/models/cash_model.dart';
import 'package:hesab_ban/models/category_model.dart';
import 'package:hesab_ban/models/check_model.dart';
import 'package:hesab_ban/models/customer_model.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hesab_ban/models/product_model.dart';
import 'package:hesab_ban/ui/screens/check_details.dart';
import 'package:hesab_ban/ui/screens/product_folder_screen.dart';
import 'package:hesab_ban/ui/widgets/confirm_button.dart';
import 'package:hesab_ban/ui/widgets/grid_menu_widget.dart';
import 'package:hive/hive.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';
import 'package:persistent_bottom_nav_bar/persistent-tab-view.dart';
import 'package:url_launcher/url_launcher.dart';

import '../static_methods.dart';
import '../ui/theme/app_colors.dart';

class HomeController extends GetxController {
  late TextEditingController categoryNameController;
  late TextEditingController cashPaymentController;
  late TextEditingController storeNameController;
  late TextEditingController storeAddressController;

  late PersistentTabController pageController;
  late ScrollController checkScreenScrollController;
  late ScrollController customerScreenScrollController;
  late ScrollController productScreenScrollController;

  var customerBox = Hive.box<Customer>(customersBox);
  var homeChecksBox = Hive.box<Check>(checksBox);
  var boxSetting = Hive.lazyBox(settingBox);
  var productBox = Hive.box<Product>(allProductBox);
  var categoryBox = Hive.box<Category>(productCategoryBox);

  RxBool showCheckFab = true.obs;
  RxBool showCustomersFab = true.obs;
  RxBool showProductsFab = true.obs;
  RxBool showCategoryProductsFab = true.obs;

  RxBool showBuyHelp = true.obs;
  RxBool showSellHelp = true.obs;
  RxBool showOneSellHelp = true.obs;
  RxBool showReturnOfSellHelp = true.obs;
  RxBool showReturnOfBuyHelp = true.obs;
  RxBool moneyUnitChange = true.obs;
  RxString moneyUnit = ''.obs;
  RxString storeName = ''.obs;
  RxString storeAddress = ''.obs;
  Rx<File> storeLogo = File('-1').obs;
  RxInt hoursNotification = 8.obs;
  RxInt minutesNotification = 0.obs;

  Customer? cashCustomer;
  String typeOfCash = '';

  bool exitApp = false;

  @override
  void onInit() {
    super.onInit();
    checkNotificationAllowed();
    checkNotificationListen();
    categoryNameController = TextEditingController();
    cashPaymentController = TextEditingController();
    storeNameController = TextEditingController();
    storeAddressController = TextEditingController();
    pageController = PersistentTabController();
    checkScreenScrollController = ScrollController();
    customerScreenScrollController = ScrollController();
    productScreenScrollController = ScrollController();
    getMoneyUnit();
    getUserInfo();
  }

  @override
  onClose() {
    super.onClose();
    AwesomeNotifications().actionSink.close();
    pageController.dispose();
    checkScreenScrollController.dispose();
    customerScreenScrollController.dispose();
    productScreenScrollController.dispose();
    categoryNameController.dispose();
    cashPaymentController.dispose();
    Hive.close();
  }

  checkNotificationAllowed() {
    AwesomeNotifications().isNotificationAllowed().then((isAllowed) {
      if (!isAllowed) {
        Get.defaultDialog(
          title: 'توجه',
          content: const Text(
            'حساب بان برای یادآوری چک ها میخواهد برای شما نوتیفیکیشن ارسال کند. آیا تایید میکنید؟',
            textAlign: TextAlign.center,
            style: TextStyle(height: 1.5),
          ),
          confirm: Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              GridMenuWidget(
                title: 'بله',
                onTap: () => AwesomeNotifications()
                    .requestPermissionToSendNotifications()
                    .then((value) => Get.back()),
                color: kDarkGreyColor,
                width: 100,
              ),
              GridMenuWidget(
                title: 'خیر',
                onTap: () {
                  Get.back();
                },
                color: kGreyColor,
                width: 100,
              ),
            ],
          ),
        );
      }
    });
  }

  checkNotificationListen() {
    AwesomeNotifications().actionStream.listen((notification) {
      Check check = homeChecksBox.values.firstWhere((element) {
        return element.id == int.parse('${notification.payload!['check_id']}');
      });
      Get.to(
        () => CheckDetails(check),
      );
    });
  }

  void changeMoneyUnit(bool value) {
    moneyUnitChange.value = value;
    moneyUnit.value = value ? 'ریال' : 'تومان';
    boxSetting.put('moneyUnitRial', value);
    boxSetting.put('moneyUnit', moneyUnit.value);
  }

  void getMoneyUnit() async {
    moneyUnitChange.value = await boxSetting.get('moneyUnitRial');
    moneyUnit.value = await boxSetting.get('moneyUnit');
  }

  void getUserInfo() async {
    storeName.value = await boxSetting.get('storeName');
    storeAddress.value = await boxSetting.get('storeAddress');
    storeLogo.value = File(await boxSetting.get('storeLogo'));
    hoursNotification.value = await boxSetting.get('notificationHours');
    minutesNotification.value = await boxSetting.get('notificationMinutes');
  }

  void setNotificationTime(context) async {
    Get.defaultDialog(
      title: 'زمان دریافت اعلان چک',
      content: Column(
        children: [
          Directionality(
            textDirection: TextDirection.ltr,
            child: TimePickerSpinner(
              normalTextStyle:
                  const TextStyle(fontSize: 20, color: kDarkGreyColor),
              highlightedTextStyle:
                  const TextStyle(fontSize: 20, color: kWhiteColor),
              isForce2Digits: true,
              time: DateTime(
                DateTime.now().year,
                DateTime.now().month,
                DateTime.now().day,
                hoursNotification.value,
                minutesNotification.value,
              ),
              spacing: 10,
              itemHeight: 40,
              alignment: Alignment.center,
              onTimeChange: (time) {
                hoursNotification.value = time.hour;
                minutesNotification.value = time.minute;
              },
            ),
          ),
        ],
      ),
      confirm: ConfirmButton(
        onTap: () {
          Get.back();
          changeScheduleOfNotifications(
              hoursNotification.value, minutesNotification.value);
        },
      ),
    );
  }

  Future<void> changeScheduleOfNotifications(int hour, int minute) async {
    await boxSetting.put('notificationHours', hoursNotification.value);
    await boxSetting.put('notificationMinutes', minutesNotification.value);
    List<NotificationModel> notificationList =
        await AwesomeNotifications().listScheduledNotifications();
    for (var notification in notificationList) {
      Map<String, dynamic> notificationSchedule =
          notification.schedule!.toMap();
      await AwesomeNotifications().createNotification(
        content: notification.content!,
        schedule: NotificationCalendar(
          allowWhileIdle: true,
          timeZone: notificationSchedule['timeZone'],
          year: notificationSchedule['year'],
          month: notificationSchedule['month'],
          day: notificationSchedule['day'],
          hour: hour,
          minute: minute,
        ),
      );
    }
  }

  void setUserInfo({bool? isName, bool? isAddress, bool? isLogo}) {
    if (isName == true) {
      setStoreName();
    } //
    else if (isAddress == true) {
      setStoreAddress();
    } //
    else {
      setStoreLogo();
    }
  }

  setStoreName() async {
    storeNameController.text = storeName.value;
    Get.defaultDialog(
      title: 'نام فروشگاه',
      content: TextField(
        controller: storeNameController,
        autofocus: true,
      ),
      confirm: ConfirmButton(
        onTap: () async {
          storeName.value = storeNameController.text.trim();
          await boxSetting.put('storeName', storeName.value);
          Get.back();
          storeNameController.clear();
        },
      ),
    );
  }

  setStoreAddress() async {
    storeAddressController.text = storeAddress.value;
    Get.defaultDialog(
      title: 'آدرس فروشگاه',
      content: TextField(
        controller: storeAddressController,
        autofocus: true,
      ),
      confirm: ConfirmButton(
        onTap: () async {
          storeAddress.value = storeAddressController.text.trim();
          await boxSetting.put('storeAddress', storeAddress.value);
          Get.back();
          storeAddressController.clear();
        },
      ),
    );
  }

  setStoreLogo() async {
    XFile pickedFile = (await ImagePicker().pickImage(
      source: ImageSource.gallery,
    )) as XFile;
    storeLogo.value = File(pickedFile.path);
    File? croppedFile = await ImageCropper().cropImage(
        sourcePath: storeLogo.value.path,
        aspectRatioPresets: Platform.isAndroid
            ? [
                CropAspectRatioPreset.square,
                CropAspectRatioPreset.ratio3x2,
                CropAspectRatioPreset.original,
                CropAspectRatioPreset.ratio4x3,
                CropAspectRatioPreset.ratio16x9
              ]
            : [
                CropAspectRatioPreset.original,
                CropAspectRatioPreset.square,
                CropAspectRatioPreset.ratio3x2,
                CropAspectRatioPreset.ratio4x3,
                CropAspectRatioPreset.ratio5x3,
                CropAspectRatioPreset.ratio5x4,
                CropAspectRatioPreset.ratio7x5,
                CropAspectRatioPreset.ratio16x9
              ],
        androidUiSettings: const AndroidUiSettings(
            toolbarColor: kBlueColor,
            toolbarWidgetColor: Colors.white,
            initAspectRatio: CropAspectRatioPreset.original,
            lockAspectRatio: false),
        iosUiSettings: const IOSUiSettings(
          aspectRatioLockEnabled: false,
        ));
    if (croppedFile != null) {
      storeLogo.value = croppedFile;
      await boxSetting.put('storeLogo', storeLogo.value.path);
    }
  }

  void openWhatsApp() async {
    var whatsapp = "+989351679934";
    var whatsappUrlAndroid = "whatsapp://send?phone=" +
        whatsapp +
        "&text=سلام. من برای برنامه حساب بان نظری داشتم.";
    var whatsappUrlIOS =
        "https://wa.me/$whatsapp?text=${Uri.parse("سلام. من برای برنامه حساب بان نظری داشتم.")}";
    if (Platform.isIOS) {
      if (await canLaunch(whatsappUrlIOS)) {
        await launch(whatsappUrlIOS, forceSafariVC: false);
      } else {
        StaticMethods.showSnackBar(
          title: 'خطا',
          description: 'برنامه واتساپ بر روی گوشی شما نصب نمی باشد.',
        );
      }
    } else {
      if (await canLaunch(whatsappUrlAndroid)) {
        await launch(whatsappUrlAndroid);
      } else {
        StaticMethods.showSnackBar(
          title: 'خطا',
          description: 'برنامه واتساپ بر روی گوشی شما نصب نمی باشد.',
        );
      }
    }
  }

  void navigateToCategory(
    context,
    String categoryName,
    bool selectProduct,
    bool fromSearch,
  ) async {
    pushNewScreen(
      context,
      screen: ProductFolderScreen(
        categoryName: categoryName,
        selectProduct: selectProduct,
        fromSearch: fromSearch,
      ),
    );
  }

  void addNewCategory() async {
    String categoryName = categoryNameController.text.trim();
    if (categoryName.isEmpty) {
      Future.delayed(
        const Duration(milliseconds: 300),
        () {
          StaticMethods.showSnackBar(
              title: 'خطا', description: 'لطفا نام را وارد کنید.');
        },
      );
    } //
    else {
      if (categoryBox.isEmpty) {
        await categoryBox.add(Category(id: 0, name: categoryName));
      } //
      else {
        Category newCategory = Category(name: categoryName);
        int index = await categoryBox.add(newCategory);
        newCategory.id = index;
        newCategory.save();
      }
      Get.back();
      StaticMethods.showSnackBar(
        title: 'تبریک!',
        description: 'دسته جدید با موفقیت ثبت شد.',
        color: kLightGreenColor,
      );
      categoryNameController.clear();
    }
  }

  void updateCategory(Category category) async {
    String categoryName = categoryNameController.text.trim();
    if (categoryName.isEmpty) {
      Future.delayed(
        const Duration(milliseconds: 300),
        () {
          StaticMethods.showSnackBar(
              title: 'خطا', description: 'لطفا نام را وارد کنید.');
        },
      );
    } //
    else {
      category.name = categoryName;
      category.save();
      categoryNameController.clear();
      StaticMethods.showSnackBar(
        title: 'تبریک!',
        description: 'دسته $categoryName با موفقیت ویرایش شد.',
        color: kLightGreenColor,
      );
    }
  }

  void deleteCategory(Category category) async {
    for (var item in productBox.values) {
      if (item.category!.name == category.name) {
        await item.delete();
      }
    }
    await category.delete();
  }

  void inputCash() async {
    await StaticMethods.selectDetails(
      title: 'پرداخت وجه نقد از طرف',
      onMeTap: () {
        typeOfCash = 'me';
        Get.back();
      },
      onCustomerTap: () {
        typeOfCash = 'customer';
        Get.back();
      },
    );
    await StaticMethods.selectCustomer(
      title: 'مشتری را انتخاب کنید',
      dropDownList: setCustomerList(),
      onSelectCustomer: (int? value) {
        for (var item in customerBox.values) {
          if (item.id == value) {
            cashCustomer = item;
          }
        }
        Get.back();
      },
    );
    Future.delayed(
      const Duration(milliseconds: 200),
      () async {
        await StaticMethods.showCashPaymentDialog(
          cashPaymentController,
          () {
            saveCashToCustomerBill();
            Get.back();
            cashPaymentController.clear();
          },
        );
      },
    );
  }

  List<DropdownMenuItem<int>> setCustomerList() {
    List<DropdownMenuItem<int>> list = [];
    for (var item in customerBox.values) {
      list.add(
        DropdownMenuItem(
          child: Text(item.name!),
          value: item.id,
        ),
      );
    }
    return list;
  }

  void saveCashToCustomerBill() async {
    if (cashPaymentController.text.trim().isNotEmpty) {
      int cashAmount =
          StaticMethods.removeSeparatorFromNumber(cashPaymentController);
      var billBox = Hive.lazyBox<Bill>(billsBox);
      Cash cash = Cash(
        cashAmount: typeOfCash == 'me' ? -cashAmount : cashAmount,
        cashDate: DateTime.now(),
      );
      int key = billBox.keys.firstWhere((key) => key == cashCustomer!.id);
      Bill? newBill = await billBox.get(key);
      newBill!.cash!.add(cash);
      await newBill.save();
      StaticMethods.showSnackBar(
        title: 'تبریک',
        description: 'پرداخت وجه نقد با موفقیت ثبت شد.',
        color: kLightGreenColor,
      );
    }
  }

  bool willPop() {
    if (!exitApp) {
      Get.snackbar('خروج', 'برای خروج یکبار دیگر دکمه بازگشت را بزنید.',
          snackPosition: SnackPosition.BOTTOM,
          margin: const EdgeInsets.all(10));
      exitApp = true;
      Future.delayed(
        const Duration(seconds: 3),
        () {
          exitApp = false;
        },
      );
      return false;
    } //
    else {
      return true;
    }
  }
}
