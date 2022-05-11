import 'package:flutter/material.dart'; //Google Material Design assets

// global vars
const everySecond = Duration(seconds: 1);
const every2Seconds = Duration(seconds: 2);
const every2Minutes = Duration(minutes: 2);
bool debugMode = true; // set this to true to show some extra elements in the UI such as the reset button
const String appTitleHome = 'My alarms';
const String appTitleAddAlarm = 'Add an alarm';


/// Show snackbar
void showSnackBarCorrect(BuildContext context, bool answerCorrect){
  ScaffoldMessenger.of(context).showSnackBar(
    SnackBar(
      duration: const Duration(seconds: 1),
      content: Text(
          (answerCorrect) ? 'Correct answer!' : 'Wrong answer!',
          style: TextStyle(color: Colors.white)),
      backgroundColor: (answerCorrect) ? Colors.green : Colors.red,
    ),
  );
}