import 'package:hesab_ban/app/core/resources/data_state.dart';
import 'package:hesab_ban/app/core/use_case/use_case.dart';
import 'package:hesab_ban/app/features/feature_cash/domain/entities/cash_entity.dart';
import 'package:hesab_ban/app/features/feature_cash/domain/repository/cash_repository.dart';

class DeleteCashUseCase extends AsyncUseCase<DataState<CashEntity>, int>{
  final CashRepository _cashRepository;

  DeleteCashUseCase(this._cashRepository);

  @override
  Future<DataState<CashEntity>> call(int params) {
    return _cashRepository.deleteCash(params);
  }
}