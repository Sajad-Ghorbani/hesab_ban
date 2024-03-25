import 'package:hesab_ban/app/core/params/setting_params.dart';
import 'package:hesab_ban/app/core/resources/data_state.dart';
import 'package:hesab_ban/app/core/use_case/use_case.dart';
import 'package:hesab_ban/app/features/feature_setting/domain/entities/setting_entity.dart';
import 'package:hesab_ban/app/features/feature_setting/domain/repository/setting_repository.dart';

class UpdateSettingUseCase
    extends AsyncUseCase<DataState<SettingEntity>, SettingParams> {
  final SettingRepository _settingRepository;

  UpdateSettingUseCase(this._settingRepository);

  @override
  Future<DataState<SettingEntity>> call(SettingParams params) async {
    return _settingRepository.update(
      SettingEntity(
        isThemeLight: params.isThemeLight,
        moneyUnit: params.moneyUnit,
        isMoneyUnitRial: params.isMoneyUnitRial,
        notificationHours: params.notificationHours,
        notificationMinutes: params.notificationMinutes,
        productCountCheck: params.productCountCheck,
        costsLabel: params.costsLabel,
        stampLogo: params.stampLogo,
        signLogo: params.signLogo,
        showCustomerBalance: params.showCustomerBalance,
        factorDescription: params.factorDescription,
        showPaymentOrReceipt: params.showPaymentOrReceipt,
        showFactorTax: params.showFactorTax,
        showFactorCosts: params.showFactorCosts,
        showFactorOffer: params.showFactorOffer,
        barcodeUrl: params.barcodeUrl,
        showPasswordScreen: params.showPasswordScreen,
      ),
    );
  }
}
