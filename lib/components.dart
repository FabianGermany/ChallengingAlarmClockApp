// This file includes outsourced widget components
import 'package:flutter/material.dart'; //Google Material Design assets

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




/// Widget for XXXXX
class xxxWidget extends  StatelessWidget{

  final varvar;
  const xxxWidget(this.varvar);


  @override
  Widget build(BuildContext context) {
    return
      Text('Add stuff here');
          }
}