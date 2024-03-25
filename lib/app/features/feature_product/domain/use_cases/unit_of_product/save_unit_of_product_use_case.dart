import 'package:hesab_ban/app/core/params/unit_of_product_params.dart';
import 'package:hesab_ban/app/core/resources/data_state.dart';
import 'package:hesab_ban/app/core/use_case/use_case.dart';
import 'package:hesab_ban/app/features/feature_product/domain/entities/unit_of_product_entity.dart';
import 'package:hesab_ban/app/features/feature_product/domain/repository/unit_of_product_repository.dart';

class SaveUnitOfProductUseCase
    extends AsyncUseCase<DataState<UnitOfProductEntity>, UnitOfProductParams> {
  final UnitOfProductRepository _unitOfProductRepository;

  SaveUnitOfProductUseCase(this._unitOfProductRepository);

  @override
  Future<DataState<UnitOfProductEntity>> call(UnitOfProductParams params)async {
    return await _unitOfProductRepository
        .saveUnitOfProduct(UnitOfProductEntity(name: params.name));
  }
}
