import 'package:hesab_ban/app/core/resources/data_state.dart';
import 'package:hesab_ban/app/core/use_case/use_case.dart';
import 'package:hesab_ban/app/features/feature_product/domain/entities/unit_of_product_entity.dart';
import 'package:hesab_ban/app/features/feature_product/domain/repository/unit_of_product_repository.dart';

class GetAllUnitOfProductUseCase extends UseCase<DataState<List<UnitOfProductEntity>>>{
  final UnitOfProductRepository _unitOfProductRepository;

  GetAllUnitOfProductUseCase(this._unitOfProductRepository);

  @override
  DataState<List<UnitOfProductEntity>> call() {
    return _unitOfProductRepository.getAllUnitOfProduct();
  }
}