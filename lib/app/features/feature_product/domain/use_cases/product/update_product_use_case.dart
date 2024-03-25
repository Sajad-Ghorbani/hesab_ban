import 'package:hesab_ban/app/core/params/product_params.dart';
import 'package:hesab_ban/app/core/resources/data_state.dart';
import 'package:hesab_ban/app/core/use_case/use_case.dart';
import 'package:hesab_ban/app/features/feature_product/domain/entities/product_entity.dart';
import 'package:hesab_ban/app/features/feature_product/domain/repository/product_repository.dart';

class UpdateProductUseCase
    extends AsyncUseCase<DataState<ProductEntity>, ProductParams> {
  final ProductRepository _productRepository;

  UpdateProductUseCase(this._productRepository);

  @override
  Future<DataState<ProductEntity>> call(ProductParams params) {
    return _productRepository.updateProduct(
      ProductEntity(
        id: params.id,
        name: params.name,
        category: params.category,
        count: params.count,
        mainUnit: params.mainUnit,
        subCountingUnit: params.subCountingUnit,
        priceOfBuy: params.priceOfBuy,
        priceOfMajorSale: params.priceOfMajorSale,
        priceOfOneSale: params.priceOfOneSale,
        unitRatio: params.unitRatio,
      ),
    );
  }
}
