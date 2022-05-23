import 'package:flutter/material.dart'; //Google Material Design assets
import 'dart:async';
import 'dart:developer' as dev;
import 'package:is_first_run/is_first_run.dart'; // for setting variables only on first start of the app
import 'alarm.dart'; // functions and more for the alarm
import 'notification.dart'; // functions and more for the notifications
import 'global.dart'; // global variables and general outsourced stuff
import 'widgets/homepage_alarm_overview.dart'; // widget for the homepage
import 'package:flutter_localizations/flutter_localizations.dart';


/// Main method
Future <void> main() async {
  dev.log("App is being started...", name: 'General');
  initializeNotifications(); //init the notifications
  runApp(const MyApp());

  // only for the first time the app is started, init the app
  bool firstCall = await IsFirstRun.isFirstCall();
  if (firstCall)
  {
  // init the app by creating default alarms etc.
    listOfSavedAlarms = initAlarms();
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
      localizationsDelegates: [
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      supportedLocales: [
        Locale('en', ''), // English, no country code
      ],
      theme: ThemeData(
        primarySwatch: Colors.deepPurple,
      ),
      home: const HomePageAlarmOverview(title: appTitleHome),
    );
  }
}