import 'package:flutter/material.dart';
import 'package:pluto_grid_v1/pluto_add_delete.dart';

import 'dummy_data.dart';


void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
   MyApp({Key? key}) : super(key: key);
  var dummyData = DummyDataStat();
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        //primaryColor: Colors.deepPurple,
        //primarySwatch: Colors.purple,
        colorScheme: ColorScheme.fromSwatch().copyWith(
          brightness: Brightness.dark,
            primary: Colors.deepPurple,
            primaryVariant: Colors.white,
            //secondary: Colors.deepPurple,
         // secondaryVariant: Colors.deepPurple,
        ),
      ),

      home:  MyHomePage(dummyData: dummyData),
    );
  }
}

class MyHomePage extends StatefulWidget {
  DummyDataStat dummyData;
   MyHomePage({Key? key,required this.dummyData}) : super(key: key);
  final String title = 'Pluto Grid';
  @override
  State<MyHomePage> createState() => _MyHomePageState(dummyData);
}

class _MyHomePageState extends State<MyHomePage> {
  //List<LogicalKeyboardKey> keys = [];
  var dummyData;
  _MyHomePageState(this.dummyData);

  @override
  Widget build(BuildContext context) {
    return Scaffold(// body: PlutoAdd(),
      body: NestedScrollView(
        headerSliverBuilder: (BuildContext context, bool innerBoxIsScrolled) {
          return <Widget>[
            const SliverAppBar(

              title: Text('Pluto Grid'),
              pinned: false,
              floating: true,
              backgroundColor: Colors.deepPurple,
                foregroundColor: Colors.white,
              //forceElevated: innerBoxIsScrolled,
            ),
          ];
        },
        body:PlutoAdd(dummyData: dummyData),
      ),

    );
  }
}
