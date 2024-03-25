import 'package:hesab_ban/app/core/resources/data_state.dart';
import 'package:hesab_ban/app/core/use_case/use_case.dart';
import 'package:hesab_ban/app/features/feature_product/domain/entities/category_entity.dart';
import 'package:hesab_ban/app/features/feature_product/domain/repository/category_repository.dart';

class GetCategoryByNameUseCase extends AsyncUseCase<DataState<CategoryEntity?>,String>{
  final CategoryRepository _categoryRepository;

  GetCategoryByNameUseCase(this._categoryRepository);

  @override
  Future<DataState<CategoryEntity?>> call(String params) {
    return _categoryRepository.getCategoryByName(params);
  }

}