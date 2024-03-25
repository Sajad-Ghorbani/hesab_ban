import 'package:flutter/material.dart';
import 'package:hesab_ban/app/core/resources/data_state.dart';
import 'package:hesab_ban/app/features/feature_check/data/data_source/local/check_db.dart';
import 'package:hesab_ban/app/features/feature_check/data/models/check_model.dart';
import 'package:hesab_ban/app/features/feature_check/domain/entities/check_entity.dart';
import 'package:hesab_ban/app/features/feature_check/domain/repository/check_repository.dart';

class CheckRepositoryImpl extends CheckRepository {
  final CheckDB _checkDb;

  CheckRepositoryImpl(this._checkDb);

  @override
  Future<DataState<CheckEntity>> deleteCheck(int id) async {
    try {
      var response = _checkDb.getById(id);
      await _checkDb.delete(id);
      return DataSuccess(response!.toEntity());
    } //
    catch (e) {
      return const DataFailed('خطایی در حذف چک به وجود آمده است.');
    }
  }

  @override
  DataState<List<CheckEntity>> getAllCheck() {
    try {
      List<Check> checks = _checkDb.getAll();
      List<CheckEntity> checksEntity = [];
      for (var value in checks) {
        checksEntity.add(value.toEntity());
      }
      return DataSuccess(checksEntity);
    } //
    catch (e) {
      return const DataFailed('خطایی در دریافت چک ها به وجود آمده است.');
    }
  }

  @override
  Future<DataState<CheckEntity>> saveCheck(CheckEntity checkEntity) async {
    try {
      Check check = Check.fromEntity(checkEntity);
      await _checkDb.save(check);
      return DataSuccess(check.toEntity());
    } //
    catch (e) {
      debugPrint(e.toString());
      return const DataFailed('خطایی در ثبت چک به وجود آمده است.');
    }
  }

  @override
  Future<DataState<CheckEntity>> updateCheck(CheckEntity checkEntity) async {
    try {
      Check check = Check.fromEntity(checkEntity);
      await _checkDb.update(check);
      return DataSuccess(checkEntity);
    } //
    catch (e) {
      return const DataFailed('خطایی در بروزرسانی چک به وجود آمده است.');
    }
  }
}
