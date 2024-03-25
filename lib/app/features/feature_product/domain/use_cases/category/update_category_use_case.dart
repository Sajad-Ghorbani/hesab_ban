import 'package:hesab_ban/app/core/params/category_params.dart';
import 'package:hesab_ban/app/core/resources/data_state.dart';
import 'package:hesab_ban/app/core/use_case/use_case.dart';
import 'package:hesab_ban/app/features/feature_product/domain/entities/category_entity.dart';
import 'package:hesab_ban/app/features/feature_product/domain/repository/category_repository.dart';

class UpdateCategoryUseCase
    extends AsyncUseCase<DataState<CategoryEntity>, CategoryParams> {
  final CategoryRepository _categoryRepository;

  UpdateCategoryUseCase(this._categoryRepository);

  @override
  Future<DataState<CategoryEntity>> call(CategoryParams params) {
    return _categoryRepository.updateCategory(
      CategoryEntity(id: params.id, name: params.name),
    );
  }
}
