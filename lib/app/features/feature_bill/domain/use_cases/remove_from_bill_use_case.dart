import 'package:hesab_ban/app/core/params/bill_params.dart';
import 'package:hesab_ban/app/core/resources/data_state.dart';
import 'package:hesab_ban/app/core/use_case/use_case.dart';
import 'package:hesab_ban/app/features/feature_bill/domain/entities/bill_entity.dart';
import 'package:hesab_ban/app/features/feature_bill/domain/repository/bill_repository.dart';

class RemoveFromBillUseCase extends AsyncUseCase<DataState<BillEntity>, BillParams>{
  final BillRepository _billRepository;

  RemoveFromBillUseCase(this._billRepository);

  @override
  Future<DataState<BillEntity>> call(BillParams params) {
    return _billRepository.removeFromBill(params);
  }
}