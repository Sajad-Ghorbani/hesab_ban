import 'package:hesab_ban/app/core/db_helper/db_helper.dart';
import 'package:hesab_ban/app/core/utils/constants.dart';
import 'package:hesab_ban/app/features/feature_product/data/models/product_model.dart';
import 'package:hive/hive.dart';

class ProductDB extends DBHelper<Product> {
  final _productBox = Hive.box<Product>(Constants.allProductBox);

  @override
  Future<void> delete(int id) async {
    await _productBox.delete(id);
  }

  @override
  List<Product> getAll() {
    return _productBox.values.toList();
  }

  @override
  Product? getById(int id) {
    return _productBox.get(id);
  }

  @override
  Future<void> save(Product value) async {
    final int key = await _productBox.add(value);
    value.id = key;
    await value.save();
  }

  @override
  Future<void> update(Product value) async {
    Product? product = _productBox.get(value.id);
    if (product != null) {
      product.name = value.name ?? product.name;
      product.priceOfBuy = value.priceOfBuy ?? product.priceOfBuy;
      product.priceOfOneSale = value.priceOfOneSale ?? product.priceOfOneSale;
      product.priceOfMajorSale =
          value.priceOfMajorSale ?? product.priceOfMajorSale;
      product.mainUnitOfProduct = value.mainUnitOfProduct ?? product.mainUnitOfProduct;
      product.subCountingUnitOfProduct =
          value.subCountingUnitOfProduct ?? product.subCountingUnitOfProduct;
      product.count = value.count ?? product.count;
      product.unitRatio = value.unitRatio ?? product.unitRatio;
      product.category = value.category ?? product.category;
      await product.save();
    }
  }

  Future<bool> existProductName(String name) async {
    return _productBox.values.any((element) => element.name == name);
  }
}
