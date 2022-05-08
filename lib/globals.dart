import 'package:flutter/material.dart'; //Google Material Design assets
import 'package:audioplayers/audioplayers.dart';
import 'dart:convert'; // for JSON etc.
import 'package:flutter_ringtone_player/flutter_ringtone_player.dart';
import 'package:shared_preferences/shared_preferences.dart'; // for saving/loading data for new start of the app

// global vars
const everySecond = Duration(seconds: 1);
const every2Seconds = Duration(seconds: 2);
bool debug_mode = true; // set this to true to show some extra elements in the UI such as the reset button

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


//   CustomAlarm
//   (
//     required this.isActive,
//     required this.isRinging,
//     required this.nameOfAlarm,
//     required this.alarmTime,
//     required this.alarmDate,
//     required this.isRecurrent,
//     required this.weekdayRecurrence,
//     required this.challengeMode
//     );

// I need the JSON format to save/load the data (shared preferences)

  // to JSON
  Map<String, dynamic> toJson() => {
    "isActive": isActive.toString(), //todo .toString() ist das korrekt?
    "isRinging": isRinging.toString(),
    "nameOfAlarm": nameOfAlarm.toString(),
    "alarmTime": alarmTime.toString(),
    "alarmDate": alarmDate.toString(),
    "isRecurrent": isRecurrent.toString(),
    "weekdayRecurrence": weekdayRecurrence.toString(),
    "challengeMode": challengeMode.toString(),
  };

  // from JSON todo das funktioniert nicht...
  // CustomAlarm.fromJson(Map<String, dynamic> json)
  //     : isActive: json['isActive'],
  //       isRinging: json['isRinging'],
  //       isActive: json['nameOfAlarm'],
  //       isRinging: json['alarmTime'],
  //       isActive: json['alarmDate'],
  //       isRinging: json['isRecurrent'],
  //       isActive: json['weekdayRecurrence'],
  //       isRinging: json['challengeMode'];

}

List<CustomAlarm?> listOfSavedAlarms = []; // list including all the saved alarms

/// Init app function; this should be called only for the first start of the app or when the app is reset via settings
List<CustomAlarm?> initApp()
{
  // Data structure / list for a collection of saved alarms
  List<CustomAlarm?> savedAlarmList = [];

  // create one default alarm with some settings
  CustomAlarm? firstDefaultAlarm = CustomAlarm();
  firstDefaultAlarm.nameOfAlarm = "Weekly meeting";
  firstDefaultAlarm.alarmTime = const TimeOfDay(hour: 16, minute: 00);
  firstDefaultAlarm.isRecurrent = true;
  firstDefaultAlarm.weekdayRecurrence = [false, false, true, true, false, false, false];
  savedAlarmList.add(firstDefaultAlarm); // add this alarm to the list

  // create another default alarm with some settings
  CustomAlarm? secondDefaultAlarm = CustomAlarm();
  secondDefaultAlarm.nameOfAlarm = "Dentist";
  secondDefaultAlarm.alarmTime = const TimeOfDay(hour: 14, minute: 45);
  secondDefaultAlarm.isActive = true;
  secondDefaultAlarm.isRecurrent = false;
  savedAlarmList.add(secondDefaultAlarm); // add this alarm to the list
  debugPrint("App has been initialized...");
  return savedAlarmList;
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

