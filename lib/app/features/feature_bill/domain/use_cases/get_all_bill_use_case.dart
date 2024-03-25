import 'package:hesab_ban/app/core/resources/data_state.dart';
import 'package:hesab_ban/app/core/use_case/use_case.dart';
import 'package:hesab_ban/app/features/feature_bill/domain/entities/bill_entity.dart';
import 'package:hesab_ban/app/features/feature_bill/domain/repository/bill_repository.dart';

class GetAllBillUseCase extends UseCase<DataState<List<BillEntity>>> {
  final BillRepository _billRepository;

  GetAllBillUseCase(this._billRepository);

  @override
  DataState<List<BillEntity>> call() {
    return _billRepository.getAllBills();
  }
}
