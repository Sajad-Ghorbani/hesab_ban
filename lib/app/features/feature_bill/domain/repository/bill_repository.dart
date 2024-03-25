import 'package:hesab_ban/app/core/params/bill_params.dart';
import 'package:hesab_ban/app/core/resources/data_state.dart';
import 'package:hesab_ban/app/features/feature_bill/domain/entities/bill_entity.dart';

abstract class BillRepository {
  Future<DataState<BillEntity>> saveBill(BillEntity billEntity);

  Future<DataState<BillEntity>> addToBill(BillParams billParams);
  Future<DataState<BillEntity>> updateCustomerBill(BillParams billParams);

  Future<DataState<BillEntity>> updateFactorOfBill(BillParams billParams);

  Future<DataState<BillEntity>> updateCheckOfBill(BillParams billParams);

  Future<DataState<BillEntity>> updateCashOfBill(BillParams billParams);

  Future<DataState<BillEntity>> removeFromBill(BillParams billParams);

  Future<DataState<String>> deleteBill(int id);

  DataState<List<BillEntity>> getAllBills();

  DataState<BillEntity?> getBillById(int id);
}
