import 'package:flutter/material.dart'; //Google Material Design assets

// data structure / class for one alarm
class customAlarm {
  bool isActive = false;
  bool isRinging = false;
  String nameOfAlarm = "New alarm";
  TimeOfDay alarmTime = TimeOfDay(hour: 9, minute: 45); // default value
  DateTime alarmDate = DateTime(DateTime.now().year, DateTime.now().month, DateTime.now().day + 1); // default today plus 1 day later
  bool isRecurrent = false; //default value is single time alarm
  List<bool> weekdayRecurrence = List.filled(7, false); //from Monday to Sunday // = [false, false, false, false, false, false, false];
  bool challengeMode = false;
  //todo: alarm sound, vibration pattern, snooze, ...
}

List<customAlarm?> listOfSavedAlarms = []; // list including all the saved alarms

/// Init app function
// todo this should only be done once when the app is launched for the first time...reset button function etc.
List<customAlarm?> initApp()
{
  // Data structure / list for a collection of saved alarms
  List<customAlarm?> listOfSavedAlarms = [];

  // create one default alarm with some settings
  customAlarm? firstDefaultAlarm = customAlarm();
  firstDefaultAlarm.nameOfAlarm = "Weekly meeting";
  listOfSavedAlarms.add(firstDefaultAlarm); // add this alarm to the list
  return listOfSavedAlarms;
  print("App has been initialized...");
}

