import 'package:hesab_ban/app/config/routes/app_pages.dart';
import 'package:hesab_ban/app/core/utils/static_methods.dart';
import 'package:hesab_ban/app/core/widgets/data_table.dart';
import 'package:hesab_ban/app/features/feature_customer/domain/entities/customer_entity.dart';
import 'package:hesab_ban/app/features/feature_customer/presentation/controller/customer_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:persian_number_utility/persian_number_utility.dart';

class CustomersContainerWidget extends StatelessWidget {
  const CustomersContainerWidget({
    super.key,
    required this.customerList,
    this.selectCustomer = false,
    this.fromSearch = false,
    this.type,
  });
  final List<CustomerEntity> customerList;
  final bool selectCustomer;
  final bool fromSearch;
  final String? type;

  @override
  Widget build(BuildContext context) {
    return GetBuilder<CustomerController>(
      builder: (controller) {
        if (customerList.isEmpty) {
          return const Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                SizedBox(
                  height: 20,
                ),
                Text('لیست مشتریان خالی می باشد.'),
                SizedBox(
                  height: 20,
                ),
              ],
            ),
          );
        } //
        else {
          customerList.sort((a, b) {
            return a.name!.compareTo(b.name!);
          });
          return Padding(
            padding: const EdgeInsets.symmetric(horizontal: 15.0),
            child: SingleChildScrollView(
              physics: const NeverScrollableScrollPhysics(),
              child: Column(
                children: [
                  DataTableWidget(
                    dataList: customerList,
                    dataColumnList: const [
                      DataColumn(
                        label: Text('ردیف'),
                        numeric: true,
                      ),
                      DataColumn(label: Text('نام')),
                      DataColumn(label: Text('شماره تماس')),
                      DataColumn(label: Text('آدرس')),
                      DataColumn(label: Text('توضیحات')),
                    ],
                    source: CustomerDataTableSource(
                      context,
                      listOfCustomer: customerList,
                      selectCustomer: selectCustomer,
                      fromSearch: fromSearch,
                      type: type,
                    ),
                  ),
                ],
              ),
            ),
          );
        }
      },
    );
  }
}

class CustomerDataTableSource extends DataTableSource {
  CustomerDataTableSource(
    this.context, {
    this.type,
    required this.listOfCustomer,
    required this.selectCustomer,
    required this.fromSearch,
  });

  final BuildContext context;
  final List<CustomerEntity> listOfCustomer;
  final bool selectCustomer;
  final bool fromSearch;
  final String? type;

  @override
  DataRow? getRow(int index) {
    assert(index >= 0);
    if (index >= listOfCustomer.length) {
      return null;
    }
    CustomerEntity customer = listOfCustomer[index];
    return DataRow.byIndex(
      index: index,
      cells: [
        DataCell(
          Text(
            (index + 1).toString().toPersianDigit(),
          ),
        ),
        DataCell(
          Text(customer.name!),
        ),
        DataCell(
          Text(
            (customer.phoneNumber1).toString().toPersianDigit(),
          ),
        ),
        DataCell(
          Text(customer.address ?? ' --- '),
        ),
        DataCell(
          Text(customer.description ?? ' --- '),
        ),
      ],
      onSelectChanged: (bool? selected) {
        if (selectCustomer) {
          if (fromSearch) {
            Get.back();
            Get.back(result: customer);
          } //
          else {
            Get.back(result: customer);
          }
        } //
        else {
          Get.toNamed(Routes.customerBalanceScreen,
              parameters: {'id': '${customer.id}'});
        }
      },
      onLongPress: () {
        selectCustomer
            ? null
            : StaticMethods.customBottomSheet(
                context,
                name: customer.name!,
                onEditTap: () {
                  Get.toNamed(Routes.createCustomerScreen,
                      arguments: customer, parameters: {'type': type ?? ''});
                },
                showDelete: true,
                onDeleteTap: () {
                  Get.back();
                  StaticMethods.deleteDialog(
                    content: 'با حذف "${customer.name}" موافق هستید؟'
                        ' این عملیات برگشت پذیر نیست.',
                    onConfirm: () {
                      Get.find<CustomerController>()
                          .deleteCustomer(customer.id!);
                      Get.back();
                    },
                  );
                },
              );
      },
    );
  }

  @override
  bool get isRowCountApproximate => false;

  @override
  int get rowCount => listOfCustomer.length;

  @override
  int get selectedRowCount => 0;
}
