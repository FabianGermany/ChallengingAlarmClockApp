// *********************************
// This is the fourth page for the challenge
// *********************************

import 'package:alarm_clock_app/widgets/success_page.dart';
import 'package:flutter/material.dart'; //Google Material Design assets
import 'dart:developer' as dev;
import '../alarm.dart'; // functions and more for the alarm
import '../quiz.dart'; // as quiz // functions and more for the quiz
import '../global.dart'; // global variables and general outsourced stuff
import '../components.dart'; // outsourced widget components
import 'homepage_alarm_overview.dart';


class ShowChallengePage extends StatefulWidget {
  final CustomAlarm? triggeredAlarm;
  final int alarmNumber;

  const ShowChallengePage({Key? key, required this.triggeredAlarm, required this.alarmNumber}) : super(key: key);

  @override
  State<ShowChallengePage> createState() => _MyShowChallengePageState();
}

class _MyShowChallengePageState extends State<ShowChallengePage> {
  int _currentScore = 0; //init the current score to 0;
  final int _targetScore = targetScore;
  String _userInput = '';
  late bool _answerCorrect;
  late bool _quizPassed;
  var _currentQuiz;
  late String _currentQuizQuestion;
  late String _currentQuizResult;
  var _score;
  final FocusNode _inputNode = FocusNode(); // used for showing keyboard

  // Create a text controller and use it to retrieve the current value
  // of the Alarm TextField.
  final _numberInputController = TextEditingController(text: '');

  @override
  void dispose() {
    // Clean up the controller when the widget is disposed.
    _numberInputController.dispose();
    _inputNode.dispose();
    super.dispose();
  }

  /// function to deactivate an alarm
  List<CustomAlarm?> _deactivateAlarm(CustomAlarm? triggeredAlarm, alarmIndex) {
      return deactivateAlarm(triggeredAlarm, alarmIndex);
  }

  /// Handle the user input based on the current quiz
  void _quizScoreHandler() {
    dev.log(_currentQuizResult, name: 'Quiz');
    dev.log(_userInput, name: 'Quiz');

    (_currentQuizResult == _userInput)
        ? _answerCorrect = true
        : _answerCorrect = false;

    //show a snackback for right/wrong answer
    showQuizSnackBar(context, _answerCorrect);

    _score = scoreHandler(_currentScore, _answerCorrect, _targetScore);
    _currentScore = _score[0];
    _quizPassed = _score[1];
    if (_quizPassed) {
      _deactivateAlarm(widget.triggeredAlarm, widget.alarmNumber);
      // show success page first for a short time before going back to homepage
      Navigator.push(
        context,
        MaterialPageRoute(
            builder: (context) => const ShowSuccessPage()),
      );
      _generateNewQuizQuestion(); // generate new question for next time
    }
    else { // quiz is not passed
      setState(() {
        _generateNewQuizQuestion(); // load next quiz page
      });
    }
    FocusScope.of(context).requestFocus(_inputNode); // show keyboard again
    _numberInputController.clear();
  }

  /// Generate a new question question
  void _generateNewQuizQuestion() {
    _currentQuiz = quizGenerator();
    _currentQuizQuestion = _currentQuiz[0];
    _currentQuizResult = _currentQuiz[1];
  }

  @override
  void initState() {
    _generateNewQuizQuestion();
    super.initState();
  }

  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      // I need this to deactivate the "Go back" button
        onWillPop: () async => false, // Deactivate "Go back" button
        child: Scaffold(
          backgroundColor: Color(0xFFE4DAFC),
          body: Container(
            margin: const EdgeInsets.all(20.0),
            child: Column(
              children: <Widget>[
                Row(
                  children: <Widget>[SizedBox(height: 50)],
                ),
                Row(
                  // Time selector
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Text(
                      "Current Score:\n$_currentScore / $_targetScore",
                      textAlign: TextAlign.center,
                      style: Theme.of(context).textTheme.headline6,
                    ),
                  ],
                ),
                Row(
                  children: <Widget>[SizedBox(height: 50)],
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Text(
                      _currentQuizQuestion,
                      style: TextStyle(
                          color: Colors.deepPurple,
                          fontSize: 30,
                          fontWeight: FontWeight.w500 //, spacing...: 0.15
                      ),
                    ),
                  ],
                ),
                Row(
                  children: <Widget>[SizedBox(height: 100)],
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Expanded(
                      flex: 8,
                      child: Form(
                        key: _formKey,
                        child: TextFormField(
                            controller: _numberInputController,
                            autofocus: true,
                            // show keyboard automatically on start
                            focusNode: _inputNode,
                            // for showing keyboard on 2nd start etc.
                            onEditingComplete: () {},
                            // this prevents keyboard from closing
                            keyboardType:
                            TextInputType.numberWithOptions(signed: true),
                            decoration: InputDecoration(
                              labelText: 'Enter the result',
                              border: OutlineInputBorder(),
                            ),
                            style: TextStyle(fontSize: 22),
                            onFieldSubmitted: (String value) {
                              setState(() {
                                _userInput = value;
                                _quizScoreHandler();
                              });
                            }),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ));
  }
}