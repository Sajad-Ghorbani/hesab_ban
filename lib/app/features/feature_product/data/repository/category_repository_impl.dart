import 'package:hesab_ban/app/core/resources/data_state.dart';
import 'package:hesab_ban/app/features/feature_product/data/data_source/local/category_db.dart';
import 'package:hesab_ban/app/features/feature_product/data/models/category_model.dart';
import 'package:hesab_ban/app/features/feature_product/domain/entities/category_entity.dart';
import 'package:hesab_ban/app/features/feature_product/domain/repository/category_repository.dart';

class CategoryRepositoryImpl extends CategoryRepository {
  final CategoryDB _categoryDB;

  CategoryRepositoryImpl(this._categoryDB);

  @override
  Future<DataState<String>> deleteCategory(int id) async {
    try {
      var response = await getCategoryById(id);
      CategoryEntity categoryEntity = response.data!;
      await _categoryDB.delete(id);
      return DataSuccess(categoryEntity.name);
    } //
    catch (e) {
      return const DataFailed('خطایی در پاک کردن دسته بندی به وجود آمده است.');
    }
  }

  @override
  DataState<List<CategoryEntity>> getAllCategory() {
    try {
      List<Category> categories = _categoryDB.getAll();
      List<CategoryEntity> categoriesEntity = [];
      for (var value in categories) {
        categoriesEntity.add(value.toEntity());
      }
      return DataSuccess(categoriesEntity);
    } //
    catch (e) {
      return const DataFailed(
          'خطایی در دریافت اطلاعات دسته بندی ها به وجود آمده است.');
    }
  }

  @override
  Future<DataState<CategoryEntity?>> getCategoryById(int id) async {
    try {
      var category = _categoryDB.getById(id);
      return DataSuccess(category?.toEntity());
    } //
    catch (e) {
      return const DataFailed(
          'خطایی در دریافت اطلاعات دسته بندی به وجود آمده است.');
    }
  }

  @override
  Future<DataState<CategoryEntity>> saveCategory(
      CategoryEntity categoryEntity) async {
    try {
      Category category = Category.fromEntity(categoryEntity);
      await _categoryDB.save(category);
      return DataSuccess(category.toEntity());
    } //
    catch (e) {
      return const DataFailed('خطایی در ثبت دسته بندی به وجود آمده است.');
    }
  }

  @override
  Future<DataState<CategoryEntity>> updateCategory(
      CategoryEntity categoryEntity) async {
    try {
      Category category = Category.fromEntity(categoryEntity);
      await _categoryDB.update(category);
      return DataSuccess(categoryEntity);
    } //
    catch (e) {
      return const DataFailed(
          'خطایی در بروزرسانی اطلاعات دسته بندی به وجود آمده است.');
    }
  }

  @override
  Future<DataState<CategoryEntity?>> getCategoryByName(String name) async {
    try {
      var category = await _categoryDB.getByName(name);
      return DataSuccess(category?.toEntity());
    } //
    catch (e) {
      return const DataFailed(
          'خطایی در دریافت اطلاعات دسته بندی به وجود آمده است.');
    }
  }
}
