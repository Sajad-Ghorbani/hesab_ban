import 'package:hesab_ban/app/core/db_helper/db_helper.dart';
import 'package:hesab_ban/app/core/utils/constants.dart';
import 'package:hesab_ban/app/features/feature_product/data/models/unit_of_product.dart';
import 'package:hive/hive.dart';

class UnitDb extends DBHelper<UnitOfProduct>{
  final _unitBox = Hive.box<UnitOfProduct>(Constants.unitOfProductBox);
  @override
  Future<void> delete(int id)async {
    await _unitBox.delete(id);
  }

  @override
  List<UnitOfProduct> getAll() {
    return _unitBox.values.toList();
  }

  @override
  UnitOfProduct? getById(int id) {
    return _unitBox.get(id);
  }

  @override
  Future<void> save(UnitOfProduct value) async{
    final int key = await _unitBox.add(value);
    value.id = key;
    await value.save();
  }

  @override
  Future<void> update(UnitOfProduct value)async {
    await _unitBox.put(value.id, value);
  }

  UnitOfProduct? getByName(String name) {
    return _unitBox.values.firstWhere((element) => element.name == name);
  }
}