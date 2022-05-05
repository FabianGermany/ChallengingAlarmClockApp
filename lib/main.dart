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


// *********************************
// This is the homepage
// *********************************
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
  DateTime _now = DateTime.now(); // init it once, otherwise it will show NULL in the beginning
  String _dateString = DateFormat("MMMM dd, yyyy").format(DateTime.now()); // init it once, otherwise it will show NULL in the beginning
  String _timeString = DateFormat("HH:mm:ss").format(DateTime.now()); // init it once, otherwise it will show NULL in the beginning

  late Timer _refreshTimer; //timer to refresh the screen like for the current time
  late Timer _alarmCheckerTimer; //timer to check for the alarm trigger status

  /// refresh the presented strings for the current time etc.
  void _updateTime() {
    // debugPrint("Let me update the time...");
    setState(() { // setState tells the Flutter framework that something has changed in this state, which causes it to rerun the build method
      _now = DateTime.now();
      _dateString = DateFormat("MMMM dd, yyyy").format(_now);
      _timeString = DateFormat("HH:mm:ss").format(_now);
      // _timeString = DateFormat('hh:mm:ss a').format(DateTime.now());
    });
  }

  /// check whether one of the alarms is triggered
  _alarmChecker(List<globals.CustomAlarm?> currentAlarmList)
  {
    setState(() {
      // debugPrint("Let me check the alarm state...");
    // check whether there is any alarm that is the past and is not set to isRinging=False yet
      for (int i = 0; i < currentAlarmList.length; i++)
        {
          // first check whether the alarm is active
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
                      //only if isRinging is still false, build the next page; otherwise it would be done several times leading to glitches
                      if(currentAlarmList[i]!.isRinging == false)
                        {
                          debugPrint("Single alarm is going off!");

                          // only go to the alarm ringing page if we are not there (otherwise it will be reloaded like every second);
                          // that's why we call the function only in the states (routes) for the alarm overview and the alarm adding;
                          // todo die funtion auslagern, soll auch bei  addalarm route gemacht werden

                          currentAlarmList[i]!.isRinging = true; // set to true for next time todo outsource to another function onChange isRinging. //todo alarm ringing page

                          Navigator.push(  // alarm will ring
                            context,
                            MaterialPageRoute(
                                builder: (context) => ShowAlarmPage(currentAlarmList[i])), // return details about current alarm since parts of it will be displayed
                          );
                          break; // break first for letting ring only one alarm if there are multiple
                          //return;
                        }
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
  void initState() { //the timers will be run here, otherwise thousands of timers will be generated
    // update shown times regularly
    _refreshTimer = Timer.periodic(globals.everySecond, (Timer t) => _updateTime());
    //This will cause that the updateTime() function will be exected every second;

    // check for alarm status regularly
    _alarmCheckerTimer = Timer.periodic(globals.every2Seconds, (Timer t) => _alarmChecker(globals.listOfSavedAlarms));

    super.initState();
  }


  @override
  void dispose() { //after timer is done, dispose it and it can be reused
    _refreshTimer.cancel();
    _alarmCheckerTimer.cancel();
    super.dispose();
  }


  @override
  Widget build(BuildContext context) {

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


            Row(children: <Widget>[SizedBox(height: 70)],), // Add some distance between the next row



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
                              GestureDetector( // I need this for the clicking on the text function to edit the alarm
                              onTap: () { //Todo EditAlarm
                                    // Navigator.push(
                                    //   context,
                                    //   MaterialPageRoute(
                                    //     builder: (context) => EditAlarmPage(globals.listOfSavedAlarms[i], i)),
                                    //   );
                                    },
                                    child:
                                      Text(
                                        "${globals.listOfSavedAlarms[i]?.nameOfAlarm}",
                                        style: TextStyle(
                                            color: (globals.listOfSavedAlarms[i]?.isActive == true)
                                                ? Colors.black
                                                : Colors.black38,
                                            //change color depending on the current recurrence mode
                                            fontSize: 20,
                                            fontWeight: FontWeight.w500 //, spacing...: 0.15
                                        ),
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
                                        fontWeight: FontWeight.w500 //, spacing...: 0.15
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




// *********************************
// This is the second page for adding the alarm
// *********************************
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

  void _selectDate() async {  //todo das und andere sachen vll.t auslagern weil doppelt gemoppelt?
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
        title: const Text('Add an alarm'),
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
                                    fontWeight: FontWeight.w500 //, spacing...: 0.15
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
                          border: OutlineInputBorder(),
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














// *********************************
// This is the third page for showing the alarm
// *********************************
class ShowAlarmPage extends StatefulWidget {
  final globals.CustomAlarm? TriggeredAlarm;
  const ShowAlarmPage(this.TriggeredAlarm);

  @override
  State<ShowAlarmPage> createState() => _MyShowAlarmPageState();
}

class _MyShowAlarmPageState extends State<ShowAlarmPage> {
  //vars here
  //functions here


  DateTime _now = DateTime.now(); // init it once, otherwise it will show NULL in the beginning
  String _dateString = DateFormat("EEEE, MMMM dd").format(DateTime.now()); // init it once, otherwise it will show NULL in the beginning
  String _timeStringShort = DateFormat("HH:mm").format(DateTime.now()); // init it once, otherwise it will show NULL in the beginning

  late Timer _refreshTimer; //timer to refresh the screen like for the current time

  /// refresh the presented strings for the current time etc.
  void _updateTime() {
    // debugPrint("Let me update the time...");
    setState(() { // setState tells the Flutter framework that something has changed in this state, which causes it to rerun the build method
      _now = DateTime.now();
      _dateString = DateFormat("EEEE, MMMM dd").format(_now);
      _timeStringShort = DateFormat("HH:mm").format(_now);
    });
  }



  @override
  void initState() {
    _refreshTimer = Timer.periodic(globals.everySecond, (Timer t) => _updateTime());
    super.initState();
  }

  @override
  void dispose() {
    _refreshTimer.cancel();
    super.dispose();
  }



  //todo ggf. parameter übergeben; siehe anderer branch...; oder mit der Klasse direkt arbeiten...

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFFE4DAFC),
      body: Container(
        margin: const EdgeInsets.all(20.0),
        child: Column( //todo maybe use Flexible/Expanded
          children: <Widget>[
            Row(children: <Widget>[SizedBox(height: 70)],), // Add some distance between the next row
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Text(
                  "Alarm",
                  style: Theme.of(context).textTheme.headline6,),
              ],
            ),
            Row(children: <Widget>[SizedBox(height: 10)],), // Add some distance between the next row
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Text(
                  "${widget.TriggeredAlarm?.nameOfAlarm}",
                  style: TextStyle(
                  color: Colors.deepPurple,
                  //change color depending on the current recurrence mode
                  fontSize: 25,
                  fontWeight: FontWeight.w500 //, spacing...: 0.15
                ),
              ),
            ],
            ),
            Row(children: <Widget>[SizedBox(height: 100)],), // Add some distance between the next row
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Text(
                  "It's",
                  style: TextStyle(
                      color: Colors.black54,
                      //change color depending on the current recurrence mode
                      fontSize: 18,
                      fontWeight: FontWeight.w500 //, spacing...: 0.15
                  ),
                ),
              ],
            ),
            Row(children: <Widget>[SizedBox(height: 5)],), // Add some distance between the next row
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Text(
                  "${_timeStringShort}",
                  style: TextStyle(
                      color: Colors.black,
                      //change color depending on the current recurrence mode
                      fontSize: 60,
                      fontWeight: FontWeight.w600 //, spacing...: 0.15
                  ),
                ),
              ],
            ),
            Row(children: <Widget>[SizedBox(height: 10)],), // Add some distance between the next row
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Text(
                  "${_dateString}",
                  style: TextStyle(
                      color: Colors.black54,
                      //change color depending on the current recurrence mode
                      fontSize: 20,
                      fontWeight: FontWeight.w400 //, spacing...: 0.15
                  ),
                ),
              ],
            ),
      Row(children: <Widget>[SizedBox(height: 80)],), // Add some distance between the next row
      Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => const ShowChallengePage()),
                );
              },
            child: const Text('Stop'),
            //
          ),
            ],
          ),
        ],
      ),




      ),
    );
  }
}
















// *********************************
// This is the fourth page for the challenge
// *********************************
class ShowChallengePage extends StatefulWidget {
  const ShowChallengePage({Key? key}) : super(key: key);

  @override
  State<ShowChallengePage> createState() => _MyShowChallengePageState();
}

class _MyShowChallengePageState extends State<ShowChallengePage> {
  //vars here
  //functions here

  //todo ggf. parameter übergeben; siehe anderer branch...; oder mit der Klasse direkt arbeiten...

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFFE4DAFC),
      body: Container(
        margin: const EdgeInsets.all(20.0),
        child: Column(
          children: <Widget>[
            Row(
              // Time selector
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
              ],
            ),
          ],
        ),
      ),
    );
  }
}
