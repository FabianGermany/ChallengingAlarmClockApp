import 'package:flutter/material.dart'; //Google Material Design assets
//import 'package:english_words/english_words.dart';
import 'package:intl/intl.dart';
import 'dart:async';
import 'dart:developer' as dev;
import 'package:is_first_run/is_first_run.dart'; // for setting variables only on first start of the app
import 'package:awesome_notifications/awesome_notifications.dart'; // notifications when the alarm is ringing
import 'alarm.dart'; // functions and more for the alarm
import 'notification.dart'; // functions and more for the notifications
import 'global.dart'; // global variables and general outsourced stuff
import 'components.dart'; // outsourced widget components
import 'widgets/homepage_alarm_overview.dart'; // widget for the homepage


Future <void> main() async {
  dev.log("App is being started...", name: 'General');
  initializeNotifications(); //init the notifications
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

class MyApp extends StatefulWidget {
  const MyApp({Key? key}) : super(key: key);
  static final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();

  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {

  @override
  void initState() {
    setNotificationListeners();
    super.initState();
  }


  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      navigatorKey: MyApp.navigatorKey,
      title: 'Alarm Clock App',
      theme: ThemeData(
        primarySwatch: Colors.deepPurple,
      ),
      home: const HomePageAlarmOverview(title: appTitleHome),
    );
  }
}

