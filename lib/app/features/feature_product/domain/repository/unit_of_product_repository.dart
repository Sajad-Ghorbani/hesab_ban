import 'package:hesab_ban/app/core/resources/data_state.dart';
import 'package:hesab_ban/app/features/feature_product/domain/entities/unit_of_product_entity.dart';

abstract class UnitOfProductRepository {
  Future<DataState<UnitOfProductEntity>> saveUnitOfProduct(
      UnitOfProductEntity unitOfProductEntity);

  Future<DataState<UnitOfProductEntity>> updateUnitOfProduct(
      UnitOfProductEntity unitOfProductEntity);

  Future<DataState<String>> deleteUnitOfProduct(int id);

  DataState<UnitOfProductEntity?> getUnitOfProductById(int id);

  DataState<UnitOfProductEntity?> getUnitOfProductByName(String name);

  DataState<List<UnitOfProductEntity>> getAllUnitOfProduct();
}
