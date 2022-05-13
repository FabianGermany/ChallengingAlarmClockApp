// This file includes outsourced widget components
import 'package:flutter/material.dart'; //Google Material Design assets
import 'alarm.dart';

/// Show snackbar for the quiz
void showQuizSnackBar(BuildContext context, bool answerCorrect){
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


/// Show snackbar for alarm creation
void showAlarmCreationSnackBar(BuildContext context){
  ScaffoldMessenger.of(context).showSnackBar(
    SnackBar(
      duration: Duration(milliseconds: 1500),
      content: Text('Alarm has been created.',
      ),
    ),
  );
}


/// Dialog component/widget to reset the app
class DialogResetApp extends StatefulWidget{
  const DialogResetApp({Key? key}) : super(key: key);

  @override
  State<DialogResetApp> createState() => _MyDialogResetAppState();
}

class _MyDialogResetAppState extends State<DialogResetApp> {

  @override
  Widget build(BuildContext context) {
    return
      AlertDialog(
        title: Text('Reset the app?'),
        content: Text(
            'You are about to reset the app back to its factory settings.'),
        actions: [
          TextButton(
            onPressed: () =>
                Navigator.pop(
                    context, 'CANCEL'),
            child: Text('CANCEL'),
          ),
          TextButton(
            onPressed: () => [
              setState(() {
                listOfSavedAlarms = initAlarms(); // reset the app
              }),
              Navigator.pop(
                  context, 'RESET'),
            ],
            child: Text('RESET'),
          ),
        ],
      );
  }
}



/// Dialog component/widget to delete an alarm
class DialogResetAlarm extends StatefulWidget{

  final index;
  const DialogResetAlarm({Key? key, required this.index}) : super(key: key);


  @override
  State<DialogResetAlarm> createState() => _MyDialogResetAlarmState();
}

class _MyDialogResetAlarmState extends State<DialogResetAlarm> {

  @override
  Widget build(BuildContext context) {
    return
      AlertDialog(
        title: Text('Delete alarm?'),
        content: Text(
            'You are about to delete this alarm.'),
        actions: [
          TextButton(
            onPressed: () =>
                Navigator.pop(
                    context, 'CANCEL'),
            //close dialog
            child: Text('CANCEL'),
          ),
          TextButton(
            onPressed: () =>
            [
              //close dialog and delete alarm at the same time
              setState(() {
                deleteAlarm(
                listOfSavedAlarms, widget.index);
              }),
              Navigator.pop(
                  context, 'DELETE'),
            ],
            child: Text('DELETE'),
          ),
        ],
      );
  }
}
