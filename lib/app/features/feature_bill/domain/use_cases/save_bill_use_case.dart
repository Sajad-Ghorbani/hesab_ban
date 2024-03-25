import 'package:hesab_ban/app/core/params/bill_params.dart';
import 'package:hesab_ban/app/core/resources/data_state.dart';
import 'package:hesab_ban/app/core/use_case/use_case.dart';
import 'package:hesab_ban/app/features/feature_bill/domain/entities/bill_entity.dart';
import 'package:hesab_ban/app/features/feature_bill/domain/repository/bill_repository.dart';

class SaveBillUseCase extends AsyncUseCase<DataState<BillEntity>, BillParams> {
  final BillRepository _billRepository;

  SaveBillUseCase(this._billRepository);

  @override
  Future<DataState<BillEntity>> call(BillParams params) async {
    return _billRepository.saveBill(
      BillEntity(
        customer: params.customer,
        cash: [],
        check: [],
        factor: [],
        cashPayment: params.customer!.initialAccountBalance,
      ),
    );
  }
}
