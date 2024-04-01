import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hesab_ban/app/config/theme/app_colors.dart';
import 'package:hesab_ban/app/core/params/category_params.dart';
import 'package:hesab_ban/app/core/params/product_params.dart';
import 'package:hesab_ban/app/core/params/unit_of_product_params.dart';
import 'package:hesab_ban/app/core/resources/data_state.dart';
import 'package:hesab_ban/app/core/utils/static_methods.dart';
import 'package:hesab_ban/app/features/feature_product/domain/entities/category_entity.dart';
import 'package:hesab_ban/app/features/feature_product/domain/entities/product_entity.dart';
import 'package:hesab_ban/app/features/feature_product/domain/entities/unit_of_product_entity.dart';
import 'package:hesab_ban/app/features/feature_product/domain/use_cases/category/delete_category_use_case.dart';
import 'package:hesab_ban/app/features/feature_product/domain/use_cases/category/get_all_category_use_case.dart';
import 'package:hesab_ban/app/features/feature_product/domain/use_cases/category/save_category_use_case.dart';
import 'package:hesab_ban/app/features/feature_product/domain/use_cases/category/update_category_use_case.dart';
import 'package:hesab_ban/app/features/feature_product/domain/use_cases/product/delete_product_use_case.dart';
import 'package:hesab_ban/app/features/feature_product/domain/use_cases/product/get_all_product_use_case.dart';
import 'package:hesab_ban/app/features/feature_product/domain/use_cases/category/get_category_by_name_use_case.dart';
import 'package:hesab_ban/app/features/feature_product/domain/use_cases/product/save_product_use_case.dart';
import 'package:hesab_ban/app/features/feature_product/domain/use_cases/product/update_product_use_case.dart';
import 'package:hesab_ban/app/features/feature_product/domain/use_cases/unit_of_product/delete_unit_of_product_use_case.dart';
import 'package:hesab_ban/app/features/feature_product/domain/use_cases/unit_of_product/get_all_unit_of_product_use_case.dart';
import 'package:hesab_ban/app/features/feature_product/domain/use_cases/unit_of_product/get_by_name_unit_of_product_use_case.dart';
import 'package:hesab_ban/app/features/feature_product/domain/use_cases/unit_of_product/save_unit_of_product_use_case.dart';
import 'package:hesab_ban/app/features/feature_product/domain/use_cases/unit_of_product/update_unit_of_product_use_case.dart';
import 'package:hesab_ban/app/features/feature_product/presentation/screens/product_folder_screen.dart';

class ProductController extends GetxController {
  final SaveProductUseCase _saveProductUseCase;
  final UpdateProductUseCase _updateProductUseCase;
  final GetAllProductUseCase _getAllProductUseCase;
  final DeleteProductUseCase _deleteProductUseCase;
  final GetAllCategoryUseCase _getAllCategoryUseCase;
  final GetCategoryByNameUseCase _getCategoryByNameUseCase;
  final SaveCategoryUseCase _saveCategoryUseCase;
  final UpdateCategoryUseCase _updateCategoryUseCase;
  final DeleteCategoryUseCase _deleteCategoryUseCase;
  final GetAllUnitOfProductUseCase _getAllUnitOfProductUseCase;
  final GetByNameUnitOfProductUseCase _getByNameUnitOfProductUseCase;
  final DeleteUnitOfProductUseCase _deleteUnitOfProductUseCase;
  final UpdateUnitOfProductUseCase _updateUnitOfProductUseCase;
  final SaveUnitOfProductUseCase _saveUnitOfProductUseCase;

  ProductController(
    this._saveProductUseCase,
    this._getCategoryByNameUseCase,
    this._updateProductUseCase,
    this._saveCategoryUseCase,
    this._updateCategoryUseCase,
    this._deleteCategoryUseCase,
    this._getAllProductUseCase,
    this._deleteProductUseCase,
    this._getAllCategoryUseCase,
    this._getAllUnitOfProductUseCase,
    this._getByNameUnitOfProductUseCase,
    this._deleteUnitOfProductUseCase,
    this._updateUnitOfProductUseCase,
    this._saveUnitOfProductUseCase,
  );

  List<DropdownMenuItem<int>> productUnitList = [];

  TextEditingController productNameController = TextEditingController();
  TextEditingController productBuyController = TextEditingController();
  TextEditingController productOneSaleController = TextEditingController();
  TextEditingController productMajorSaleController = TextEditingController();
  TextEditingController productCountController = TextEditingController();
  TextEditingController categoryNameController = TextEditingController();
  TextEditingController unitNameController = TextEditingController();
  late ScrollController productScreenScrollController;

  RxBool showProductsFab = true.obs;
  RxBool showCategoryProductsFab = true.obs;
  int productMainUnit = 0;
  List<CategoryEntity> categories = [];
  List<ProductEntity> products = [];
  List<UnitOfProductEntity> units = [];
  int editUnitId = -1;
  FocusNode unitNode = FocusNode();

  @override
  void onInit() {
    super.onInit();
    productScreenScrollController = ScrollController();
    getCategories();
    getProducts();
    getUnitOfProduct();
    productUnitList = getUnitList();
  }

  @override
  void onClose() {
    super.onClose();
    productNameController.dispose();
    productBuyController.dispose();
    productOneSaleController.dispose();
    productMajorSaleController.dispose();
    productCountController.dispose();
    categoryNameController.dispose();
    unitNameController.dispose();
    productScreenScrollController.dispose();
  }

  getCategories() {
    var response = _getAllCategoryUseCase();
    if (response.data == null) {
      StaticMethods.showSnackBar(
        title: 'خطا!',
        description: response.error!,
      );
    } //
    else {
      categories = response.data!;
      update();
    }
  }

  List<ProductEntity>? getProducts() {
    var response = _getAllProductUseCase();
    if (response.data == null) {
      StaticMethods.showSnackBar(
        title: 'خطا!',
        description: response.error!,
      );
      return null;
    } //
    else {
      products = response.data!;
      update();
      return products;
    }
  }

  List<UnitOfProductEntity>? getUnitOfProduct() {
    var response = _getAllUnitOfProductUseCase();
    if (response.data == null) {
      StaticMethods.showSnackBar(title: 'خطا', description: response.error!);
      return null;
    } //
    else {
      units = response.data!;
      update();
      return units;
    }
  }

  List<DropdownMenuItem<int>> getUnitList() {
    List<DropdownMenuItem<int>> list = [];
    for (int i = 0; i < units.length; i++) {
      list.add(
        DropdownMenuItem(
          value: i,
          child: Text(
            units[i].name!,
          ),
        ),
      );
    }
    return list;
  }

  void saveProduct(context, String productCategoryName) async {
    if (productNameController.text.isEmpty) {
      StaticMethods.showSnackBar(
          title: 'خطا', description: 'لطفا نام را وارد کنید.');
    } //
    else {
      ProductParams product = ProductParams(
        name: productNameController.text.trim(),
        count: productCountController.text.isEmpty
            ? 0
            : StaticMethods.removeSeparatorFromNumber(productCountController,
                toDouble: true),
        priceOfBuy: productBuyController.text.isEmpty
            ? 0
            : StaticMethods.removeSeparatorFromNumber(productBuyController),
        priceOfOneSale: productOneSaleController.text.isEmpty
            ? 0
            : StaticMethods.removeSeparatorFromNumber(productOneSaleController),
        priceOfMajorSale: productMajorSaleController.text.isEmpty
            ? 0
            : StaticMethods.removeSeparatorFromNumber(
                productMajorSaleController),
        mainUnit: units[productMainUnit],
        category: await getCurrentCategory(productCategoryName),
      );
      var response = await _saveProductUseCase(product);
      if (response.data == null) {
        StaticMethods.showSnackBar(
          title: 'خطا!',
          description: response.error!,
        );
      } //
      else {
        resetProductScreen(context);
        StaticMethods.showSnackBar(
          title: 'تبریک!',
          description: 'محصول جدید با موفقیت ثبت شد.',
          color: kLightGreenColor,
        );
        getProducts();
        update();
      }
    }
  }

  Future<CategoryEntity?> getCurrentCategory(String categoryName) async {
    var response = await _getCategoryByNameUseCase(categoryName);
    if (response.data == null) {
      StaticMethods.showSnackBar(
        title: 'خطا!',
        description: response.error!,
      );
      return null;
    } //
    else {
      return response.data!;
    }
  }

  void resetProductScreen(context) {
    FocusScope.of(context).unfocus();
    productNameController.clear();
    productBuyController.clear();
    productOneSaleController.clear();
    productMajorSaleController.clear();
    productCountController.clear();
  }

  Future<DataState<ProductEntity>> updateProduct(ProductParams product) async {
    return await _updateProductUseCase(product);
  }

  void updateProductUI(context, ProductEntity product) async {
    if (productNameController.text.isEmpty) {
      StaticMethods.showSnackBar(
          title: 'خطا', description: 'لطفا نام را وارد کنید.');
    } //
    else {
      ProductParams newProduct = ProductParams(
        id: product.id,
        name: productNameController.text.trim(),
        count: productCountController.text.isEmpty
            ? 0
            : StaticMethods.removeSeparatorFromNumber(productCountController,
                toDouble: true),
        priceOfBuy: productBuyController.text.isEmpty
            ? 0
            : StaticMethods.removeSeparatorFromNumber(productBuyController),
        priceOfOneSale: productOneSaleController.text.isEmpty
            ? 0
            : StaticMethods.removeSeparatorFromNumber(productOneSaleController),
        priceOfMajorSale: productMajorSaleController.text.isEmpty
            ? 0
            : StaticMethods.removeSeparatorFromNumber(
                productMajorSaleController),
        mainUnit: units[productMainUnit],
        category: product.category,
      );
      var response = await updateProduct(newProduct);
      if (response.data == null) {
        StaticMethods.showSnackBar(
          title: 'خطا!',
          description: response.error!,
        );
        return;
      } //
      else {
        Get.back();
        resetProductScreen(context);
        getProducts();
        update();
        StaticMethods.showSnackBar(
          title: 'تبریک!',
          description: 'محصول ${response.data!.name} با موفقیت ویرایش شد.',
          color: kLightGreenColor,
        );
      }
    }
  }

  void addNewCategory() async {
    String categoryName = categoryNameController.text.trim();
    if (categoryName.isEmpty) {
      Future.delayed(
        const Duration(milliseconds: 300),
        () {
          StaticMethods.showSnackBar(
              title: 'خطا!', description: 'لطفا نام را وارد کنید.');
        },
      );
    } //
    else {
      var response =
          await _saveCategoryUseCase(CategoryParams(name: categoryName));
      if (response.data == null) {
        StaticMethods.showSnackBar(
          title: 'خطا!',
          description: response.error!,
        );
      } //
      else {
        Get.back();
        StaticMethods.showSnackBar(
          title: 'تبریک!',
          description: 'دسته جدید با موفقیت ثبت شد.',
          color: kLightGreenColor,
        );
        categoryNameController.clear();
        getCategories();
        update();
      }
    }
  }

  void navigateToCategory(
      String categoryName, bool selectProduct, bool fromSearch) {
    Get.to(
      () => ProductFolderScreen(
        categoryName: categoryName,
        selectProduct: selectProduct,
        fromSearch: fromSearch,
      ),
    );
  }

  void updateCategory(CategoryEntity category) async {
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
      var response = await _updateCategoryUseCase(
        CategoryParams(
          id: category.id,
          name: categoryName,
        ),
      );
      if (response.data == null) {
        StaticMethods.showSnackBar(
          title: 'خطا!',
          description: response.error!,
        );
      } //
      else {
        categoryNameController.clear();
        StaticMethods.showSnackBar(
          title: 'تبریک!',
          description: 'دسته $categoryName با موفقیت ویرایش شد.',
          color: kLightGreenColor,
        );
        for (var value in products) {
          updateProduct(
            ProductParams(
              id: value.id,
              category: response.data,
            ),
          );
        }
        getCategories();
        getProducts();
      }
    }
  }

  void deleteCategory(CategoryEntity category) async {
    var response = _getAllProductUseCase();
    for (var item in response.data!) {
      if (item.category!.name == category.name) {
        await _deleteProductUseCase(item.id!);
      }
    }
    await _deleteCategoryUseCase(category.id!);
    getCategories();
    getProducts();
    update();
  }

  void deleteProduct(int id) async {
    await _deleteProductUseCase(id);
    getProducts();
    update();
  }

  Future<UnitOfProductEntity?> saveUnitOfProduct(String unitName) async {
    var response =
        await _saveUnitOfProductUseCase(UnitOfProductParams(name: unitName));
    if (response.data == null) {
      StaticMethods.showSnackBar(title: 'خطا', description: response.error!);
      return null;
    } //
    else {
      return response.data;
    }
  }

  Future<String?> deleteUnitOfProduct(int id) async {
    var response = await _deleteUnitOfProductUseCase(id);
    if (response.data == null) {
      StaticMethods.showSnackBar(
        title: 'خطا!',
        description: response.error!,
      );
      return null;
    } //
    else {
      return response.data!;
    }
  }

  Future<UnitOfProductEntity?> updateUnitOfProduct(
      int unitId, String unitName) async {
    var response = await _updateUnitOfProductUseCase(
      UnitOfProductParams(
        id: unitId,
        name: unitName,
      ),
    );
    if (response.data == null) {
      StaticMethods.showSnackBar(
        title: 'خطا!',
        description: response.error!,
      );
      return null;
    } //
    else {
      return response.data;
    }
  }

  UnitOfProductEntity? getByNameUnitOfProduct(String name) {
    var response = _getByNameUnitOfProductUseCase(name);
    if (response.data == null) {
      StaticMethods.showSnackBar(
        title: 'خطا!',
        description: response.error!,
      );
      return null;
    } //
    else {
      return response.data;
    }
  }

  void saveUnit() async {
    String name = unitNameController.text.trim();
    if (name.isEmpty) {
      StaticMethods.showSnackBar(
        title: 'خطا!',
        description: 'لطفا نام را وارد کنید.',
      );
    } //
    else {
      for (var item in units) {
        if (item.name == name) {
          StaticMethods.showSnackBar(
            title: 'خطا!',
            description: 'نام وارد شده تکراری می باشد.',
          );
          return;
        }
      }
      UnitOfProductEntity? unit = await saveUnitOfProduct(name);
      if (unit != null) {
        resetUnitScreen();
        getUnitOfProduct();
        productUnitList = getUnitList();
        StaticMethods.showSnackBar(
          title: 'تبریک!',
          description: '${unit.name} با موفقیت اضافه شد.',
          color: kLightGreenColor,
        );
      }
    }
  }

  void deleteUnit(int id) async {
    String? unitName = await deleteUnitOfProduct(id);
    if (unitName != null) {
      Get.back();
      getUnitOfProduct();
      productUnitList = getUnitList();
      StaticMethods.showSnackBar(
        title: 'تبریک!',
        description: '$unitName با موفقیت حذف شد.',
        color: kLightGreenColor,
      );
      resetUnitScreen();
    }
  }

  void editUnit(UnitOfProductEntity unit) {
    editUnitId = unit.id!;
    unitNameController.text = unit.name!;
    unitNode.requestFocus();
    update();
  }

  updateUnit() async {
    String name = unitNameController.text.trim();
    if (name.isEmpty) {
      StaticMethods.showSnackBar(
        title: 'خطا!',
        description: 'لطفا نام را وارد کنید.',
      );
    } //
    else {
      for (var item in units) {
        if (item.name == name) {
          StaticMethods.showSnackBar(
            title: 'خطا!',
            description: 'نام وارد شده تکراری می باشد.',
          );
          return;
        }
      }
      UnitOfProductEntity? unit = await updateUnitOfProduct(editUnitId, name);
      if (unit != null) {
        resetUnitScreen();
        getUnitOfProduct();
        productUnitList = getUnitList();
        StaticMethods.showSnackBar(
          title: 'تبریک!',
          description: '${unit.name} با موفقیت ویرایش شد.',
          color: kLightGreenColor,
        );
      }
    }
  }

  void resetUnitScreen() {
    unitNode.unfocus();
    editUnitId = -1;
    unitNameController.clear();
    update();
  }

  void sortProducts(int index) {
    switch (index) {
      case 0:
        products.sort(
          (a, b) => a.name!.compareTo(b.name!),
        );
        break;
      case 1:
        products.sort(
          (a, b) => b.count!.compareTo(a.count!),
        );
        break;
      case 2:
        products.sort(
          (a, b) => a.count!.compareTo(b.count!),
        );
        break;
    }
    update();
  }

  void moveProductToCategory(
      ProductEntity product, CategoryEntity category) async {
    var response = await updateProduct(
      ProductParams(
        id: product.id,
        category: category,
      ),
    );
    if (response.data == null) {
      StaticMethods.showSnackBar(
        title: 'خطا!',
        description: response.error!,
      );
      return;
    } //
    else {
      getCategories();
      getProducts();
      update();
      StaticMethods.showSnackBar(
        title: 'تبریک!',
        description:
            'محصول ${product.name} با موفقیت به ${category.name} منتقل شد.',
        color: kLightGreenColor,
      );
    }
  }
}
