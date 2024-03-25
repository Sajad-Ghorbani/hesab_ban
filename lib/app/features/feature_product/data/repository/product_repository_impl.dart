import 'package:hesab_ban/app/core/resources/data_state.dart';
import 'package:hesab_ban/app/features/feature_product/data/data_source/local/product_db.dart';
import 'package:hesab_ban/app/features/feature_product/data/models/product_model.dart';
import 'package:hesab_ban/app/features/feature_product/domain/entities/product_entity.dart';
import 'package:hesab_ban/app/features/feature_product/domain/repository/product_repository.dart';

class ProductRepositoryImpl extends ProductRepository {
  final ProductDB _productDB;

  ProductRepositoryImpl(this._productDB);

  @override
  Future<DataState<String>> deleteProduct(int id) async {
    try {
      var response = await getProductById(id);
      ProductEntity productEntity = response.data!;
      await _productDB.delete(id);
      return DataSuccess(productEntity.name);
    } //
    catch (e) {
      return const DataFailed('خطایی در پاک کردن محصول به وجود آمده است.');
    }
  }

  @override
  DataState<List<ProductEntity>> getAllProduct() {
    try {
      List<Product> products = _productDB.getAll();
      List<ProductEntity> productsEntity = [];
      for (var value in products) {
        productsEntity.add(value.toEntity());
      }
      return DataSuccess(productsEntity);
    } //
    catch (e) {
      return const DataFailed(
          'خطایی در دریافت اطلاعات محصولات به وجود آمده است.');
    }
  }

  @override
  Future<DataState<ProductEntity>> getProductById(int id) async {
    try {
      var product = _productDB.getById(id);
      return DataSuccess(product?.toEntity());
    } //
    catch (e) {
      return const DataFailed(
          'خطایی در دریافت اطلاعات محصول به وجود آمده است.');
    }
  }

  @override
  Future<DataState<ProductEntity>> saveProduct(
      ProductEntity productEntity) async {
    try {
      Product product = Product.fromEntity(productEntity);
      if (await _productDB.existProductName(product.name!)) {
        return const DataFailed('نام محصول وارد شده تکراری می باشد.');
      }
      await _productDB.save(product);
      return DataSuccess(product.toEntity());
    } //
    catch (e) {
      return const DataFailed('خطایی در ثبت محصول به وجود آمده است.');
    }
  }

  @override
  Future<DataState<ProductEntity>> updateProduct(
      ProductEntity productEntity) async {
    try {
      Product product = Product.fromEntity(productEntity);
      await _productDB.update(product);
      return DataSuccess(productEntity);
    } //
    catch (e) {
      return const DataFailed(
          'خطایی در بروزرسانی اطلاعات محصول به وجود آمده است.');
    }
  }
}
