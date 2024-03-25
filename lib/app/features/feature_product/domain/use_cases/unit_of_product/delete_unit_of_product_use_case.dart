import 'package:hesab_ban/app/core/resources/data_state.dart';
import 'package:hesab_ban/app/core/use_case/use_case.dart';
import 'package:hesab_ban/app/features/feature_product/domain/repository/unit_of_product_repository.dart';

class DeleteUnitOfProductUseCase extends AsyncUseCase<DataState<String>, int> {
  final UnitOfProductRepository _unitOfProductRepository;

  DeleteUnitOfProductUseCase(this._unitOfProductRepository);

  @override
  Future<DataState<String>> call(int params) async {
    return await _unitOfProductRepository.deleteUnitOfProduct(params);
  }
}
