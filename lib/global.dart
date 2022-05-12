import 'package:flutter/material.dart';
import 'dart:developer' as dev;
import 'main.dart';


// global vars
const everySecond = Duration(seconds: 1);
const every2Seconds = Duration(seconds: 2);
const every2Minutes = Duration(minutes: 2);
bool debugMode = true; // set this to true to show some extra elements in the UI such as the reset button
const String appTitleHome = 'My alarms';
const String appTitleAddAlarm = 'Add an alarm';


//conversion function to compare TimeOfDay datatypes
double TimeOfDayToDouble(TimeOfDay time){
  return (time.hour + time.minute / 60.0);
}
