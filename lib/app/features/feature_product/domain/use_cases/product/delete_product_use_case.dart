import 'package:hesab_ban/app/core/resources/data_state.dart';
import 'package:hesab_ban/app/core/use_case/use_case.dart';
import 'package:hesab_ban/app/features/feature_product/domain/repository/product_repository.dart';

class DeleteProductUseCase extends AsyncUseCase<DataState<String>, int> {
  final ProductRepository _productRepository;

  DeleteProductUseCase(this._productRepository);

  @override
  Future<DataState<String>> call(int params) async {
    return await _productRepository.deleteProduct(params);
  }
}
