import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'customized_widgets/paginated_data_table.dart';

class DataTableWidget extends StatelessWidget {
  const DataTableWidget({
    super.key,
    required this.dataList,
    required this.dataColumnList,
    required this.source,
  });
  final List dataList;
  final List<DataColumn> dataColumnList;
  final DataTableSource source;

  @override
  Widget build(BuildContext context) {
    RxInt rowsPerPage = 1.obs;
    if (dataList.length <= 10) {
      rowsPerPage.value = dataList.length;
    } //
    else {
      rowsPerPage.value = 10;
    }
    return Obx(
      () => PaginatedDataTableWidget(
        arrowHeadColor: Colors.white,
        columnSpacing: 30,
        showFirstLastButtons: true,
        showCheckboxColumn: false,
        tableLength: dataList.length,
        rowsPerPage: rowsPerPage.value,
        availableRowsPerPage: [
          rowsPerPage.value < 10 ? rowsPerPage.value : 10,
          20,
          50,
        ],
        onRowsPerPageChanged: (int? value) {
          if (value != null) {
            rowsPerPage.value = value;
          }
        },
        columns: dataColumnList,
        source: source,
      ),
    );
  }
}
