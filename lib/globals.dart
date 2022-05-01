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
  firstDefaultAlarm.isRecurrent = true;
  firstDefaultAlarm.weekdayRecurrence = [false, false, true, true, false, false, false];
  listOfSavedAlarms.add(firstDefaultAlarm); // add this alarm to the list
  return listOfSavedAlarms;
  print("App has been initialized...");
}

/// Convert weekday number to weekday string
String weekdayNumberToString(int number)
{
  String output = 'None';
  switch(number){
    case 1: output = 'Mon'; break;
    case 2: output = 'Tue'; break;
    case 3: output = 'Wed'; break;
    case 4: output = 'Thu'; break;
    case 5: output = 'Fri'; break;
    case 6: output = 'Sat'; break;
    case 7: output = 'Sun'; break;
  }
  return output;
}

/// Converts a bool list of weekdays to strings
String weekdayBoolListToString(List<bool> weekdays)
{
  String output = "";
  int weekdayCounter = 0;
  for (final i in weekdays)
    {
    weekdayCounter++;
    if (i == true)
      {
        if (output == "")
          {
            output = output + weekdayNumberToString(weekdayCounter); //the first entry without comma
          }
        else
          {
            output = output + ", "+ weekdayNumberToString(weekdayCounter); //the other entries with a comma
          }
      }
  }
  return output;
}