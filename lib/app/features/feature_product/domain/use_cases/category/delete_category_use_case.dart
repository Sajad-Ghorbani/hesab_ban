import 'package:hesab_ban/app/core/resources/data_state.dart';
import 'package:hesab_ban/app/core/use_case/use_case.dart';
import 'package:hesab_ban/app/features/feature_product/domain/repository/category_repository.dart';

class DeleteCategoryUseCase extends AsyncUseCase<DataState<String>, int> {
  final CategoryRepository _categoryRepository;

  DeleteCategoryUseCase(this._categoryRepository);

  @override
  Future<DataState<String>> call(int params) async {
    return _categoryRepository.deleteCategory(params);
  }
}
