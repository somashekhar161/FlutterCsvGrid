import 'package:flutter/material.dart';
import 'package:pluto_grid_v1/screen/pluto_add_delete.dart';
import 'package:loading_indicator/loading_indicator.dart';
import 'data/dummy_data.dart';
import 'package:url_strategy/url_strategy.dart';
import 'package:provider/provider.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import 'firebase_options.dart';



Future main() async {
  setPathUrlStrategy();///removes # in url
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
   MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {

    return ChangeNotifierProvider(
      create: (ctx) => DummyDataStat(),
      child: MaterialApp(
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

        home:  MyHomePage(),
      ),
    );
  }
}

class MyHomePage extends StatefulWidget {

   MyHomePage({Key? key,}) : super(key: key);
  final String title = 'Pluto Grid';
  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  //List<LogicalKeyboardKey> keys = [];



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
        body:PlutoAdd(),



      ),

    );
  }
}
