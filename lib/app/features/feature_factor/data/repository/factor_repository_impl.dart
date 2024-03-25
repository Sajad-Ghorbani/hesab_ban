import 'package:hesab_ban/app/core/resources/data_state.dart';
import 'package:hesab_ban/app/features/feature_factor/data/data_source/local/factor_db.dart';
import 'package:hesab_ban/app/features/feature_factor/data/models/factor_model.dart';
import 'package:hesab_ban/app/features/feature_factor/domain/entities/factor_entity.dart';
import 'package:hesab_ban/app/features/feature_factor/domain/repository/factor_repository.dart';

class FactorRepositoryImpl extends FactorRepository{
  final FactorDB _factorDB;

  FactorRepositoryImpl(this._factorDB);

  @override
  DataState<String> deleteFactor(int id) {
    try {
      Factor? factor = _factorDB.getById(id);
      _factorDB.delete(id);
      return DataSuccess(factor!.id.toString());
    } on Exception catch (_) {
      return const DataFailed('خطایی در حذف فاکتور رخ داده است.');
    }
  }

  @override
  DataState<List<FactorEntity>> getAllFactors() {
    try {
      List<Factor> factors = _factorDB.getAll();
      List<FactorEntity> factorsEntity = [];
      for (var value in factors) {
        factorsEntity.add(value.toEntity());
      }
      return DataSuccess(factorsEntity);
    } on Exception catch (_) {
      return const DataFailed('خطایی در دریافت لیست فاکتورها رخ داده است.');
    }
  }

  @override
  Future<DataState<FactorEntity>> saveFactor(FactorEntity factorEntity) async{
    try {
      Factor factor = Factor.fromEntity(factorEntity);
      await _factorDB.save(factor);
      return DataSuccess(factor.toEntity());
    } on Exception catch (_) {
      return const DataFailed('خطایی در ثبت فاکتور جدید رخ داده است.');
    }
  }

  @override
  Future<DataState<FactorEntity>> updateFactor(FactorEntity factorEntity) async{
    try {
      Factor factor = Factor.fromEntity(factorEntity);
      await _factorDB.update(factor);
      return DataSuccess(factorEntity);
    } on Exception catch (_) {
      return const DataFailed('خطایی در بروزرسانی فاکتور رخ داده است.');
    }
  }
}