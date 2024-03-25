import 'package:hesab_ban/app/core/params/cash_params.dart';
import 'package:hesab_ban/app/core/resources/data_state.dart';
import 'package:hesab_ban/app/core/use_case/use_case.dart';
import 'package:hesab_ban/app/features/feature_cash/domain/entities/cash_entity.dart';
import 'package:hesab_ban/app/features/feature_cash/domain/repository/cash_repository.dart';

class SaveCashUseCase extends AsyncUseCase<DataState<CashEntity>, CashParams> {
  final CashRepository _cashRepository;

  SaveCashUseCase(this._cashRepository);

  @override
  Future<DataState<CashEntity>> call(CashParams params) {
    CashEntity cash = CashEntity(
      customer: params.cashCustomer,
      cashDate: params.cashDate,
      cashAmount: params.cashAmount,
      factorId: params.factorId,
    );
    return _cashRepository.saveCash(cash);
  }
}
