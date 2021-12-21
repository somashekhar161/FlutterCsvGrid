import 'package:csv/csv.dart';
import 'package:open_file/open_file.dart';
import 'package:pluto_grid/pluto_grid.dart';
import 'package:file_picker/file_picker.dart';

class DummyDataStat {
  late List<PlutoColumn> columns;
  List<PlutoRow>? rows;
  PlutoGridStateManager? stateManager;
  String date = "Date (DDMMYYYY)";
  Map<String, String> acct = {
    //accounts(key):groups(value)
    'Purchase Local 12 %': 'Purchase',
    'Purchase Interstate 12%': 'Expenses',
    'Purchase Local 0%': 'Liabilities',
    'Purchase Interstate 0%': 'Asset',
    'Purchase (Composition)': 'Asset',
    'Cash': 'Asset',
    'Capital': 'Investment'
  };
  List<String>? groups = ['Purchase', 'Expenses', 'Liabilities', 'Asset'];

  List<PlutoColumn> columnData() {
    columns = [
      /// Date Column definition
      PlutoColumn(
        title: date,
        minWidth: 152.0,
        field: 'date_field',
        enableColumnDrag: false,
        enableRowDrag: false,
        enableSorting: false,
        enableContextMenu: false,
        enableDropToResize: true,
        enableFilterMenuItem: false,
        enableHideColumnMenuItem: false,
        enableSetColumnsMenuItem: true,
        enableEditingMode: true,
        type: PlutoColumnType.text(),
      ),

      /// Name Column definition
      PlutoColumn(
        minWidth: 100.0,
        title: 'De.Account',
        field: 'de_field',
        enableColumnDrag: false,
        enableRowDrag: false,
        enableSorting: false,
        enableContextMenu: false,
        enableDropToResize: true,
        enableFilterMenuItem: false,
        enableHideColumnMenuItem: false,
        enableSetColumnsMenuItem: true,
        enableEditingMode: true,
        type: PlutoColumnType.select(
          acct.keys.toList(),
          enableColumnFilter: true,
        ),
        applyFormatterInEditing: false,
        formatter: (dynamic acts) {
          String a = '';
          //String ac='(N)None';
          if (acct.keys.contains(acts.toString())) {
            acct.forEach((key, value) {
              if (key.toString() == acts.toString()) {
                var vkey = key.toString();
                var vValue = value.toString();
                a = '($vkey)$vValue';
              }
            });
            return a;
          }
          return a;
        },
      ),
      PlutoColumn(
        minWidth: 100.0,
        title: 'Ce.Account',
        field: 'ce_field',
        enableColumnDrag: false,
        enableRowDrag: false,
        enableSorting: false,
        enableContextMenu: false,
        enableDropToResize: true,
        enableFilterMenuItem: false,
        enableHideColumnMenuItem: false,
        enableSetColumnsMenuItem: true,
        enableEditingMode: true,
        type: PlutoColumnType.select(
          acct.keys.toList(),
          enableColumnFilter: true,
        ),
        applyFormatterInEditing: false,
        formatter: (dynamic acts) {
          String a = '';
          //String ac='(N)None';
          if (acct.keys.contains(acts.toString())) {
            acct.forEach((key, value) {
              if (key.toString() == acts.toString()) {
                var vkey = key.toString();
                var vValue = value.toString();
                a = '($vkey)$vValue';
              }
            });
            return a;
          }
          return a;
        },
      ),

      /// Description Column definition
      PlutoColumn(
        minWidth: 100.0,
        title: 'Description',
        field: 'desc_field',
        enableColumnDrag: false,
        enableRowDrag: false,
        enableSorting: false,
        enableContextMenu: false,
        enableDropToResize: true,
        enableFilterMenuItem: false,
        enableHideColumnMenuItem: false,
        enableSetColumnsMenuItem: true,
        enableEditingMode: true,
        type: PlutoColumnType.text(),
      ),

      /// Amount Column definition
      PlutoColumn(
        minWidth: 100.0,
        title: 'VoucherNo',
        field: 'vn_field',
        //frozen: PlutoColumnFrozen.right,
        enableColumnDrag: false,
        enableRowDrag: false,
        enableSorting: false,
        enableContextMenu: false,
        enableDropToResize: true,
        enableFilterMenuItem: false,
        enableHideColumnMenuItem: false,
        enableSetColumnsMenuItem: true,
        enableEditingMode: true,
        type: PlutoColumnType.number(),
      ),
      PlutoColumn(
        minWidth: 110.0,
        title: 'TotalAmount',
        field: 'amt_field',
        //frozen: PlutoColumnFrozen.right,
        enableColumnDrag: false,
        enableRowDrag: false,
        enableSorting: false,
        enableContextMenu: false,
        enableDropToResize: true,
        enableFilterMenuItem: false,
        enableHideColumnMenuItem: false,
        enableSetColumnsMenuItem: false,
        enableEditingMode: true,
        type: PlutoColumnType.number(),
      ),
    ];
    return columns;
  }

  DummyDataStat() {
    rows = [
      PlutoRow(
        cells: {
          'date_field': PlutoCell(value: '2020-08-06'),
          'de_field': PlutoCell(value: 'Cash'),
          'ce_field': PlutoCell(value: 'Capital'),
          'desc_field': PlutoCell(value: 'Text cell value1'),
          'vn_field': PlutoCell(value: 10),
          'amt_field': PlutoCell(value: 120),
        },
      ),
    ];
  }
  List<PlutoRow> rowsByColumns(
      {required int length, List<PlutoColumn>? columns}) {
    return List<int>.generate(length, (index) => ++index).map((rowIndex) {
      return rowByColumns(columns!);
    }).toList();
  }

  PlutoRow rowByColumns(List<PlutoColumn> columns) {
    final cells = <String, PlutoCell>{};

    for (var column in columns) {
      cells[column.field] = PlutoCell(
        value: (PlutoColumn element) {
          if (element.type.isNumber) {
            return null; //faker.randomGenerator.decimal(scale: 1000000000);
          } else if (element.type.isSelect) {
            //(element.type.select!.items!.toList()).first
            return "";
          } else if (element.type.isDate) {
            return null;
          } else {
            return ""; //faker.food.restaurant();
          }
        }(column),
      );
    }

    //rows!.add(PlutoRow(cells: cells));
    return PlutoRow(cells: cells);
  }

  Future<String> saveData(var stateM) async {
    stateManager = stateM;
    List<List<dynamic>> rows1 = List<List<dynamic>>.empty(growable: true);
    print('refreshedinState');
    stateManager?.rows.forEach((element) {
      List<dynamic> row1 = List.empty(growable: true);
      element?.cells.values.map((e) => e).forEach((element) {
        if (element.value != '' &&
            element.value != 0 &&
            element.value != null) {
          print(element.value);
          row1.add(element.value);
        }
      });
      if (row1.isNotEmpty) {
        rows1.add(row1);
        print(rows1);
      }
    });
    var csv = const ListToCsvConverter().convert(rows1);
    List<String> header=[];
    stateManager!.columns.forEach((element) {
      print(element.title);
      header.add(element.title);
    });
    //print(header);
    String head = header.join(",");
    print(head+'\n'+csv);
    //print(csv);



    return csv;
  }

  void loadData(Future<String> csv) async {
    String csvS = await csv;

      List<List<dynamic>> listData = CsvToListConverter().convert(csvS);
      print(listData);
      listData.forEach((element) {
        //final cells = <String, PlutoCell>{};
        var cells = <String, PlutoCell>{};
        cells = {
          'date_field': PlutoCell(value: element[0]),
          'de_field': PlutoCell(value: element[1]),
          'ce_field': PlutoCell(value: element[2]),
          'desc_field': PlutoCell(value: element[3]),
          'vn_field': PlutoCell(value: element[4]),
          'amt_field': PlutoCell(value: element[5]),
        };
        List<PlutoRow> rows = [PlutoRow(cells: cells)];
        stateManager!.appendRows(rows);
        //print(element[0].runtimeType);
      });
   final result = await FilePicker.platform.pickFiles();
   if(result == null) return;

   final file = result.files.first;
   OpenFile.open(file.path!);
    //  if (await Permission.storage.request().isGranted) {
    //
////store file in documents folder
    //
    //    String dir = (await getExternalStorageDirectory())!.path + "/mycsv.csv";
    //    String file = "$dir";
    //
    //    File f = new File(file);
    //
//// convert rows to String and write as csv file
    //    f.writeAsString(csv);
    //  }else{
    //
    //    Map<Permission, PermissionStatus> statuses = await [
    //      Permission.storage,
    //    ].request();
    //  }

    /* final content = base64Encode(csv.codeUnits);
    final url = 'data:application/csv;base64,$content';
    await launch(url);

    */
  }
}
