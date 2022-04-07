import 'dart:io';

import 'package:hesab_ban/constants.dart';
import 'package:hive/hive.dart';
import 'package:open_file/open_file.dart';
import 'package:path_provider/path_provider.dart';
import 'package:pdf/widgets.dart';

import 'package:printing/printing.dart';
import 'package:get/get.dart';
import 'package:flutter/services.dart';
import 'package:hesab_ban/controllers/home_controller.dart';
import 'package:hesab_ban/models/factor_model.dart';
import 'package:hesab_ban/static_methods.dart';
import 'package:pdf/pdf.dart';
import 'package:persian_number_utility/persian_number_utility.dart';

import '../../models/customer_model.dart';
import '../../models/factor_row.dart';

class PrintController extends GetxController {
  String storeName = '';
  String storeAddress = '';
  String storeLogoPath = '-1';
  late MemoryImage storeLogo;

  var boxSetting = Hive.lazyBox(settingBox);

  @override
  onInit() {
    super.onInit();
    getStoreInfo();
  }

  void getStoreInfo() async {
    storeName = await boxSetting.get('storeName');
    storeAddress = await boxSetting.get('storeAddress');
    storeLogoPath = await boxSetting.get('storeLogo');
    storeLogo = MemoryImage(File(storeLogoPath).readAsBytesSync());
  }

  Future<File> saveDocument({
    required String name,
    required Document pdf,
  }) async {
    final bytes = await pdf.save();
    final dir = await getApplicationDocumentsDirectory();
    final file = File('${dir.path}/$name');
    await file.writeAsBytes(bytes);
    return file;
  }

  Future openFile(File file) async {
    final url = file.path;

    await OpenFile.open(url);
  }

  Future shareFile(File file) async {
    await Printing.sharePdf(
        bytes: file.readAsBytesSync(), filename: file.path.split('/').last);
  }

  Future<File> generate(Factor factor, int customerCashPayment) async {
    final pdf = Document(
      theme: ThemeData.withFont(
        base: Font.ttf(
            await rootBundle.load("assets/fonts/IRANYekan_Regular.ttf")),
        bold:
            Font.ttf(await rootBundle.load("assets/fonts/IRANYekan_Bold.ttf")),
      ),
    );

    pdf.addPage(MultiPage(
      build: (context) => [
        buildHeader(factor),
        SizedBox(height: 1 * PdfPageFormat.cm),
        buildInvoice(factor),
        buildTotal(factor, customerCashPayment),
        SizedBox(height: 1 * PdfPageFormat.cm),
        buildFooter(),
      ],
      textDirection: TextDirection.rtl,
      pageFormat: PdfPageFormat.a4,
      margin: const EdgeInsets.all(1 * PdfPageFormat.cm),
    ));

    return await saveDocument(
      name: '${factor.customer!.name!} ${factor.id}.pdf',
      pdf: pdf,
    );
  }

  Widget buildHeader(Factor factor) => Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(height: 1 * PdfPageFormat.cm),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Container(
                width: 50,
                height: 50,
                child: BarcodeWidget(
                  data: 'https://cafebazaar.ir/app/com.nahal1401.hesab_ban',
                  barcode: Barcode.qrCode(),
                ),
              ),
              Column(
                children: [
                  Text(
                    StaticMethods.setTypeFactorString(factor.typeOfFactor!),
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                  SizedBox(height: 3 * PdfPageFormat.mm),
                  Text(
                    storeName == '' ? 'نام فروشگاه' : storeName,
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
                  ),
                  SizedBox(height: 3 * PdfPageFormat.mm),
                  Text(
                    storeAddress == '' ? 'آدرس فروشگاه' : storeAddress,
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                ],
              ),
              Container(
                child: storeLogoPath == '-1'
                    ? SizedBox.shrink()
                    : Image(
                        storeLogo,
                        width: 80,
                        height: 80,
                        fit: BoxFit.contain,
                      ),
              ),
            ],
          ),
          Divider(),
          Row(
            crossAxisAlignment: CrossAxisAlignment.end,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              buildInvoiceInfo(factor),
              buildCustomerAddress(factor.customer!),
            ],
          ),
        ],
      );

  Widget buildCustomerAddress(Customer customer) {
    return Expanded(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          customerText(
            title: 'خریدار: ',
            titleStyle: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.bold,
            ),
            value: customer.name!,
          ),
          SizedBox(height: 3 * PdfPageFormat.mm),
          customerText(
            title: 'آدرس: ',
            titleStyle: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.bold,
            ),
            value: customer.address!,
          ),
          SizedBox(height: 3 * PdfPageFormat.mm),
          customerText(
            title: 'شماره تماس: ',
            titleStyle: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.bold,
            ),
            value: customer.phoneNumber1!,
          ),
        ],
      ),
    );
  }

  Widget buildInvoiceInfo(Factor factor) {
    final titles = <String>[
      'شماره فاکتور:',
      'تاریخ:',
    ];
    final data = <String>[
      factor.id.toString(),
      '${factor.factorDate}'.toPersianDate(digitType: NumStrLanguage.English),
    ];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: List.generate(
        titles.length,
        (index) {
          final title = titles[index];
          final value = data[index];

          return Column(
            children: [
              buildText(title: title, value: value, width: 100),
              SizedBox(height: 5 * PdfPageFormat.mm),
            ],
          );
        },
      ),
    );
  }

  Widget buildInvoice(Factor factor) {
    final headers = [
      'قیمت کل )${Get.find<HomeController>().moneyUnit.value}(',
      'قیمت واحد )${Get.find<HomeController>().moneyUnit.value}(',
      'تعداد',
      'شرح',
      'ردیف',
    ];
    final data = List.generate(
      factor.factorRows!.length,
      (index) {
        FactorRow row = factor.factorRows![index];
        return [
          '${row.productSum.abs()}'.seRagham(),
          '${row.productPrice}'.seRagham(),
          '${row.productCount}'.seRagham(),
          row.productName,
          index + 1,
        ];
      },
    );

    return Table.fromTextArray(
      headers: headers,
      data: data,
      border: const TableBorder(
        horizontalInside: BorderSide(width: 1),
        verticalInside: BorderSide(width: 1),
      ),
      headerStyle: TextStyle(fontWeight: FontWeight.bold),
      headerDecoration: BoxDecoration(
        color: PdfColors.grey300,
        borderRadius: const BorderRadius.vertical(
          top: Radius.circular(10),
        ),
        border: Border.all(width: 1),
      ),
      rowDecoration: BoxDecoration(
        border: Border.all(width: 1),
      ),
      oddRowDecoration: BoxDecoration(
        color: PdfColors.grey300,
        border: Border.all(width: 1),
      ),
      cellHeight: 30,
      headerAlignment: Alignment.center,
      columnWidths: {
        0: const FlexColumnWidth(2),
        1: const FlexColumnWidth(2),
        2: const FlexColumnWidth(1),
        3: const FlexColumnWidth(3.5),
        4: const FlexColumnWidth(0.6),
      },
      cellAlignments: {
        0: Alignment.center,
        1: Alignment.center,
        2: Alignment.center,
        3: Alignment.centerRight,
        4: Alignment.center,
      },
    );
  }

  Widget buildTotal(Factor factor, int customerCashPayment) {
    return Container(
      alignment: Alignment.centerRight,
      child: Row(
        children: [
          Expanded(
            flex: 5,
            child: Container(
              decoration: BoxDecoration(
                border: Border.all(
                  width: 1.5,
                ),
                borderRadius:
                    const BorderRadius.vertical(bottom: Radius.circular(10)),
              ),
              height: 30,
              padding: const EdgeInsets.symmetric(horizontal: 10),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  buildText(
                    title: 'جمع کل فاکتور',
                    titleStyle: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.bold,
                    ),
                    value: factor.factorSum!.abs().toString().seRagham() +
                        ' ' +
                        Get.find<HomeController>().moneyUnit.value,
                    unite: true,
                  ),
                ],
              ),
            ),
          ),
          Expanded(
            flex: 6,
            child: Container(
              padding: const EdgeInsets.symmetric(vertical: 6, horizontal: 5),
              alignment: Alignment.center,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      Text(customerCashPayment.abs().toString().seRagham(),
                          style: TextStyle(fontWeight: FontWeight.bold)),
                      SizedBox(width: 1 * PdfPageFormat.mm),
                      Text('مانده حساب شما با احتساب این فاکتور مبلغ'),
                    ],
                  ),
                  SizedBox(height: 5),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      Text('می باشد.'),
                      SizedBox(width: 1 * PdfPageFormat.mm),
                      Text(customerCashPayment < 0 ? 'بدهکار' : 'بستانکار',
                          style: TextStyle(fontWeight: FontWeight.bold)),
                      SizedBox(width: 1 * PdfPageFormat.mm),
                      Text(Get.find<HomeController>().moneyUnit.value),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget buildFooter() => Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Expanded(
            child: Center(
              child: Text('امضا فروشنده'),
            ),
          ),
          Expanded(
            child: Center(
              child: Text('امضا خریدار'),
            ),
          ),
        ],
      );

  buildSimpleText({
    required String title,
    required String value,
  }) {
    final style = TextStyle(fontWeight: FontWeight.bold);

    return Row(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.end,
      children: [
        Text(title, style: style),
        SizedBox(width: 2 * PdfPageFormat.mm),
        Text(value),
      ],
    );
  }

  buildText({
    required String title,
    required String value,
    double width = double.infinity,
    TextStyle? titleStyle,
    bool unite = false,
  }) {
    final style = titleStyle ?? TextStyle(fontWeight: FontWeight.bold);

    return Container(
      width: width,
      child: Row(
        children: [
          Text(value, style: unite ? style : null),
          Expanded(child: Text(title, style: style)),
        ],
      ),
    );
  }

  customerText({
    required String title,
    required String value,
    double width = double.infinity,
    TextStyle? titleStyle,
    bool unite = false,
  }) {
    final style = titleStyle ?? TextStyle(fontWeight: FontWeight.bold);

    return Container(
      width: width,
      child: Row(
        children: [
          Expanded(
            child: Text(value, style: unite ? style : null),
          ),
          SizedBox(width: 10),
          Text(title, style: style),
        ],
      ),
    );
  }
}
