import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:archive/archive_io.dart';
import 'package:file_picker/file_picker.dart';
import 'package:get/get.dart';
import 'package:hesab_ban/constants.dart';
import 'package:hesab_ban/models/bill_model.dart';
import 'package:hesab_ban/models/category_model.dart';
import 'package:hesab_ban/models/check_model.dart';
import 'package:hesab_ban/models/customer_model.dart';
import 'package:hesab_ban/models/factor_model.dart';
import 'package:hesab_ban/models/product_model.dart';
import 'package:hive/hive.dart';
import 'package:permission_handler/permission_handler.dart';

class BackupController extends GetxController {
  late Box<Product> productBox;
  late Box<Customer> customerBox;
  late Box<Check> checkBox;
  late Box<Category> categoryBox;
  late LazyBox<Factor> factorsBox;
  late LazyBox<Bill> billBox;
  late LazyBox settingsBox;

  bool showLoading = false;
  String appDirectory = 'storage/emulated/0/HesabBan/backup/.data/';

  String formattedDate = DateTime.now()
      .toString()
      .split('.')
      .first
      .substring(0, 16)
      .replaceAll(' ', '-')
      .replaceAll(':', '-');
  Directory newDirectory = Directory('storage/emulated/0/HesabBan/backup/');

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
  }

  Future<Directory> getDirectory() async {
    var checkResult = await Permission.storage.status;
    if (!checkResult.isGranted) {
      await Permission.storage.request();
    }
    Directory newDirectory = Directory(appDirectory);
    if (await newDirectory.exists() == false) {
      return newDirectory.create(recursive: true);
    }
    return newDirectory;
  }

  // This is method for to map lazy box on hive
  Future<Map<dynamic, dynamic>> toMap(LazyBox box) async {
    Map data = {};
    List keys = box.keys.toList();

    for (int i = 0; i < box.length; i++) {
      data.addAll({keys[i]: await box.getAt(i)});
    }
    return data;
  }

  Future<void> createBackup() async {
    showLoading = true;
    update();
    Map<String, Map<String, dynamic>> productMap = productBox
        .toMap()
        .map((key, value) => MapEntry(key.toString(), value.toJson()));
    Map<String, Map<String, dynamic>> customerMap = customerBox
        .toMap()
        .map((key, value) => MapEntry(key.toString(), value.toJson()));
    Map<String, Map<String, dynamic>> checkMap = checkBox
        .toMap()
        .map((key, value) => MapEntry(key.toString(), value.toJson()));
    Map<String, Map<String, dynamic>> factorMap = await toMap(factorsBox).then(
        (value) => value
            .map((key, value) => MapEntry(key.toString(), value.toJson())));
    Map<String, Map<String, dynamic>> billMap = await toMap(billBox).then(
        (value) => value
            .map((key, value) => MapEntry(key.toString(), value.toJson())));
    Map<String, Map<String, dynamic>> categoryMap = categoryBox
        .toMap()
        .map((key, value) => MapEntry(key.toString(), value.toJson()));
    Map<String, dynamic> settingMap = await toMap(settingsBox).then(
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
    Directory dir = await getDirectory();
    //
    String productPath = '${dir.path}product-$formattedDate.hdb';
    String customerPath = '${dir.path}customer-$formattedDate.hdb';
    String checkPath = '${dir.path}check-$formattedDate.hdb';
    String factorPath = '${dir.path}factor-$formattedDate.hdb';
    String billPath = '${dir.path}bill-$formattedDate.hdb';
    String categoryPath = '${dir.path}category-$formattedDate.hdb';
    String settingPath = '${dir.path}setting-$formattedDate.hdb';
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
      encoder.create('${newDirectory.path}backup_$formattedDate.hdb');
      for (File file in files) {
        encoder.addFile(file);
      }
      encoder.close();
    } catch (e) {
      print(e);
      print('ERROR on write zip file');
    }
    showLoading = false;
    update();
    // uploadFile(File(encoder.zipPath));
  }

  Future<void> restoreBackup() async {
    var checkResult = await Permission.storage.status;
    if (!checkResult.isGranted) {
      await Permission.storage.request();
    }
    showLoading = true;
    update();
    File selectedFile = File('-1');
    FilePickerResult? pickedFile = await FilePicker.platform.pickFiles();
    if (pickedFile != null) {
      selectedFile = File(pickedFile.files.single.path!);
    } //
    else {
      showLoading = false;
      update();
      return;
    }
    String commonDateName = selectedFile.path.split('/').last.split('_').last;
    //
    final inputStream = InputFileStream(selectedFile.path);
    final archive = ZipDecoder().decodeBuffer(inputStream);
    for (var val in archive.files) {
      if (val.isFile) {
        final outputStream = OutputFileStream(appDirectory + val.name);
        val.writeContent(outputStream);
        outputStream.close();
      }
    }
    //
    List<FileSystemEntity> dataDirectory =
        await Directory(appDirectory).list().toList();
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
        print(newMap);
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
        print(newMap);
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
        print(newMap);
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
        print(newMap);
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
        print(newMap);
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
        print(newMap);
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
        print(map);
        settingsBox.putAll(map);
      }
    }
    showLoading = false;
    update();
  }
}
