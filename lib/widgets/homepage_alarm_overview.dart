// *********************************
// This is the homepage
// *********************************

import 'package:flutter/material.dart'; //Google Material Design assets
import 'package:intl/intl.dart';
import 'dart:async';
import 'dart:developer' as dev;
import 'package:shared_preferences/shared_preferences.dart'; // for saving/loading data for new start of the app
import 'dart:convert'; // for JSON etc.
import '../alarm.dart'; // functions and more for the alarm
import '../global.dart'; // global variables and general outsourced stuff
import 'add_alarm_page.dart'; // widget for the alarm adding
import 'package:alarm_clock_app/components.dart';

class HomePageAlarmOverview extends StatefulWidget {
  const HomePageAlarmOverview({Key? key, required this.title})
      : super(key: key);

  // This widget is the homepage of the app. It has different states.
  final String title;

  @override
  State<HomePageAlarmOverview> createState() => _HomePageAlarmOverviewState();
}

class _HomePageAlarmOverviewState extends State<HomePageAlarmOverview> {
  // Declare vars for the time (init it once, otherwise it will show NULL in the beginning)
  DateTime _now = DateTime.now();
  String _dateString = DateFormat("MMMM dd, yyyy").format(DateTime.now());
  String _timeString = DateFormat("HH:mm:ss").format(DateTime.now());
  late DateTime alarmTimeAsDateTime;
  late DateTime threeSecondsAfterAlarm;

  // timer on order to ....
  late Timer _refreshTimer; // ...refresh the screen like for the current time
  late Timer _alarmCheckerTimer; // ...check for the alarm trigger status
  late Timer _saveDataTimer; // ...save/backup data regularly

  /// refresh the presented strings for the current time etc.
  void _updateTime() {
    setState(() {
      // setState causes the rerun of the build method
      _now = DateTime.now();
      _dateString = DateFormat("MMMM dd, yyyy").format(_now);
      _timeString = DateFormat("HH:mm:ss").format(_now);
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
            // +1 day because also the same day should be included
            if (currentAlarmList[i]!.alarmDate.isBefore(DateTime(
                DateTime.now().year,
                DateTime.now().month,
                DateTime.now().day + 1))) {
              // the time has passed (but not too long time ago, like 3 seconds)
              alarmTimeAsDateTime = DateTime(
                  DateTime.now().year,
                  DateTime.now().month,
                  DateTime.now().day,
                  currentAlarmList[i]!.alarmTime.hour,
                  currentAlarmList[i]!.alarmTime.minute);
              threeSecondsAfterAlarm = DateTime(
                  DateTime.now().year,
                  DateTime.now().month,
                  DateTime.now().day,
                  currentAlarmList[i]!.alarmTime.hour,
                  currentAlarmList[i]!.alarmTime.minute,
                  5);
              if ((DateTime.now().isAfter(alarmTimeAsDateTime)) &&
                  (DateTime.now().isBefore(threeSecondsAfterAlarm))) {
                //only if isRinging is still false, build the next page; otherwise it would be done several times leading to glitches
                if (currentAlarmList[i]!.isRinging == false) {
                  // start the alarm
                  alarmReaction(currentAlarmList[i], i, context, 'Single');
                  break; // break first for letting ring only one alarm if there are multiple
                  //return;
                }
              }
            }
          }

          // case 2: recurring alarm
          else if (currentAlarmList[i]!.isRecurrent == true) {
            // check whether today is one of the recurring days
            if (currentAlarmList[i]!.weekdayRecurrence[
                    dateTimeRemapper(DateTime.now().weekday)] ==
                true) {
              // the time has passed (but not too long time ago, like 3 seconds)
              alarmTimeAsDateTime = DateTime(
                  DateTime.now().year,
                  DateTime.now().month,
                  DateTime.now().day,
                  currentAlarmList[i]!.alarmTime.hour,
                  currentAlarmList[i]!.alarmTime.minute);
              threeSecondsAfterAlarm = DateTime(
                  DateTime.now().year,
                  DateTime.now().month,
                  DateTime.now().day,
                  currentAlarmList[i]!.alarmTime.hour,
                  currentAlarmList[i]!.alarmTime.minute,
                  5);
              if ((DateTime.now().isAfter(alarmTimeAsDateTime)) &&
                  (DateTime.now().isBefore(threeSecondsAfterAlarm))) {
                //only if isRinging is still false, build the next page; otherwise it would be done several times leading to glitches
                if (currentAlarmList[i]!.isRinging == false) {
                  // start the alarm
                  alarmReaction(currentAlarmList[i], i, context, 'Recurrent');
                  break; // break first for letting ring only one alarm if there are multiple
                }
              }
            }
          }
        }
      }
    });
  }

  @override
  void initState() {
    // update the in the UI presented current time regularly
    _refreshTimer = Timer.periodic(everySecond, (Timer t) => _updateTime());

    // check for alarm status regularly
    _alarmCheckerTimer = Timer.periodic(
        everySecond, (Timer t) => _alarmChecker(listOfSavedAlarms));

    // backup data regularly (just in case)
    _saveDataTimer = Timer.periodic(every2Minutes, (Timer t) => saveData());

    loadData(); // load backup of alarm list
    stopAlarmSound(); // turn off sound from last start
    super.initState();
  }

  /// Loading the current alarm list on start
  Future<void> loadData() async {
    dev.log("Loading alarm data...", name: 'Alarm');
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      if (prefs.containsKey('alarmList')) {
        listOfSavedAlarms = (prefs.getStringList('alarmList') ?? [])
            .map((alarm) => CustomAlarm.fromJson(jsonDecode(alarm)))
            .toList();
        dev.log('Loaded ${listOfSavedAlarms.length} saved alarms.',
            name: 'Alarm');
      } else {
        dev.log('No saved alarms found.', name: 'Alarm');
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
                        child: Align(
                          alignment: Alignment.centerLeft,
                          child: GestureDetector(
                            // longpress here to reset the app (debugging purposes first)
                            onLongPress: () {
                              debugMode
                                  ? // if debug mode start dialog for reset
                                  showDialog<String>(
                                      context: context,
                                      builder: (BuildContext context) =>
                                          DialogResetApp(), //Start dialog to reset app
                                    )
                                  : null; //if not debug mode don't do anything
                            },

                            child: Column(
                              //mainAxisAlignment: MainAxisAlignment.center,
                              children: <Widget>[
                                Row(
                                  children: <Widget>[
                                    Expanded(
                                      flex: 4,
                                      child: Align(
                                        alignment: Alignment.centerLeft,
                                        child: const Text(
                                          'Current time:',
                                        ),
                                      ),
                                    ),
                                    Expanded(
                                      flex: 6,
                                      child: Align(
                                        alignment: Alignment.centerRight,
                                        child: Text(
                                          _timeString,
                                          style: Theme.of(context)
                                              .textTheme
                                              .headline6,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                                Row(
                                  children: <Widget>[SizedBox(height: 15)],
                                ),
                                // Add some distance between the next row
                                Row(
                                  children: <Widget>[
                                    Expanded(
                                      flex: 4,
                                      child: Align(
                                        alignment: Alignment.centerLeft,
                                        child: const Text(
                                          'Current date:',
                                        ),
                                      ),
                                    ),
                                    Expanded(
                                      flex: 6,
                                      child: Align(
                                        alignment: Alignment.centerRight,
                                        child: Text(
                                          _dateString,
                                          style: Theme.of(context)
                                              .textTheme
                                              .headline6,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
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
                                                DialogResetAlarm(
                                                    index:
                                                        i), // show dialog for deleting the alarm
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
                                  SizedBox(height: 3),
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
                                          "${listOfSavedAlarms[i]?.alarmTime.to24hours()}",
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
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
