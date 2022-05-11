// *********************************
// This is the homepage
// *********************************


import 'package:flutter/material.dart'; //Google Material Design assets
import 'package:intl/intl.dart';
import 'dart:async';
import 'dart:developer' as dev;
import 'package:is_first_run/is_first_run.dart'; // for setting variables only on first start of the app
import 'package:shared_preferences/shared_preferences.dart'; // for saving/loading data for new start of the app
import 'dart:convert'; // for JSON etc.
import 'package:wakelock/wakelock.dart'; // this is needed to keep the screen active
import 'package:flutter_local_notifications/flutter_local_notifications.dart'; // notifications when the alarm is ringing
import 'package:awesome_notifications/awesome_notifications.dart'; // notifications when the alarm is ringing (alternative)
import '../alarm.dart'; // functions and more for the alarm
import '../quiz.dart'; // as quiz // functions and more for the quiz
import '../global.dart'; // global variables and general outsourced stuff
import 'widget-alarm-trigger.dart'; // widget for the alarm exposure
import 'widget-add-alarm.dart'; // widget for the alarm adding




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
  DateTime _now = DateTime
      .now(); // init it once, otherwise it will show NULL in the beginning
  String _dateString = DateFormat("MMMM dd, yyyy").format(DateTime
      .now()); // init it once, otherwise it will show NULL in the beginning
  String _timeString = DateFormat("HH:mm:ss").format(DateTime
      .now()); // init it once, otherwise it will show NULL in the beginning

  late Timer
  _refreshTimer; // timer to refresh the screen like for the current time
  late Timer _alarmCheckerTimer; // timer to check for the alarm trigger status
  late Timer _saveDataTimer; // timer to save/backup data regularly

  /// refresh the presented strings for the current time etc.
  void _updateTime() {
    setState(() {
      // setState tells the Flutter framework that something has changed in this state, which causes it to rerun the build method
      _now = DateTime.now();
      _dateString = DateFormat("MMMM dd, yyyy").format(_now);
      _timeString = DateFormat("HH:mm:ss").format(_now);
      // _timeString = DateFormat('hh:mm:ss a').format(DateTime.now());
    });
  }

  /// check whether one of the alarms is triggered
  _alarmChecker(List<CustomAlarm?> currentAlarmList) {
    setState(() {
      // check whether there is any alarm that is the past and is not set to isRinging=False yet
      for (int i = 0; i < currentAlarmList.length; i++) {
        // first check whether the alarm is active
        if (currentAlarmList[i]!.isActive == true) {
          // case 1: single time alarm
          if (currentAlarmList[i]!.isRecurrent == false) {
            // the day has passed
            if (currentAlarmList[i]!.alarmDate.isBefore(DateTime(
                DateTime.now().year,
                DateTime.now().month,
                DateTime.now().day +
                    1))) // +1 day because also the same day should be included
                {
              // the time has passed
              double toDouble(TimeOfDay myTime) =>
                  myTime.hour + myTime.minute / 60.0; //conversion function
              if (toDouble(currentAlarmList[i]!.alarmTime) <=
                  (toDouble(TimeOfDay.now()))) {
                //only if isRinging is still false, build the next page; otherwise it would be done several times leading to glitches
                if (currentAlarmList[i]!.isRinging == false) {
                  dev.log("Single alarm is going off!", name: 'Alarm');
                  playAlarmSound(0.5); // play alarm
                  Wakelock.enable(); // keep the screen active

                  // create a notification
                  AwesomeNotifications().createNotification(
                    content: NotificationContent(
                      id: 10,
                      channelKey: 'basic_channel',
                      title: 'Simple Notification',
                      body: 'Simple body',
                    ),
                  );

                  // only go to the alarm ringing page if we are not there (otherwise it will be reloaded like every second);
                  // that's why we call the function only in the states (routes) for the alarm overview and the alarm adding;
                  // todo die funtion auslagern, soll auch bei  addalarm route gemacht werden

                  currentAlarmList[i]!.isRinging =
                  true; // set to true for next time todo outsource to another function onChange isRinging. //todo alarm ringing page

                  saveData();

                  Navigator.push(
                    // alarm will ring
                    context,
                    MaterialPageRoute(
                        builder: (context) => ShowAlarmPage(currentAlarmList[i],
                            i)), // return details about current alarm since parts of it will be displayed
                  );
                  break; // break first for letting ring only one alarm if there are multiple
                  //return;
                }
              }
            }
          }

          // case 2: recurring alarm
          else if (currentAlarmList[i]!.isRecurrent == true) {
            //todo that's a bit more complicated
            //dev.log("Recurrent alarm is going off!", name: 'Alarm');
          }
        }
      }
    });
  }

  /// function to delete the alarm
  void _deleteAlarm(
      List<CustomAlarm?> currentAlarmList, int itemNumberToBeRemoved) {
    setState(() {
      currentAlarmList.removeAt(itemNumberToBeRemoved);
      dev.log("Alarm has been deleted!", name: 'Alarm');
    });
  }

  @override
  void initState() {
    // the timers will be run here, otherwise thousands of timers will be generated
    // update shown times regularly
    _refreshTimer = Timer.periodic(everySecond, (Timer t) => _updateTime());
    //This will cause that the updateTime() function will be exected every second;

    // check for alarm status regularly
    _alarmCheckerTimer = Timer.periodic(
        every2Seconds, (Timer t) => _alarmChecker(listOfSavedAlarms));

    // save data regularly (just in case)
    _saveDataTimer = Timer.periodic(every2Minutes, (Timer t) => saveData());

    loadData(); // load backup of alarm list
    stopAlarmSound(); // turn off sound from last start

    super.initState();
  }

  /// Loading listOfSavedAlarms (on start)
  Future<void> loadData() async {
    dev.log("Loading alarm data...", name: 'Alarm');
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      if (prefs.containsKey('alarmList')) {
        listOfSavedAlarms = (prefs.getStringList('alarmList') ?? [])
            .map((alarm) => CustomAlarm.fromJson(jsonDecode(alarm)))
            .toList();
        dev.log('Loaded ${listOfSavedAlarms.length} saved alarms',
            name: 'Alarm');
      } else {
        dev.log('No saved alarms found', name: 'Alarm');
      }
    });
  }

  @override
  void dispose() {
    //after timer is done, dispose it and it can be reused
    _refreshTimer.cancel();
    _alarmCheckerTimer.cancel();
    _saveDataTimer.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      // I need this to deactivate the "Go back" button
      onWillPop: () async => false, // Deactivate "Go back" button
      child: Scaffold(
        appBar: AppBar(
          title: Text(widget.title),
          centerTitle: true,
        ),
        body: Container(
          margin: const EdgeInsets.all(20.0),
          child: ListView(
            //scrollable
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
                                _timeString,
                                style: Theme.of(context).textTheme.headline6,
                              ),
                              const Text(
                                'The current date is',
                              ),
                              Text(
                                _dateString,
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
                                      builder: (context) =>
                                      const AddAlarmPage()),
                                );
                              }),
                        ),
                      ),
                    ],
                  ),

                  Row(
                    children: <Widget>[SizedBox(height: 70)],
                  ),
                  // Add some distance between the next row

                  // List of alarms (for loop)
                  for (int i = 0; i < listOfSavedAlarms.length; i++)
                  //for (final alarm_element in listOfSavedAlarms)
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
                                        GestureDetector(
                                          // I need this for the clicking on the text function to edit the alarm
                                          onTap: () {
                                            //EditAlarm can be done here, but I didn't implement it
                                            // Navigator.push(
                                            //   context,
                                            //   MaterialPageRoute(
                                            //     builder: (context) => EditAlarmPage(listOfSavedAlarms[i], i)),
                                            //   );
                                          },
                                          child: Text(
                                            "${listOfSavedAlarms[i]?.nameOfAlarm}",
                                            style: TextStyle(
                                                color: (listOfSavedAlarms[i]
                                                    ?.isActive ==
                                                    true)
                                                    ? Colors.black
                                                    : Colors.black38,
                                                fontSize: 20,
                                                fontWeight: FontWeight
                                                    .w500 //, spacing...: 0.15
                                            ),
                                          ),
                                        ),

                                        //Delete the alarm
                                        IconButton(
                                          icon:
                                          const Icon(Icons.delete_outlined),
                                          tooltip: 'Delete the alarm',
                                          color:
                                          (listOfSavedAlarms[i]?.isActive ==
                                              true)
                                              ? Colors.black38
                                              : Colors.black26,
                                          iconSize: 20.0,
                                          onPressed: () => showDialog<String>(
                                            context: context,
                                            builder: (BuildContext context) =>
                                                AlertDialog(
                                                  title: Text('Delete alarm?'),
                                                  content: Text(
                                                      'You are about to delete this alarm.'),
                                                  actions: [
                                                    TextButton(
                                                      onPressed: () =>
                                                          Navigator.pop(
                                                              context, 'CANCEL'),
                                                      //close dialog
                                                      child: Text('CANCEL'),
                                                    ),
                                                    TextButton(
                                                      onPressed: () => [
                                                        //close dialog and delete alarm at the same time
                                                        _deleteAlarm(
                                                            listOfSavedAlarms, i),
                                                        Navigator.pop(
                                                            context, 'DELETE'),
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
                                          "${listOfSavedAlarms[i]?.alarmTime.hour.toString().padLeft(2, '0')}:${listOfSavedAlarms[i]?.alarmTime.minute.toString().padLeft(2, '0')}",
                                          style: TextStyle(
                                              color: (listOfSavedAlarms[i]
                                                  ?.isActive ==
                                                  true)
                                                  ? Colors.black
                                                  : Colors.black38,
                                              fontSize: 20,
                                              fontWeight: FontWeight
                                                  .w500 //, spacing...: 0.15
                                          ),
                                        ),
                                        Text("  "),
                                        // add some space

                                        //Display the date / the recurring weekdays
                                        (listOfSavedAlarms[i]?.isRecurrent ==
                                            true)
                                            ? // check for the mode via a?b:c

                                        // case one: recurrence mode
                                        Text(
                                          weekdayBoolListToString(
                                              listOfSavedAlarms[i]!
                                                  .weekdayRecurrence),
                                          style: TextStyle(
                                              color: (listOfSavedAlarms[i]
                                                  ?.isActive ==
                                                  true)
                                                  ? Colors.black
                                                  : Colors.black38),
                                        )
                                            :

                                        // case two: date mode
                                        Text(
                                          DateFormat('EEE, d MMM').format(
                                              listOfSavedAlarms[i]!
                                                  .alarmDate),
                                          style: TextStyle(
                                              color: (listOfSavedAlarms[i]
                                                  ?.isActive ==
                                                  true)
                                                  ? Colors.black
                                                  : Colors.black38),
                                        ),
                                      ],
                                    ),
                                  ),
                                  Expanded(
                                    flex: 3,
                                    child: Row(),
                                  ),
                                  Expanded(
                                    // Toggle/Switch for active/inactive
                                    flex: 2,
                                    child: Row(
                                      children: <Widget>[
                                        Switch(
                                          value: listOfSavedAlarms[i]!.isActive,
                                          activeColor: Color(0xFF6200EE),
                                          onChanged: (bool value) {
                                            setState(() {
                                              listOfSavedAlarms[i]!.isActive =
                                                  value;
                                              saveData();
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

                  Row(
                    // Add some space
                    children: <Widget>[
                      SizedBox(height: 60),
                    ],
                  ),

                  debugMode
                      ? Row(
                    // row for reset function (only debug mode...)
                    children: <Widget>[
                      Expanded(
                        // Col/Expanded for showing the current time and date
                        flex: 8,
                        child: Center(),
                      ),
                      Expanded(
                        // Col/Expanded for the add alarm button
                        flex: 2,
                        child: Align(
                          alignment: Alignment.centerRight,
                          child: IconButton(
                              icon: const Icon(Icons.dangerous),
                              tooltip: 'Reset the app',
                              color: Colors.black26,
                              iconSize: 20.0,
                              onPressed: () {
                                setState(() {
                                  listOfSavedAlarms = initAlarms();
                                });
                              }),
                        ),
                      ),
                    ],
                  )
                      : Row(),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
