import 'package:flutter/material.dart'; //Google Material Design assets
//import 'package:english_words/english_words.dart';
import 'package:intl/intl.dart';
import 'dart:async';
import 'package:weekday_selector/weekday_selector.dart';
import 'package:is_first_run/is_first_run.dart'; // for setting variables only on first start of the app
import 'package:shared_preferences/shared_preferences.dart'; // for saving/loading data for new start of the app
import 'dart:convert'; // for JSON etc.
import 'package:wakelock/wakelock.dart'; // this is needed to keep the screen active
import 'package:flutter_local_notifications/flutter_local_notifications.dart'; // notifications when the alarm is ringing
import 'package:awesome_notifications/awesome_notifications.dart'; // notifications when the alarm is ringing (alternative)
import 'alarm.dart'; //functions and more for the alarm
import 'quiz.dart'; //as quiz // functions and more for the quiz
import 'global.dart'; //global variables and general outsourced stuff
import 'dart:developer' as dev;

Future<void> main() async {
  dev.log("App is being started...", name: 'General'); //todo statt debug
  //init the notifications //todo outsource

  AwesomeNotifications().initialize(
      // set the icon to null if you want to use the default app icon
      'resource://drawable/res_app_icon',
      [
        NotificationChannel(
            channelGroupKey: 'basic_channel_group',
            channelKey: 'basic_channel',
            channelName: 'Basic notifications',
            channelDescription: 'Notification channel for basic tests',
            defaultColor: Color(0xFF9D50DD),
            ledColor: Colors.white)
      ],
      // Channel groups are only visual and are not required
      //todo aktivieren
      // channelGroups: [
      //   NotificationChannelGroup(
      //       channelGroupkey: 'basic_channel_group',
      //       channelGroupName: 'Basic group')
      // ],
      debug: true);

  // todo funktioniert nicht; das in initstate(?)
  // Request the user authorization to send local and push notifications; Make more polite...
  AwesomeNotifications().isNotificationAllowed().then((isAllowed) {
    if (!isAllowed) {
      // This is just a basic example. For real apps, you must show some
      // friendly dialog box before call the request method.
      // This is very important to not harm the user experience
      AwesomeNotifications().requestPermissionToSendNotifications();
    }
  });

  runApp(const MyApp());
  bool firstCall = await IsFirstRun.isFirstCall();
  if (firstCall ==
      true) // only for the first time the app is started, init the app
  {
    listOfSavedAlarms =
        initAlarms(); //init the app; creating default alarms etc. and store into a globally available list
  }
  dev.log("App has been fully loaded...", name: 'General');
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  //todo
  // // start to listen the notification actions (user taps)
  // AwesomeNotifications().actionStream.listen(
  // (ReceivedNotification receivedNotification){
  //
  // Navigator.of(context).pushNamed(
  // '/NotificationPage',
  // arguments: {
  // // your page params. I recommend you to pass the
  // // entire *receivedNotification* object
  // id: receivedNotification.id
  // }
  // );
  // }
  // );

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Alarm Clock App',
      theme: ThemeData(
        primarySwatch: Colors.deepPurple,
      ),
      home: const MyHomePage(title: appTitleHome),
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
  final myAlarmNameController =
      TextEditingController(text: 'My personal alarm');

  @override
  void dispose() {
    // Clean up the controller when the widget is disposed.
    myAlarmNameController.dispose();
    super.dispose();
  }

  /// function to save the created/edited alarm
  List<CustomAlarm?> _saveAlarm(List<CustomAlarm?> currentAlarmList) {
    List<CustomAlarm?> alarmList = currentAlarmList;
    CustomAlarm? newCreatedAlarm = CustomAlarm(
      isActive: true,
      // if saved, then automatically make active
      isRinging: false,
      nameOfAlarm: myAlarmNameController.text,
      alarmTime: _chosenTime,
      alarmDate: _chosenDate,
      isRecurrent: _recurrentMode,
      weekdayRecurrence: _chosenWeekdays,
      challengeMode: _challengingModeActive,
    ); // create a new default alarm

    alarmList.add(newCreatedAlarm); //add the alarm to the list
    dev.log("Alarm has been created!", name: 'Alarm');
    listOfSavedAlarms = alarmList; //save the local list back to the global one
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
    //todo das und andere sachen vll.t auslagern weil doppelt gemoppelt?
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

  final _formKey =
      GlobalKey<FormState>(); // It's needed for the input of the alarm name

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(appTitleAddAlarm),
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
                                        : Colors.black26),
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
                                DateFormat('MMMEd').format(_chosenDate),
                                style: TextStyle(
                                    color: _recurrentMode == false
                                        ? Colors.black
                                        : Colors.black26,
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
                  child: Form(
                    key: _formKey,
                    child: TextFormField(
                      controller: myAlarmNameController,
                      decoration: InputDecoration(
                        labelText: 'Name of alarm',
                        border: OutlineInputBorder(),
                      ),
                      validator: (value) {
                        if (value == null ||
                            value.isEmpty ||
                            value.length > 20) {
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
                            : Colors.black38),
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
                      onPressed: () {
                        if (_formKey.currentState!.validate()) {
                          // for multiple commands in onPressed this form should be used:
                          // () =>[command1, command2]
                          // but in if statement, it seems to be not necessary
                          _saveAlarm(listOfSavedAlarms); // save current alarm
                          saveData(); // backup alarmlist
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
  final CustomAlarm? triggeredAlarm;
  final int alarmNumber;

  const ShowAlarmPage(this.triggeredAlarm, this.alarmNumber);

  @override
  State<ShowAlarmPage> createState() => _MyShowAlarmPageState();
}

class _MyShowAlarmPageState extends State<ShowAlarmPage> {
  //vars here
  //functions here

  DateTime _now = DateTime
      .now(); // init it once, otherwise it will show NULL in the beginning
  String _dateString = DateFormat("EEEE, MMMM dd").format(DateTime
      .now()); // init it once, otherwise it will show NULL in the beginning
  String _timeStringShort = DateFormat("HH:mm").format(DateTime
      .now()); // init it once, otherwise it will show NULL in the beginning

  late Timer
      _refreshTimer; //timer to refresh the screen like for the current time

  /// refresh the presented strings for the current time etc.
  void _updateTime() {
    setState(() {
      // setState tells the Flutter framework that something has changed in this state, which causes it to rerun the build method
      _now = DateTime.now();
      _dateString = DateFormat("EEEE, MMMM dd").format(_now);
      _timeStringShort = DateFormat("HH:mm").format(_now);
    });
  }

  //todo das klappt nur bei non-recurring..muss ich noch ändern
  /// function to deactivate an alarm //todo
  List<CustomAlarm?> _deactivateAlarm(CustomAlarm? triggeredAlarm, alarmIndex) {
    return deactivateAlarm(triggeredAlarm, alarmIndex);
  }

  @override
  void initState() {
    _refreshTimer = Timer.periodic(everySecond, (Timer t) => _updateTime());
    super.initState();
  }

  @override
  void dispose() {
    _refreshTimer.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
        // I need this to deactivate the "Go back" button
        onWillPop: () async => false, // Deactivate "Go back" button
        child: Scaffold(
          backgroundColor: Color(0xFFE4DAFC),
          body: Container(
            margin: const EdgeInsets.all(20.0),
            child: Column(
              children: <Widget>[
                Row(
                  children: <Widget>[SizedBox(height: 70)],
                ),
                // Add some distance between the next row
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Text(
                      "Alarm",
                      style: Theme.of(context).textTheme.headline6,
                    ),
                  ],
                ),
                Row(
                  children: <Widget>[SizedBox(height: 10)],
                ),
                // Add some distance between the next row
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Text(
                      "${widget.triggeredAlarm?.nameOfAlarm}",
                      style: TextStyle(
                          color: Colors.deepPurple,
                          fontSize: 25,
                          fontWeight: FontWeight.w500 //, spacing...: 0.15
                          ),
                    ),
                  ],
                ),
                Row(
                  children: <Widget>[SizedBox(height: 100)],
                ),
                // Add some distance between the next row
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Text(
                      "It's",
                      style: TextStyle(
                          color: Colors.black54,
                          fontSize: 18,
                          fontWeight: FontWeight.w500 //, spacing...: 0.15
                          ),
                    ),
                  ],
                ),
                Row(
                  children: <Widget>[SizedBox(height: 5)],
                ),
                // Add some distance between the next row
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Text(
                      _timeStringShort,
                      style: TextStyle(
                          color: Colors.black,
                          fontSize: 60,
                          fontWeight: FontWeight.w600 //, spacing...: 0.15
                          ),
                    ),
                  ],
                ),
                Row(
                  children: <Widget>[SizedBox(height: 10)],
                ),
                // Add some distance between the next row
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Text(
                      _dateString,
                      style: TextStyle(
                          color: Colors.black54,
                          fontSize: 20,
                          fontWeight: FontWeight.w400 //, spacing...: 0.15
                          ),
                    ),
                  ],
                ),
                Row(
                  children: <Widget>[SizedBox(height: 80)],
                ),
                // Add some distance between the next row
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    ElevatedButton(
                      // if challenge mode is active, go to page 4, otherwise to page 1 and turn off the alarm
                      onPressed: () {
                        if (widget.triggeredAlarm?.challengeMode == true) {
                          // challenge mode
                          playAlarmSound(0.1); // make alarm a bit more silent
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => ShowChallengePage(
                                    widget.triggeredAlarm, widget.alarmNumber)),
                          );
                        } else {
                          // no challenge mode
                          _deactivateAlarm(
                              widget.triggeredAlarm, widget.alarmNumber);
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) =>
                                    const MyHomePage(title: appTitleHome)),
                          );
                        }
                      },

                      child: const Text('Stop'),
                      //
                    ),
                  ],
                ),
              ],
            ),
          ),
        ));
  }
}

// *********************************
// This is the fourth page for the challenge
// *********************************
class ShowChallengePage extends StatefulWidget {
  final CustomAlarm? triggeredAlarm;
  final int alarmNumber;

  const ShowChallengePage(this.triggeredAlarm, this.alarmNumber);

  @override
  State<ShowChallengePage> createState() => _MyShowChallengePageState();
}

class _MyShowChallengePageState extends State<ShowChallengePage> {
  int currentScore = 0; //init the current score to 0;
  int targetScore = 5;
  String userInput = '';
  late bool answerCorrect;
  late bool quizPassed;
  var currentQuiz;
  late String currentQuizQuestion;
  late String currentQuizResult;
  var score;
  FocusNode inputNode = FocusNode(); // used for showing keyboard

  // Create a text controller and use it to retrieve the current value
  // of the Alarm TextField.
  var myNumberInputController = TextEditingController(text: '');

  @override
  void dispose() {
    // Clean up the controller when the widget is disposed.
    myNumberInputController.dispose();
    inputNode.dispose();
    super.dispose();
  }

  /// function to deactivate an alarm
  List<CustomAlarm?> _deactivateAlarm(CustomAlarm? triggeredAlarm, alarmIndex) {
    return deactivateAlarm(triggeredAlarm, alarmIndex);
  }

  /// Handle the user input based on the current quiz
  void _quizScoreHandler() {
    dev.log(currentQuizResult, name: 'Quiz');
    dev.log(userInput, name: 'Quiz');

    (currentQuizResult == userInput)
        ? answerCorrect = true
        : answerCorrect = false;

    //todo
    //show a snackback for right/wrong answer //todo
    /* if (answerCorrect){
      ScaffoldMessenger.of(context).showSnackBar(
        const snackBarRightAnswer = SnackBar(
          content: Text(
              'Correct!',
            style: TextStyle(color: Colors.white)),
          backgroundColor: Colors.green,
      ),
      );


    }
    else { // (!answerCorrect)
      ScaffoldMessenger.of(context).showSnackBar(
      const snackBarWrongAnswer = SnackBar(
      content: Text(
      'Correct!',
      style: TextStyle(color: Colors.white)),
      backgroundColor: Colors.red,
      ),
      )
    }*/
    score = scoreHandler(currentScore, answerCorrect, targetScore);
    currentScore = score[0];
    quizPassed = score[1];
    if (quizPassed) {
      _deactivateAlarm(widget.triggeredAlarm, widget.alarmNumber);
      _generateNewQuizQuestion(); // generate new question for next time
      Navigator.push(
        context,
        MaterialPageRoute(
            builder: (context) => const MyHomePage(title: appTitleHome)),
      );
    } else // quiz is not passed
    {
      // load next quiz page
      setState(() {
        _generateNewQuizQuestion();
      });
    }
    //inputNode.requestFocus(); // show keyboard again
    FocusScope.of(context).requestFocus(inputNode); // show keyboard again
    myNumberInputController.clear();
  }

  void _generateNewQuizQuestion() {
    currentQuiz = quizGenerator();
    currentQuizQuestion = currentQuiz[0];
    currentQuizResult = currentQuiz[1];
  }

  @override
  void initState() {
    _generateNewQuizQuestion();
    super.initState();
  }

  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
        // I need this to deactivate the "Go back" button
        onWillPop: () async => false, // Deactivate "Go back" button
        child: Scaffold(
          backgroundColor: Color(0xFFE4DAFC),
          body: Container(
            margin: const EdgeInsets.all(20.0),
            child: Column(
              children: <Widget>[
                Row(
                  children: <Widget>[SizedBox(height: 50)],
                ),
                Row(
                  // Time selector
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Text(
                      "Current Score:\n$currentScore / $targetScore",
                      textAlign: TextAlign.center,
                      style: Theme.of(context).textTheme.headline6,
                    ),
                  ],
                ),
                Row(
                  children: <Widget>[SizedBox(height: 50)],
                ),
                Row(
                  // Time selector
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Text(
                      currentQuizQuestion,
                      style: TextStyle(
                          color: Colors.deepPurple,
                          fontSize: 30,
                          fontWeight: FontWeight.w500 //, spacing...: 0.15
                          ),
                    ),
                  ],
                ),
                Row(
                  children: <Widget>[SizedBox(height: 100)],
                ),
                Row(
                  // Time selector
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Expanded(
                      flex: 8,
                      child: Form(
                        key: _formKey,
                        child: TextFormField(
                            controller: myNumberInputController,
                            autofocus: true,
                            // show keyboard automatically on start
                            focusNode: inputNode,
                            // for showing keyboard on 2nd start etc.
                            onEditingComplete: () {},
                            // this prevents keyboard from closing
                            keyboardType:
                                TextInputType.numberWithOptions(signed: true),
                            decoration: InputDecoration(
                              labelText: 'Enter the result',
                              border: OutlineInputBorder(),
                            ),
                            style: TextStyle(fontSize: 22),
                            onFieldSubmitted: (String value) {
                              setState(() {
                                userInput = value;
                                _quizScoreHandler();
                              });
                            }),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ));
  }
}
