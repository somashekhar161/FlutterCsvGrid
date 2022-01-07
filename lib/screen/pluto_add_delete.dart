import 'dart:convert';
import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:pluto_grid/pluto_grid.dart';

import 'package:universal_html/html.dart';
import 'add_accts.dart';
import '../data/dummy_data.dart';
import 'package:provider/provider.dart';
import 'package:csv/csv.dart';
import 'package:loading_indicator/loading_indicator.dart';
/*import 'package:path_provider/path_provider.dart';

import 'package:file_picker/file_picker.dart';*/

class PlutoAdd extends StatefulWidget {
  PlutoAdd({Key? key}) : super(key: key);

  @override
  _PlutoAdd createState() => _PlutoAdd();
}

class _PlutoAdd extends State<PlutoAdd> {
  List<PlutoColumn>? columns;

  List<PlutoRow>? rows;

  PlutoGridStateManager? stateManager;

  PlutoGridSelectingMode? gridSelectingMode = PlutoGridSelectingMode.row;

  List<LogicalKeyboardKey> keys = [];

  Map<String, String>? acct;

  double gridWidth = 750.0;

  late AnimationController controller;

  var providerData;

  var Total;

  @override
  void initState() {

    super.initState();
    print("restarted");


    setState(() {

      //columns = dummyData.columnData();
      //rows = dummyData.rows;
    });

  }

  void autoFitGrid() {
    for (var element in stateManager!.columns) {
      stateManager!.autoFitColumn(context, element);
    }
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
          stateManager!.rows.last!.cells.values.elementAt(5).value != 0 ) {
        final List<PlutoRow> rows = count == null
            ? [DummyDataStat().rowByColumns(columns!)]
            : DummyDataStat().rowsByColumns(length: count, columns: columns);

        stateManager!.appendRows(rows);
        setState(() {
          Total = stateManager!.rows.length.toString();
        });
        return 1;
      }
      setState(() {
        Total = stateManager!.rows.length.toString();
      });
      return 0;
    }

  }

  void handleRemoveCurrentRowButton() {
    stateManager!.removeCurrentRow();
    setState(() {
      Total = stateManager!.rows.length.toString();
    });
  }

  void handleRemoveSelectedRowsButton() {
    stateManager!.removeRows(stateManager!.currentSelectingRows);
    setState(() {
      Total = stateManager!.rows.length.toString();
    });
  }

  void printData(){
    String? date;
    String? de;
    String? ce;
    String? desc;
    int? vn;
    int? amt;
    stateManager!.currentRow?.cells.forEach((key, value) {

      if (key == "date_field") date = value.value;
      if (key == "de_field") de = value.value;
      if (key == "ce_field") ce = value.value;
      if (key == "desc_field") desc = value.value;
      if (key == "vn_field") vn = value.value;
      if (key == "amt_field") amt = value.value;
    });
    print(
        " date= $date, de= $de, ce= $ce, desc= $desc, vn= $vn, amt= $amt");
  }

  @override
  Widget build(BuildContext context) {
    providerData = Provider.of<DummyDataStat>(context);
    columns = providerData.columnData();
    rows = providerData.rows;
    //providerData.loadFromFBase(stateManager,true);//loads data from firebase

    return LayoutBuilder(
      builder: (context, size) {
        return SingleChildScrollView(
          scrollDirection: Axis.vertical,
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Row(

                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Tooltip(
                      triggerMode: TooltipTriggerMode.longPress,
                      message: "firebase Load Data",
                      child: ElevatedButton(
                        onPressed: () async {
                          providerData.loadFromFBase(stateManager,true);//loads data from firebase

                        },
                        child: const Text('firebase Load'),
                      ),
                    ),
                    SizedBox(
                      width: 20,
                    ),
                    Tooltip(
                      triggerMode: TooltipTriggerMode.longPress,
                      message: "firebase Update Data",
                      child: ElevatedButton(
                        onPressed: () async {
                          stateManager?.removeRows(rows);
                          stateManager?.resetCurrentState();
                          providerData.addUser(stateManager);//updates data in firebase



                        },
                        child: const Text('firebase Update'),
                      ),
                    ),
                  ],
                ),
              ),

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
                  onPressed: () async {
                    //providerData.addUser(stateManager);//updates data in firebase
                    Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(builder: (context) => add_accounts()),
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
                  Tooltip(
                    triggerMode: TooltipTriggerMode.longPress,
                    message: "Save Sheet as CSV",
                    child: ElevatedButton(
                      onPressed: () async {
                        String path = await providerData.saveData(stateManager);
                        if (path.length < 3) {
                          path = "Downloads";
                        }
                        ScaffoldMessenger.of(context).hideCurrentSnackBar();
                        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                          content: Text("saved in this $path"),
                        ));
                      },
                      child: const Icon(Icons.file_download_done_outlined),
                    ),
                  ),
                  const SizedBox(
                    width: 20,
                  ),
                  Tooltip(
                    triggerMode: TooltipTriggerMode.longPress,
                    message: "Upload Sheet",
                    child: ElevatedButton(
                      onPressed: () {
                        showDialog<String>(
                          context: context,
                          builder: (BuildContext context) => AlertDialog(
                            title: const Text('Upload CSV File'),
                            content: const Text('How to load CSV File on Grid'),
                            actions: <Widget>[
                              TextButton(
                                onPressed: () =>
                                    Navigator.pop(context, 'Cancel'),
                                child: const Text('Cancel'),
                              ),
                              Tooltip(
                                triggerMode: TooltipTriggerMode.longPress,
                                message: "Uploaded on same sheet",
                                child: TextButton(
                                  onPressed: () async {
                                    Navigator.pop(context, 'Same Sheet');
                                    bool Newfile = false;

                                    String? path = await providerData.loadFileS(
                                        stateManager, Newfile);
                                    print(path);
                                    providerData.clear(path);

                                    // print('$path');
                                    //dummyData.clear(path);
                                  },
                                  child: const Text('Same Sheet'),
                                ),
                              ),
                              Tooltip(
                                triggerMode: TooltipTriggerMode.longPress,
                                message: "Previous Sheet will be deleted",
                                child: TextButton(
                                  onPressed: () async {
                                    Navigator.pop(context, 'New Sheet');
                                    bool Newfile = true;
                                    String? path = await providerData.loadFileS(
                                        stateManager, Newfile);
                                    providerData.clear(path);
                                  },
                                  child: const Text('New Sheet'),
                                ),
                              ),
                            ],
                          ),
                        );
                      },
                      child: const Icon(Icons.upload_file_rounded),
                    ),
                  ),

                 // dataBuild(),
                ],
              ),
            ],
          ),
        );
      },
    );
  }
  //eof build



  //pluto Grid
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
        padding:
            const EdgeInsets.only(left: 10, right: 10, top: 15, bottom: 10),
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
                //configuration: PlutoGridConfiguration.dark(),
                onChanged: (P) {
                  autoFitGrid();
                  print(P);
                  int? id;
                  handleAddRowButton();
                  setState(() {
                    Total = stateManager!.rows.length.toString();
                    gridWidth = stateManager!.columnsWidth.toDouble();
                  });

                  //stateManager!.resetCurrentState();
                },
                onLoaded: (PlutoGridOnLoadedEvent event) {
                  stateManager = event.stateManager;
                  stateManager!.setSelectingMode(gridSelectingMode!);
                 // stateManager?.removeRows(rows);
                 // providerData.loadFromFBase(stateManager,true);//loads data from firebase
                  autoFitGrid();
                  //handleAddRowButton();
                  stateManager?.columns.clear();
                  print("onload");
                  setState(() {
                    Total = stateManager!.rows.length.toString();
                    gridWidth = stateManager!.columnsWidth.toDouble();
                  });
                },
              ),
            ),
            Container(
              alignment: Alignment.topLeft,
              child: RichText(

                text: TextSpan(
                  text: 'Total ',
                  style: DefaultTextStyle.of(context).style,
                  children:  <TextSpan>[
                    TextSpan(text: Total, style: TextStyle(fontWeight: FontWeight.bold)),
                    TextSpan(text: ' records'),
                  ],
                ),
              ),
            ),

          ],
        ),
      ),
    );
  }
}
