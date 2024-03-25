import 'package:hesab_ban/app/core/db_helper/db_helper.dart';
import 'package:hesab_ban/app/core/utils/constants.dart';
import 'package:hesab_ban/app/features/feature_cash/data/models/cash_model.dart';
import 'package:hesab_ban/app/features/feature_check/data/models/check_model.dart';
import 'package:hesab_ban/app/features/feature_factor/data/models/factor_model.dart';
import 'package:hive/hive.dart';

class FactorDB extends DBHelper<Factor> {
  final _factorBox = Hive.box<Factor>(Constants.factorBox);
  final _cashBox = Hive.box<Cash>(Constants.cashBox);
  final _checkBox = Hive.box<Check>(Constants.checksBox);

  @override
  Future<void> delete(int id) async {
    Factor factor = getById(id)!;
    await Future.forEach(factor.cashesId!, (item) async {
      Cash cash = _cashBox.get(item)!;
      cash.factorId = null;
      await cash.save();
    });
    await Future.forEach(factor.checksId!, (item) async {
      Check check = _checkBox.get(item)!;
      check.factorId = null;
      await check.save();
    });
    await _factorBox.delete(id);
  }

  @override
  List<Factor> getAll() {
    return _factorBox.values
        .where((factor) =>
            factor.typeOfFactor == TypeOfFactor.oneSale ||
            factor.customer?.isActive == true)
        .toList();
  }

  @override
  Factor? getById(int id) {
    return _factorBox.get(id);
  }

  @override
  Future<void> save(Factor value) async {
    if (_factorBox.isEmpty) {
      value.id = 1;
      await _factorBox.put(1, value);
    } //
    else {
      final int key = await _factorBox.add(value);
      value.id = key;
      await value.save();
    }
  }

  @override
  Future<void> update(Factor value) async {
    Factor? factor = getById(value.id!);
    if (factor != null) {
      factor.customer = value.customer ?? factor.customer;
      factor.factorRows = value.factorRows ?? factor.factorRows;
      factor.factorSum = value.factorSum ?? factor.factorSum;
      factor.factorDate = value.factorDate ?? factor.factorDate;
      factor.costs = value.costs ?? factor.costs;
      factor.costsLabel = value.costsLabel ?? factor.costsLabel;
      factor.tax = value.tax ?? factor.tax;
      factor.offer = value.offer ?? factor.offer;
      factor.checksId = value.checksId ?? factor.checksId;
      factor.cashesId = value.cashesId ?? factor.cashesId;
      factor.description = value.description ?? factor.description;
      factor.save();
    }
  }
}
