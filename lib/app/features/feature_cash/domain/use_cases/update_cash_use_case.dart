import 'package:hesab_ban/app/core/params/cash_params.dart';
import 'package:hesab_ban/app/core/resources/data_state.dart';
import 'package:hesab_ban/app/core/use_case/use_case.dart';
import 'package:hesab_ban/app/features/feature_cash/domain/entities/cash_entity.dart';
import 'package:hesab_ban/app/features/feature_cash/domain/repository/cash_repository.dart';

class UpdateCashUseCase
    extends AsyncUseCase<DataState<CashEntity>, CashParams> {
  final CashRepository _cashRepository;

  UpdateCashUseCase(this._cashRepository);

  @override
  Future<DataState<CashEntity>> call(CashParams params) {
    CashEntity cash = CashEntity(
      id: params.id,
      cashAmount: params.cashAmount,
      cashDate: params.cashDate,
      customer: params.cashCustomer,
      factorId: params.factorId,
    );
    return _cashRepository.updateCash(cash);
  }
}
