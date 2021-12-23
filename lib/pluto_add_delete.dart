import 'dart:convert';
import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:pluto_grid/pluto_grid.dart';
import 'add_accts.dart';
import 'dummy_data.dart';
import 'package:csv/csv.dart';
/*import 'package:path_provider/path_provider.dart';

import 'package:file_picker/file_picker.dart';*/

class PlutoAdd extends StatefulWidget {
  DummyDataStat dummyData;
  PlutoAdd({Key? key, required this.dummyData}) : super(key: key);

  @override
  _PlutoAdd createState() => _PlutoAdd(dummyData);
}

class _PlutoAdd extends State<PlutoAdd> {
  var dummyData;
  _PlutoAdd(this.dummyData);

  List<PlutoColumn>? columns;

  List<PlutoRow>? rows;

  PlutoGridStateManager? stateManager;

  PlutoGridSelectingMode? gridSelectingMode = PlutoGridSelectingMode.row;

  List<LogicalKeyboardKey> keys = [];

  Map<String, String>? acct;

  double gridWidth = 750.0;
  var csv;

  @override
  void initState() {
    acct = dummyData.acct;

    super.initState();
    print("restarted");
    setState(() {
      columns = dummyData.columnData();
      rows = dummyData.rows;
    });
  }

  void autoFitGrid() {
    for (var element in stateManager!.columns) {
      stateManager!.autoFitColumn(context, element);
    }
    print(stateManager!.columnsWidth);
  }

  double reWidth() {
    if (stateManager!.columnsWidth <= 400) {
      return 750.0;
    } else {
      return stateManager!.columnsWidth;
    }
  }

  int handleAddRowButton({int? count}) {
    if (stateManager!.rows.isEmpty) {
      final List<PlutoRow> rows = count == null
          ? [DummyDataStat().rowByColumns(columns!)]
          : DummyDataStat().rowsByColumns(length: count, columns: columns);

      stateManager!.appendRows(rows);
      return 1;
    } else {
      if (stateManager!.rows.last!.cells.values.elementAt(0).value != "" &&
          stateManager!.rows.last!.cells.values.elementAt(1).value != "" &&
          stateManager!.rows.last!.cells.values.elementAt(2).value != "" &&
          stateManager!.rows.last!.cells.values.elementAt(3).value != "" &&
          stateManager!.rows.last!.cells.values.elementAt(4).value != 0 &&
          stateManager!.rows.last!.cells.values.elementAt(5).value != 0) {
        final List<PlutoRow> rows = count == null
            ? [DummyDataStat().rowByColumns(columns!)]
            : DummyDataStat().rowsByColumns(length: count, columns: columns);

        stateManager!.appendRows(rows);
        return 1;
      }
      return 0;
    }
  }

  void handleRemoveCurrentRowButton() {
    stateManager!.removeCurrentRow();
  }

  void handleRemoveSelectedRowsButton() {
    stateManager!.removeRows(stateManager!.currentSelectingRows);
  }

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, size) {
        return SingleChildScrollView(
          scrollDirection: Axis.vertical,
          child: Column(
            children: [
              Container(
                alignment: Alignment.center,
                width: size.maxWidth,
                height: size.maxHeight,
                constraints: BoxConstraints(
                  //minHeight: 250,
                  maxWidth: gridWidth + 30,
                  maxHeight: MediaQuery.of(context).size.height / 1.3,
                ),
                child: Column(
                  children: [
                    Expanded(
                      child: gridExpandedBody(),
                    ),
                  ],
                ),
              ),
              ElevatedButton(
                  onPressed: () {
                    Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(
                          builder: (context) => add_accounts(
                                dummyData: dummyData,
                              )),
                    );
                  },
                  child: const Text('Add Account')),
              const SizedBox(
                height: 10,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  ElevatedButton(
                    onPressed: () async {
                      csv = dummyData.saveData(stateManager,"fileCsv");
                    },
                    child: const Icon(Icons.file_download_done_outlined),
                  ),
                  const SizedBox(
                    width: 20,
                  ),
                  ElevatedButton(
                    onPressed: () {
                      if (true) {
                        dummyData.loadData();
                        ScaffoldMessenger.of(context).hideCurrentSnackBar();
                        ScaffoldMessenger.of(context)
                            .showSnackBar(const SnackBar(
                          content: Text("Loaded"),
                        ));
                      } /*else {
                        ScaffoldMessenger.of(context).hideCurrentSnackBar();
                        ScaffoldMessenger.of(context)
                            .showSnackBar(const SnackBar(
                          content: Text("Null"),
                        ));
                      }
                      */
                    },
                    child: const Icon(Icons.upload_file_outlined),
                  ),
                ],
              ),
            ],
          ),
        );
      },
    );
  }

  RawKeyboardListener gridExpandedBody() {
    return RawKeyboardListener(
      autofocus: true,
      focusNode: FocusNode(),
      onKey: (event) {
        final key = event.logicalKey;
        const keyM = LogicalKeyboardKey.keyM;
        const keyD = LogicalKeyboardKey.keyD;
        const keyQ = LogicalKeyboardKey.keyQ;
        if (event is RawKeyDownEvent) {
          if (keys.contains(key)) return;

          setState(() => keys.add(key));
          if (event.isKeyPressed(LogicalKeyboardKey.controlLeft) &&
              event.isKeyPressed(keyM)) {
            handleAddRowButton();
          }
          if (event.isKeyPressed(LogicalKeyboardKey.controlLeft) &&
              event.isKeyPressed(keyD)) {
            handleRemoveCurrentRowButton();
          }
          if (event.isKeyPressed(LogicalKeyboardKey.controlLeft) &&
              event.isKeyPressed(keyQ)) {
            handleRemoveSelectedRowsButton();
          }
        } else {
          setState(() => keys.remove(key));
        }
      },
      child: Container(
        padding: const EdgeInsets.only(left: 10, right: 10, top: 15, bottom: 10),
        child: Column(
          children: [
            Wrap(
              spacing: 15,
              children: [
                Tooltip(
                  triggerMode: TooltipTriggerMode.longPress,
                  message: 'Add Row (ctrl+M)',
                  child: ElevatedButton(
                    child: const Icon(Icons.add),
                    onPressed: () {
                      int flag = handleAddRowButton();
                      if (flag == 0) {
                        ScaffoldMessenger.of(context).hideCurrentSnackBar();
                        ScaffoldMessenger.of(context)
                            .showSnackBar(const SnackBar(
                          content: Text("Fill all the Values"),
                        ));
                      }
                    },
                  ),
                ),
                Tooltip(
                  triggerMode: TooltipTriggerMode.longPress,
                  message: 'Remove Current Row (ctrl+D)',
                  child: ElevatedButton(
                    child: const Icon(Icons.delete),
                    onPressed: handleRemoveCurrentRowButton,
                  ),
                ),
                Tooltip(
                  triggerMode: TooltipTriggerMode.longPress,
                  message: 'Remove Selected Rows(ctrl+Q)',
                  child: ElevatedButton(
                    child: const Text('Remove Selected Rows'),
                    onPressed: handleRemoveSelectedRowsButton,
                  ),
                ),
              ],
            ),
            const SizedBox(
              height: 10,
            ),
            Expanded(
              child: PlutoGrid(
                columns: columns,
                rows: rows,
                onChanged: (P) {
                  autoFitGrid();
                  print(P);
                  handleAddRowButton();
                  setState(() {
                    gridWidth = stateManager!.columnsWidth.toDouble();
                    print(gridWidth.runtimeType);
                  });

                  //stateManager!.resetCurrentState();
                },
                onLoaded: (PlutoGridOnLoadedEvent event) {
                  stateManager = event.stateManager;
                  stateManager!.setSelectingMode(gridSelectingMode!);
                  autoFitGrid();
                  handleAddRowButton();
                  setState(() {
                    gridWidth = stateManager!.columnsWidth.toDouble();
                    print(gridWidth.runtimeType);
                  });
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
