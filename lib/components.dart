// This file includes outsourced widget components
import 'package:flutter/material.dart'; //Google Material Design assets
import 'alarm.dart';

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




/// Dialog component to reset the app
class DialogResetApp extends StatefulWidget{

  const DialogResetApp();

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
            'You are about to reset the app.'),
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
                  context, 'DELETE'),
            ],
            child: Text('DELETE'),
          ),
        ],
      );
  }
}