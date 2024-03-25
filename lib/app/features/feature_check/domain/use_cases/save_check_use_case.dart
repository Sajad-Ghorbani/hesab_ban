import 'package:hesab_ban/app/core/params/check_params.dart';
import 'package:hesab_ban/app/core/resources/data_state.dart';
import 'package:hesab_ban/app/core/use_case/use_case.dart';
import 'package:hesab_ban/app/features/feature_check/data/models/check_model.dart';
import 'package:hesab_ban/app/features/feature_check/domain/entities/bank_entity.dart';
import 'package:hesab_ban/app/features/feature_check/domain/entities/check_entity.dart';
import 'package:hesab_ban/app/features/feature_check/domain/repository/check_repository.dart';

class SaveCheckUseCase extends AsyncUseCase<DataState<CheckEntity>, CheckParams> {
  final CheckRepository _checkRepository;

  SaveCheckUseCase(this._checkRepository);

  @override
  Future<DataState<CheckEntity>> call(CheckParams params) async {
    TypeOfCheck typeOfCheck = TypeOfCheck.values
        .firstWhere((element) => element.name == params.typeOfCheck);
    CheckEntity check = CheckEntity(
      bankName: params.bankName,
      checkDeliveryDate: params.checkDeliveryDate,
      checkDueDate: params.checkDueDate,
      checkNumber: params.checkNumber,
      typeOfCheck: typeOfCheck,
      checkAmount: params.checkAmount,
      checkBank:
          bankList.firstWhere((element) => element.name == params.checkBank),
      customerCheck: params.customerCheck,
      factorId: params.factorId,
    );
    return _checkRepository.saveCheck(check);
  }
}
