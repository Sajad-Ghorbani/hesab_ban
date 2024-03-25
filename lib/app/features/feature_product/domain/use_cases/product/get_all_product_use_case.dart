import 'package:hesab_ban/app/core/resources/data_state.dart';
import 'package:hesab_ban/app/core/use_case/use_case.dart';
import 'package:hesab_ban/app/features/feature_product/domain/entities/product_entity.dart';
import 'package:hesab_ban/app/features/feature_product/domain/repository/product_repository.dart';

class GetAllProductUseCase
    extends UseCase<DataState<List<ProductEntity>>> {
  final ProductRepository _productRepository;

  GetAllProductUseCase(this._productRepository);

  @override
  DataState<List<ProductEntity>> call() {
    return _productRepository.getAllProduct();
  }
}
