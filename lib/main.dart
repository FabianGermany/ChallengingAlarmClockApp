import 'package:flutter/material.dart';
import 'package:english_words/english_words.dart';
import  'package:intl/intl.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Alarm Clock App',
      theme: ThemeData(
        primarySwatch: Colors.deepPurple,
      ),
      home: const MyHomePage(title: 'Alarm Clock Web Version'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({Key? key, required this.title}) : super(key: key);

  // This widget is the homepage of the app. It has different states.

  // This class is the configuration for the state. It holds the values (in this
  // case the title) provided by the parent (in this case the App widget) and
  // used by the build method of the State. Fields in a Widget subclass are
  // always marked "final".

  final String title;


  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {

  // Declare vars for the time
  DateTime? now; //todo is late the right keyword to declare var?
  String? date_string; //todo dafür sorgen dass das in echtzeit geupdated wird
  String? time_string;



  void _updateTime() {
    setState(() {
      // setState is needed to tell the Flutter framework that something has
      // changed in this State, which causes it to rerun the build method below
      // so that the display can reflect the updated values.
      now = DateTime.now();
      date_string = DateFormat("MMMM, dd, yyyy").format(DateTime.now()); //todo dafür sorgen dass das in echtzeit geupdated wird
      time_string = DateFormat("HH:mm:ss").format(DateTime.now());
    });
  }


  // run the time update at least every second
  // run the date update at least every minute...todo doesnt make sense
  // _updateTime();



  @override
  Widget build(BuildContext context) {
    // This method is rerun every time setState is called, for instance as done
    // by the _updateTime method above.
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body:
        Container(
        margin: const EdgeInsets.all(20.0),
        child:
          Column(
            children: [
              Align(
                alignment: Alignment.centerRight,
                child:
                  IconButton(
                    icon: const Icon(Icons.add),
                    tooltip: 'Add a new alarm',
                    color: Colors.deepPurple,
                    iconSize: 50.0,
                    onPressed: _updateTime, //todo change to my desired function
                  ),
              ),

              Center(
                child: Column(
                  // Column is also a layout widget
                  mainAxisAlignment: MainAxisAlignment.center, //center vertically
                  children: <Widget>[
                    const Text(
                      'The current time is',
                    ),
                    Text(
                      '$time_string',
                      style: Theme.of(context).textTheme.headline4,
                    ),
                    const Text(
                      'The current date is',
                    ),
                    Text(
                      '$date_string',
                      style: Theme.of(context).textTheme.headline4,
                    ),
                    // Already set alarms
                    Text(
                      'Here the already set alarms will be displayed.'
                    )
                  ],
                ),
              ),
            ],
          ),
        ),
    );
  }
}
