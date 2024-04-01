import 'dart:developer';

import 'package:hesab_ban/app/core/resources/data_state.dart';
import 'package:hesab_ban/app/features/feature_product/data/data_source/local/unit_db.dart';
import 'package:hesab_ban/app/features/feature_product/data/models/unit_of_product.dart';
import 'package:hesab_ban/app/features/feature_product/domain/entities/unit_of_product_entity.dart';
import 'package:hesab_ban/app/features/feature_product/domain/repository/unit_of_product_repository.dart';

class UnitOfProductRepositoryImpl extends UnitOfProductRepository {
  final UnitDb _unitDb;

  UnitOfProductRepositoryImpl(this._unitDb);

  @override
  Future<DataState<String>> deleteUnitOfProduct(int id) async {
    try {
      var response = getUnitOfProductById(id);
      UnitOfProductEntity unitOfProductEntity = response.data!;
      await _unitDb.delete(id);
      return DataSuccess(unitOfProductEntity.name);
    } //
    on Exception catch (e) {
      log(e.toString());
      return const DataFailed('خطایی در پاک کردن واحد کالا به وجود آمده است.');
    }
  }

  @override
  DataState<List<UnitOfProductEntity>> getAllUnitOfProduct() {
    try {
      List<UnitOfProduct> units = _unitDb.getAll();
      List<UnitOfProductEntity> unitsEntity = [];
      for (var value in units) {
        unitsEntity.add(value.toEntity());
      }
      return DataSuccess(unitsEntity);
    } //
    on Exception catch (e) {
      log(e.toString());
      return const DataFailed(
          'خطایی در دریافت اطلاعات واحد کالاها به وجود آمده است.');
    }
  }

  @override
  DataState<UnitOfProductEntity?> getUnitOfProductById(int id) {
    try {
      var unit = _unitDb.getById(id);
      return DataSuccess(unit?.toEntity());
    } //
    on Exception catch (e) {
      log(e.toString());
      return const DataFailed('خطایی در دیافت واحد کالا به وجود آمده است.');
    }
  }

  @override
  DataState<UnitOfProductEntity?> getUnitOfProductByName(String name) {
    var unit = _unitDb.getByName(name);
    return DataSuccess(unit?.toEntity());
  }

  @override
  Future<DataState<UnitOfProductEntity>> saveUnitOfProduct(
      UnitOfProductEntity unitOfProductEntity) async {
    try {
      var unit = UnitOfProduct.fromEntity(unitOfProductEntity);
      await _unitDb.save(unit);
      return DataSuccess(unit.toEntity());
    } //
    on Exception catch (e) {
      log(e.toString());
      return const DataFailed('خطایی در ثبت واحد کالا به وجود آمده است.');
    }
  }

  @override
  Future<DataState<UnitOfProductEntity>> updateUnitOfProduct(
      UnitOfProductEntity unitOfProductEntity) async{
    try {
      var unit = UnitOfProduct.fromEntity(unitOfProductEntity);
      await _unitDb.update(unit);
      return DataSuccess(unit.toEntity());
    } //
    on Exception catch (e) {
      log(e.toString());
      return const DataFailed('خطایی در بروزرسانی واحد کالا به وجود آمده است.');
    }
  }
}
