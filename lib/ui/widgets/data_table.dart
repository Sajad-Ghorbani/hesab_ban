import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'customized_widgets/paginated_data_table.dart';

class DataTableWidget extends StatelessWidget {
  const DataTableWidget({
    Key? key,
    required this.dataList,
    required this.dataColumnList,
    required this.source,
  }) : super(key: key);
  final List dataList;
  final List<DataColumn> dataColumnList;
  final DataTableSource source;

  @override
  Widget build(BuildContext context) {
    RxInt _rowsPerPage = 1.obs;
    if (dataList.length <= 10) {
      _rowsPerPage.value = dataList.length;
    } //
    else {
      _rowsPerPage.value = 10;
    }
    return Obx(
      () => PaginatedDataTableWidget(
        arrowHeadColor: Colors.white,
        columnSpacing: 30,
        showFirstLastButtons: true,
        showCheckboxColumn: false,
        tableLength: dataList.length,
        rowsPerPage: _rowsPerPage.value,
        availableRowsPerPage: [
          _rowsPerPage.value < 10 ? _rowsPerPage.value : 10,
          20,
          50,
        ],
        onRowsPerPageChanged: (int? value) {
          if (value != null) {
            _rowsPerPage.value = value;
          }
        },
        columns: dataColumnList,
        source: source,
      ),
    );
  }
}
