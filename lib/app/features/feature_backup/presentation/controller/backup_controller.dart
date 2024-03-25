import 'dart:async';
import 'dart:convert';
import 'dart:developer';
import 'dart:io';

import 'package:archive/archive_io.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:googleapis/abusiveexperiencereport/v1.dart';
import 'package:hesab_ban/app/core/utils/static_methods.dart';
import 'package:hesab_ban/app/core/widgets/confirm_button.dart';
import 'package:hesab_ban/app/features/feature_backup/presentation/controller/google_auth_client.dart';
import 'package:hesab_ban/app/features/feature_bill/data/models/bill_model.dart';
import 'package:hesab_ban/app/features/feature_cash/data/models/cash_model.dart';
import 'package:hesab_ban/app/features/feature_check/data/models/check_model.dart';
import 'package:hesab_ban/app/features/feature_customer/data/models/customer_model.dart';
import 'package:hesab_ban/app/features/feature_factor/data/models/factor_model.dart';
import 'package:hesab_ban/app/features/feature_product/data/models/category_model.dart';
import 'package:hesab_ban/app/features/feature_product/data/models/product_model.dart';
import 'package:hesab_ban/app/features/feature_product/data/models/unit_of_product.dart';
import 'package:hesab_ban/app/features/feature_setting/data/models/setting_model.dart';
import 'package:hesab_ban/app/features/feature_setting/data/models/user_model.dart';
import 'package:hive/hive.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:googleapis/drive/v3.dart' as drive;
import 'package:google_sign_in/google_sign_in.dart' as sign_in;
import 'package:persian_number_utility/persian_number_utility.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:hesab_ban/app/core/utils/constants.dart';

class BackupController extends GetxController {
  late Box<Product> productBox;
  late Box<Customer> customerBox;
  late Box<Check> checkBox;
  late Box<Category> categoryBox;
  late Box<Factor> factorsBox;
  late Box<Bill> billBox;
  late Box<Setting> settingsBox;
  late Box<User> userBox;
  late Box<Cash> cashBox;

  RxBool showLoading = false.obs;
  RxString email = '-1'.obs;
  RxList<drive.File> onlineBackupList = <drive.File>[].obs;
  RxList<FileSystemEntity> storageBackupList = <FileSystemEntity>[].obs;

  late Directory _appDataDirectory;
  late Directory _appDirectory;

  @override
  void onInit() {
    super.onInit();
    productBox = Hive.box<Product>(Constants.allProductBox);
    customerBox = Hive.box<Customer>(Constants.customersBox);
    checkBox = Hive.box<Check>(Constants.checksBox);
    factorsBox = Hive.box<Factor>(Constants.factorBox);
    billBox = Hive.box<Bill>(Constants.billsBox);
    settingsBox = Hive.box<Setting>(Constants.settingBox);
    categoryBox = Hive.box<Category>(Constants.productCategoryBox);
    userBox = Hive.box<User>(Constants.userBox);
    cashBox = Hive.box<Cash>(Constants.cashBox);
    _getDirectory().then((value) async {
      await _setStorageBackupList();
      await checkBackupFilesCount();
    });
    _setUserEmail();
  }

  _setUserEmail() async {
    email.value = userBox.get(0)?.userEmail ?? '-1';
  }

  _setStorageBackupList() async {
    List<FileSystemEntity> list = [];
    List<FileSystemEntity> fileList = await _appDirectory.list().toList();
    fileList.sort(
      (a, b) => a.statSync().modified.compareTo(b.statSync().modified),
    );
    for (var file in fileList) {
      if (file.path.split('/').last.startsWith('backup')) {
        list.add(file);
      }
    }
    storageBackupList.value = list.reversed.toList();
  }

  Future<void> _getDirectory() async {
    var checkResult = await Permission.manageExternalStorage.status;
    var checkExternalStorage = await Permission.storage.status;
    if (!checkResult.isGranted && !checkExternalStorage.isGranted) {
      await Permission.storage.request();
      await Permission.manageExternalStorage.request();
    }
    final newDirectory = Directory('/storage/emulated/0/Hesab Ban');
    Directory rootDirectory = Directory('${newDirectory.path}/backup/.data/');
    if (await rootDirectory.exists() == false) {
      _appDataDirectory = await rootDirectory.create(recursive: true);
      _appDirectory = Directory('${newDirectory.path}/backup/');
      return;
    }
    _appDataDirectory = rootDirectory;
    _appDirectory = Directory('${newDirectory.path}/backup/');
    return;
  }

  Map<String, Map<String, dynamic>> createMapOfBox(Box box) {
    return box
        .toMap()
        .map((key, value) => MapEntry(key.toString(), value.toJson()));
  }

  Future<void> createBackup(bool createOnlineBackup) async {
    String formattedDate =
        '${DateTime.now().toString().toPersianDate(digitType: NumStrLanguage.English).replaceAll('/', '-')}'
        '-${DateTime.now().toString().split('.').first.split(' ').last.substring(0, 5).replaceAll(':', '-')}';
    showLoading.value = true;
    Map<String, Map<String, dynamic>> productMap = createMapOfBox(productBox);
    Map<String, Map<String, dynamic>> customerMap = createMapOfBox(customerBox);
    Map<String, Map<String, dynamic>> checkMap = createMapOfBox(checkBox);
    Map<String, Map<String, dynamic>> factorMap = createMapOfBox(factorsBox);
    Map<String, Map<String, dynamic>> billMap = createMapOfBox(billBox);
    Map<String, Map<String, dynamic>> categoryMap = createMapOfBox(categoryBox);
    Map<String, Map<String, dynamic>> cashMap = createMapOfBox(cashBox);
    Map<String, Map<String, dynamic>> settingMap = createMapOfBox(settingsBox);
    Map<String, Map<String, dynamic>> userMap = createMapOfBox(userBox);
    //
    List<int> productJson = jsonEncode(productMap).codeUnits;
    List<int> customerJson = jsonEncode(customerMap).codeUnits;
    List<int> checkJson = jsonEncode(checkMap).codeUnits;
    List<int> factorJson = jsonEncode(factorMap).codeUnits;
    List<int> billJson = jsonEncode(billMap).codeUnits;
    List<int> settingJson = jsonEncode(settingMap).codeUnits;
    List<int> categoryJson = jsonEncode(categoryMap).codeUnits;
    List<int> cashJson = jsonEncode(cashMap).codeUnits;
    List<int> userJson = jsonEncode(userMap).codeUnits;
    //
    String productPath = '${_appDataDirectory.path}product-$formattedDate.xhdb';
    String customerPath =
        '${_appDataDirectory.path}customer-$formattedDate.xhdb';
    String checkPath = '${_appDataDirectory.path}check-$formattedDate.xhdb';
    String factorPath = '${_appDataDirectory.path}factor-$formattedDate.xhdb';
    String billPath = '${_appDataDirectory.path}bill-$formattedDate.xhdb';
    String categoryPath =
        '${_appDataDirectory.path}category-$formattedDate.xhdb';
    String settingPath = '${_appDataDirectory.path}setting-$formattedDate.xhdb';
    String cashPath = '${_appDataDirectory.path}cash-$formattedDate.xhdb';
    String userPath = '${_appDataDirectory.path}user-$formattedDate.xhdb';
    //
    File productBackupFile = File(productPath);
    File customerBackupFile = File(customerPath);
    File checkBackupFile = File(checkPath);
    File factorBackupFile = File(factorPath);
    File billBackupFile = File(billPath);
    File categoryBackupFile = File(categoryPath);
    File settingBackupFile = File(settingPath);
    File cashBackupFile = File(cashPath);
    File userBackupFile = File(userPath);
    //
    List<File> files = [];
    files.add(productBackupFile);
    files.add(customerBackupFile);
    files.add(checkBackupFile);
    files.add(factorBackupFile);
    files.add(billBackupFile);
    files.add(categoryBackupFile);
    files.add(settingBackupFile);
    files.add(cashBackupFile);
    files.add(userBackupFile);
    try {
      await productBackupFile.writeAsString(productJson.toString());
      await customerBackupFile.writeAsString(customerJson.toString());
      await checkBackupFile.writeAsString(checkJson.toString());
      await factorBackupFile.writeAsString(factorJson.toString());
      await billBackupFile.writeAsString(billJson.toString());
      await categoryBackupFile.writeAsString(categoryJson.toString());
      await settingBackupFile.writeAsString(settingJson.toString());
      await cashBackupFile.writeAsString(cashJson.toString());
      await userBackupFile.writeAsString(userJson.toString());
      var encoder = ZipFileEncoder();
      encoder.create('${_appDirectory.path}backup_$formattedDate.xhdb');
      await Future.forEach(files, (file) async {
        await encoder.addFile(file);
      }).then((value) {
        encoder.close();
      });
      await checkBackupFilesCount();
      if (createOnlineBackup) {
        _createOnlineBackup(File(encoder.zipPath));
      } //
      else {
        _setStorageBackupList();
      }
    } catch (e) {
      log(e.toString());
    }
    showLoading.value = false;
  }

  setBackup(File selectedFile) {
    String commonDateName = selectedFile.path.split('/').last.split('_').last;
    String oldBackupName = commonDateName.split('.').last;
    if (oldBackupName == 'hdb') {
      restoreOldVersionBackup(selectedFile, commonDateName);
    } //
    else {
      restoreNewVersionBackup(selectedFile, commonDateName);
    }
  }

  Future<void> restoreOldVersionBackup(
      File selectedFile, String commonDateName) async {
    showLoading.value = true;
    //
    final inputStream = InputFileStream(selectedFile.path);
    final archive = ZipDecoder().decodeBuffer(inputStream);
    for (var val in archive.files) {
      if (val.isFile) {
        final outputStream =
            OutputFileStream(_appDataDirectory.path + val.name);
        val.writeContent(outputStream);
        outputStream.close();
      }
    }
    //
    List<FileSystemEntity> dataDirectory =
        await _appDataDirectory.list().toList();
    List<File> files = [];
    for (var file in dataDirectory) {
      if (file.path.contains(commonDateName)) {
        files.add(File(file.path));
      }
    }
    //
    for (var file in files) {
      if (file.path.contains('product')) {
        await restoreProduct(file);
      } //
      else if (file.path.contains('customer')) {
        Map<int, Customer> newMap = await restoreCustomer(file);
        await customerBox.clear();
        //
        List<Customer> customers = [];
        customers.addAll(newMap.values);
        for (var value in customers) {
          value.isActive = true;
        }
        //
        Map<int, Customer> customersMap = {
          for (var customer in customers) customer.id!: customer
        };
        //
        customerBox.putAll(customersMap);
      } //
      else if (file.path.contains('check')) {
        await restoreCheck(file);
      } //
      else if (file.path.contains('factor')) {
        Map<int, Factor> newMap = await restoreFactor(file);
        await factorsBox.clear();
        //
        List<Factor> factors = [];
        factors.addAll(newMap.values);
        for (var value in factors) {
          value.customer?.isActive = true;
        }
        //
        Map<int, Factor> factorMap = {
          for (var factor in factors) factor.id!: factor
        };
        factorsBox.putAll(factorMap);
      } //
      else if (file.path.contains('bill')) {
        Map<int, Bill> newMap = await restoreBill(file);
        cashBox.clear();
        Map<int, Cash> cashMap = {};
        for (int i = 0; i < newMap.length; i++) {
          getCashPayment(newMap[i]!);
          for (var value in newMap[i]!.cash!) {
            value.id = i;
            value.cashCustomer = newMap[i]!.customer;
            cashMap.addAll({i: value});
          }
        }
        cashBox.putAll(cashMap);
      } //
      else if (file.path.contains('category')) {
        await restoreCategory(file);
      } //
      else {
        settingsBox.clear();
        List numbersList = jsonDecode(await file.readAsString());
        List<int> intList = [];
        for (var element in numbersList) {
          intList.add(element as int);
        }
        Map<dynamic, dynamic> map =
            jsonDecode(String.fromCharCodes(intList)) as Map<dynamic, dynamic>;
        Map<int, Setting> settingMap = {
          0: Setting(
            moneyUnit: map['moneyUnit'],
            notificationMinutes: map['notificationMinutes'],
            notificationHours: map['notificationHours'],
            isMoneyUnitRial: map['moneyUnitRial'],
            isThemeLight: true,
            productCountCheck: true,
            showCustomerBalance: true,
            showPaymentOrReceipt: true,
          )
        };
        Map<int, User> userMap = {
          0: User(
            id: 0,
            storeAddress: map['storeAddress'],
            storeName: map['storeName'],
            userEmail: map['userEmail'],
          )
        };
        settingsBox.putAll(settingMap);
        userBox.putAll(userMap);
      }
    }
    showLoading.value = false;
    Get.defaultDialog(
      title: 'بروزرسانی تغییرات',
      content: const Padding(
        padding: EdgeInsets.symmetric(horizontal: 20),
        child: Text(
          'برای اعمال تغییرات از برنامه خارج شده و دوباره راه اندازی کنید.',
          style: TextStyle(height: 1.5),
        ),
      ),
      confirm: ConfirmButton(onTap: Get.back),
    );
  }

  getCashPayment(Bill bill) {
    int cashPayment = bill.customer!.initialAccountBalance ?? 0;
    if (bill.factor != null) {
      for (var item in bill.factor!) {
        cashPayment = cashPayment + item.factorSum!;
      }
    }
    if (bill.check != null) {
      for (var item in bill.check!) {
        cashPayment = cashPayment + item.checkAmount!;
      }
    }
    if (bill.cash != null) {
      for (var item in bill.cash!) {
        cashPayment = cashPayment + item.cashAmount!;
      }
    }
    bill.cashPayment = cashPayment;
  }

  Future<void> restoreNewVersionBackup(
      File selectedFile, String commonDateName) async {
    showLoading.value = true;
    //
    final inputStream = InputFileStream(selectedFile.path);
    final archive = ZipDecoder().decodeBuffer(inputStream);
    for (var val in archive.files) {
      if (val.isFile) {
        final outputStream =
            OutputFileStream(_appDataDirectory.path + val.name);
        val.writeContent(outputStream);
        outputStream.close();
      }
    }
    //
    List<FileSystemEntity> dataDirectory =
        await _appDataDirectory.list().toList();
    List<File> files = [];
    for (var file in dataDirectory) {
      if (file.path.contains(commonDateName)) {
        files.add(File(file.path));
      }
    }
    //
    for (var file in files) {
      if (file.path.contains('product')) {
        await restoreProduct(file);
      } //
      else if (file.path.contains('customer')) {
        await restoreCustomer(file);
      } //
      else if (file.path.contains('check')) {
        await restoreCheck(file);
      } //
      else if (file.path.contains('cash')) {
        cashBox.clear();
        List numbersList = jsonDecode(await file.readAsString());
        List<int> intList = [];
        for (var element in numbersList) {
          intList.add(element as int);
        }
        Map<dynamic, dynamic> map =
            jsonDecode(String.fromCharCodes(intList)) as Map<dynamic, dynamic>;
        Map<int, Cash> newMap = map.map<int, Cash>(
          (key, value) => MapEntry(int.parse(key), Cash.fromJson(value)),
        );
        cashBox.putAll(newMap);
      } //
      else if (file.path.contains('user')) {
        userBox.clear();
        List numbersList = jsonDecode(await file.readAsString());
        List<int> intList = [];
        for (var element in numbersList) {
          intList.add(element as int);
        }
        Map<dynamic, dynamic> map =
            jsonDecode(String.fromCharCodes(intList)) as Map<dynamic, dynamic>;
        Map<int, User> newMap = map.map<int, User>(
          (key, value) => MapEntry(int.parse(key), User.fromJson(value)),
        );
        userBox.putAll(newMap);
      } //
      else if (file.path.contains('factor')) {
        await restoreFactor(file);
      } //
      else if (file.path.contains('bill')) {
        await restoreBill(file);
      } //
      else if (file.path.contains('category')) {
        await restoreCategory(file);
      } //
      else {
        settingsBox.clear();
        List numbersList = jsonDecode(await file.readAsString());
        List<int> intList = [];
        for (var element in numbersList) {
          intList.add(element as int);
        }
        Map<dynamic, dynamic> map =
            jsonDecode(String.fromCharCodes(intList)) as Map<dynamic, dynamic>;
        Map<int, Setting> newMap = map.map<int, Setting>(
          (key, value) => MapEntry(int.parse(key), Setting.fromJson(value)),
        );
        settingsBox.putAll(newMap);
      }
    }
    showLoading.value = false;
    Get.defaultDialog(
      title: 'بروزرسانی تغییرات',
      content: const Padding(
        padding: EdgeInsets.symmetric(horizontal: 20),
        child: Text(
          'برای اعمال تغییرات از برنامه خارج شده و دوباره راه اندازی کنید.',
          style: TextStyle(height: 1.5),
        ),
      ),
      confirm: ConfirmButton(onTap: Get.back),
    );
  }

  _createOnlineBackup(File file) async {
    showLoading.value = true;
    final driveApi = await _getDriveApi();
    if (driveApi == null) {
      await file.delete();
      return;
    }
    final folderId = await _getFolderId(driveApi);
    if (folderId == null) {
      return;
    }
    var media = drive.Media(file.openRead(), file.lengthSync());
    drive.File driveFile = drive.File();
    driveFile.name = file.path.split('/').last;
    driveFile.parents = [folderId];
    driveFile.modifiedTime = DateTime.now().toUtc();
    await driveApi.files.create(driveFile, uploadMedia: media);
    await file.delete();
    await checkDriveBackupFilesCount();
    await setOnlineBackupList();
  }

  Future<drive.DriveApi?> _getDriveApi() async {
    var connectivityResult = await (Connectivity().checkConnectivity());
    if (connectivityResult == ConnectivityResult.none) {
      showLoading.value = false;
      StaticMethods.showSnackBar(
        title: 'خطا',
        description:
            'برای استفاده از مزایای پشتیبان گیری آنلاین باید ارتباط اینترنت شما وصل باشد.',
        duration: const Duration(seconds: 4),
      );
      return null;
    } //
    else {
      try {
        final googleSignIn = sign_in.GoogleSignIn.standard(scopes: [
          drive.DriveApi.driveFileScope,
          'email',
        ]);
        Map<String, String>? authHeaders = {};
        final sign_in.GoogleSignInAccount? account =
            await googleSignIn.signIn();
        authHeaders = await account?.authHeaders;
        if (authHeaders == null) {
          showLoading.value = false;
          return null;
        }
        email.value = account!.email;

        User? user = userBox.get(0);
        if (user != null) {
          user.userEmail = email.value;
          user.save();
        } //
        else {
          userBox.put(
              0,
              User(
                id: 0,
                userEmail: email.value,
              ));
        }

        final authenticateClient = GoogleAuthClient(authHeaders);
        final driveApi = drive.DriveApi(
          authenticateClient,
        );
        return driveApi;
      } catch (e) {
        log(e.toString());
        return null;
      }
    }
  }

  Future<String?> _getFolderId(drive.DriveApi driveApi) async {
    const mimeType = "application/vnd.google-apps.folder";
    String folderName = "Hesab Ban";

    try {
      final found = await driveApi.files.list(
        q: "mimeType = '$mimeType' and name = '$folderName'",
        $fields: "files(id, name)",
      );
      final files = found.files;
      if (files == null) {
        return null;
      }

      // The folder already exists
      if (files.isNotEmpty) {
        return files.first.id;
      }

      // Create a folder
      var folder = drive.File();
      folder.name = folderName;
      folder.mimeType = mimeType;
      final folderCreation = await driveApi.files.create(folder);
      return folderCreation.id;
    } catch (e) {
      log('folder not created');
      log('error...>>> $e');
      return null;
    }
  }

  downloadFile(String id, String name) async {
    showLoading.value = true;
    final driveApi = await _getDriveApi();
    if (driveApi == null) {
      return;
    }
    drive.Media file = await driveApi.files.get(id,
        downloadOptions: drive.DownloadOptions.fullMedia) as drive.Media;
    File savedFile = File(_appDirectory.path + name);
    List<int> dataStore = [];
    file.stream.listen((data) {
      dataStore.insertAll(dataStore.length, data);
    }, onDone: () async {
      await savedFile.writeAsBytes(dataStore);
      await setBackup(savedFile);
      savedFile.delete();
      showLoading.value = false;
    }, onError: (error) {
      showLoading.value = false;
    });
  }

  Future<void> setOnlineBackupList() async {
    showLoading.value = true;
    try {
      final driveApi = await _getDriveApi();
      if (driveApi == null) {
        return;
      }
      showLoading.value = false;

      final fileList = await driveApi.files.list(
        spaces: 'drive',
        q: "name contains 'backup_'",
      );
      final files = fileList.files;
      if (files == null) {
        showLoading.value = false;
        return;
      } //
      else {
        onlineBackupList.value = files;
        showLoading.value = false;
        return;
      }
    } on DetailedApiRequestError catch (e) {
      if (e.status == 401 && e.message == "Invalid Credentials") {
        final googleUser = await sign_in.GoogleSignIn.standard(scopes: [
          drive.DriveApi.driveFileScope,
          'email',
        ]).signInSilently();
        if (googleUser == null) {
          return;
        } //
        await setOnlineBackupList();
      }
    }
  }

  checkBackupFilesCount() async {
    List<FileSystemEntity> backupList = await _appDirectory.list().toList();
    List<FileSystemEntity> backupDataList = await _appDataDirectory.list().toList();
    backupList
        .sort((a, b) => a.statSync().changed.compareTo(b.statSync().changed));
    if (backupList.length > 10) {
      await backupList[0].delete();
    }
    for (var value in backupDataList) {
      await value.delete();
    }
  }

  Future<void> checkDriveBackupFilesCount() async {
    final driveApi = await _getDriveApi();
    if (driveApi == null) {
      return;
    }

    final fileList = await driveApi.files.list(
      spaces: 'drive',
      q: "name contains 'backup_'",
    );
    final files = fileList.files;
    if (files == null) {
      return;
    } //
    else {
      if (files.length > 5) {
        await driveApi.files.delete(files.last.id!);
      }
      return;
    }
  }

  restoreProduct(File file) async {
    productBox.clear();
    List numbersList = jsonDecode(await file.readAsString());
    List<int> intList = [];
    for (var element in numbersList) {
      intList.add(element as int);
    }
    Map<dynamic, dynamic> map =
        jsonDecode(String.fromCharCodes(intList)) as Map<dynamic, dynamic>;
    Map<int, Product> newMap = map.map<int, Product>(
      (key, value) => MapEntry(int.parse(key), Product.fromJson(value)),
    );

    // if backup file is from old version handle new main unit of product
    List<Product> products = [];
    products.addAll(newMap.values);
    for (int i = 0; i < map.values.toList().length; i++) {
      Map item = map.values.toList()[i];
      if (item['mainUnit'] == 'number') {
        products[i].mainUnitOfProduct = UnitOfProduct(id: 0, name: 'عدد');
      }
      if (item['mainUnit'] == 'packet') {
        products[i].mainUnitOfProduct = UnitOfProduct(id: 1, name: 'کارتن');
      }
      if (item['mainUnit'] == 'meter') {
        products[i].mainUnitOfProduct = UnitOfProduct(id: 4, name: 'متر');
      }
      if (item['mainUnit'] == 'squareMeters') {
        products[i].mainUnitOfProduct = UnitOfProduct(id: 5, name: 'متر مربع');
      }
      if (item['mainUnit'] == 'box') {
        products[i].mainUnitOfProduct = UnitOfProduct(id: 2, name: 'بسته');
      }
      if (item['mainUnit'] == 'branch') {
        products[i].mainUnitOfProduct = UnitOfProduct(id: 3, name: 'شاخه');
      }
    }
    Map<int, Product> productMap = {
      for (var product in products) product.id!: product
    };
    //

    productBox.putAll(productMap);
  }

  Future<Map<int, Customer>> restoreCustomer(File file) async {
    customerBox.clear();
    List numbersList = jsonDecode(await file.readAsString());
    List<int> intList = [];
    for (var element in numbersList) {
      intList.add(element as int);
    }
    Map<dynamic, dynamic> map =
        jsonDecode(String.fromCharCodes(intList)) as Map<dynamic, dynamic>;
    Map<int, Customer> newMap = map.map<int, Customer>(
      (key, value) => MapEntry(int.parse(key), Customer.fromJson(value)),
    );
    customerBox.putAll(newMap);
    return newMap;
  }

  restoreCheck(File file) async {
    checkBox.clear();
    List numbersList = jsonDecode(await file.readAsString());
    List<int> intList = [];
    for (var element in numbersList) {
      intList.add(element as int);
    }
    Map<dynamic, dynamic> map =
        jsonDecode(String.fromCharCodes(intList)) as Map<dynamic, dynamic>;
    Map<int, Check> newMap = map.map<int, Check>(
      (key, value) => MapEntry(int.parse(key), Check.fromJson(value)),
    );
    checkBox.putAll(newMap);
  }

  Future<Map<int, Factor>> restoreFactor(File file) async {
    factorsBox.clear();
    List numbersList = jsonDecode(await file.readAsString());
    List<int> intList = [];
    for (var element in numbersList) {
      intList.add(element as int);
    }
    Map<dynamic, dynamic> map =
        jsonDecode(String.fromCharCodes(intList)) as Map<dynamic, dynamic>;
    Map<int, Factor> newMap = map.map<int, Factor>(
      (key, value) => MapEntry(int.parse(key), Factor.fromJson(value)),
    );
    factorsBox.putAll(newMap);
    return newMap;
  }

  Future<Map<int, Bill>> restoreBill(File file) async {
    billBox.clear();
    List numbersList = jsonDecode(await file.readAsString());
    List<int> intList = [];
    for (var element in numbersList) {
      intList.add(element as int);
    }
    Map<dynamic, dynamic> map =
        jsonDecode(String.fromCharCodes(intList)) as Map<dynamic, dynamic>;
    Map<int, Bill> newMap = map.map<int, Bill>(
      (key, value) => MapEntry(int.parse(key), Bill.fromJson(value)),
    );
    billBox.putAll(newMap);
    return newMap;
  }

  restoreCategory(File file) async {
    categoryBox.clear();
    List numbersList = jsonDecode(await file.readAsString());
    List<int> intList = [];
    for (var element in numbersList) {
      intList.add(element as int);
    }
    Map<dynamic, dynamic> map =
        jsonDecode(String.fromCharCodes(intList)) as Map<dynamic, dynamic>;
    Map<int, Category> newMap = map.map<int, Category>(
      (key, value) => MapEntry(int.parse(key), Category.fromJson(value)),
    );
    categoryBox.putAll(newMap);
  }
}
