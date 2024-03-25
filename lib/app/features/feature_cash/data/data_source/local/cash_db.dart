import 'package:hesab_ban/app/core/db_helper/db_helper.dart';
import 'package:hesab_ban/app/core/utils/constants.dart';
import 'package:hesab_ban/app/features/feature_cash/data/models/cash_model.dart';
import 'package:hesab_ban/app/features/feature_factor/data/models/factor_model.dart';
import 'package:hive/hive.dart';

class CashDB extends DBHelper<Cash> {
  final _cashBox = Hive.box<Cash>(Constants.cashBox);
  final _factorBox = Hive.box<Factor>(Constants.factorBox);

  @override
  Future<void> delete(int id) async {
    Cash? cash = getById(id);
    if (cash != null) {
      int? factorId = cash.factorId;
      if (factorId != null) {
        Factor? factor = _factorBox.get(id);
        if (factor != null) {
          factor.cashesId!.remove(id);
          await factor.save();
        }
      }
      await _cashBox.delete(id);
    }
  }

  @override
  List<Cash> getAll() {
    return _cashBox.values.toList();
  }

  @override
  Cash? getById(int id) {
    return _cashBox.get(id);
  }

  @override
  Future<void> save(Cash value) async {
    final int key = await _cashBox.add(value);
    value.id = key;
    await value.save();
  }

  @override
  Future<void> update(Cash value) async {
    await _cashBox.put(value.id, value);
  }
}
