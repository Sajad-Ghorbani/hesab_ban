import 'package:hesab_ban/app/core/resources/data_state.dart';
import 'package:hesab_ban/app/core/use_case/use_case.dart';
import 'package:hesab_ban/app/features/feature_bill/domain/entities/bill_entity.dart';
import 'package:hesab_ban/app/features/feature_bill/domain/repository/bill_repository.dart';

class GetBillByIdUseCase extends InputUseCase<DataState<BillEntity?>, int> {
  final BillRepository _billRepository;

  GetBillByIdUseCase(this._billRepository);

  @override
  DataState<BillEntity?> call(int params) {
    return _billRepository.getBillById(params);
  }
}
