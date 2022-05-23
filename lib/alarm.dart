import 'package:flutter/material.dart'; //Google Material Design assets
import 'dart:convert'; // for JSON etc.
import 'package:flutter_ringtone_player/flutter_ringtone_player.dart';
import 'package:shared_preferences/shared_preferences.dart'; // for saving/loading data for new start of the app
import 'package:wakelock/wakelock.dart'; // this is needed to keep the screen active
import 'dart:developer' as dev;
import 'package:awesome_notifications/awesome_notifications.dart'; // notifications when the alarm is ringing
import 'notification.dart'; // functions and more for the notifications
import 'widgets/show_alarm_page.dart'; // widget for the alarm exposure

/// data structure / class for one single alarm
class CustomAlarm {
  bool isActive;
  bool isRinging;
  String nameOfAlarm;
  TimeOfDay alarmTime;
  DateTime alarmDate;
  bool isRecurrent;
  List<bool> weekdayRecurrence;
  bool challengeMode;

  // constructor with initial/default values
  CustomAlarm
  ({
    this.isActive = false,
    this.isRinging = false,
    this.nameOfAlarm = "New alarm",
    this.alarmTime = const TimeOfDay(hour: 9, minute: 45),
    DateTime? alarmDate, // cf. [Info1]
    this.isRecurrent = false,
    List<bool>? weekdayRecurrence, // cf. [Info1]
    this.challengeMode = false
  }
  // [Info1] constructors need const values; that's why it's outsourced where it can be non-const.;
    ):
      alarmDate = alarmDate ?? DateTime(DateTime.now().year, DateTime.now().month, DateTime.now().day + 1), // default today plus 1 day later
      weekdayRecurrence = weekdayRecurrence ?? List.filled(7, false) // = [false, ..., false]; Attention: [0] is Sunday, [1] is Monday etc.
  ;

  // Information
  // isRecurrent and alarmDate are exclusive, so only one value is used
  // and the user could be null; however, I won't use null, since whene editing
  // the alarm it can be toggled; in this way the old information can be stored

  // JSON format is needed to save/load the data (shared preferences doesn't support classes as datatype)

  // (1) Object to JSON
  Map<String, dynamic> toJson() => {
    "isActive": isActive,
    "isRinging": isRinging,
    "nameOfAlarm": nameOfAlarm,
    "alarmTimeHour": alarmTime.hour,
    "alarmTimeMinute": alarmTime.minute,
    "alarmDate": alarmDate.toIso8601String(),
    "isRecurrent": isRecurrent,
    "weekdayRecurrence": weekdayRecurrence,
    "challengeMode": challengeMode,
  };

  // (2) JSON to Object
  factory CustomAlarm.fromJson(Map<String, dynamic> json){
    return CustomAlarm(
        isActive: json['isActive'],
        isRinging: json['isRinging'],
        nameOfAlarm: json['nameOfAlarm'],
        alarmTime: TimeOfDay(hour: json['alarmTimeHour'], minute: json['alarmTimeMinute']),
        alarmDate: DateTime.parse(json['alarmDate']),
        isRecurrent: json['isRecurrent'],
        weekdayRecurrence: (json['weekdayRecurrence'] as List<dynamic>).cast<bool>(),
        challengeMode: json['challengeMode'],
    );
  }
}

// list including all the saved alarms
List<CustomAlarm?> listOfSavedAlarms = [];

/// Init app function
/// This is called only for the first start of the app or when the app is resetted via settings
List<CustomAlarm?> initAlarms(){
  // Data structure / list for a collection of saved alarms
  List<CustomAlarm?> savedAlarmList = [];

  // create one default alarm with some settings
  CustomAlarm? firstDefaultAlarm = CustomAlarm(
    isActive: false,
    isRinging: false,
    nameOfAlarm: "Weekly meeting",
    alarmTime: const TimeOfDay(hour: 16, minute: 00),
    alarmDate: DateTime(DateTime.now().year, DateTime.now().month, DateTime.now().day + 1),
    isRecurrent: true,
    weekdayRecurrence: [false, false, true, true, false, false, false],
    challengeMode: false,
  );

  // create another default alarm with some settings
  CustomAlarm? secondDefaultAlarm = CustomAlarm(
    isActive: true,
    isRinging: false,
    nameOfAlarm: "Dentist",
    alarmTime: const TimeOfDay(hour: 14, minute: 45),
    alarmDate: DateTime(DateTime.now().year, DateTime.now().month, DateTime.now().day + 1),
    isRecurrent: false,
    weekdayRecurrence: [false, false, true, true, false, false, false],
    challengeMode: false,
  );

  // add the alarms to the list
  savedAlarmList.add(firstDefaultAlarm);
  savedAlarmList.add(secondDefaultAlarm);
  dev.log("Alarms have been initialized...", name: 'Alarm');
  return savedAlarmList;
}

/// Convert weekday number to custom weekday string
String weekdayNumberToString(int number)
{
  String output = 'None';
  switch(number){
    case 0: output = 'Sun'; break;
    case 1: output = 'Mon'; break;
    case 2: output = 'Tue'; break;
    case 3: output = 'Wed'; break;
    case 4: output = 'Thu'; break;
    case 5: output = 'Fri'; break;
    case 6: output = 'Sat'; break;
  }
  return output;
}

/// Weekday conversion function
/// I need this function because
/// WeekdaySelector starts Sunday (0) to Saturday (6)
/// while DayTime.now().weekday goes from Monday (1) to Sunday (7)
int dateTimeRemapper(int input){
  int output = 0;
  switch(input){
    case 0: output = 7; break;
    case 1: output = 1; break;
    case 2: output = 2; break;
    case 3: output = 3; break;
    case 4: output = 4; break;
    case 5: output = 5; break;
    case 6: output = 6; break;
  }
  return output;
}


/// Converts a bool list of weekdays to a string
/// that will be displayed in the UI
String weekdayBoolListToString(List<bool> weekdays)
{
  String output = "";
  int weekdayCounter = -1;
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


/// Conversion of 12h AM/PM format to 24h format with TimeOfDay
extension TimeOfDayConverter on TimeOfDay {
  String to24hours() {
    final hour = this.hour.toString().padLeft(2, "0");
    final min = this.minute.toString().padLeft(2, "0");
    return "$hour:$min";
  }
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


/// Function to deactivate a single or recurring alarm
List<CustomAlarm?> deactivateAlarm(
    CustomAlarm? triggeredAlarm, alarmIndex) {

  List<CustomAlarm?> alarmList = listOfSavedAlarms;
  alarmList[alarmIndex]!.isRinging = false;
  if (triggeredAlarm?.isRecurrent == true){
      alarmList[alarmIndex]!.isActive = true; // keep it active for next weekday
      dev.log("Recurring alarm has been turned off temporarily!", name: 'Alarm');
  }
  else {
    alarmList[alarmIndex]!.isActive = false;
    dev.log("Single alarm has been turned off!", name: 'Alarm');
  }
  stopAlarmSound();
  Wakelock.disable(); // stop that the screen is consistently active
  AwesomeNotifications().cancelAll(); //remove notifications
  listOfSavedAlarms = alarmList; //save the local list back to the global one
  saveData();
  return alarmList;
}



/// Backuping the alarm list listOfSavedAlarms
/// Do it:
/// (1) after an alarm is created
/// (2) after an alarm is deleted
/// (3) after an alarm is edited (not available at this time)
/// (4) after characterists of an alarm change:
///   (4.1) isRinging (when is alarm is going off and when it's deactived)
///   (4.2) isActive (when the toggle is used)
/// (5) regularly via a timer
Future<void> saveData() async {
  dev.log("Saving alarm data...", name: 'Alarm');
  final prefs = await SharedPreferences.getInstance();
  prefs.setStringList('alarmList', listOfSavedAlarms.map((alarm) => jsonEncode(alarm)).toList()); //set JSON-encoded values to the key 'alarmList'
  dev.log('Saved ${listOfSavedAlarms.length} alarms.', name: 'Alarm');
}


/// Function including the reactions when an alarm goes off
/// We only go to the alarm ringing page if we are not there (otherwise it will be reloaded like every second);
//  That's why we call the function only in the states (routes) for the alarm overview and the alarm adding;
void alarmReaction(CustomAlarm? triggeredAlarm, index, context, typeOfAlarm){
  dev.log("$typeOfAlarm alarm is going off!", name: 'Alarm');
  playAlarmSound(0.5); // play alarm
  Wakelock.enable(); // keep the screen active
  createNotification(triggeredAlarm!.nameOfAlarm);
  triggeredAlarm.isRinging = true; // set to true for next time
  saveData();
  Navigator.push(
    // alarm will ring
    context,
    MaterialPageRoute(
        builder: (context) => ShowAlarmPage(triggeredAlarm: triggeredAlarm,
            alarmNumber: index)),
  );
}

/// Function to delete an alarm
void deleteAlarm(
    List<CustomAlarm?> currentAlarmList, int itemNumberToBeRemoved) {
    currentAlarmList.removeAt(itemNumberToBeRemoved);
    dev.log("Alarm has been deleted!", name: 'Alarm');
}