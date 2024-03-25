import 'package:hesab_ban/app/core/resources/data_state.dart';
import 'package:hesab_ban/app/features/feature_factor/domain/entities/factor_entity.dart';

abstract class FactorRepository {
  Future<DataState<FactorEntity>> saveFactor(FactorEntity factorEntity);

  Future<DataState<FactorEntity>> updateFactor(FactorEntity factorEntity);

  DataState<String> deleteFactor(int id);

  DataState<List<FactorEntity>> getAllFactors();
}
