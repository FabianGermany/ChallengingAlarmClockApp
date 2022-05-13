import 'package:awesome_notifications/awesome_notifications.dart';
import 'package:flutter/material.dart';
import 'dart:developer' as dev;

/// Notification controller
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
  }
}

/// Initialize the notification function
void initializeNotifications(){
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
}


/// Set notification listeners
void setNotificationListeners(){
  AwesomeNotifications().setListeners(
      onActionReceivedMethod:         NotificationController.onActionReceivedMethod,
      onNotificationCreatedMethod:    NotificationController.onNotificationCreatedMethod,
      onNotificationDisplayedMethod:  NotificationController.onNotificationDisplayedMethod,
      onDismissActionReceivedMethod:  NotificationController.onDismissActionReceivedMethod
  );
}


/// Create an alarm notification
void createNotification(nameOfAlarm){
  AwesomeNotifications().createNotification(
    content: NotificationContent(
        id: 10,
        channelKey: 'basic_channel',
        title: 'The alarm "$nameOfAlarm" is ringing!',
        body: 'Click here to turn it off.',
        autoDismissible: false,
        locked: true,
        //wakeUpScreen: true, //this removes the notification when app is in background for some reason...
        actionType: ActionType.Default
    ),
    //actionButtons:
  );
}