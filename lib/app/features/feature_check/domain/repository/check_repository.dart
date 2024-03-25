import 'package:hesab_ban/app/core/resources/data_state.dart';
import 'package:hesab_ban/app/features/feature_check/domain/entities/check_entity.dart';

abstract class CheckRepository {
  Future<DataState<CheckEntity>> saveCheck(CheckEntity checkEntity);

  Future<DataState<CheckEntity>> updateCheck(CheckEntity checkEntity);

  Future<DataState<CheckEntity>> deleteCheck(int id);

  DataState<List<CheckEntity>> getAllCheck();
}
