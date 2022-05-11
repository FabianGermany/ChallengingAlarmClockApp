import 'package:flutter/material.dart'; //Google Material Design assets
//import 'package:english_words/english_words.dart';
import 'package:intl/intl.dart';
import 'dart:async';
import 'dart:developer' as dev;
import 'package:is_first_run/is_first_run.dart'; // for setting variables only on first start of the app
import 'package:awesome_notifications/awesome_notifications.dart'; // notifications when the alarm is ringing
import 'alarm.dart'; // functions and more for the alarm
import 'global.dart'; // global variables and general outsourced stuff
import 'components.dart'; // outsourced widget components
import 'widgets/homepage_alarm_overview.dart'; // widget for the homepage


Future <void> main() async {
  dev.log("App is being started...", name: 'General');

  //init the notifications //todo outsource
  AwesomeNotifications().initialize(
      // set the icon to null if you want to use the default app icon
      //'resource://drawable/res_app_icon',
      null,
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
      channelGroups: [
        NotificationChannelGroup(
            channelGroupKey: 'basic_channel_group',
            channelGroupName: 'Basic group')
      ],
      debug: true);

  // Request the user authorization to send local and push notifications; Make more polite...
  AwesomeNotifications().isNotificationAllowed().then((isAllowed) {
    if (!isAllowed) {
      // Here should be a friendly dialog box for better UX
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

class MyApp extends StatefulWidget {
  const MyApp({Key? key}) : super(key: key);
  static final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();

  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {

  @override
  void initState() {

    // Only after at least the action method is set, the notification events are delivered
    AwesomeNotifications().setListeners(
        onActionReceivedMethod:         NotificationController.onActionReceivedMethod,
        onNotificationCreatedMethod:    NotificationController.onNotificationCreatedMethod,
        onNotificationDisplayedMethod:  NotificationController.onNotificationDisplayedMethod,
        onDismissActionReceivedMethod:  NotificationController.onDismissActionReceivedMethod
    );

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

