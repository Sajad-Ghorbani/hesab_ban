import 'package:hesab_ban/app/core/resources/data_state.dart';
import 'package:hesab_ban/app/features/feature_product/domain/entities/category_entity.dart';

abstract class CategoryRepository{
  Future<DataState<CategoryEntity>> saveCategory(CategoryEntity categoryEntity);

  Future<DataState<CategoryEntity>> updateCategory(CategoryEntity categoryEntity);

  Future<DataState<String>> deleteCategory(int id);

  Future<DataState<CategoryEntity?>> getCategoryById(int id);

  Future<DataState<CategoryEntity?>> getCategoryByName(String name);

  DataState<List<CategoryEntity>> getAllCategory();
}