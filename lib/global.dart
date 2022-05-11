import 'package:awesome_notifications/awesome_notifications.dart'; //todo die klasse unten outsourcen...
import 'dart:developer' as dev;
import 'main.dart';


// global vars
const everySecond = Duration(seconds: 1);
const every2Seconds = Duration(seconds: 2);
const every2Minutes = Duration(minutes: 2);
bool debugMode = true; // set this to true to show some extra elements in the UI such as the reset button
const String appTitleHome = 'My alarms';
const String appTitleAddAlarm = 'Add an alarm';


class NotificationController {

  /// Use this method to detect when a new notification or a schedule is created
  static Future <void> onNotificationCreatedMethod(ReceivedNotification receivedNotification) async {
    // Your code goes here
    dev.log('Notification has been created...', name: 'Notification');
  }

  /// Use this method to detect every time that a new notification is displayed
  static Future <void> onNotificationDisplayedMethod(ReceivedNotification receivedNotification) async {
    // Your code goes here
    dev.log('Notification has been displayed...', name: 'Notification');
  }

  /// Use this method to detect if the user dismissed a notification
  static Future <void> onDismissActionReceivedMethod(ReceivedAction receivedAction) async {
    // Your code goes here
    dev.log('Notification has been dismissed...', name: 'Notification');
  }

  /// Use this method to detect when the user taps on a notification or action button
  static Future <void> onActionReceivedMethod(ReceivedAction receivedAction) async {
    // Your code goes here
    dev.log('Notification has been tapped on...', name: 'Notification');

    // Navigate into pages, avoiding to open the notification details page over another details page already opened
    MyApp.navigatorKey.currentState?.pushNamedAndRemoveUntil('/notification-page',
            (route) => (route.settings.name != '/notification-page') || route.isFirst,
        arguments: receivedAction);

    //todo da ist noch mehr code ...
  }
}


