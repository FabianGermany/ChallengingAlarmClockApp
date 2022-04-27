import 'package:flutter/material.dart'; //Google Material Design assets
import 'package:english_words/english_words.dart';
import 'package:intl/intl.dart';
import 'dart:async';
import 'package:weekday_selector/weekday_selector.dart';
import 'globals.dart' as globals; //global variables and stuff from other .dart file

void main() {
  print("App is being started...");
  runApp(const MyApp());


  // todo this should only be done once when the app is launched for the first time...reset function etc.
  globals.customAlarm? firstDefaultAlarm = globals.customAlarm(); // create one default alarm
  firstDefaultAlarm.nameOfAlarm = "Weekly meeting";
  globals.customAlarm? SavedCreatedAlarm;
  globals.customAlarm? newCreatedAlarm;
  print("App has been fully loaded...");
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
  DateTime? now;
  String? date_string;
  String? time_string;
  static const everySecond = Duration(seconds: 1);

  void _updateTime() {
    setState(() {
      // setState is needed to tell the Flutter framework that something has
      // changed in this State, which causes it to rerun the build method below
      // so that the display can reflect the updated values.
      now = DateTime.now();
      date_string = DateFormat("MMMM, dd, yyyy").format(DateTime.now());
      time_string = DateFormat("HH:mm:ss").format(DateTime.now());
      // time_string = DateFormat('hh:mm:ss a').format(DateTime.now());
    });
  }

  @override
  Widget build(BuildContext context) {
    Timer.periodic(
        everySecond,
        (Timer t) =>
            _updateTime()); //This will cause that the updateTime() function will be exected every second; todo I'm not sure why it only runs in the build function...
    // This method is rerun every time setState is called, for instance as done
    // by the _updateTime method above.
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: Container(
        margin: const EdgeInsets.all(20.0),
        child: Column(
          children: <Widget>[
            // I need this single column to allow multiple rows
            Row( // Row for the current date/time and the add alarm button
              children: <Widget>[
                Expanded( // Col/Expanded for showing the current time and date
                  flex: 7, // 70%
                  child: Center(
                    child: Column(
                      // Column is also a layout widget
                      mainAxisAlignment: MainAxisAlignment.center,
                      //center vertically
                      children: <Widget>[
                        const Text(
                          'The current time is',
                        ),
                        Text(
                          '$time_string',
                          style: Theme.of(context).textTheme.headline5,
                        ),
                        const Text(
                          'The current date is',
                        ),
                        Text(
                          '$date_string',
                          style: Theme.of(context).textTheme.headline5,
                        ),
                        // Already set alarms
                      ],
                    ),
                  ),
                ),
                Expanded( // Col/Expanded for adding some space
                    flex: 1, // 10%
                    child: Text('') //empty
                    ),
                Expanded( // Col/Expanded for the add alarm button
                  flex: 2, // 20%
                  child: Align(
                    alignment: Alignment.centerRight,
                    child: IconButton(
                        icon: const Icon(Icons.add),
                        tooltip: 'Add a new alarm',
                        color: Colors.deepPurple,
                        iconSize: 50.0,
                        onPressed: () {
                          //globals.newCreatedAlarm = customAlarm();
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => const AddAlarmPage()),
                          );
                        }),
                  ),
                ),
              ],
            ),
            Row( // Row for the set alarms
              // Second row
              mainAxisAlignment: MainAxisAlignment.center, //center vertically
              children: <Widget>[
                SizedBox(height: 70), // Add some distance between the next row
                Align(
                  alignment: Alignment.center,
                  child: Text('Here the already set alarms will be displayed.'),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

// Second page for adding the alarm
class AddAlarmPage extends StatefulWidget {
  const AddAlarmPage({Key? key}) : super(key: key);

  @override
  State<AddAlarmPage> createState() => _MyAddAlarmPageState();
}

class _MyAddAlarmPageState extends State<AddAlarmPage> {
  TimeOfDay _time = TimeOfDay(hour: 7, minute: 15);
  DateTime _date = DateTime.now(); // DateTime(2022, 1, 1);

  final chosen_weekdays = List.filled(7, false); // for weekday picker


  void _selectTime() async {
    final TimeOfDay? newTime = await showTimePicker(
      context: context,
      initialTime: _time,
    );
    if (newTime != null) {
      setState(() {
        _time = newTime;
      });
    }
  }


  void _selectDate() async {
    final DateTime? newDate = await showDatePicker(
      context: context,
      initialDate: _date,
      firstDate: DateTime.now(), // today;
      lastDate: DateTime(DateTime.now().year + 5, DateTime.now().month, DateTime.now().day), // today plus later
      helpText: 'Select a date',
    );
    if (newDate != null) {
      setState(() {
        _date = newDate;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Add an alarm'),
      ),
      body: Container(
        margin: const EdgeInsets.all(20.0),
        child: Column(
          children: <Widget>[

            Row( // Time selector
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Expanded(
                  flex: 5,
                  child: ElevatedButton(
                    onPressed: _selectTime,
                    child: Text('Select time'),
                  ),
                ),
                Expanded(
                  flex: 5,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      Column(
                        children: <Widget>[
                          Row(
                            children: <Widget>[
                              Text(
                                'Selected time:',
                              ),
                            ],
                          ),
                          Row(
                            children: <Widget>[
                              SizedBox(height: 6),
                            ],
                          ),
                          Row(
                            children: <Widget>[
                              Text(
                                '${_time.format(context)}',
                                style: Theme.of(context).textTheme.headline6,
                              ),
                            ],
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),




            Row( // Info text
              children: <Widget>[
                Expanded(
                  child:
                  const Text(
                    '\nPlease chose either a concrete date for the alarm or - if it is repetitive - choose the desired weekdays.\n',
                  ),
                ),
              ],
            ),


            Row( // Date selector
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Expanded(
                  flex: 5,
                  child: ElevatedButton(
                    onPressed: _selectDate,
                    child: Text('Select date'),
                  ),
                ),
                Expanded(
                  flex: 5,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      Column(
                        children: <Widget>[
                          Row(
                            children: <Widget>[
                              Text(
                                'Selected date:',
                              ),
                            ],
                          ),
                          Row(
                            children: <Widget>[
                              SizedBox(height: 6),
                            ],
                          ),
                          Row(
                            children: <Widget>[
                              Text( // todo flexible geht hier irgendwie nicht...
                                '${DateFormat('yMMMEd').format(_date)}',
                                style: Theme.of(context).textTheme.headline6,
                              ),
                            ],
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),

            Row( // Add some space
              children: <Widget>[
                SizedBox(height: 10),
              ],
            ),

            Row( // Weekday picker
              children: <Widget>[
                Expanded(
                  child:
                    WeekdaySelector(
                      onChanged: (int day) {
                        setState(() {
                          final index = day % 7;
                          chosen_weekdays[index] = !chosen_weekdays[index];
                        });
                      },
                      values: chosen_weekdays,
                    ),
                  ),
              ],
            ),

            Row( // Add some space
              children: <Widget>[
                SizedBox(height: 10),
              ],
            ),

            Row( // Cancel and confirm buttons
              children: <Widget>[
                // Cancel button
                Expanded(
                  flex: 30,
                  child: Center(
                    child: OutlinedButton(
                      onPressed: () {
                        Navigator.pop(context);
                        // todo destruct object
                      },
                      child: const Text('Cancel'),
                    ),
                  ),
                ),
                Expanded( // Some space
                  flex: 40,
                  child: Center(
                  ),
                ),

                Expanded( // Confirm button
                  flex: 30, // 30%
                  child: Center(
                    child: OutlinedButton(
                      onPressed: () {
                        Navigator.pop(context);
                        // save object
                        //SavedCreatedAlarm = newCreatedAlarm;
                        //todo hier noch speichern!
                      },
                      child: const Text('Confirm'),
                    ),
                  ),
                ),

              ],
            ),
          ],
        ),
      ),
    );
  }
}
