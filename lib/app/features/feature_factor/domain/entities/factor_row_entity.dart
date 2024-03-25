class FactorRowEntity {
  String productName;
  double productCount;
  int productPriceOfSale;
  int _productSum;
  String productUnit;
  int? priceOfBuy;
  int? priceOfOneSale;

  FactorRowEntity(
    this._productSum, {
    required this.productName,
    required this.productCount,
    required this.productPriceOfSale,
    required this.productUnit,
    this.priceOfBuy,
    this.priceOfOneSale,
  });

  int get productSum {
    if (priceOfBuy != null) {
      _productSum = (productCount * priceOfBuy!.toDouble()).toInt();
    } //
    else {
      _productSum = (productCount * productPriceOfSale.toDouble()).toInt();
    }
    return _productSum;
  }

  @override
  String toString() {
    return '$productName -- $productCount -- $productSum -- $_productSum -- $productUnit -- $productPriceOfSale  -- hashCode => $hashCode --\n $priceOfBuy -- $priceOfOneSale';
  }

  @override
  int get hashCode => productName.hashCode + productCount.hashCode + productSum;

  @override
  bool operator ==(Object other) {
    return other is FactorRowEntity &&
        productName == other.productName &&
        productCount == other.productCount &&
        productSum == other.productSum &&
        productPriceOfSale == other.productPriceOfSale &&
        priceOfBuy == other.priceOfBuy &&
        priceOfOneSale == other.priceOfOneSale;
  }
}
