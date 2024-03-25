import 'package:hesab_ban/app/core/resources/data_state.dart';
import 'package:hesab_ban/app/core/use_case/use_case.dart';
import 'package:hesab_ban/app/features/feature_product/domain/entities/category_entity.dart';
import 'package:hesab_ban/app/features/feature_product/domain/repository/category_repository.dart';

class GetAllCategoryUseCase extends UseCase<DataState<List<CategoryEntity>>>{
  final CategoryRepository _categoryRepository;

  GetAllCategoryUseCase(this._categoryRepository);

  @override
  DataState<List<CategoryEntity>> call() {
    return _categoryRepository.getAllCategory();
  }
}