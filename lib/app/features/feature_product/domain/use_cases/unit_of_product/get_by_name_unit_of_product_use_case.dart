import 'package:hesab_ban/app/core/resources/data_state.dart';
import 'package:hesab_ban/app/features/feature_product/domain/entities/unit_of_product_entity.dart';
import 'package:hesab_ban/app/features/feature_product/domain/repository/unit_of_product_repository.dart';

class GetByNameUnitOfProductUseCase {
  final UnitOfProductRepository _unitOfProductRepository;

  GetByNameUnitOfProductUseCase(this._unitOfProductRepository);

  DataState<UnitOfProductEntity?> call(String name) {
    return _unitOfProductRepository.getUnitOfProductByName(name);
  }
}
