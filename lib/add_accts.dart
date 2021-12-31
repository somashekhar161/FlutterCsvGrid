import 'package:flutter/material.dart';
import 'dummy_data.dart';
import 'package:dropdown_search/dropdown_search.dart';

import 'main.dart';

class add_accounts extends StatefulWidget {
  DummyDataStat dummyData;
   add_accounts({Key? key,required this.dummyData}) : super(key: key);

  @override
  _add_accountsState createState() => _add_accountsState(dummyData);
}

class _add_accountsState extends State<add_accounts> {
  final TextEditingController _acctController = TextEditingController();
  final TextEditingController _groupSController = TextEditingController();
  String? selectedGroup;
  List<String>? groups;
  Map<String, String>? acct;
  var dummyData;
  _add_accountsState(this.dummyData);
  @override
  void initState() {
    super.initState();
    groups = dummyData.groups;
    acct = dummyData.acct;
    print('addAccountInit');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.deepPurple,
        foregroundColor: Colors.white,
        leading: Builder(
          builder: (BuildContext context) {
            return IconButton(
              icon: const Icon(Icons.arrow_left),
              onPressed: () {
                Navigator.pushReplacement(
                context,
                MaterialPageRoute(builder: (context) => MyHomePage(dummyData: dummyData,)),
              );},
              tooltip: MaterialLocalizations.of(context).openAppDrawerTooltip,
            );
          },
        ),
        title: const Text('Add Accounts'),
      ),
      body: SingleChildScrollView(
        child: Container(
        padding: const EdgeInsets.all(128),
        child: Column(
          children: [
            Container(
              alignment: Alignment.topLeft,
              //color: Colors.grey,
              child: RichText(

               textAlign : TextAlign.left,
                text:  TextSpan(

                  text: 'Enter Account Name Below',
                  style: Theme.of(context).textTheme.bodyText2,

                ),
              ),
            ),

            Row(
              children: [
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.only(top:4.0,bottom: 0.0),
                    child: TextField(
                      cursorWidth: 1.0,
                      decoration: const InputDecoration(

                        border: OutlineInputBorder(),
                        labelText: 'Enter Account',
                      ),
                      controller: _acctController,
                    ),
                  ),
                ),
                const SizedBox(
                  width: 10,
                ),
                Expanded(
                  child: DropdownSearch<String>(
                    mode: Mode.MENU,
                    showSearchBox: true,
                    // showSelectedItem: true,
                    items: groups,
                    label: "Select Group",
                    hint: "Group",
                    //popupItemDisabled: (String s) => s.startsWith('I'),
                    onChanged: (T) => selectedGroup = T,
                  ),
                ),
              ],
            ),
           
            const SizedBox(
              height: 10,
            ),

            ElevatedButton(
              onPressed: () {
                //Navigator.pop(context);
                print(_acctController.text);
                print(selectedGroup);
                if (_acctController.text.isNotEmpty && selectedGroup != null) {
                  if (acct?.keys.contains(_acctController.text.trim()) ==
                      false) {
                    print('notNull');
                    acct![_acctController.text.trim()] = selectedGroup!;
                    print(acct?.keys.toList());
                    ScaffoldMessenger.of(context).hideCurrentSnackBar();
                    ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                      content: Text("Account Added"),
                    ));
                  } else {
                    ScaffoldMessenger.of(context).hideCurrentSnackBar();
                    ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                      content: Text("Account Already Exists"),
                    ));
                  }
                } else {
                  ScaffoldMessenger.of(context).hideCurrentSnackBar();
                  ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                    content: Text("Fill all the Values"),
                  ));
                }
                _acctController.text='';
                selectedGroup='';
              },
              child: const Text('Add Account'),
            ),
            const SizedBox(
              height: 10,
            ),
            const Divider(
              height: 20,
              thickness: 5,
              indent: 20,
              endIndent: 20,
              color: Colors.grey,
            ),
            const SizedBox(
              height: 20,
            ),
            Container(
              alignment: Alignment.topLeft,
              //color: Colors.grey,
              child: RichText(

                textAlign : TextAlign.left,
                text: TextSpan(

                  text: 'Enter Group Name Below',
                  style: Theme.of(context).textTheme.bodyText2,

                ),
              ),
            ),
            SizedBox(
              height: 5,
            ),
            TextField(
              decoration: const InputDecoration(
                border: OutlineInputBorder(),
                labelText: 'Enter Group',
              ),
              controller: _groupSController,
            ),
            const SizedBox(
              height: 10,
            ),
            ElevatedButton(
              onPressed: () {

                print(_groupSController.text);
                if (_groupSController.text.isNotEmpty &&
                    _groupSController.text != '') {
                  if (groups?.contains(_groupSController.text.trim()) ==
                      false) {
                    print('notNull');
                    groups?.add(_groupSController.text.trim());
                    ScaffoldMessenger.of(context).hideCurrentSnackBar();
                    ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                      content: Text("Group Added"),
                    ));
                  } else {
                    ScaffoldMessenger.of(context).hideCurrentSnackBar();
                    ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                      content: Text("Group Already Exists"),
                    ));
                  }
                } else {
                  ScaffoldMessenger.of(context).hideCurrentSnackBar();
                  ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                    content: Text("Fill Group Value"),
                  ));
                }
                _groupSController.text='';
              },
              child: const Text('Add Group'),
            ),
          ],
        ),
      ),
      ),
    );
  }
}
