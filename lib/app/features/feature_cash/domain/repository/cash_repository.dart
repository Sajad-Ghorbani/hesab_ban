import 'package:hesab_ban/app/core/resources/data_state.dart';
import 'package:hesab_ban/app/features/feature_cash/domain/entities/cash_entity.dart';

abstract class CashRepository{
  Future<DataState<CashEntity>> saveCash(CashEntity cashEntity);

  Future<DataState<CashEntity>> updateCash(CashEntity cashEntity);

  Future<DataState<CashEntity>> deleteCash(int id);

  DataState<List<CashEntity>> getAllCash();
}