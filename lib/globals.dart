import 'package:flutter/material.dart'; //Google Material Design assets
import 'package:audioplayers/audioplayers.dart';
import 'package:flutter_ringtone_player/flutter_ringtone_player.dart';

// global vars
const everySecond = Duration(seconds: 1);
const every2Seconds = Duration(seconds: 2);

// data structure / class for one alarm
class CustomAlarm {
  bool isActive = false;
  bool isRinging = false;
  String nameOfAlarm = "New alarm";
  TimeOfDay alarmTime = const TimeOfDay(hour: 9, minute: 45); // default value
  DateTime alarmDate = DateTime(DateTime.now().year, DateTime.now().month, DateTime.now().day + 1); // default today plus 1 day later
  bool isRecurrent = false; //default value is single time alarm
  List<bool> weekdayRecurrence = List.filled(7, false); //from Monday to Sunday // = [false, false, false, false, false, false, false];
  bool challengeMode = false;
  //todo: alarm sound, vibration pattern, snooze, ...
}

List<CustomAlarm?> listOfSavedAlarms = []; // list including all the saved alarms

/// Init app function
// todo this should only be done once when the app is launched for the first time...reset button function etc.
List<CustomAlarm?> initApp()
{
  // Data structure / list for a collection of saved alarms
  List<CustomAlarm?> listOfSavedAlarms = [];

  // create one default alarm with some settings
  CustomAlarm? firstDefaultAlarm = CustomAlarm();
  firstDefaultAlarm.nameOfAlarm = "Weekly meeting";
  firstDefaultAlarm.alarmTime = const TimeOfDay(hour: 16, minute: 00);
  firstDefaultAlarm.isRecurrent = true;
  firstDefaultAlarm.weekdayRecurrence = [false, false, true, true, false, false, false];
  listOfSavedAlarms.add(firstDefaultAlarm); // add this alarm to the list

  // create another default alarm with some settings
  CustomAlarm? secondDefaultAlarm = CustomAlarm();
  secondDefaultAlarm.nameOfAlarm = "Dentist";
  secondDefaultAlarm.alarmTime = const TimeOfDay(hour: 14, minute: 45);
  secondDefaultAlarm.isActive = true;
  secondDefaultAlarm.isRecurrent = false;
  listOfSavedAlarms.add(secondDefaultAlarm); // add this alarm to the list
  debugPrint("App has been initialized...");
  return listOfSavedAlarms;
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



/// Play audio function
void playAlarmSound(double volume)
{
  FlutterRingtonePlayer.play(
    android: AndroidSounds.notification,
    ios: IosSounds.glass,
    looping: true, // Android only - API >= 28
    volume: volume, // Android only - API >= 28
    asAlarm: true, // Android only - all APIs
  );
}

/// Stop audio function
void stopAlarmSound()
{
  FlutterRingtonePlayer.stop();
}

