import 'dart:async';
import 'dart:convert';
import 'dart:developer';
import 'dart:io';

import 'package:archive/archive_io.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:googleapis/abusiveexperiencereport/v1.dart';
import 'package:hesab_ban/constants.dart';
import 'package:hesab_ban/data/models/bill_model.dart';
import 'package:hesab_ban/data/models/category_model.dart';
import 'package:hesab_ban/data/models/check_model.dart';
import 'package:hesab_ban/data/models/customer_model.dart';
import 'package:hesab_ban/data/models/factor_model.dart';
import 'package:hesab_ban/data/models/product_model.dart';
import 'package:hesab_ban/data/providers/google_auth_client.dart';
import 'package:hesab_ban/static_methods.dart';
import 'package:hesab_ban/ui/widgets/confirm_button.dart';
import 'package:hive/hive.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:googleapis/drive/v3.dart' as drive;
import 'package:google_sign_in/google_sign_in.dart' as sign_in;
import 'package:persian_number_utility/persian_number_utility.dart';
import 'package:connectivity_plus/connectivity_plus.dart';

class BackupController extends GetxController {
  late Box<Product> productBox;
  late Box<Customer> customerBox;
  late Box<Check> checkBox;
  late Box<Category> categoryBox;
  late LazyBox<Factor> factorsBox;
  late LazyBox<Bill> billBox;
  late LazyBox settingsBox;

  RxBool showLoading = false.obs;
  RxString email = '-1'.obs;
  RxList<drive.File> onlineBackupList = <drive.File>[].obs;
  RxList<FileSystemEntity> storageBackupList = <FileSystemEntity>[].obs;

  late Directory _appDataDirectory;
  late Directory _appDirectory;

  String formattedDate = DateTime.now()
          .toString()
          .toPersianDate(digitType: NumStrLanguage.English)
          .replaceAll('/', '-') +
      '-' +
      DateTime.now()
          .toString()
          .split('.')
          .first
          .split(' ')
          .last
          .substring(0, 5)
          .replaceAll(':', '-');

  @override
  void onInit() {
    super.onInit();
    productBox = Hive.box<Product>(allProductBox);
    customerBox = Hive.box<Customer>(customersBox);
    checkBox = Hive.box<Check>(checksBox);
    factorsBox = Hive.lazyBox<Factor>(factorBox);
    billBox = Hive.lazyBox<Bill>(billsBox);
    settingsBox = Hive.lazyBox(settingBox);
    categoryBox = Hive.box(productCategoryBox);
    _getDirectory().then((value) async {
      await _setStorageBackupList();
      await checkBackupFilesCount();
    });
    _setUserEmail();
  }

  _setUserEmail() async {
    email.value = await settingsBox.get('userEmail') ?? '-1';
  }

  _setStorageBackupList() async {
    List<FileSystemEntity> list = [];
    List<FileSystemEntity> fileList = await _appDirectory.list().toList();
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
    Directory rootDirectory = Directory(newDirectory.path + '/backup/.data/');
    if (await rootDirectory.exists() == false) {
      _appDataDirectory = await rootDirectory.create(recursive: true);
      _appDirectory = Directory(newDirectory.path + '/backup/');
      return;
    }
    _appDataDirectory = rootDirectory;
    _appDirectory = Directory(newDirectory.path + '/backup/');
    return;
  }

  // This is method for to map lazy box on hive
  Future<Map<dynamic, E>> _toMap<E>(LazyBox box) async {
    Map<dynamic, E> data = {};
    List keys = box.keys.toList();

    for (int i = 0; i < box.length; i++) {
      data.addAll({keys[i]: await box.getAt(i)});
    }
    return data;
  }

  Future<Map<String, Map<String, dynamic>>> createMapOfBox(
      Box? box, LazyBox? lazyBox) async {
    if (lazyBox != null && lazyBox.lazy) {
      return await _toMap(lazyBox).then((value) =>
          value.map((key, value) => MapEntry(key.toString(), value.toJson())));
    } //
    else {
      return box!
          .toMap()
          .map((key, value) => MapEntry(key.toString(), value.toJson()));
    }
  }

  Future<void> createBackup(bool createOnlineBackup) async {
    showLoading.value = true;
    Map<String, Map<String, dynamic>> productMap =
        await createMapOfBox(productBox, null);
    Map<String, Map<String, dynamic>> customerMap =
        await createMapOfBox(customerBox, null);
    Map<String, Map<String, dynamic>> checkMap =
        await createMapOfBox(checkBox, null);
    Map<String, Map<String, dynamic>> factorMap =
        await createMapOfBox(null, factorsBox);
    Map<String, Map<String, dynamic>> billMap =
        await createMapOfBox(null, billBox);
    Map<String, Map<String, dynamic>> categoryMap =
        await createMapOfBox(categoryBox, null);
    Map<String, dynamic> settingMap = await _toMap(settingsBox).then(
        (value) => value.map((key, value) => MapEntry(key.toString(), value)));
    settingMap.remove('storeLogo');
    //
    List<int> productJson = jsonEncode(productMap).codeUnits;
    List<int> customerJson = jsonEncode(customerMap).codeUnits;
    List<int> checkJson = jsonEncode(checkMap).codeUnits;
    List<int> factorJson = jsonEncode(factorMap).codeUnits;
    List<int> billJson = jsonEncode(billMap).codeUnits;
    List<int> settingJson = jsonEncode(settingMap).codeUnits;
    List<int> categoryJson = jsonEncode(categoryMap).codeUnits;
    //
    String productPath = '${_appDataDirectory.path}product-$formattedDate.hdb';
    String customerPath =
        '${_appDataDirectory.path}customer-$formattedDate.hdb';
    String checkPath = '${_appDataDirectory.path}check-$formattedDate.hdb';
    String factorPath = '${_appDataDirectory.path}factor-$formattedDate.hdb';
    String billPath = '${_appDataDirectory.path}bill-$formattedDate.hdb';
    String categoryPath =
        '${_appDataDirectory.path}category-$formattedDate.hdb';
    String settingPath = '${_appDataDirectory.path}setting-$formattedDate.hdb';
    //
    File productBackupFile = File(productPath);
    File customerBackupFile = File(customerPath);
    File checkBackupFile = File(checkPath);
    File factorBackupFile = File(factorPath);
    File billBackupFile = File(billPath);
    File categoryBackupFile = File(categoryPath);
    File settingBackupFile = File(settingPath);
    //
    List<File> files = [];
    files.add(productBackupFile);
    files.add(customerBackupFile);
    files.add(checkBackupFile);
    files.add(factorBackupFile);
    files.add(billBackupFile);
    files.add(categoryBackupFile);
    files.add(settingBackupFile);
    try {
      await productBackupFile.writeAsString(productJson.toString());
      await customerBackupFile.writeAsString(customerJson.toString());
      await checkBackupFile.writeAsString(checkJson.toString());
      await factorBackupFile.writeAsString(factorJson.toString());
      await billBackupFile.writeAsString(billJson.toString());
      await categoryBackupFile.writeAsString(categoryJson.toString());
      await settingBackupFile.writeAsString(settingJson.toString());
      var encoder = ZipFileEncoder();
      encoder.create('${_appDirectory.path}backup_$formattedDate.hdb');
      for (File file in files) {
        encoder.addFile(file);
      }
      encoder.close();
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

  Future<void> restoreBackup(File selectedFile) async {
    showLoading.value = true;
    String commonDateName = selectedFile.path.split('/').last.split('_').last;
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
        productBox.clear();
        List numbersList = jsonDecode(await file.readAsString());
        List<int> intList = [];
        for (var element in numbersList) {
          intList.add(element as int);
        }
        Map<dynamic, dynamic> map =
            jsonDecode(String.fromCharCodes(intList)) as Map<dynamic, dynamic>;
        Map<int, Product> newMap = map.map<int, Product>(
            (key, value) => MapEntry(int.parse(key), Product.fromJson(value)));
        productBox.putAll(newMap);
      } //
      else if (file.path.contains('customer')) {
        customerBox.clear();
        List numbersList = jsonDecode(await file.readAsString());
        List<int> intList = [];
        for (var element in numbersList) {
          intList.add(element as int);
        }
        Map<dynamic, dynamic> map =
            jsonDecode(String.fromCharCodes(intList)) as Map<dynamic, dynamic>;
        Map<int, Customer> newMap = map.map<int, Customer>(
            (key, value) => MapEntry(int.parse(key), Customer.fromJson(value)));
        customerBox.putAll(newMap);
      } //
      else if (file.path.contains('check')) {
        checkBox.clear();
        List numbersList = jsonDecode(await file.readAsString());
        List<int> intList = [];
        for (var element in numbersList) {
          intList.add(element as int);
        }
        Map<dynamic, dynamic> map =
            jsonDecode(String.fromCharCodes(intList)) as Map<dynamic, dynamic>;
        Map<int, Check> newMap = map.map<int, Check>(
            (key, value) => MapEntry(int.parse(key), Check.fromJson(value)));
        checkBox.putAll(newMap);
      } //
      else if (file.path.contains('factor')) {
        factorsBox.clear();
        List numbersList = jsonDecode(await file.readAsString());
        List<int> intList = [];
        for (var element in numbersList) {
          intList.add(element as int);
        }
        Map<dynamic, dynamic> map =
            jsonDecode(String.fromCharCodes(intList)) as Map<dynamic, dynamic>;
        Map<int, Factor> newMap = map.map<int, Factor>(
            (key, value) => MapEntry(int.parse(key), Factor.fromJson(value)));
        factorsBox.putAll(newMap);
      } //
      else if (file.path.contains('bill')) {
        billBox.clear();
        List numbersList = jsonDecode(await file.readAsString());
        List<int> intList = [];
        for (var element in numbersList) {
          intList.add(element as int);
        }
        Map<dynamic, dynamic> map =
            jsonDecode(String.fromCharCodes(intList)) as Map<dynamic, dynamic>;
        Map<int, Bill> newMap = map.map<int, Bill>(
            (key, value) => MapEntry(int.parse(key), Bill.fromJson(value)));
        billBox.putAll(newMap);
      } //
      else if (file.path.contains('category')) {
        categoryBox.clear();
        List numbersList = jsonDecode(await file.readAsString());
        List<int> intList = [];
        for (var element in numbersList) {
          intList.add(element as int);
        }
        Map<dynamic, dynamic> map =
            jsonDecode(String.fromCharCodes(intList)) as Map<dynamic, dynamic>;
        Map<int, Category> newMap = map.map<int, Category>(
            (key, value) => MapEntry(int.parse(key), Category.fromJson(value)));
        categoryBox.putAll(newMap);
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
        settingsBox.putAll(map);
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
        await settingsBox.put('userEmail', account.email);

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
      await restoreBackup(savedFile);
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
        q: "name contains 'backup_' and name contains '.hdb'",
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
    List<FileSystemEntity> backupDataList = await _appDirectory.list().toList();
    if (backupDataList.length > 11) {
      await backupDataList[1].delete();
    }
  }

  Future<void> checkDriveBackupFilesCount() async {
    final driveApi = await _getDriveApi();
    if (driveApi == null) {
      return;
    }

    final fileList = await driveApi.files.list(
      spaces: 'drive',
      q: "name contains 'backup_' and name contains '.hdb'",
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
}
