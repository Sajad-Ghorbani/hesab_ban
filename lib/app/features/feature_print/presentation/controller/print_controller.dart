import 'dart:io';

import 'package:hesab_ban/app/core/utils/extensions.dart';
import 'package:hesab_ban/app/core/utils/static_methods.dart';
import 'package:hesab_ban/app/features/feature_cash/domain/entities/cash_entity.dart';
import 'package:hesab_ban/app/features/feature_cash/presentation/controller/cash_controller.dart';
import 'package:hesab_ban/app/features/feature_check/domain/entities/check_entity.dart';
import 'package:hesab_ban/app/features/feature_check/presentation/controller/check_controller.dart';
import 'package:hesab_ban/app/features/feature_factor/data/models/factor_model.dart';
import 'package:hesab_ban/app/features/feature_factor/domain/entities/factor_entity.dart';
import 'package:hesab_ban/app/features/feature_factor/domain/entities/factor_row_entity.dart';
import 'package:hesab_ban/app/features/feature_setting/presentation/controller/setting_controller.dart';
import 'package:open_file/open_file.dart';
import 'package:path_provider/path_provider.dart';
import 'package:pdf/widgets.dart';
import 'package:printing/printing.dart';
import 'package:get/get.dart';
import 'package:flutter/services.dart';
import 'package:pdf/pdf.dart';
import 'package:persian_number_utility/persian_number_utility.dart';

class PrintController extends GetxController {
  String storeName = '';
  String storeAddress = '';
  String storeLogoPath = '-1';
  String stampLogoPath = '-1';
  String signLogoPath = '-1';
  String barcodeUrl = '-1';
  bool showCustomerBalance = true;
  bool showPaymentOrReceipt = true;
  bool showFactorTax = true;
  bool showFactorCosts = true;
  bool showFactorOffer = true;
  MemoryImage? storeLogo;
  MemoryImage? stampLogo;
  MemoryImage? signLogo;

  @override
  onInit() {
    super.onInit();
    getStoreInfo();
  }

  void getStoreInfo() async {
    storeName = Get.find<SettingController>().storeName;
    storeAddress = Get.find<SettingController>().storeAddress;
    showCustomerBalance = Get.find<SettingController>().showCustomerBalance;
    showPaymentOrReceipt = Get.find<SettingController>().showPaymentOrReceipt;
    showFactorTax = Get.find<SettingController>().showFactorTax;
    showFactorCosts = Get.find<SettingController>().showFactorCosts;
    showFactorOffer = Get.find<SettingController>().showFactorOffer;
    storeLogoPath = Get.find<SettingController>().storeLogo.path;
    stampLogoPath = Get.find<SettingController>().stampLogo.path;
    signLogoPath = Get.find<SettingController>().signLogo.path;
    barcodeUrl = Get.find<SettingController>().barcodeUrl;
    storeLogo = storeLogoPath == '-1'
        ? null
        : MemoryImage(File(storeLogoPath).readAsBytesSync());
    stampLogo = stampLogoPath == '-1'
        ? null
        : MemoryImage(File(stampLogoPath).readAsBytesSync());
    signLogo = signLogoPath == '-1'
        ? null
        : MemoryImage(File(signLogoPath).readAsBytesSync());
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

  Future<Uint8List> generateFactor(
      FactorEntity factor, int? customerCashPayment) async {
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
        SizedBox(height: 2 * PdfPageFormat.mm),
        buildTotal(factor, customerCashPayment),
        SizedBox(height: 1 * PdfPageFormat.cm),
        buildFooter(factor),
      ],
      textDirection: TextDirection.rtl,
      pageFormat: PdfPageFormat.a4,
      margin: const EdgeInsets.all(1 * PdfPageFormat.cm),
    ));

    return pdf.save();
  }

  Future<File> generate(FactorEntity factor, int customerCashPayment) async {
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
        SizedBox(height: 2 * PdfPageFormat.mm),
        buildTotal(factor, customerCashPayment),
        SizedBox(height: 1 * PdfPageFormat.cm),
        buildFooter(factor),
      ],
      textDirection: TextDirection.rtl,
      pageFormat: PdfPageFormat.a4,
      margin: const EdgeInsets.all(1 * PdfPageFormat.cm),
    ));

    return await saveDocument(
      name: factor.customer?.name != null
          ? '${factor.customer!.name!} ${factor.id}.pdf'
          : 'فاکتور خرده فروشی شماره ${factor.id}.pdf',
      pdf: pdf,
    );
  }

  Widget buildHeader(FactorEntity factor) => Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(height: 1 * PdfPageFormat.cm),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Container(
                child: storeLogoPath == '-1'
                    ? SizedBox.shrink()
                    : Image(
                  storeLogo!,
                  width: 80,
                  height: 80,
                  fit: BoxFit.contain,
                ),
              ),
              Column(
                children: [
                  Text(
                    StaticMethods.setTypeFactorString(
                        factor.typeOfFactor!.name),
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
                width: 50,
                height: 50,
                child: BarcodeWidget(
                  data: barcodeUrl != '-1'
                      ? barcodeUrl
                      : 'https://cafebazaar.ir/app/com.nahal1401.hesab_ban',
                  barcode: Barcode.qrCode(),
                ),
              ),
            ],
          ),
          Divider(),
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              buildCustomerAddress(factor),
              buildInvoiceInfo(factor),
            ],
          ),
        ],
      );

  Widget buildCustomerAddress(FactorEntity factor) {
    return Expanded(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          customerText(
            title: factor.typeOfFactor == TypeOfFactor.buy ||
                    factor.typeOfFactor == TypeOfFactor.returnOfSale
                ? 'فروشنده: '
                : 'خریدار: ',
            titleStyle: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.bold,
            ),
            value: factor.customer?.name ?? '',
          ),
          SizedBox(height: 3 * PdfPageFormat.mm),
          customerText(
            title: 'آدرس: ',
            titleStyle: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.bold,
            ),
            value: factor.customer?.address ?? '',
          ),
          SizedBox(height: 3 * PdfPageFormat.mm),
          customerText(
            title: 'شماره تماس: ',
            titleStyle: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.bold,
            ),
            value: factor.customer?.phoneNumber1 ?? '',
          ),
        ],
      ),
    );
  }

  Widget buildInvoiceInfo(FactorEntity factor) {
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

  Widget buildInvoice(FactorEntity factor) {
    final headers = [
      'قیمت کل (${Get.find<SettingController>().moneyUnit})',
      'قیمت واحد (${Get.find<SettingController>().moneyUnit})',
      'تعداد/مقدار',
      'شرح',
      'ردیف',
    ];
    final data = List.generate(
      factor.factorRows!.length,
      (index) {
        FactorRowEntity row = factor.factorRows![index];
        return [
          '${row.productSum.abs()}'.seRagham(),
          '${factor.typeOfFactor == TypeOfFactor.buy ? row.priceOfBuy : row.productPriceOfSale}'
              .seRagham(),
          '${row.productCount.removeDot().seRagham()}\n${row.productUnit}',
          row.productName,
          index + 1,
        ];
      },
    );

    return TableHelper.fromTextArray(
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
        2: const FlexColumnWidth(1.3),
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

  int checkSum(List<int> checksId) {
    List<CheckEntity>? checks = Get.find<CheckController>().getAllChecks();
    List<CheckEntity> cChecks = [];
    int sum = 0;
    if (checks != null) {
      for (var item in checks) {
        for (var value in checksId) {
          if (item.id == value) {
            cChecks.add(item);
          }
        }
      }
      for (var item in cChecks) {
        sum += item.checkAmount!;
      }
    }
    return sum.abs();
  }

  int cashSum(List<int> cashesId) {
    var controller = Get.put<CashController>(
        CashController(Get.find(), Get.find(), Get.find(), Get.find()));
    List<CashEntity>? cashes = controller.getAllCashes();
    List<CashEntity> cCashes = [];
    int sum = 0;
    if (cashes != null) {
      for (var item in cashes) {
        for (var value in cashesId) {
          if (item.id == value) {
            cCashes.add(item);
          }
        }
      }
      for (var item in cCashes) {
        sum += item.cashAmount!;
      }
    }
    return sum.abs();
  }

  Widget buildTotal(FactorEntity factor, int? customerCashPayment) {
    bool typeOfFactor = factor.typeOfFactor!.name == 'buy' ||
        factor.typeOfFactor!.name == 'returnOfSale';
    return Container(
      alignment: Alignment.centerRight,
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            flex: 6,
            child: Container(
              padding: const EdgeInsets.symmetric(vertical: 6, horizontal: 5),
              alignment: Alignment.center,
              child: factor.customer?.name != null
                  ? Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  if (showCustomerBalance)
                    Column(
                      children: [
                        Row(
                          children: [
                            Text(
                                'مانده حساب شما با احتساب این فاکتور مبلغ'),
                            SizedBox(width: 1 * PdfPageFormat.mm),
                            Text(customerCashPayment!.abs().formatPrice(),
                                style: TextStyle(
                                    fontWeight: FontWeight.bold)),
                          ],
                        ),
                        SizedBox(height: 2),
                        Row(
                          children: [
                            Text(Get.find<SettingController>().moneyUnit),
                            SizedBox(width: 1 * PdfPageFormat.mm),
                            Text(
                                customerCashPayment < 0
                                    ? 'بدهکار'
                                    : 'بستانکار',
                                style: TextStyle(
                                    fontWeight: FontWeight.bold)),
                            SizedBox(width: 1 * PdfPageFormat.mm),
                            Text('می باشد.'),
                          ],
                        ),
                        SizedBox(height: 20),
                      ],
                    ),
                  if (showPaymentOrReceipt)
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        if (factor.checksId != null &&
                            factor.checksId!.isNotEmpty)
                          Text(
                              'جمع چک ${typeOfFactor ? 'پرداختی' : 'دریافتی'}: ${checkSum(factor.checksId!).formatPrice()}  ${Get.find<SettingController>().moneyUnit}'),
                        SizedBox(height: 10),
                        if (factor.cashesId != null &&
                            factor.cashesId!.isNotEmpty)
                          Text(
                              'جمع وجه نقد ${typeOfFactor ? 'پرداختی' : 'دریافتی'}: ${cashSum(factor.cashesId!).formatPrice()}  ${Get.find<SettingController>().moneyUnit}'),
                      ],
                    ),
                  if (factor.description != null)
                    Text(factor.description!),
                ],
              )
                  : null,
            ),
          ),
          Expanded(
            flex: 5,
            child: Column(
              children: [
                if (showFactorTax)
                  Container(
                    decoration: BoxDecoration(
                      border: Border.all(
                        width: 1.5,
                      ),
                    ),
                    height: 30,
                    padding: const EdgeInsets.symmetric(horizontal: 10),
                    child: buildText(
                      title: 'مالیات',
                      titleStyle: const TextStyle(fontSize: 12),
                      value:
                          '${(factor.tax ?? 0).formatPrice()} ${Get.find<SettingController>().moneyUnit}',
                      unite: true,
                    ),
                  ),
                if (showFactorCosts)
                  Container(
                    decoration: BoxDecoration(
                      border: Border.all(
                        width: 1.5,
                      ),
                    ),
                    height: 30,
                    padding: const EdgeInsets.symmetric(horizontal: 10),
                    child: buildText(
                      title: factor.costs?.label ?? 'هزینه ها',
                      titleStyle: const TextStyle(fontSize: 12),
                      value:
                          '${(factor.costs?.cost ?? 0).formatPrice()} ${Get.find<SettingController>().moneyUnit}',
                      unite: true,
                    ),
                  ),
                if (showFactorOffer)
                  Container(
                    decoration: BoxDecoration(
                      border: Border.all(
                        width: 1.5,
                      ),
                    ),
                    height: 30,
                    padding: const EdgeInsets.symmetric(horizontal: 10),
                    child: buildText(
                      title: 'تخفیف',
                      titleStyle: const TextStyle(fontSize: 12),
                      value:
                          '${(factor.offer ?? 0).formatPrice()} ${Get.find<SettingController>().moneyUnit}',
                      unite: true,
                    ),
                  ),
                Container(
                  decoration: BoxDecoration(
                    border: Border.all(
                      width: 1.5,
                    ),
                    borderRadius: const BorderRadius.vertical(
                        bottom: Radius.circular(10)),
                  ),
                  height: 30,
                  padding: const EdgeInsets.symmetric(horizontal: 10),
                  child: buildText(
                    title: 'جمع کل فاکتور',
                    titleStyle: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.bold,
                    ),
                    value:
                        '${factor.factorSum!.abs().formatPrice()} ${Get.find<SettingController>().moneyUnit}',
                    unite: true,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget buildFooter(FactorEntity factor) => Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            child: Center(
              child: factor.customer?.name != null ? Text('امضا خریدار') : null,
            ),
          ),
          if (stampLogoPath != '-1') SizedBox(width: 40),
          Expanded(
            child: Center(
              child: Column(
                children: [
                  Align(
                    alignment: stampLogoPath != '-1'
                        ? Alignment.centerRight
                        : Alignment.center,
                    child: Text('امضا فروشنده'),
                  ),
                  SizedBox(height: 15),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      if (signLogoPath != '-1')
                        Image(
                          signLogo!,
                          width: 100,
                          height: 100,
                          fit: BoxFit.contain,
                        ),
                      if (stampLogoPath != '-1')
                        Image(
                          stampLogo!,
                          width: 100,
                          height: 100,
                          fit: BoxFit.contain,
                        ),
                    ],
                  ),
                ],
              ),
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
          Expanded(child: Text(title, style: style)),
          Text(value, style: unite ? style : null),
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
          Text(title, style: style),
          SizedBox(width: 10),
          Expanded(
            child: Text(value, style: unite ? style : null),
          ),
        ],
      ),
    );
  }
}
