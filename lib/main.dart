import 'package:flutter/material.dart'; //Google Material Design assets
//import 'package:english_words/english_words.dart';
import 'package:intl/intl.dart';
import 'dart:async';
import 'package:weekday_selector/weekday_selector.dart';
import 'globals.dart' as globals; //global variables and stuff from other .dart file

void main()
{
  print("App is being started...");
  runApp(const MyApp());
  globals.listOfSavedAlarms = globals.initApp(); //init the app; creating default alarms etc. and store into a globally available list
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
  static const everySecond = Duration(seconds: 1);
  DateTime? _now;
  String? _dateString;
  String? _timeString;
  bool _alarmActive = false; //todo das in Liste etc. für alle alarme...

  void _updateTime() {
    setState(() {
      // setState is needed to tell the Flutter framework that something has
      // changed in this State, which causes it to rerun the build method below
      // so that the display can reflect the updated values.
      _now = DateTime.now();
      _dateString = DateFormat("MMMM, dd, yyyy").format(_now!);
      _timeString = DateFormat("HH:mm:ss").format(_now!);
      // _timeString = DateFormat('hh:mm:ss a').format(DateTime.now());
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
                          '$_timeString',
                          style: Theme.of(context).textTheme.headline6,
                        ),
                        const Text(
                          'The current date is',
                        ),
                        Text(
                          '$_dateString',
                          style: Theme.of(context).textTheme.headline6,
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
              mainAxisAlignment: MainAxisAlignment.center, //center vertically
              children: <Widget>[
                SizedBox(height: 70), // Add some distance between the next row
                Align(
                  alignment: Alignment.center,
                  child: Text('Here the already set alarms will be displayed.'),
                ),
              ],
            ),


            // List of alarms (for loop)
            for (final alarm_element in globals.listOfSavedAlarms) //todo klammern //todo zugehörigkeit alles
              Row( // Row for the set alarms I
                children: <Widget>[
                  Expanded(child:
                  Column(children: <Widget>[

                  Row( // Row for the set alarms I
                    children: <Widget>[
                      Expanded(
                      flex: 5,
                      child: Row(
                        //mainAxisAlignment: MainAxisAlignment.center,
                        children: <Widget>[
                          //todo dafür sorgen dass ALLE alarmde dargestellt werden
                          //todo schauen ob alarmList und ListOf...ob das passt.
                          Text(
                            "${alarm_element?.nameOfAlarm}",
                            style:TextStyle(
                                color: (alarm_element?.isActive == true) ? Colors.black : Colors.black38 , //change color depending on the current recurrence mode
                                fontSize: 20, fontWeight: FontWeight.w500//, spacing...: 0.15
                            ),
                          ),
                        ],
                      ),
                      ),
                      Expanded( // Col/Expanded for the add alarm button
                        flex: 5,
                        child: Row(), //empty
                      ),
                    ],
                  ),
                  // some space
                  Row(
                    children: <Widget>[
                      SizedBox(height: 9),
                    ],
                  ),
                  Row( // Row for the set alarms II
                    children: <Widget>[
                      Expanded(
                        flex: 5,
                        child: Row(
                          //mainAxisAlignment: MainAxisAlignment.center,
                          children: <Widget>[
                            //todo dafür sorgen dass ALLE alarmde dargestellt werden
                            //todo schauen ob alarmList und ListOf...ob das passt.
                            Text(
                              "${alarm_element?.alarmTime.hour}:${alarm_element?.alarmTime.minute}",
                              style:TextStyle(
                                  color: (alarm_element?.isActive == true) ? Colors.black : Colors.black38 , //change color depending on the current recurrence mode
                                  fontSize: 20, fontWeight: FontWeight.w500//, spacing...: 0.15
                              ),
                            ),
                            Text("  "), // add some space

                            //Display the date / the recurring weekdays
                            (alarm_element?.isRecurrent == true) ? // check for the mode via a?b:c

                            // case one: recurrence mode
                            Text
                            (
                                "${globals.weekdayBoolListToString(alarm_element!.weekdayRecurrence)}",
                                style:TextStyle(color: (alarm_element.isActive == true) ? Colors.black : Colors.black38), //change color depending on the current recurrence mode
                            ):

                            // case two: date mode
                            Text
                            (
                                "${DateFormat('EEE, d MMM').format(alarm_element!.alarmDate)}",
                                style:TextStyle(color: (alarm_element.isActive == true) ? Colors.black : Colors.black38), //change color depending on the current recurrence mode
                            ),

                          ],
                        ),
                      ),
                      Expanded( // Show date or weekdays
                        flex: 3,
                        child: Row(
                          //todo here dann flexibel anzeigen...
                        ),
                      ),
                      Expanded( // Toggle/Switch for active/inactive
                        flex: 2,
                        child: Row(
                          children: <Widget>[
                            Switch(
                              value: alarm_element.isActive,
                              activeColor: Color(0xFF6200EE),
                              onChanged: (bool value) {
                                setState(() {
                                  alarm_element.isActive = value;
                                });
                              },
                            ),
                        ],
                        ),
                      ),
                    ],
                  ),

                    // some space
                    Row(
                      children: <Widget>[
                        SizedBox(height: 25),
                      ],
                    ),
                ],
              ),
            ),
          ],
        ),

  //}, // end of the for loop todo brauche ich was

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
  TimeOfDay _chosenTime = TimeOfDay(hour: 7, minute: 15);
  DateTime _chosenDate = DateTime.now(); // DateTime(2022, 1, 1);
  List<bool> _chosenWeekdays = List.filled(7, false); // for weekday picker
  bool _challengingModeActive = false;
  bool _recurrentMode = false;

  /// function to save alarm
  List<globals.customAlarm?> _saveAlarm(List<globals.customAlarm?> currentalarmList)
  {
    List<globals.customAlarm?> alarmList = currentalarmList;
    globals.customAlarm? newCreatedAlarm = globals.customAlarm(); // create a new default alarm

    // overwrite the default values
    newCreatedAlarm.isActive = true; // if saved, then automatically make active
    //newCreatedAlarm.nameOfAlarm = "New alarm"; // This feature won't be available in this version
    newCreatedAlarm.alarmTime = _chosenTime;
    newCreatedAlarm.alarmDate = _chosenDate;
    newCreatedAlarm.isRecurrent = _recurrentMode;
    newCreatedAlarm.weekdayRecurrence = _chosenWeekdays;
    newCreatedAlarm.challengeMode = _challengingModeActive;
    alarmList.add(newCreatedAlarm); //add the alarm to the list
    print("Alarm has been created!");
    globals.listOfSavedAlarms = alarmList; //save the local list back to the global one
    return alarmList;
  }


  void _selectTime() async {
    final TimeOfDay? newTime = await showTimePicker(
      context: context,
      initialTime: _chosenTime,
    );
    if (newTime != null) {
      setState(() {
        _chosenTime = newTime;
      });
    }
  }


  void _selectDate() async {
    final DateTime? newDate = await showDatePicker(
      context: context,
      initialDate: _chosenDate,
      firstDate: DateTime.now(), // today;
      lastDate: DateTime(DateTime.now().year + 5, DateTime.now().month, DateTime.now().day), // today plus later
      helpText: 'Select a date',
    );
    if (newDate != null) { //close the menu and save
      setState(() {
        _chosenDate = newDate;
        _recurrentMode = false; // if date is chosen and saved, set recurrent mode to false
        _chosenWeekdays = List.filled(7, false);// if date is chosen and saved, also make the recurrent buttons default again
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
                                '${_chosenTime.format(context)}',
                                style: Theme.of(context).textTheme.headline6, //textTheme.subtitle1
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
                                style:TextStyle(color: _recurrentMode == false ? Colors.black : Colors.black26), //change color depending on the current recurrence mode
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
                                '${DateFormat('MMMEd').format(_chosenDate)}',
                                style:
                                TextStyle(
                                        color: _recurrentMode == false ? Colors.black : Colors.black26 , //change color depending on the current recurrence mode
                                        fontSize: 20, fontWeight: FontWeight.w500//, spacing...: 0.15
                                      ),
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
                          _chosenWeekdays[index] = !_chosenWeekdays[index];

                          // if any weekday is active, activate recurrent mode, otherwise not
                          if (_chosenWeekdays.any((e) => e == true))
                          {
                            _recurrentMode = true;
                          }
                          else {
                            _recurrentMode = false;
                          }
                        });
                      },
                      values: _chosenWeekdays,
                    ),
                  ),
              ],
            ),

            Row( // Add some space
              children: <Widget>[
                SizedBox(height: 10),
              ],
            ),

            Row( // Toggle/Switch for Challenge Mode
              children: <Widget>[
                Expanded(
                  flex: 8,
                  child:
                      Text
                      ('Challenge mode',
                        style:
                        TextStyle(
                            color: (_challengingModeActive == true) ? Colors.black : Colors.black38
                        ), //change color depending on the current recurrence mode
                      ),
                  ),
                 Expanded(
                   flex: 2,
                   child:
                      Switch(
                        value: _challengingModeActive,
                        activeColor: Color(0xFF6200EE),
                        onChanged: (bool value) {
                          setState(() {
                            _challengingModeActive = value;
                          });
                        },
                      ),
                  ),
              ],
            ),
            Row( // Add some space
              children: <Widget>[
                SizedBox(height: 30),
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
                      //on pressed save the alarm and close the menu at the same time
                      onPressed: ()=>[_saveAlarm(globals.listOfSavedAlarms),Navigator.pop(context)],
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
