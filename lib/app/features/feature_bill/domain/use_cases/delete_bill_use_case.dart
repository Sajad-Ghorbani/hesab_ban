import 'package:hesab_ban/app/core/resources/data_state.dart';
import 'package:hesab_ban/app/core/use_case/use_case.dart';
import 'package:hesab_ban/app/features/feature_bill/domain/repository/bill_repository.dart';

class DeleteBillUseCase extends AsyncUseCase<DataState<String>, int> {
  final BillRepository _billRepository;

  DeleteBillUseCase(this._billRepository);

  @override
  Future<DataState<String>> call(int params) async {
    return _billRepository.deleteBill(params);
  }
}
