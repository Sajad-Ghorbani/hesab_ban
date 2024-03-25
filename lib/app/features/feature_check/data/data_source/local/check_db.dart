import 'package:hesab_ban/app/core/db_helper/db_helper.dart';
import 'package:hesab_ban/app/core/utils/constants.dart';
import 'package:hesab_ban/app/features/feature_check/data/models/check_model.dart';
import 'package:hive/hive.dart';

class CheckDB extends DBHelper<Check> {
  final _checkBox = Hive.box<Check>(Constants.checksBox);

  @override
  Future<void> save(Check value) async {
    final int key = await _checkBox.add(value);
    value.id = key;
    await value.save();
  }

  Future<bool> existCheckNumber(String number) async {
    return _checkBox.values.any((element) => element.checkNumber == number);
  }

  @override
  Future<void> update(Check value) async {
    await _checkBox.put(value.id, value);
  }

  @override
  Future<void> delete(int id) async {
    await _checkBox.delete(id);
  }

  @override
  Check? getById(int id) {
    return _checkBox.get(id);
  }

  @override
  List<Check> getAll()  {
    for(var value in _checkBox.values){
      if(value.checkAmount == null){
        _checkBox.delete(value.key);
      }
    }
    return _checkBox.values.toList();
  }
}
