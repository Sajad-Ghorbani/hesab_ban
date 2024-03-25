import 'package:hesab_ban/app/core/db_helper/db_helper.dart';
import 'package:hesab_ban/app/core/utils/constants.dart';
import 'package:hesab_ban/app/features/feature_product/data/models/category_model.dart';
import 'package:hive/hive.dart';

class CategoryDB extends DBHelper<Category> {
  final _categoryBox = Hive.box<Category>(Constants.productCategoryBox);

  @override
  Future<void> delete(int id) async {
    await _categoryBox.delete(id);
  }

  @override
  List<Category> getAll()  {
    return _categoryBox.values.toList();
  }

  @override
  Category? getById(int id)  {
    return _categoryBox.get(id);
  }

  @override
  Future<void> save(Category value) async {
    final int key = await _categoryBox.add(value);
    value.id = key;
    await value.save();
  }

  @override
  Future<void> update(Category value) async {
    await _categoryBox.put(value.id, value);
  }

  Future<Category?> getByName(String name) async {
    return _categoryBox.values.firstWhere((element) => element.name == name);
  }
}
