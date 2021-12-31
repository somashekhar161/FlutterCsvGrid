import 'package:flutter/material.dart';
import 'package:pluto_grid_v1/pluto_add_delete.dart';
import 'package:loading_indicator/loading_indicator.dart';
import 'dummy_data.dart';
import 'package:url_strategy/url_strategy.dart';


void main() {
  setPathUrlStrategy();///removes # in url
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
   MyApp({Key? key}) : super(key: key);
  var dummyData = DummyDataStat();
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {

    return MaterialApp(
      title: 'Grid',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        //primaryColor: Colors.deepPurple,
        primarySwatch: Colors.deepPurple,
        brightness: Brightness.dark,
        primaryTextTheme: TextTheme(
          bodyText2: TextStyle(fontSize: 18.0, fontWeight: FontWeight.bold, color: Colors.white ),
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
