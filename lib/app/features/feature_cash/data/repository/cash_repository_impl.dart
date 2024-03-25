import 'package:hesab_ban/app/core/resources/data_state.dart';
import 'package:hesab_ban/app/features/feature_cash/data/data_source/local/cash_db.dart';
import 'package:hesab_ban/app/features/feature_cash/data/models/cash_model.dart';
import 'package:hesab_ban/app/features/feature_cash/domain/entities/cash_entity.dart';
import 'package:hesab_ban/app/features/feature_cash/domain/repository/cash_repository.dart';

class CashRepositoryImpl extends CashRepository {
  final CashDB _cashDB;

  CashRepositoryImpl(this._cashDB);

  @override
  Future<DataState<CashEntity>> deleteCash(int id) async {
    try {
      var response = _cashDB.getById(id);
      await _cashDB.delete(id);
      return DataSuccess(response!.toEntity());
    } //
    catch (_) {
      return const DataFailed('خطایی در حذف وجه نقد به وجود آمده است.');
    }
  }

  @override
  DataState<List<CashEntity>> getAllCash() {
    try {
      List<Cash> cashes = _cashDB.getAll();
      List<CashEntity> cashEntities = [];
      for (var value in cashes) {
        cashEntities.add(value.toEntity());
      }
      return DataSuccess(cashEntities);
    } //
    catch (_) {
      return const DataFailed('خطایی در دریافت لیست وجه نقد به وجود آمده است.');
    }
  }

  @override
  Future<DataState<CashEntity>> saveCash(CashEntity cashEntity) async {
    try {
      Cash cash = Cash.fromEntity(cashEntity);
      await _cashDB.save(cash);
      return DataSuccess(cash.toEntity());
    } catch (e) {
      return const DataFailed('خطایی در ثبت وجه نقد به وجود آمده است.');
    }
  }

  @override
  Future<DataState<CashEntity>> updateCash(CashEntity cashEntity) async {
    try {
      Cash cash = Cash.fromEntity(cashEntity);
      await _cashDB.update(cash);
      return DataSuccess(cashEntity);
    } catch (e) {
      return const DataFailed('خطایی در  ویرایش وجه نقد به وجود آمده است.');
    }
  }
}
