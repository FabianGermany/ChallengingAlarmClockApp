import 'package:flutter/material.dart'; //Google Material Design assets
//import 'package:english_words/english_words.dart';
import 'package:intl/intl.dart';
import 'dart:async';
import 'package:weekday_selector/weekday_selector.dart';
import 'globals.dart'
    as globals; //global variables and stuff from other .dart file

void main() {
  debugPrint("App is being started...");
  runApp(const MyApp());
  globals.listOfSavedAlarms = globals
      .initApp(); //init the app; creating default alarms etc. and store into a globally available list
  debugPrint("App has been fully loaded...");
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
  static const every2Seconds = Duration(seconds: 30);
  DateTime? _now;
  String? _dateString;
  String? _timeString;

  /// refresh the presented strings for the current time etc.
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

  /// check whether one of the alarms is triggered
  void _alarmChecker(List<globals.CustomAlarm?> currentAlarmList)
  {
    //todo bug geht erst sehr spät los...
    setState(() {
    // check whether there is any alarm that is the past and is not set to isRinging=False yet
      for (int i = 0; i < currentAlarmList.length; i++)
        {
          // first checker whether the alarm is active
          if(currentAlarmList[i]!.isActive == true)
            {
            // case 1: single time alarm
            if(currentAlarmList[i]!.isRecurrent == false)
              {
              // the day has passed //todo only compare date
              if(currentAlarmList[i]!.alarmDate.isBefore(DateTime(DateTime.now().year, DateTime.now().month, DateTime.now().day + 1))) // +1 day because also the same day should be included
                  {
                      // the time has passed
                    double toDouble(TimeOfDay myTime) => myTime.hour + myTime.minute/60.0; //conversion function
                    if(toDouble(currentAlarmList[i]!.alarmTime) <= (toDouble(TimeOfDay.now())))
                    {
                      currentAlarmList[i]!.isRinging = true; // alarm will ring //todo another function onChange isRinging. //todo alarm ringing page
                      debugPrint("Single alarm is going off!");
                      break; // break first for letting ring only one alarm if there are multiple
                    }
                  }
              }

            // case 2: recurring alarm
            else if(currentAlarmList[i]!.isRecurrent == true)
            {
              //todo that's a bit more complicated
              //debugPrint("Recurrent alarm is going off!");
            }

          }
        }
    });
  }

  /// function to delete the alarm //todo dialog
  void _deleteAlarm(List<globals.CustomAlarm?> currentAlarmList, int itemNumberToBeRemoved)
  {
    setState(() {
      currentAlarmList.removeAt(itemNumberToBeRemoved);
      debugPrint("Alarm has been deleted!");
    });
  }

  @override
  Widget build(BuildContext context) {

    // update shown times regularly
    Timer.periodic(
        everySecond,
        (Timer t) =>
            _updateTime()); //This will cause that the updateTime() function will be exected every second; todo I'm not sure why it only runs in the build function...
    // This method is rerun every time setState is called, for instance as done
    // by the _updateTime method above.

    // check for alarm status regularly
    Timer.periodic(
        every2Seconds,
            (Timer t) =>
                _alarmChecker(globals.listOfSavedAlarms));

    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: Container(
        margin: const EdgeInsets.all(20.0),
        child:
          ListView( //scrollable
            children: <Widget>[
              Column(
                children: <Widget>[
            // I need this single column to allow multiple rows
            Row(
              // Row for the current date/time and the add alarm button
              children: <Widget>[
                Expanded(
                  // Col/Expanded for showing the current time and date
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
                Expanded(
                    // Col/Expanded for adding some space
                    flex: 1, // 10%
                    child: Text('') //empty
                    ),
                Expanded(
                  // Col/Expanded for the add alarm button
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


            Row(
              // Row for the set alarms
              mainAxisAlignment: MainAxisAlignment.center, //center vertically
              children: <Widget>[
                SizedBox(height: 70), // Add some distance between the next row
              ],
            ),



            // List of alarms (for loop)
            for (int i = 0; i < globals.listOfSavedAlarms.length; i++)
            //for (final alarm_element in globals.listOfSavedAlarms)
              Row(
                // Row for the set alarms I
                children: <Widget>[
                  Expanded(
                    child: Column(
                      children: <Widget>[
                        Row(
                          // Row for the set alarms I
                          children: <Widget>[
                            Expanded(
                              flex: 10,
                              child: Row(
                                //mainAxisAlignment: MainAxisAlignment.center,
                                children: <Widget>[
                                  Text(
                                    "${globals.listOfSavedAlarms[i]?.nameOfAlarm}",
                                    style: TextStyle(
                                        color: (globals.listOfSavedAlarms[i]?.isActive == true)
                                            ? Colors.black
                                            : Colors.black38,
                                        //change color depending on the current recurrence mode
                                        fontSize: 20,
                                        fontWeight:
                                            FontWeight.w500 //, spacing...: 0.15
                                        ),
                                  ),

                                  //Delete the alarm
                                  IconButton(
                                      icon: const Icon(Icons.delete_outlined),
                                      tooltip: 'Delete the alarm',
                                      color: (globals.listOfSavedAlarms[i]?.isActive == true)
                                          ? Colors.black38
                                          : Colors.black26,
                                      iconSize: 20.0,
                                       onPressed:
                                       () => showDialog<String>(
                                          context: context,
                                          builder: (BuildContext context) =>
                                          //todo move it somewhere else; use a builder or something
                                          AlertDialog(
                                            title: Text('Delete alarm?'),
                                            content: Text('You are about to delete this alarm.'),
                                            actions: [
                                              TextButton(
                                                onPressed: () => Navigator.pop(context, 'CANCEL'), //close dialog
                                                child: Text('CANCEL'),
                                              ),
                                              TextButton(
                                                onPressed: ()=> [ //close dialog and delete alarm at the same time
                                                  _deleteAlarm(globals.listOfSavedAlarms, i),
                                                  Navigator.pop(context, 'DELETE'),
                                                ],
                                                  child: Text('DELETE'),
                                              ),
                                            ],
                                          ),
                                  ),
                                  ),
                                ],
                              ),
                            ),
                            Expanded(
                              // Col/Expanded for the add alarm button
                              flex: 0,
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
                        Row(
                          // Row for the set alarms II
                          children: <Widget>[
                            Expanded(
                              flex: 5,
                              child: Row(
                                //mainAxisAlignment: MainAxisAlignment.center,
                                children: <Widget>[
                                  Text(
                                    "${globals.listOfSavedAlarms[i]?.alarmTime.hour.toString().padLeft(2, '0')}:${globals.listOfSavedAlarms[i]?.alarmTime.minute.toString().padLeft(2, '0')}",
                                    style: TextStyle(
                                        color: (globals.listOfSavedAlarms[i]?.isActive == true)
                                            ? Colors.black
                                            : Colors.black38,
                                        //change color depending on the current recurrence mode
                                        fontSize: 20,
                                        fontWeight:
                                            FontWeight.w500 //, spacing...: 0.15
                                        ),
                                  ),
                                  Text("  "), // add some space

                                  //Display the date / the recurring weekdays
                                  (globals.listOfSavedAlarms[i]?.isRecurrent == true)
                                      ? // check for the mode via a?b:c

                                      // case one: recurrence mode
                                      Text(
                                          globals.weekdayBoolListToString(globals.listOfSavedAlarms[i]!.weekdayRecurrence),
                                          style: TextStyle(
                                              color: (globals.listOfSavedAlarms[i]?.isActive == true)
                                                  ? Colors.black
                                                  : Colors.black38), //change color depending on the current recurrence mode
                                        )
                                      :

                                      // case two: date mode
                                      Text(
                                          DateFormat('EEE, d MMM').format(globals.listOfSavedAlarms[i]!.alarmDate),
                                          style: TextStyle(
                                              color: (globals.listOfSavedAlarms[i]?.isActive == true)
                                                  ? Colors.black
                                                  : Colors.black38), //change color depending on the current recurrence mode
                                        ),
                                ],
                              ),
                            ),
                            Expanded(
                              // Show date or weekdays
                              flex: 3,
                              child: Row(
                                  //todo here dann flexibel anzeigen...
                                  ),
                            ),
                            Expanded(
                              // Toggle/Switch for active/inactive
                              flex: 2,
                              child: Row(
                                children: <Widget>[
                                  Switch(
                                    value: globals.listOfSavedAlarms[i]!.isActive,
                                    activeColor: Color(0xFF6200EE),
                                    onChanged: (bool value) {
                                      setState(() {
                                        globals.listOfSavedAlarms[i]!.isActive = value;
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
          ],
        ),
      ],
        ),
      ),
    );
  }
}

// Second page for adding/editing the alarm
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


  // Create a text controller and use it to retrieve the current value
  // of the Alarm TextField.
  final myAlarmNameController = TextEditingController(text: 'My personal alarm');

  @override
  void dispose() {
  // Clean up the controller when the widget is disposed.
    myAlarmNameController.dispose();
  super.dispose();
  }

  /// function to save the alarm
  List<globals.CustomAlarm?> _saveAlarm(
      List<globals.CustomAlarm?> currentAlarmList) {
    List<globals.CustomAlarm?> alarmList = currentAlarmList;
    globals.CustomAlarm? newCreatedAlarm =
        globals.CustomAlarm(); // create a new default alarm

    // overwrite the default values
    newCreatedAlarm.isActive = true; // if saved, then automatically make active
    newCreatedAlarm.nameOfAlarm = myAlarmNameController.text;
    newCreatedAlarm.alarmTime = _chosenTime;
    newCreatedAlarm.alarmDate = _chosenDate;
    newCreatedAlarm.isRecurrent = _recurrentMode;
    newCreatedAlarm.weekdayRecurrence = _chosenWeekdays;
    newCreatedAlarm.challengeMode = _challengingModeActive;
    alarmList.add(newCreatedAlarm); //add the alarm to the list
    debugPrint("Alarm has been created!");
    globals.listOfSavedAlarms =
        alarmList; //save the local list back to the global one
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
      firstDate: DateTime.now(),
      // today;
      lastDate: DateTime(
          DateTime.now().year + 5, DateTime.now().month, DateTime.now().day),
      // today plus later
      helpText: 'Select a date',
    );
    if (newDate != null) {
      //close the menu and save
      setState(() {
        _chosenDate = newDate;
        _recurrentMode =
            false; // if date is chosen and saved, set recurrent mode to false
        _chosenWeekdays = List.filled(7,
            false); // if date is chosen and saved, also make the recurrent buttons default again
      });
    }
  }

  // This is a GlobalKey<FormState>, not a GlobalKey<MyCustomFormState>.
  // It's needed for the input of the alarm name
  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Add or edit an alarm'),
      ),
      body: Container(
        margin: const EdgeInsets.all(20.0),
        child: Column(
          children: <Widget>[
            Row(
              // Time selector
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
                                _chosenTime.format(context),
                                style: Theme.of(context)
                                    .textTheme
                                    .headline6, //textTheme.subtitle1
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
            Row(
              // Info text
              children: <Widget>[
                Expanded(
                  child: const Text(
                    '\nPlease chose either a concrete date for the alarm or - if it is repetitive - choose the desired weekdays.\n',
                  ),
                ),
              ],
            ),
            Row(
              // Date selector
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
                                style: TextStyle(
                                    color: _recurrentMode == false
                                        ? Colors.black
                                        : Colors
                                            .black26), //change color depending on the current recurrence mode
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
                                // todo flexible geht hier irgendwie nicht...
                                DateFormat('MMMEd').format(_chosenDate),
                                style: TextStyle(
                                    color: _recurrentMode == false
                                        ? Colors.black
                                        : Colors.black26,
                                    //change color depending on the current recurrence mode
                                    fontSize: 20,
                                    fontWeight:
                                        FontWeight.w500 //, spacing...: 0.15
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
            Row(
              // Add some space
              children: <Widget>[
                SizedBox(height: 10),
              ],
            ),
            Row(
              // Weekday picker
              children: <Widget>[
                Expanded(
                  child: WeekdaySelector(
                    onChanged: (int day) {
                      setState(() {
                        final index = day % 7;
                        _chosenWeekdays[index] = !_chosenWeekdays[index];

                        // if any weekday is active, activate recurrent mode, otherwise not
                        if (_chosenWeekdays.any((e) => e == true)) {
                          _recurrentMode = true;
                        } else {
                          _recurrentMode = false;
                        }
                      });
                    },
                    values: _chosenWeekdays,
                  ),
                ),
              ],
            ),
            Row(
              // Add some space
              children: <Widget>[
                SizedBox(height: 10),
              ],
            ),

            // Type of alarm
            Row(
              children: <Widget>[
                Expanded(
                  flex: 8,
                  child:
                  Form(
                    key: _formKey,
                      child:
                        TextFormField(
                        controller: myAlarmNameController,
                        decoration: InputDecoration(
                          labelText: 'Name of alarm',
                          //errorText: , //todo show only if == "" or if more than 18;
                          border: OutlineInputBorder(),
                          //suffixIcon: Icon( //todo show only if == "";
                           // Icons.error,
                          //),
                      ),
                      validator: (value) {
                        if (value == null || value.isEmpty || value.length > 20) {
                          return 'Please use a name between 1 and 20 characters.';
                        }
                        return null;
                      },
                    ),

                  ),
                ),

              ],
            ),

            Row(
              // Add some space
              children: <Widget>[
                SizedBox(height: 10),
              ],
            ),
            Row(
              // Toggle/Switch for Challenge Mode
              children: <Widget>[
                Expanded(
                  flex: 8,
                  child: Text(
                    'Challenge mode',
                    style: TextStyle(
                        color: (_challengingModeActive == true)
                            ? Colors.black
                            : Colors
                                .black38), //change color depending on the current recurrence mode
                  ),
                ),
                Expanded(
                  flex: 2,
                  child: Switch(
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
            Row(
              // Add some space
              children: <Widget>[
                SizedBox(height: 30),
              ],
            ),
            Row(
              // Cancel and confirm buttons
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
                Expanded(
                  // Some space
                  flex: 40,
                  child: Center(),
                ),

                Expanded(
                  // Confirm button
                  flex: 30, // 30%
                  child: Center(
                    child: OutlinedButton(
                      //on pressed save the alarm and close the menu at the same time
                      // Validate returns true if the form is valid, or false otherwise.
                      onPressed:() {   if (_formKey.currentState!.validate()) {
                        // for multiple commands in onPressed this form should be used:
                        // () =>[command1, command2]
                        // but in if statement, it seems to be not necessary
                        _saveAlarm(globals.listOfSavedAlarms);
                        Navigator.pop(context);
                      } else {
                            //don't save it
                          }
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
