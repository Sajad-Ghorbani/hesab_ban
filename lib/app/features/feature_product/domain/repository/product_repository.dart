import 'package:hesab_ban/app/core/resources/data_state.dart';
import 'package:hesab_ban/app/features/feature_product/domain/entities/product_entity.dart';

abstract class ProductRepository {
  Future<DataState<ProductEntity>> saveProduct(ProductEntity productEntity);

  Future<DataState<ProductEntity>> updateProduct(ProductEntity productEntity);

  Future<DataState<String>> deleteProduct(int id);

  Future<DataState<ProductEntity?>> getProductById(int id);

  DataState<List<ProductEntity>> getAllProduct();
}