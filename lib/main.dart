import 'package:flutter/material.dart'; //Google Material Design assets
//import 'package:english_words/english_words.dart';
import 'package:intl/intl.dart';
import 'dart:async';
import 'dart:developer' as dev;
import 'package:is_first_run/is_first_run.dart'; // for setting variables only on first start of the app
import 'package:flutter_local_notifications/flutter_local_notifications.dart'; // notifications when the alarm is ringing
import 'package:awesome_notifications/awesome_notifications.dart'; // notifications when the alarm is ringing (alternative)
import 'alarm.dart'; // functions and more for the alarm
import 'global.dart'; // global variables and general outsourced stuff
import 'widgets/components.dart'; // outsourced widget components
import 'widgets/widget-home-alarm-overview.dart'; // widget for the homepage



Future <void> main() async {
  dev.log("App is being started...", name: 'General');
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

