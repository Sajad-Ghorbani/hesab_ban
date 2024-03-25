import 'package:hesab_ban/app/core/resources/data_state.dart';
import 'package:hesab_ban/app/core/use_case/use_case.dart';
import 'package:hesab_ban/app/features/feature_cash/domain/entities/cash_entity.dart';
import 'package:hesab_ban/app/features/feature_cash/domain/repository/cash_repository.dart';

class GetAllCashUseCase extends UseCase<DataState<List<CashEntity>>> {
  final CashRepository _cashRepository;

  GetAllCashUseCase(this._cashRepository);

  @override
  DataState<List<CashEntity>> call() {
    return _cashRepository.getAllCash();
  }
}
