import 'dart:convert';
import 'dart:io' as IO;
import 'package:file_picker/file_picker.dart';
import 'package:file_picker_cross/file_picker_cross.dart';
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:flutter/services.dart';
import 'package:universal_html/html.dart' as html;
import 'package:flutter/material.dart';

import 'dart:math';
import 'package:csv/csv.dart';
import 'dart:async';
import 'package:pluto_grid/pluto_grid.dart';
import 'package:external_path/external_path.dart';
import 'accounts.dart';
//import 'package:file_picker/file_picker.dart';

class DummyDataStat extends ChangeNotifier {
  late List<PlutoColumn> columns;
  List<PlutoRow>? rows;
  PlutoGridStateManager? stateManager;
  String date = "Date (DDMMYYYY)";
  Map<String, String> acct = accounts().acct;
  List<String>? groups = accounts().groups;
  String id = 'id';

  List<PlutoColumn> columnData() {
    columns = [
      ///hidden column
      PlutoColumn(
        title: id,
        hide: true,
        minWidth: 0,
        field: 'id_field',
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

      ///hidden

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
          String a = '(${acts.toString()})None';
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
          String a = '(${acts.toString()})None';
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
    /*columns = [
     ///hidden column
      PlutoColumn(
        title: id,
        hide:true,
        minWidth: 0,
        field: 'id_field',
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
      ///hidden

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
          String a = '(${acts.toString()})None';
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
          String a = '(${acts.toString()})None';
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
    ]; */
    rows = [
      PlutoRow(
        cells: {
          'id_field': PlutoCell(value: 1),
          'date_field': PlutoCell(value: '06082020'),
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

  //adds and empty row
  PlutoRow rowByColumns(List<PlutoColumn> columns) {
    final cells = <String, PlutoCell>{};

    for (var column in columns) {
      cells[column.field] = PlutoCell(
        value: (PlutoColumn element) {
          if (element.type.isNumber) {
            return 0; //faker.randomGenerator.decimal(scale: 1000000000);
          } else if (element.type.isSelect) {
            //(element.type.select!.items!.toList()).first
            return "";
          } else if (element.type.isDate) {
            return "";
          } else {
            return ""; //faker.food.restaurant();
          }
        }(column),
      );
    }

    //rows!.add(PlutoRow(cells: cells));
    return PlutoRow(cells: cells);
  }

  ///saves data to local Downloads
  Future<String> saveData(var stateM) async {
    //if (filename.length < 1) {
    //  filename = "Csvfile";
    //}

    stateManager = stateM;

    ///instance of stateManager
    List<List<dynamic>> rows1 = List<List<dynamic>>.empty(growable: true);

    stateManager?.rows.forEach((element) {
      List<dynamic> row1 = List.empty(growable: true);
      bool rFlag = true;

      ///checks row is null
      element!.cells.values.map((e) => e).forEach((element) {
        if (element.value == "") {
          rFlag = false;
        }
      });

      element.cells.values.elementAt(0).value = 'Null';
      //print(element.cells.values.elementAt(0).value);

      ///adds row
      if (rFlag) {
        element.cells.values.map((e) => e).forEach((element) {
          if (element.value != 'Null') {
            row1.add(element.value);
          }
        });
      }
      if (row1.isNotEmpty) {
        rows1.add(row1);
        //print(rows1);
      }
    });
    var csv = const ListToCsvConverter().convert(rows1);
    List<String> header = [];
    stateManager!.columns.forEach((element) {
      //print(element.title);
      header.add(element.title);
    });
    //print(header);
    String head = header.join(",");
    //print(head+'\n'+csv);
    //print(csv);
    if (kIsWeb) {
      downloadWeb(csv);
    } else if (IO.Platform.isAndroid || IO.Platform.isIOS) {
      var dir = await ExternalPath.getExternalStoragePublicDirectory(
          ExternalPath.DIRECTORY_DOWNLOADS);
      print("dir $dir");
      //String file = "$dir";

      final IO.File? f = IO.File(dir + "/csv_file.csv");

      await f?.writeAsString(csv);

      return dir;
    }
    return '';
  }

  void downloadWeb(String csv) {
    final bytes = utf8.encode(csv);
    final blob = html.Blob([bytes]);
    final url = html.Url.createObjectUrlFromBlob(blob);
    final anchor = html.document.createElement('a') as html.AnchorElement
      ..href = url
      ..style.display = 'none'
      ..download = 'csv_file.csv';
    html.document.body?.children.add(anchor);

// download
    anchor.click();

// cleanup
    html.document.body?.children.remove(anchor);
    html.Url.revokeObjectUrl(url);
  }
//eof save Data

//loadData from local
  Future<bool> loadData(var stateM, var filetext) async {
    //String csvS = await csv;
    stateManager = stateM;
    String? filepath;
    filepath = filetext;

    if (filepath == null || filepath == '') {
      return false;
    } else {
      final List<List<dynamic>> listData =
          await CsvToListConverter().convert(filepath);
      //print(listData);
      try {
        List<PlutoRow> rowsAll = [];
        for (var element in listData) {
          //final cells = <String, PlutoCell>{};
          var cells = <String, PlutoCell>{};
          if (element[0].runtimeType != String) {
            element[0].toString();
          }
          if (element[1].runtimeType != String) {
            element[1].toString();
          }
          if (element[2].runtimeType != String) {
            element[2].toString();
          }
          if (element[3].runtimeType != String) {
            element[3].toString();
          }
          cells = {
            'id_field': PlutoCell(value: 0),
            'date_field': PlutoCell(value: element[0]),
            'de_field': PlutoCell(value: element[1]),
            'ce_field': PlutoCell(value: element[2]),
            'desc_field': PlutoCell(value: element[3]),
            'vn_field': PlutoCell(value: element[4]),
            'amt_field': PlutoCell(value: element[5]),
          };
          PlutoRow rows = PlutoRow(cells: cells);
          rowsAll.add(rows);

          //print(element[0].runtimeType);
        }
        stateManager!.appendRows(rowsAll);
        print('Done');
        return false;
      } catch (e) {
        // print(e);
        print("errorinAppend");
      }
    }
    return false;
  }

  Future<String?> loadFileS(var stateM, bool Newfile) async {
    stateManager = stateM;

    FilePickerCross? myFile;
    myFile = await pickFile();
    print('file_path_is:${myFile?.path}');
    stateManager?.setShowLoading(true);
    var data = myFile.toString();
    if (data != '') {
      if (Newfile) {
        stateManager?.removeRows(rows);
      }
      await loadData(stateManager, data);
    }
    stateManager?.setShowLoading(false);
    return myFile?.path;
  }

  Future<FilePickerCross?> pickFile() async {
    FilePickerCross? myFile;
    try {
      myFile = await FilePickerCross.importFromStorage(
          type: FileTypeCross.custom, fileExtension: 'csv,');
    } catch (e) {
      print(e.runtimeType);
      print("error");
    }

    return myFile;
  }

  void clear(path) async {
    if (kIsWeb != true) {
      if (IO.Platform.isAndroid || IO.Platform.isIOS) {
        await FilePickerCross.delete(path: path);
      }
    } else {
      print('web');
    }
  }
//eof loadData from local
}
