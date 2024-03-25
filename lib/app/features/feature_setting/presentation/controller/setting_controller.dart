import 'dart:async';
import 'dart:developer';
import 'dart:io';
import 'dart:ui' as ui;

import 'package:appcheck/appcheck.dart';
import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/services.dart';
import 'package:flutter_flavor/flutter_flavor.dart';
import 'package:flutter_time_picker_spinner/flutter_time_picker_spinner.dart';
import 'package:get/get.dart';
import 'package:hesab_ban/app/config/routes/app_pages.dart';
import 'package:hesab_ban/app/config/theme/app_colors.dart';
import 'package:hesab_ban/app/config/theme/app_theme.dart';
import 'package:hesab_ban/app/core/params/setting_params.dart';
import 'package:hesab_ban/app/core/params/user_params.dart';
import 'package:hesab_ban/app/core/resources/data_state.dart';
import 'package:hesab_ban/app/core/utils/extensions.dart';
import 'package:hesab_ban/app/core/utils/static_methods.dart';
import 'package:hesab_ban/app/core/widgets/confirm_button.dart';
import 'package:hesab_ban/app/core/widgets/grid_menu_widget.dart';
import 'package:hesab_ban/app/features/feature_check/domain/entities/check_entity.dart';
import 'package:hesab_ban/app/features/feature_check/presentation/controller/check_controller.dart';
import 'package:hesab_ban/app/features/feature_setting/domain/entities/user_entity.dart';
import 'package:hesab_ban/app/features/feature_setting/domain/use_cases/setting/delete_from_setting_use_case.dart';
import 'package:hesab_ban/app/features/feature_setting/domain/use_cases/setting/get_setting_use_case.dart';
import 'package:hesab_ban/app/features/feature_setting/domain/use_cases/setting/update_setting_use_case.dart';
import 'package:hesab_ban/app/features/feature_setting/domain/use_cases/user/delete_user_logo_use_case.dart';
import 'package:hesab_ban/app/features/feature_setting/domain/use_cases/user/get_user_by_id_use_case.dart';
import 'package:hesab_ban/app/features/feature_setting/domain/use_cases/user/save_user_use_case.dart';
import 'package:hesab_ban/app/features/feature_setting/domain/use_cases/user/update_user_use_case.dart';
import 'package:hesab_ban/app/features/feature_setting/presentation/controller/notification_service.dart';
import 'package:hesab_ban/app/features/feature_setting/presentation/screens/signature/drawn_line.dart';
import 'package:html/parser.dart';
import 'package:image/image.dart' as img;
import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:persian_number_utility/persian_number_utility.dart';
import 'package:url_launcher/url_launcher_string.dart';

class SettingController extends GetxController {
  final SaveUserUseCase _saveUserUseCase;
  final UpdateUserUseCase _updateUserUseCase;
  final GetUserByIdUseCase _getUserByIdUseCase;
  final DeleteUserLogoUseCase _deleteUserLogoUseCase;
  final UpdateSettingUseCase _updateSettingUseCase;
  final GetSettingUseCase _getSettingUseCase;
  final DeleteFromSettingUseCase _deleteFromSettingUseCase;

  SettingController(
    this._saveUserUseCase,
    this._updateUserUseCase,
    this._getUserByIdUseCase,
    this._updateSettingUseCase,
    this._getSettingUseCase,
    this._deleteFromSettingUseCase,
    this._deleteUserLogoUseCase,
  );

  late TextEditingController storeNameController;
  late TextEditingController storeAddressController;
  late TextEditingController costsLabelController;
  late TextEditingController factorDescriptionController;
  late TextEditingController barcodeUrlController;

  String? costsLabel;
  String? factorDescription;
  bool moneyUnitChange = true;
  String moneyUnit = '';
  String storeName = '';
  String storeAddress = '';
  File storeLogo = File('-1');
  File stampLogo = File('-1');
  File signLogo = File('-1');
  int hoursNotification = 8;
  int minutesNotification = 0;
  bool isLightTheme = false;
  bool productCountCheck = true;
  bool showCustomerBalance = true;
  bool showPaymentOrReceipt = true;
  bool showFactorTax = true;
  bool showFactorCosts = true;
  bool showFactorOffer = true;
  bool showPasswordScreen = false;
  bool checkAppUpdate = true;
  String hashPassword = '-1';
  UserEntity user = UserEntity();
  String appVersion = '-1';
  String barcodeUrl = '-1';

  final GlobalKey globalKey = GlobalKey();
  List<DrawnLine> lines = <DrawnLine>[];
  DrawnLine? line;
  double selectedWidth = 6.0;

  StreamController<List<DrawnLine>> linesStreamController =
      StreamController<List<DrawnLine>>.broadcast();
  StreamController<DrawnLine> currentLineStreamController =
      StreamController<DrawnLine>.broadcast();

  permission() async {
    var checkResult = await Permission.manageExternalStorage.status;
    var checkExternalStorage = await Permission.storage.status;
    if (!checkResult.isGranted && !checkExternalStorage.isGranted) {
      await Permission.storage.request();
      await Permission.manageExternalStorage.request();
    }
  }

  @override
  void onInit() {
    super.onInit();
    storeNameController = TextEditingController();
    storeAddressController = TextEditingController();
    costsLabelController = TextEditingController();
    factorDescriptionController = TextEditingController();
    barcodeUrlController = TextEditingController();
    Future.delayed(const Duration(seconds: 2), () async {
      getSettings();
      getUserInfo();
      // getAppVersion();
    });
  }

  @override
  void onClose() {
    super.onClose();
    storeNameController.dispose();
    storeAddressController.dispose();
    costsLabelController.dispose();
    factorDescriptionController.dispose();
    barcodeUrlController.dispose();
    linesStreamController.close();
    currentLineStreamController.close();
  }

  void changeMoneyUnit(bool value) async {
    moneyUnitChange = value;
    moneyUnit = value ? 'تومان' : 'ریال';
    var response = await _updateSettingUseCase(SettingParams(
      isMoneyUnitRial: value,
      moneyUnit: moneyUnit,
    ));
    if (response.data == null) {
      StaticMethods.showSnackBar(
        title: 'خطا!',
        description: response.error!,
      );
    }
    update();
  }

  void changeTheme(bool value) async {
    isLightTheme = value;
    Get.changeTheme(
      Get.isDarkMode ? AppThemeData.lightTheme : AppThemeData.darkTheme,
    );
    await _updateSettingUseCase(SettingParams(
      isThemeLight: value,
    ));
    update();
  }

  void getSettings() async {
    var response = _getSettingUseCase();
    if (response.data == null) {
      StaticMethods.showSnackBar(
        title: 'خطا!',
        description: response.error!,
      );
    } //
    else {
      moneyUnitChange = response.data!.isMoneyUnitRial!;
      moneyUnit = response.data!.moneyUnit!;
      isLightTheme = response.data!.isThemeLight!;
      hoursNotification = response.data!.notificationHours!;
      minutesNotification = response.data!.notificationMinutes!;
      productCountCheck = response.data!.productCountCheck ?? true;
      costsLabel = response.data!.costsLabel;
      barcodeUrl = response.data!.barcodeUrl ?? '-1';
      stampLogo = File(response.data!.stampLogo ?? '-1');
      signLogo = File(response.data!.signLogo ?? '-1');
      if (!await stampLogo.exists()) {
        stampLogo = File('-1');
      }
      if (!await signLogo.exists()) {
        signLogo = File('-1');
      }
      showCustomerBalance = response.data!.showCustomerBalance ?? true;
      showPaymentOrReceipt = response.data!.showPaymentOrReceipt ?? true;
      showFactorTax = response.data!.showFactorTax ?? true;
      showFactorCosts = response.data!.showFactorCosts ?? true;
      showFactorOffer = response.data!.showFactorOffer ?? true;
      showPasswordScreen = response.data!.showPasswordScreen ?? false;
      factorDescription = response.data!.factorDescription;
      update();
    }
  }

  void getUserInfo() async {
    var response = await _getUserByIdUseCase(0);
    if (response.data == null) {
      log('${response.error}');
    } //
    else {
      user = response.data!;
      storeName = user.storeName ?? '';
      storeAddress = user.storeAddress ?? '';
      hashPassword = user.hashedPassword ?? '-1';
      storeLogo = File(user.storeLogo ?? '-1');
      if (!await storeLogo.exists()) {
        storeLogo = File('-1');
      }
    }
    update();
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
              minutesInterval: 5,
              time: DateTime(
                DateTime.now().year,
                DateTime.now().month,
                DateTime.now().day,
                hoursNotification,
                minutesNotification,
              ),
              spacing: 10,
              itemHeight: 40,
              alignment: Alignment.center,
              onTimeChange: (time) {
                hoursNotification = time.hour;
                minutesNotification = time.minute;
                update();
              },
            ),
          ),
        ],
      ),
      confirm: ConfirmButton(
        onTap: () {
          Get.back();
          changeScheduleOfNotifications(hoursNotification, minutesNotification);
        },
      ),
    );
  }

  Future<bool> checkNotificationAllowed() async {
    bool isAllowed = await NotificationService().notificationStatus();
    if (!isAllowed) {
      await Get.defaultDialog(
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
              onTap: () async {
                NotificationService().requestPermission().then((value) {
                  isAllowed = value ?? false;
                  Get.back();
                  return isAllowed;
                });
              },
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
      return false;
    }
    return true;
  }

  Future<void> changeScheduleOfNotifications(int hour, int minute) async {
    if (await checkNotificationAllowed()) {
      var response = await _updateSettingUseCase(SettingParams(
        notificationHours: hour,
        notificationMinutes: minute,
      ));
      if (response.data == null) {
        StaticMethods.showSnackBar(
          title: 'خطا!',
          description: response.error!,
        );
      } //
      else {
        await NotificationService().cancelAllNotifications();
        List<CheckEntity> checks = Get.find<CheckController>()
            .getAllChecks()!
            .where(
                (element) => element.checkDeliveryDate!.isAfter(DateTime.now()))
            .toList();
        for (var check in checks) {
          await NotificationService().scheduleNotification(
            id: check.id!,
            title: '💵 سر رسید چک',
            body:
                'شما یک چک ${check.typeOfCheck!.name == 'send' ? 'به' : 'از'} '
                '${check.customerCheck!.name}'
                ' از ${check.checkBank!.name}'
                ' به مبلغ ${check.checkAmount!.abs().formatPrice()} '
                '${Get.find<SettingController>().moneyUnit} دارید.',
            payload: '${check.id}',
            dateTime: DateTime(
              check.checkDeliveryDate!.year,
              check.checkDeliveryDate!.month,
              check.checkDeliveryDate!.day,
              hour,
              minute,
            ),
          );
        }
      }
    }
  }

  void setUserInfo({bool? isName, bool? isAddress, bool? isLogo}) async {
    if (isName == true) {
      await setStoreName();
    } //
    else if (isAddress == true) {
      await setStoreAddress();
    } //
    else {
      storeLogo = await takingPicture() ?? File('-1');
    }
    if (user.id == null) {
      var response = await _saveUserUseCase(UserParams(
        storeName: storeName,
        storeAddress: storeAddress,
        storeLogo: storeLogo.path,
      ));
      if (response.data == null) {
        StaticMethods.showSnackBar(
          title: 'خطا!',
          description: response.error!,
        );
      } //
      else {
        user = response.data!;
      }
    } //
    else {
      var response = await _updateUserUseCase(UserParams(
        id: user.id,
        storeName: storeName,
        storeAddress: storeAddress,
        storeLogo: storeLogo.path,
      ));
      if (response.data == null) {
        StaticMethods.showSnackBar(
          title: 'خطا!',
          description: response.error!,
        );
      } //
      else {
        user = response.data!;
      }
    }
    update();
  }

  setStoreName() async {
    storeNameController.text = storeName;
    await Get.defaultDialog(
      title: 'نام فروشگاه',
      content: TextField(
        controller: storeNameController,
        textDirection: TextDirection.rtl,
        autofocus: true,
        onTap: () {
          StaticMethods.textFieldOnTap(storeNameController);
        },
      ),
      confirm: ConfirmButton(
        onTap: () async {
          storeName = storeNameController.text.trim();
          Get.back();
          storeNameController.clear();
          update();
        },
      ),
    );
  }

  setStoreAddress() async {
    storeAddressController.text = storeAddress;
    await Get.defaultDialog(
      title: 'آدرس فروشگاه',
      content: TextField(
        controller: storeAddressController,
        textDirection: TextDirection.rtl,
        autofocus: true,
        onTap: () {
          StaticMethods.textFieldOnTap(storeAddressController);
        },
      ),
      confirm: ConfirmButton(
        onTap: () async {
          storeAddress = storeAddressController.text.trim();
          Get.back();
          storeAddressController.clear();
          update();
        },
      ),
    );
  }

  Future<File?> takingPicture() async {
    XFile pickedFile = (await ImagePicker().pickImage(
      source: ImageSource.gallery,
    )) as XFile;
    File file = File(pickedFile.path);
    CroppedFile? croppedFile = await ImageCropper().cropImage(
      sourcePath: file.path,
      compressFormat: ImageCompressFormat.png,
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
      uiSettings: [
        AndroidUiSettings(
            toolbarColor: kBlueColor,
            toolbarWidgetColor: Colors.white,
            backgroundColor: Colors.white,
            initAspectRatio: CropAspectRatioPreset.original,
            lockAspectRatio: false),
        IOSUiSettings(
          aspectRatioLockEnabled: false,
        ),
      ],
    );
    if (croppedFile != null) {
      file = File(croppedFile.path);
      update();
      return file;
    }
    return null;
  }

  void openWhatsApp() async {
    var whatsapp = "+989351679934";
    var whatsappUrlAndroid =
        "whatsapp://send?phone=$whatsapp&text=سلام. من برای برنامه حساب بان نظری داشتم.";
    var whatsappUrlIOS =
        "https://wa.me/$whatsapp?text=${Uri.parse("سلام. من برای برنامه حساب بان نظری داشتم.")}";
    if (Platform.isIOS) {
      if (await canLaunchUrlString(whatsappUrlIOS)) {
        await launchUrlString(whatsappUrlIOS);
      } else {
        StaticMethods.showSnackBar(
          title: 'خطا',
          description: 'برنامه واتساپ بر روی گوشی شما نصب نمی باشد.',
        );
      }
    } else {
      if (await canLaunchUrlString(whatsappUrlAndroid)) {
        await launchUrlString(whatsappUrlAndroid);
      } else {
        StaticMethods.showSnackBar(
          title: 'خطا',
          description: 'برنامه واتساپ بر روی گوشی شما نصب نمی باشد.',
        );
      }
    }
  }

  void openTelegram() async {
    var telegramUrlAndroid = "https://t.me/sajad_ghorbaniii";
    const package = "org.telegram.messenger";
    bool appExist = false;
    try {
      appExist = await AppCheck.isAppEnabled(package);
    } on Exception catch (_) {
      appExist = false;
    }
    if (appExist) {
      await launchUrlString(telegramUrlAndroid);
    } else {
      StaticMethods.showSnackBar(
        title: 'خطا',
        description: 'برنامه تلگرام بر روی گوشی شما نصب نمی باشد.',
      );
    }
  }

  void openBale() async {
    var baleUrlAndroid = "https://ble.ir/sajad2012gh";
    const package = "ir.nasim";
    bool appExist = false;
    try {
      appExist = await AppCheck.isAppEnabled(package);
    } on Exception catch (_) {
      appExist = false;
    }
    if (appExist) {
      await launchUrlString(baleUrlAndroid);
    } else {
      StaticMethods.showSnackBar(
        title: 'خطا',
        description: 'برنامه بله بر روی گوشی شما نصب نمی باشد.',
      );
    }
  }

  void changeFactorSetting(String settingName, bool value) async {
    // set the corresponding field to the value
    switch (settingName) {
      case 'productCountCheck':
        productCountCheck = value;
        break;
      case 'showCustomerBalance':
        showCustomerBalance = value;
        break;
      case 'showPaymentOrReceipt':
        showPaymentOrReceipt = value;
        break;
      case 'showFactorTax':
        showFactorTax = value;
        break;
      case 'showFactorCosts':
        showFactorCosts = value;
        break;
      case 'showFactorOffer':
        showFactorOffer = value;
        break;
      default:
        return; // invalid setting name
    }
    // call the use case with the updated params
    var response = await _updateSettingUseCase(
      SettingParams(
        productCountCheck: productCountCheck,
        showCustomerBalance: showCustomerBalance,
        showPaymentOrReceipt: showPaymentOrReceipt,
        showFactorTax: showFactorTax,
        showFactorCosts: showFactorCosts,
        showFactorOffer: showFactorOffer,
      ),
    );
    // handle the response
    if (response.data == null) {
      StaticMethods.showSnackBar(
        title: 'خطا!',
        description: response.error!,
      );
    }
    update();
  }

  void changeCostsLabel() async {
    costsLabelController.text = costsLabel ?? '';
    await Get.defaultDialog(
      title: 'نام هزینه ها',
      content: TextField(
        controller: costsLabelController,
        textDirection: TextDirection.rtl,
        autofocus: true,
        onTap: () {
          StaticMethods.textFieldOnTap(costsLabelController);
        },
      ),
      confirm: ConfirmButton(
        onTap: () async {
          costsLabel = costsLabelController.text.trim();
          Get.back();
          costsLabelController.clear();
          if (costsLabel!.isEmpty) {
            var response = await _deleteFromSettingUseCase('costLabel');
            if (response.data == null) {
              StaticMethods.showSnackBar(
                title: 'خطا!',
                description: response.error!,
              );
            }
          } //
          else {
            var response = await _updateSettingUseCase(SettingParams(
              costsLabel: costsLabel,
            ));
            if (response.data == null) {
              StaticMethods.showSnackBar(
                title: 'خطا!',
                description: response.error!,
              );
            }
          }
          update();
        },
      ),
    );
  }

  void changeFactorDescription(BuildContext context) async {
    factorDescriptionController.text = factorDescription ?? '';
    await Get.defaultDialog(
      title: 'توضیحات فاکتور',
      content: TextField(
        controller: factorDescriptionController,
        textDirection: TextDirection.rtl,
        autofocus: true,
        minLines: 2,
        maxLines: 3,
        onTap: () {
          StaticMethods.textFieldOnTap(factorDescriptionController);
        },
      ),
      confirm: ConfirmButton(
        onTap: () async {
          factorDescription = factorDescriptionController.text.trim();
          Get.back();
          factorDescriptionController.clear();
          if (factorDescription!.isEmpty) {
            var response = await _deleteFromSettingUseCase('factorDescription');
            if (response.data == null) {
              StaticMethods.showSnackBar(
                title: 'خطا!',
                description: response.error!,
              );
            }
          } //
          else {
            var response = await _updateSettingUseCase(SettingParams(
              factorDescription: factorDescription,
            ));
            if (response.data == null) {
              StaticMethods.showSnackBar(
                title: 'خطا!',
                description: response.error!,
              );
            }
          }
          update();
        },
      ),
    );
  }

  void setStampPicture() async {
    stampLogo = await takingPicture() ?? File('-1');
    update();
    var response = await _updateSettingUseCase(SettingParams(
      stampLogo: stampLogo.path,
    ));
    if (response.data == null) {
      StaticMethods.showSnackBar(
        title: 'خطا!',
        description: response.error!,
      );
    }
    update();
  }

  void deleteStoreLogo() async {
    storeLogo = File('-1');
    update();
    var response = await _deleteUserLogoUseCase(user.id!);
    if (response.data == null) {
      StaticMethods.showSnackBar(
        title: 'خطا!',
        description: response.error!,
      );
    }
    update();
  }

  void deleteStampLogo([bool isStamp = true]) async {
    DataState<String> response;
    if (isStamp) {
      stampLogo = File('-1');
      update();
      response = await _deleteFromSettingUseCase('stampLogo');
    } //
    else {
      signLogo = File('-1');
      update();
      response = await _deleteFromSettingUseCase('signLogo');
    }
    if (response.data == null) {
      StaticMethods.showSnackBar(
        title: 'خطا!',
        description: response.error!,
      );
    }
    update();
  }

  Future<void> saveSignature(BuildContext context) async {
    Size size = MediaQuery.sizeOf(context);
    try {
      if (lines.isNotEmpty) {
        final boundary = globalKey.currentContext!.findRenderObject()
            as RenderRepaintBoundary;
        final image = await boundary.toImage();
        final byteData = await image.toByteData(format: ui.ImageByteFormat.png);
        final pngBytes = byteData!.buffer.asUint8List();
        final newDirectory = await getTemporaryDirectory();
        final dateFormatted = DateTime.now()
            .toPersianDate(
              digitType: NumStrLanguage.English,
              showTime: true,
              showTimeSecond: true,
            )
            .replaceAll('/', '')
            .replaceAll(':', '')
            .removeAllWhitespace;
        File imgFile = File('${newDirectory.path}/$dateFormatted.png');
        imgFile.writeAsBytes(pngBytes).then((value) async {
          await (img.Command()
                ..decodePngFile(imgFile.path)
                ..copyCrop(
                  x: 0,
                  y: (size.height ~/ 4) + 10,
                  width: size.width.toInt(),
                  height: size.width.toInt(),
                )
                ..writeToFile(
                    '${newDirectory.path}/signature$dateFormatted.png'))
              .execute()
              .then((value) async {
            signLogo = File('${newDirectory.path}/signature$dateFormatted.png');
            update();
            await imgFile.delete();
            var response = await _updateSettingUseCase(SettingParams(
              signLogo: signLogo.path,
            ));
            if (response.data == null) {
              StaticMethods.showSnackBar(
                title: 'خطا!',
                description: response.error!,
              );
            }
            update();
            Get.back();
            clearSignBox();
          });
        }).catchError((onError) {
          if (kDebugMode) {
            print(onError);
          }
        });
      }
    } catch (e) {
      if (kDebugMode) {
        print(e);
      }
    }
  }

  Future<void> clearSignBox() async {
    lines = [];
    line = null;
    update();
  }

  void onPanStart(DragStartDetails details, BuildContext context) {
    final box = context.findRenderObject() as RenderBox;
    final point = box.globalToLocal(details.globalPosition);
    line = DrawnLine([point], Colors.black, selectedWidth);
    currentLineStreamController.add(line!);
    update();
  }

  void onPanUpdate(DragUpdateDetails details, BuildContext context) {
    final box = context.findRenderObject() as RenderBox;
    final point = box.globalToLocal(details.globalPosition);
    final path = List.from(line!.path)..add(point);
    line = DrawnLine(path, Colors.black, selectedWidth);

    if (lines.isEmpty) {
      lines.add(line!);
    } else {
      lines[lines.length - 1] = line!;
    }
    currentLineStreamController.add(line!);
    update();
  }

  void onPanEnd(DragEndDetails details) {
    lines = List.from(lines)..add(line!);
    linesStreamController.add(lines);
  }

  getAppVersion() async {
    PackageInfo packageInfo = await PackageInfo.fromPlatform();
    appVersion = packageInfo.version;
    update();
    if (checkAppUpdate) {
      Dio dio = Dio();
      try {
        final response = await dio.get(
          'https://api.pishkhan.cafebazaar.ir/v1/apps/releases/last-published',
          options: Options(
            contentType: 'application/json',
            headers: {
              'CAFEBAZAAR-PISHKHAN-API-SECRET':
                  'eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJpc3MiOiJuYXNoZXItcGlzaGtoYW4tYXBpIiwiaWF0IjoxNjkwMzI4NDY4LCJleHAiOjQ4NDM5Mjg0NjgsImFwaV9hZ2VudF9pZCI6MjA0NH0.kDvfcHW9rhMwpzUfyBj8OWgWwTE_S0o68Kuk6pMcBok',
            },
            responseType: ResponseType.json,
          ),
        );
        int? bazaarAppVersion =
            response.data['release']['packages'][0]['version_code'];
        String? changeLogFa = response.data['release']['changelog_fa'];
        var document = parse(changeLogFa ?? '');
        final String? parsedString =
            parse(document.body?.text).documentElement?.text;
        List<String> changeLogs = [];
        if (parsedString != null) {
          for (var item in parsedString.split('-')) {
            if (item.isNotEmpty) {
              changeLogs.add(item.trim());
            }
          }
        }
        if (bazaarAppVersion != null &&
            bazaarAppVersion > int.parse(packageInfo.buildNumber)) {
          String marketName = FlavorConfig.instance.variables['name'];
          Future.delayed(
            const Duration(seconds: 1),
            () {
              StaticMethods.deleteDialog(
                barrierDismissible: false,
                contentWidget: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'نسخه جدید برنامه در $marketName'
                      ' منتشر شده و همین الان میتونی حساب بان رو بروزرسانی کنی.',
                      style: const TextStyle(
                        height: 1.5,
                      ),
                      textAlign: TextAlign.center,
                    ),
                    const Text(
                      '* قبل از بروزرسانی حتما از اطلاعات خود پشتیبانی بگیرید',
                      style: TextStyle(
                        color: kRedColor,
                        height: 1.5,
                      ),
                    ),
                    const Text(
                      'تغییرات اخیر:',
                      style: TextStyle(
                        height: 1.5,
                      ),
                    ),
                    if (changeLogs.isNotEmpty) ...[
                      ...changeLogs.map((e) => Text(' - $e'))
                    ],
                  ],
                ),
                onConfirm: () async {
                  Get.back();
                  String url = FlavorConfig.instance.variables['appLink'];
                  if (await canLaunchUrlString(url)) {
                    await launchUrlString(
                      url,
                      mode: LaunchMode.externalApplication,
                    );
                  }
                },
                cancelText: 'فعلا نه',
                onCancel: () {
                  checkAppUpdate = false;
                  update();
                },
                confirmText: 'بروزرسانی',
              );
            },
          );
        }
      } //
      on Exception catch (e) {
        log(e.toString());
      }
    }
  }

  void setBarcodeUrl() async {
    barcodeUrlController.text = barcodeUrl != '-1' ? barcodeUrl : '';
    await Get.defaultDialog(
      title: 'لینک اختصاصی بارکد',
      content: TextField(
        controller: barcodeUrlController,
        textDirection: TextDirection.rtl,
        autofocus: true,
        onTap: () {
          StaticMethods.textFieldOnTap(barcodeUrlController);
        },
      ),
      confirm: ConfirmButton(
        onTap: () async {
          barcodeUrl = barcodeUrlController.text.trim();
          Get.back();
          barcodeUrlController.clear();
          if (barcodeUrl.isEmpty) {
            await deleteBarcodeUrl();
          } //
          else {
            var response = await _updateSettingUseCase(SettingParams(
              barcodeUrl: barcodeUrl,
            ));
            if (response.data == null) {
              StaticMethods.showSnackBar(
                title: 'خطا!',
                description: response.error!,
              );
            }
          }
          update();
        },
      ),
    );
  }

  deleteBarcodeUrl() async {
    barcodeUrl = '-1';
    update();
    var response = await _deleteFromSettingUseCase('barcodeUrl');
    if (response.data == null) {
      StaticMethods.showSnackBar(
        title: 'خطا!',
        description: response.error!,
      );
    }
    update();
  }

  void openPayLink() async {
    String url = 'https://hesabban.ir.page';
    if (await canLaunchUrlString(url)) {
      await launchUrlString(
        url,
        mode: LaunchMode.externalApplication,
      );
    }
  }

  changeShowPassword(bool value) async {
    showPasswordScreen = value;
    update();
    var response = await _updateSettingUseCase(SettingParams(
      showPasswordScreen: value,
    ));
    if (response.data == null) {
      StaticMethods.showSnackBar(title: '', description: response.error!);
      showPasswordScreen = !value;
      update();
    } //
    else {
      if (value == true) {
        Get.toNamed(Routes.changePasswordScreen);
      }
    }
  }

  void showAcademy() async {
    var academyUrl = "https://www.aparat.com/playlist/8039984";
    if (await canLaunchUrlString(academyUrl)) {
      await launchUrlString(academyUrl, mode: LaunchMode.externalApplication);
      Get.back();
    } //
    else {
      StaticMethods.showSnackBar(
        title: 'خطا',
        duration: const Duration(seconds: 7),
        content: Column(
          children: [
            const Text(
              'گوشی شما دسترسی ندارد تا لینک آموزش ها را باز کند. لطفا روی لینک زیر'
              ' کلیک کنید تا کپی شود و سپس در مرورگر خود وارد کنید.',
              style: TextStyle(height: 1.5, color: Colors.white),
            ),
            const SizedBox(height: 10),
            ElevatedButton(
              onPressed: () {
                Clipboard.setData(
                  const ClipboardData(
                      text: 'https://www.aparat.com/playlist/8039984'),
                );
              },
              style:
                  ElevatedButton.styleFrom(backgroundColor: kLightGreenColor),
              child: const Text(
                'لینک آموزش',
                style: TextStyle(color: Colors.white),
              ),
            ),
          ],
        ),
      );
    }
  }
}
