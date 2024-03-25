import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hesab_ban/app/config/routes/app_pages.dart';
import 'package:hesab_ban/app/config/theme/app_colors.dart';
import 'package:hesab_ban/app/core/params/cash_params.dart';
import 'package:hesab_ban/app/core/params/check_params.dart';
import 'package:hesab_ban/app/core/params/factor_params.dart';
import 'package:hesab_ban/app/core/params/product_params.dart';
import 'package:hesab_ban/app/core/utils/extensions.dart';
import 'package:hesab_ban/app/core/utils/primitive_factor.dart';
import 'package:hesab_ban/app/core/utils/static_methods.dart';
import 'package:hesab_ban/app/features/feature_bill/presentation/controller/bill_controller.dart';
import 'package:hesab_ban/app/features/feature_cash/domain/entities/cash_entity.dart';
import 'package:hesab_ban/app/features/feature_cash/presentation/controller/cash_controller.dart';
import 'package:hesab_ban/app/features/feature_check/domain/entities/bank_entity.dart';
import 'package:hesab_ban/app/features/feature_check/domain/entities/check_entity.dart';
import 'package:hesab_ban/app/features/feature_check/presentation/controller/check_controller.dart';
import 'package:hesab_ban/app/features/feature_customer/domain/entities/customer_entity.dart';
import 'package:hesab_ban/app/features/feature_factor/data/models/factor_model.dart';
import 'package:hesab_ban/app/features/feature_factor/domain/entities/factor_entity.dart';
import 'package:hesab_ban/app/features/feature_factor/domain/entities/factor_row_entity.dart';
import 'package:hesab_ban/app/features/feature_factor/domain/use_cases/delete_factor_use_case.dart';
import 'package:hesab_ban/app/features/feature_factor/domain/use_cases/get_all_factor_use_case.dart';
import 'package:hesab_ban/app/features/feature_factor/domain/use_cases/save_factor_use_case.dart';
import 'package:hesab_ban/app/features/feature_factor/domain/use_cases/update_factor_use_case.dart';
import 'package:hesab_ban/app/features/feature_product/domain/entities/product_entity.dart';
import 'package:hesab_ban/app/features/feature_product/presentation/controller/product_controller.dart';
import 'package:hesab_ban/app/features/feature_setting/presentation/controller/setting_controller.dart';
import 'package:persian_datetime_picker/persian_datetime_picker.dart';
import 'package:persian_number_utility/persian_number_utility.dart';

class FactorController extends GetxController {
  final SaveFactorUseCase _saveFactorUseCase;
  final GetAllFactorUseCase _getAllFactorUseCase;
  final DeleteFactorUseCase _deleteFactorUseCase;
  final UpdateFactorUseCase _updateFactorUseCase;

  FactorController(
    this._getAllFactorUseCase,
    this._saveFactorUseCase,
    this._deleteFactorUseCase,
    this._updateFactorUseCase,
  );

  var cashController = Get.put(CashController(
    Get.find(),
    Get.find(),
    Get.find(),
    Get.find(),
  ));

  List<FactorRowEntity> listFactorRow = <FactorRowEntity>[];
  int factorSum = -1;
  double tax = 0;
  double offer = 0;
  ({String? label, int? cost}) costs =
      (label: Get.find<SettingController>().costsLabel, cost: 0);
  String? description = Get.find<SettingController>().factorDescription;
  String factorDateLabel = '-1';
  DateTime? factorDate;
  int amountLabel = 0;
  TextEditingController productCountController = TextEditingController();
  TextEditingController productPriceOfSaleController = TextEditingController();
  TextEditingController productPriceOfBuyController = TextEditingController();
  TextEditingController productPriceOfOneSaleController =
      TextEditingController();
  TextEditingController taxController = TextEditingController();
  TextEditingController offerController = TextEditingController();
  TextEditingController costsTitleController = TextEditingController();
  TextEditingController costsCountController = TextEditingController();
  TextEditingController descriptionController = TextEditingController();
  ScrollController amountScreenScrollController = ScrollController();
  ScrollController allFactorScreenScrollController = ScrollController();

  RxBool amountScreenShowFab = true.obs;
  RxBool allFactorScreenShowFab = true.obs;
  String factorNumber = '-1';

  bool customerSelected = false;
  CustomerEntity customer = CustomerEntity();
  List<CheckParams> checkList = [];
  List<CashParams> cashList = [];

  List<FactorEntity> factors = [];
  List<FactorEntity> factorsFiltered = [];

  String? startDateFilterLabel;
  DateTime startDateFilter = DateTime.now();
  String? endDateFilterLabel;
  DateTime endDateFilter = DateTime.now();
  int filterIndex = 0;
  bool showTax = Get.find<SettingController>().showFactorTax;
  bool showCosts = Get.find<SettingController>().showFactorCosts;
  bool showOffer = Get.find<SettingController>().showFactorOffer;

  @override
  void onInit() {
    super.onInit();
    getFactorNumber();
    costsTitleController.text = Get.find<SettingController>().costsLabel ?? '';
  }

  @override
  onClose() {
    super.onClose();
    productCountController.dispose();
    productPriceOfSaleController.dispose();
    productPriceOfOneSaleController.dispose();
    productPriceOfBuyController.dispose();
    taxController.dispose();
    offerController.dispose();
    costsCountController.dispose();
    costsTitleController.dispose();
    amountScreenScrollController.dispose();
    allFactorScreenScrollController.dispose();
    descriptionController.dispose();
  }

  void initializeFactors(String typeOfFactor) {
    var response = _getAllFactorUseCase();
    if (response.data == null) {
      StaticMethods.showSnackBar(
        title: 'خطا!',
        description: response.error!,
      );
    } //
    else {
      factors = response.data!
          .where((item) => item.typeOfFactor!.name == typeOfFactor)
          .toList();
      factorsFiltered =
          factors.where((element) => element.factorDate!.isToday()).toList();
    }
  }

  void initialForUpdate(FactorEntity factor) {
    factorNumber = factor.id.toString();
    factorDate = factor.factorDate;
    factorDateLabel = factor.factorDate!.toPersianDate();
    customerSelected = true;
    customer = factor.customer!;
    listFactorRow = factor.factorRows!;
    factorSum = factor.factorSum!.abs();
    offer = factor.offer ?? 0;
    tax = factor.tax ?? 0;
    costs = factor.costs?.cost == null
        ? (label: Get.find<SettingController>().costsLabel, cost: 0)
        : factor.costs!;
    description = factor.description;
    getAmountsForUpdate(factor);
    calculationOfTaxPercentage(factor);
    setCostsForUpdate(factor);
    setOfferForUpdate(factor);
  }

  getFactorNumber() {
    var response = _getAllFactorUseCase();
    if (response.data == null) {
      StaticMethods.showSnackBar(
        title: 'خطا!',
        description: response.error!,
      );
    } //
    else {
      if (response.data!.isEmpty) {
        factorNumber = '1';
      } //
      else {
        factorNumber = (response.data!.last.id! + 1).toString();
      }
      update();
    }
  }

  getPriceOfType(String typeOfFactor, ProductEntity product) {
    if (typeOfFactor == 'oneSale') {
      return product.priceOfOneSale;
    }
    if (typeOfFactor == 'returnOfBuy') {
      return product.priceOfBuy;
    }
    if (typeOfFactor == 'buy' ||
        typeOfFactor == 'sale' ||
        typeOfFactor == 'returnOfSale') {
      return product.priceOfMajorSale;
    }
  }

  Future<void> selectProduct(context, String typeOfFactor) async {
    var product = await Get.toNamed(
      Routes.allProductScreen,
      arguments: true,
    );
    if (product != null) {
      productPriceOfSaleController.text =
          '${getPriceOfType(typeOfFactor, product)}'.seRagham();
      if (typeOfFactor == 'buy') {
        productPriceOfBuyController.text = '${product.priceOfBuy}'.seRagham();
        productPriceOfOneSaleController.text =
            '${product.priceOfOneSale}'.seRagham();
      }
      StaticMethods.inputProductCount(
        product: product,
        isBuy: typeOfFactor == 'buy',
        onConfirm: () {
          addProductToFactor(
            product: product,
            count: StaticMethods.removeSeparatorFromNumber(
                productCountController,
                toDouble: true),
            priceOfSale: StaticMethods.removeSeparatorFromNumber(
                productPriceOfSaleController),
            priceOfBuy: productPriceOfBuyController.text.isEmpty
                ? null
                : StaticMethods.removeSeparatorFromNumber(
                    productPriceOfBuyController),
            priceOfOneSale: productPriceOfOneSaleController.text.isEmpty
                ? null
                : StaticMethods.removeSeparatorFromNumber(
                    productPriceOfOneSaleController),
          );
        },
        productCountController: productCountController,
        productPriceOfSaleController: productPriceOfSaleController,
        productPriceOfBuyController: productPriceOfBuyController,
        productPriceOfOneSaleController: productPriceOfOneSaleController,
      );
      update();
    }
  }

  void addProductToFactor({
    required ProductEntity product,
    required double count,
    required int priceOfSale,
    int? priceOfBuy,
    int? priceOfOneSale,
  }) {
    Get.back();
    productCountController.clear();
    productPriceOfBuyController.clear();
    productPriceOfSaleController.clear();
    productPriceOfOneSaleController.clear();
    FactorRowEntity row = FactorRowEntity(
      0,
      productName: product.name!,
      productCount: count,
      productPriceOfSale: priceOfSale,
      productUnit: product.mainUnit!.name!,
      priceOfBuy: priceOfBuy,
      priceOfOneSale: priceOfOneSale,
    );
    if (listFactorRow
        .any((factorRow) => factorRow.productName == row.productName)) {
      int rowIndex = listFactorRow
          .indexWhere((factorRow) => factorRow.productName == row.productName);
      row.productCount += listFactorRow[rowIndex].productCount;
      listFactorRow[rowIndex] = row;
    } //
    else {
      listFactorRow.add(row);
    }
    setTax();
    update([listFactorRow]);
  }

  void calculateSum() {
    if (listFactorRow.isEmpty) {
      factorSum = 0;
      tax = 0;
      costs = (label: costs.label, cost: 0);
      offer = 0;
    } //
    else {
      int sum = 0;
      for (var item in listFactorRow) {
        sum += item.productSum;
      }
      factorSum = sum + tax.toInt() + costs.cost! - offer.toInt();
    }
    update();
  }

  void addCash(String typeOfCash) async {
    var cashParams = await Get.toNamed(
      Routes.createCashScreen,
      parameters: {
        'from_factor': 'true',
        'customer_id': customer.id.toString(),
        'type_of_cash': typeOfCash,
      },
    );
    if (cashParams != null) {
      cashList.add(cashParams);
      getAmount();
    }
    update();
  }

  void addCheck(String typeOfCheck) async {
    var checkParams = await Get.toNamed(
      Routes.createCheckScreen,
      parameters: {
        'from_factor': 'true',
        'customer_id': customer.id.toString(),
        'type_of_check': typeOfCheck,
      },
    );
    if (checkParams != null) {
      checkList.add(checkParams);
      getAmount();
    }
    update();
  }

  void amountsTapped(String typeOfFactor, FactorEntity? factor) async {
    if (factor == null) {
      String typeOfAmounts =
          typeOfFactor == 'buy' || typeOfFactor == 'returnOfSale'
              ? 'send'
              : 'received';
      if (customer.id == null) {
        StaticMethods.showSnackBar(
          title: 'خطا',
          description: 'لطفا طرف حساب را انتخاب کنید.',
        );
        Future.delayed(const Duration(milliseconds: 1500), () {
          selectCustomer();
        });
      } //
      else {
        Get.toNamed(
          Routes.amountsScreen,
          parameters: {
            'type_of_amounts': typeOfAmounts,
          },
        );
        update();
      }
    } //
    else {
      StaticMethods.showSnackBar(
        title: 'توجه',
        description: 'برای ویرایش '
            '${typeOfFactor == 'buy' || typeOfFactor == 'returnOfSale' ? 'پرداختی ها' : 'دریافتی ها'} '
            'از قسمت مربوطه اقدام کنید.',
      );
    }
  }

  void selectCustomer() async {
    var customerResult = await Get.toNamed(
      Routes.allCustomerScreen,
      arguments: true,
    );
    if (customerResult != null) {
      customer = customerResult;
      customerSelected = true;
      update();
    }
  }

  void selectDate(BuildContext context) async {
    var pickedDate = await StaticMethods.getDate(context);
    if (pickedDate != null) {
      factorDateLabel = pickedDate.formatCompactDate();
      factorDate = pickedDate.toDateTime();
    }
    update();
  }

  bool willPop() {
    if (listFactorRow.isEmpty) {
      return true;
    } //
    else {
      StaticMethods.deleteDialog(
        content:
            'شما یک فاکتور دارید که آن را ذخیره نکرده اید. آیا میخواهید خارج شوید؟',
        onConfirm: () {
          Get.back();
          Get.back();
          listFactorRow.clear();
        },
      );
      return false;
    }
  }

  onRowTapped(FactorRowEntity row, int index, String typeOfFactor) {
    updateRow(row, index, typeOfFactor);
  }

  onRowLongPressed(
      context, FactorRowEntity row, int index, String typeOfFactor) {
    StaticMethods.customBottomSheet(
      context,
      name: row.productName,
      onEditTap: () {
        Get.back();
        updateRow(row, index, typeOfFactor);
      },
      onDeleteTap: () {
        Get.back();
        listFactorRow.removeAt(index);
        setTax();
        update();
      },
    );
  }

  updateRow(FactorRowEntity row, int index, String typeOfFactor) async {
    productCountController.text = row.productCount.removeDot();
    productPriceOfSaleController.text = row.productPriceOfSale.toString();
    if (typeOfFactor == 'buy') {
      productPriceOfBuyController.text = row.priceOfBuy.toString();
      productPriceOfOneSaleController.text = row.priceOfOneSale.toString();
    }
    var response = Get.find<ProductController>().getProducts();
    ProductEntity product = response!
        .firstWhere((ProductEntity product) => product.name == row.productName);
    StaticMethods.inputProductCount(
      product: product,
      isBuy: typeOfFactor == 'buy',
      onConfirm: () {
        double count = StaticMethods.removeSeparatorFromNumber(
          productCountController,
          toDouble: true,
        );
        int price = StaticMethods.removeSeparatorFromNumber(
            productPriceOfSaleController);
        int? priceOfBuy = productPriceOfBuyController.text.isEmpty
            ? null
            : StaticMethods.removeSeparatorFromNumber(
                productPriceOfBuyController);
        int? priceOfOneSale = productPriceOfOneSaleController.text.isEmpty
            ? null
            : StaticMethods.removeSeparatorFromNumber(
                productPriceOfOneSaleController);
        Get.back();
        productCountController.clear();
        productPriceOfSaleController.clear();
        FactorRowEntity newRow = FactorRowEntity(
          row.productSum,
          productName: row.productName,
          productCount: count,
          productPriceOfSale: price,
          productUnit: row.productUnit,
          priceOfBuy: priceOfBuy,
          priceOfOneSale: priceOfOneSale,
        );
        listFactorRow[index] = newRow;
        setTax();
        update();
      },
      productCountController: productCountController,
      productPriceOfSaleController: productPriceOfSaleController,
      productPriceOfBuyController: productPriceOfBuyController,
      productPriceOfOneSaleController: productPriceOfOneSaleController,
    );
  }

  (bool, List<ProductEntity>) validatingFactor(String typeOfFactor) {
    bool productCountCheck = Get.find<SettingController>().productCountCheck;
    var response = Get.find<ProductController>().getProducts();
    List<ProductEntity> products = response!;
    if (typeOfFactor != 'oneSale') {
      if (customer.id == null) {
        StaticMethods.showSnackBar(
          title: 'خطا',
          description: typeOfFactor == 'buy' || typeOfFactor == 'returnOfBuy'
              ? 'فروشنده نمی تواند خالی باشد.\nفروشنده را انتخاب کنید.'
              : 'خریدار نمی تواند خالی باشد.\nخریدار را انتخاب کنید.',
        );
        Future.delayed(const Duration(milliseconds: 1500), () {
          selectCustomer();
        });
        return (false, products);
      }
    }
    if (factorSum <= 0) {
      StaticMethods.showSnackBar(
        title: 'خطا',
        description: 'فاکتور خالی می باشد.',
      );
      return (false, products);
    }
    if (typeOfFactor == 'buy' || typeOfFactor == 'returnOfSale') {
      return (true, products);
    } //
    else {
      for (var item in listFactorRow) {
        for (var product in products) {
          if (item.productName == product.name!) {
            if (!productCountCheck) {
              return (true, products);
            } //
            else if (product.count! - item.productCount < 0) {
              StaticMethods.showSnackBar(
                title: 'خطا',
                description:
                    'موجودی محصول ${product.name} کمتر از مقداری ایست که در فاکتور وارد کرده اید.\n'
                    'لطفا مقدار وارد شده در فاکتور را تصحیح کنید.',
                duration: const Duration(seconds: 5),
              );
              return (false, products);
            } //
            else if (product.priceOfBuy! > item.productPriceOfSale ||
                (item.priceOfOneSale != null &&
                    product.priceOfBuy! > item.priceOfOneSale!)) {
              StaticMethods.showSnackBar(
                title: 'خطا',
                description:
                    'قیمت فروش ${product.name} کمتر از قیمت خرید می باشد. \n'
                    'لطفا مبلغ وارد شده در فاکتور را تصحیح کنید.',
                duration: const Duration(seconds: 5),
              );
              return (false, products);
            }
          }
        }
      }
    }
    return (true, products);
  }

  Future<bool> saveFactor(String typeOfFactor) async {
    (bool, List<ProductEntity>) validateFactor = validatingFactor(typeOfFactor);
    List<ProductEntity> products = validateFactor.$2;
    if (!validateFactor.$1) return false;
    FactorParams newFactor = FactorParams(
      factorDate: factorDate ?? DateTime.now(),
      factorRows: [],
      factorSum: typeOfFactor == 'buy' || typeOfFactor == 'returnOfSale'
          ? factorSum
          : -factorSum,
      typeOfFactor: typeOfFactor,
      customer: customer,
      offer: offer,
      tax: tax,
      costs: costs,
      checksId: [],
      cashesId: [],
      description: description,
    );
    newFactor.factorRows!.addAll(listFactorRow);
    var finalFactor = await _saveFactorUseCase(newFactor);
    if (finalFactor.data == null) {
      StaticMethods.showSnackBar(
        title: 'خطا!',
        description: finalFactor.error!,
      );
    } //
    else {
      await Future.forEach(listFactorRow, (item) async {
        for (var product in products) {
          if (item.productName == product.name!) {
            var factorType =
                typeOfFactor == 'buy' || typeOfFactor == 'returnOfSale'
                    ? 1
                    : -1;
            ProductParams productParams = ProductParams(id: product.id);
            productParams.count = StaticMethods.roundDouble(
                product.count! + factorType * item.productCount);
            if (typeOfFactor == 'buy') {
              productParams.priceOfBuy = item.priceOfBuy;
              productParams.priceOfOneSale = item.priceOfOneSale;
              productParams.priceOfMajorSale = item.productPriceOfSale;
            }
            await updateProductInFactor(productParams);
          }
        }
      });
      if (customer.id != null) {
        await Future.forEach(cashList, (cash) async {
          cash.factorId = finalFactor.data!.id;
          var cashResponse = await cashController.registerCash(cash);
          if (cashResponse != null) {
            newFactor.cashesId!.add(cashResponse.id!);
            await Get.find<BillController>().addToBill(
              customer: customer,
              cash: cashResponse,
            );
          }
        });
        await Future.forEach(checkList, (check) async {
          check.factorId = finalFactor.data!.id;
          var checkResponse =
              await Get.find<CheckController>().saveCheck(check);
          if (checkResponse != null) {
            newFactor.checksId!.add(checkResponse.id!);
            await Get.find<BillController>().addToBill(
              customer: customer,
              check: checkResponse,
            );
          }
        });
        var response = await _updateFactorUseCase(finalFactor.data!);
        Get.find<CheckController>().getAllChecks();
        await Get.find<BillController>().addToBill(
          customer: customer,
          factor: response.data!,
        );
      }
      listFactorRow.clear();
      factorSum = -1;
      update();
      Get.back();
      StaticMethods.showSnackBar(
        title: 'تبریک!',
        description: 'فاکتور شما با موفقیت ثبت شد.',
        color: kLightGreenColor,
        duration: const Duration(seconds: 4),
      );
      return true;
    }
    return false;
  }

  void deleteFactor(FactorEntity factor) async {
    var response = _deleteFactorUseCase(factor.id!);
    if (response.data == null) {
      StaticMethods.showSnackBar(
        title: 'خطا!',
        description: response.error!,
      );
    } //
    else {
      List<ProductEntity> products =
          Get.find<ProductController>().getProducts()!;
      var factorType = factor.typeOfFactor!.name == 'buy' ||
              factor.typeOfFactor!.name == 'returnOfSale'
          ? 1
          : -1;
      for (var item in factor.factorRows!) {
        for (var product in products) {
          if (item.productName == product.name!) {
            ProductParams productParams = ProductParams(
              id: product.id,
            );
            productParams.count = StaticMethods.roundDouble(
                product.count! - factorType * item.productCount);
            await updateProductInFactor(productParams);
          }
        }
      }
      if (factor.customer?.id != null) {
        await Get.find<BillController>()
            .removeFromBill(customer: factor.customer!, factor: factor);
      }
      initializeFactors(factor.typeOfFactor!.name);
      update();
      Get.back();
    }
  }

  void setTax() {
    if (taxController.text.isEmpty) {
      tax = 0;
    } //
    else {
      int sum = 0;
      for (var item in listFactorRow) {
        sum += item.productSum;
      }
      tax = (double.parse(taxController.text) * sum) / 100;
    }
    calculateSum();
    update();
  }

  void setCosts() {
    costs = (
      label: costsTitleController.text.isNotEmpty
          ? costsTitleController.text
          : null,
      cost: costsCountController.text.isEmpty
          ? 0
          : StaticMethods.removeSeparatorFromNumber(costsCountController)
    );
    calculateSum();
    update();
    Get.back();
  }

  void setOffer() {
    if (offerController.text.isNotEmpty) {
      offer = StaticMethods.removeSeparatorFromNumber(
        offerController,
        toDouble: true,
      );
    } //
    else {
      offer = 0;
    }
    calculateSum();
    update();
    Get.back();
  }

  String getImageAddress(String bankName) {
    return bankList
        .firstWhere((element) => element.name == bankName)
        .imageAddress!;
  }

  void getAmount() {
    int sum = 0;
    for (var item in cashList) {
      sum += item.cashAmount!;
    }
    for (var item in checkList) {
      sum += item.checkAmount!;
    }
    amountLabel = sum;
  }

  void onEditeMenuTap(money, String typeOfFactor) {
    Future.delayed(const Duration(milliseconds: 500), () async {
      String type = typeOfFactor == 'buy' || typeOfFactor == 'returnOfSale'
          ? 'send'
          : 'received';
      if (money is CashParams) {
        var cashParams = await Get.toNamed(
          Routes.createCashScreen,
          parameters: {
            'from_factor': 'true',
            'customer_id': money.cashCustomer!.id.toString(),
            'type_of_cash': type,
            'cash_amount': money.cashAmount.toString(),
            'cash_date': money.cashDate.toString(),
          },
        );
        if (cashParams != null) {
          int index = cashList.indexOf(money);
          cashList.removeAt(index);
          cashList.insert(index, cashParams);
          getAmount();
        }
      }
      if (money is CheckParams) {
        var checkParam = await Get.toNamed(
          Routes.createCheckScreen,
          parameters: {
            'from_factor': 'true',
            'customer_id': money.customerCheck!.id.toString(),
            'type_of_check': type,
            'check_bank': money.checkBank.toString(),
            'check_number': money.checkNumber.toString(),
            'check_amount': money.checkAmount.toString(),
            'check_due_date': money.checkDueDate.toString(),
            'check_delivery_date': money.checkDeliveryDate.toString(),
          },
        );
        if (checkParam != null) {
          int index = checkList.indexOf(money);
          checkList.removeAt(index);
          checkList.insert(index, checkParam);
          getAmount();
        }
      }
      update();
    });
  }

  void onDeleteMenuTap(money) {
    Future.delayed(const Duration(milliseconds: 500), () {
      if (money is CashParams) {
        cashList.remove(money);
      }
      if (money is CheckParams) {
        checkList.remove(money);
      }
      getAmount();
      update();
    });
  }

  void getAmountsForUpdate(FactorEntity factor) {
    checkList.clear();
    cashList.clear();
    List<CheckEntity>? checks = Get.find<CheckController>().getAllChecks();
    List<CashEntity>? cashes = Get.find<CashController>().getAllCashes();
    if (checks != null && factor.checksId != null) {
      for (var checkId in factor.checksId!) {
        for (var item in checks) {
          if (checkId == item.id) {
            CheckParams checkParams = CheckParams(
              id: item.id,
              bankName: item.bankName,
              checkAmount: item.checkAmount,
              checkNumber: item.checkNumber,
              customerCheck: item.customerCheck,
              checkBank: item.checkBank?.name,
              checkDueDate: item.checkDueDate,
              checkDeliveryDate: item.checkDeliveryDate,
              typeOfCheck: item.typeOfCheck?.name,
            );
            checkList.add(checkParams);
          }
        }
      }
    }
    if (cashes != null && factor.cashesId != null) {
      for (var cashId in factor.cashesId!) {
        for (var item in cashes) {
          if (cashId == item.id) {
            CashParams cashParams = CashParams(
              id: item.id,
              cashAmount: item.cashAmount,
              cashCustomer: item.customer,
              cashDate: item.cashDate,
              factorId: item.factorId,
            );
            cashList.add(cashParams);
          }
        }
      }
    }
    getAmount();
  }

  void calculationOfTaxPercentage(FactorEntity factor) {
    if (factor.tax == null || factor.tax == 0) {
      taxController.text = '0';
    } //
    else {
      int sum = 0;
      for (var item in listFactorRow) {
        sum += item.productSum;
      }
      taxController.text = ((factor.tax! * 100) / sum).removeDot();
    }
  }

  void setCostsForUpdate(FactorEntity factor) {
    if (factor.costs?.cost != null) {
      costsCountController.text = factor.costs!.cost!.toString();
    }
    if (factor.costs?.label != null) {
      costsTitleController.text = factor.costs!.label!;
    }
  }

  void setOfferForUpdate(FactorEntity factor) {
    if (factor.offer != null) {
      offerController.text = factor.offer!.removeDot();
    }
  }

  void updateFactor(PrimitiveFactor primitiveFactor, String typeOfFactor,
      FactorEntity factorEntity) async {
    if (factorChanged(primitiveFactor)) {
      PrimitiveFactor newFactor = PrimitiveFactor(
        customer: customer,
        factorRows: listFactorRow,
      );
      Map changeList = primitiveFactor.propsDiffs(newFactor);
      List<CustomerEntity?>? customerList = changeList['customer'];
      List<List<FactorRowEntity>?>? rowList = changeList['factorRows'];
      //
      (bool, List<ProductEntity>) validateFactor =
          validatingFactor(typeOfFactor);
      if (!validateFactor.$1) return;
      FactorEntity factor = FactorEntity(
        id: factorEntity.id,
        customer: customer,
        factorDate: factorDate,
        offer: offer,
        tax: tax,
        costs: costs,
        factorRows: listFactorRow,
        factorSum: typeOfFactor == 'buy' || typeOfFactor == 'returnOfSale'
            ? factorSum
            : -factorSum,
        typeOfFactor:
            TypeOfFactor.values.firstWhere((type) => type.name == typeOfFactor),
        description: description,
      );
      var response = await _updateFactorUseCase(factor);
      if (response.data != null) {
        if (customerList != null) {
          await Get.find<BillController>()
              .removeFromBill(customer: customerList[0]!, factor: factorEntity);
          await Get.find<BillController>()
              .addToBill(customer: customer, factor: response.data);
        } //
        else {
          if (typeOfFactor != 'oneSale') {
            await Get.find<BillController>()
                .updateBill(customer: customer, factor: response.data);
          }
        }
        List<ProductEntity> products = validateFactor.$2;
        if (rowList != null) {
          var preRowList = rowList[0]!;
          var currRowList = rowList[1]!;
          var factorType =
              typeOfFactor == 'buy' || typeOfFactor == 'returnOfSale' ? 1 : -1;
          for (var currProduct in currRowList) {
            var preProduct = preRowList.firstWhereOrNull(
                (p) => p.productName == currProduct.productName);
            var product =
                products.firstWhere((p) => p.name == currProduct.productName);
            if (preProduct != null) {
              ProductParams productParams = ProductParams(id: product.id);
              var diff = currProduct.productCount - preProduct.productCount;
              if (diff != 0) {
                productParams.count = StaticMethods.roundDouble(
                    product.count! + factorType * diff);
                if (typeOfFactor == 'buy') {
                  productParams.priceOfBuy = currProduct.priceOfBuy;
                  productParams.priceOfOneSale = currProduct.priceOfOneSale;
                  productParams.priceOfMajorSale =
                      currProduct.productPriceOfSale;
                }
                await updateProductInFactor(productParams);
              }
            } //
            else {
              ProductParams productParams = ProductParams(id: product.id);
              productParams.count = StaticMethods.roundDouble(
                  product.count! + factorType * currProduct.productCount);
              if (typeOfFactor == 'buy') {
                productParams.priceOfBuy = currProduct.priceOfBuy;
                productParams.priceOfOneSale = currProduct.priceOfOneSale;
                productParams.priceOfMajorSale = currProduct.productPriceOfSale;
              }
              await updateProductInFactor(productParams);
            }
          }
          for (var preProduct in preRowList) {
            var currProduct = currRowList.firstWhereOrNull(
                (p) => p.productName == preProduct.productName);
            if (currProduct == null) {
              var product =
                  products.firstWhere((p) => p.name == preProduct.productName);
              ProductParams productParams = ProductParams(id: product.id);
              productParams.count = StaticMethods.roundDouble(
                  product.count! + factorType * preProduct.productCount);
              await updateProductInFactor(productParams);
            }
          }
        }
        initializeFactors(typeOfFactor);
        update();
        Get.back();
        StaticMethods.showSnackBar(
          title: 'تبریک',
          description: 'فاکتور بروزرسانی شد',
          color: kLightGreenColor,
        );
      }
    } //
    else {
      Get.back();
    }
  }

  bool factorChanged(PrimitiveFactor primitiveFactor) {
    PrimitiveFactor newFactor = PrimitiveFactor(
      customer: customer,
      factorDate: factorDate,
      offer: offer,
      tax: tax,
      costs: costs,
      factorRows: listFactorRow,
      factorSum: factorSum,
      description: description,
    );
    if (primitiveFactor == newFactor) {
      return false;
    }
    return true;
  }

  bool backFactorScreen(
      FactorEntity? factor, PrimitiveFactor? primitiveFactor) {
    if (listFactorRow.isEmpty) {
      return true;
    } //
    else {
      if (factor != null) {
        if (!factorChanged(primitiveFactor!)) {
          return true;
        }
      }
      StaticMethods.deleteDialog(
        content:
            'شما یک فاکتور دارید که آن را ذخیره نکرده اید. آیا میخواهید خارج شوید؟',
        onConfirm: () {
          Get.back();
          Get.back();
          listFactorRow.clear();
          if (factor != null) {
            listFactorRow.addAll(primitiveFactor!.factorRows!);
          }
          update();
        },
      );
      return false;
    }
  }

  Future<void> updateProductInFactor(ProductParams productParams) async {
    await Get.find<ProductController>().updateProduct(productParams);
    Get.find<ProductController>().getProducts();
  }

  void filterTapped(int index) async {
    filterIndex = index;
    var currentDate = DateTime.now();
    endDateFilter = currentDate;
    switch (index) {
      case 0:
        startDateFilter = currentDate;
        break;
      case 1:
        // Use a single variable to store the date 7 days ago
        var date7DaysAgo = currentDate.subtract(const Duration(days: 7));
        startDateFilter = date7DaysAgo;
        break;
      case 2:
        // Use a single variable to store the date 30 days ago
        var date30DaysAgo = currentDate.subtract(const Duration(days: 30));
        startDateFilter = date30DaysAgo;
        break;
      default:
        // Use a single variable to store the date 90 days ago
        var date90DaysAgo = currentDate.subtract(const Duration(days: 90));
        startDateFilter = date90DaysAgo;
    }
    startDateFilter.getDifferenceDateString();
    startDateFilterLabel = startDateFilter.toPersianDate();
    endDateFilterLabel = endDateFilter.toPersianDate();
    factorsFiltered = factors
        .where((element) =>
            element.factorDate!.isAfter(startDateFilter) ||
            element.factorDate!.difference(startDateFilter).inDays == 0)
        .toList();
    update();
  }

  void filterDateTapped(bool isStart, BuildContext context) async {
    var pickedDate = await StaticMethods.getDate(context);
    if (pickedDate != null) {
      isStart
          ? startDateFilter = pickedDate.toDateTime()
          : endDateFilter = pickedDate.toDateTime();
      isStart
          ? startDateFilterLabel = pickedDate.formatCompactDate()
          : endDateFilterLabel = pickedDate.formatCompactDate();
      factorsFiltered = factors
          .where((element) =>
              element.factorDate!.isAfter(startDateFilter) &&
              element.factorDate!.isBefore(endDateFilter))
          .toList();
    }
    update();
  }

  void setDescription() {
    if (descriptionController.text.trim().isNotEmpty) {
      description = descriptionController.text.trim();
    } //
    else {
      description = null;
    }
    Get.back();
    descriptionController.clear();
    update();
  }

  double getFooterHeight() {
    if (showOffer && showCosts && showTax) {
      return 0;
    } //
    else if ((!showOffer && showCosts && showTax) ||
        (showOffer && !showCosts && showTax) ||
        (showOffer && showCosts && !showTax)) {
      return 37;
    } //
    else if ((!showOffer && !showCosts && showTax) ||
        (showOffer && !showCosts && !showTax) ||
        (!showOffer && showCosts && !showTax)) {
      return 74;
    } //
    else {
      return 111;
    } //
  }
}
