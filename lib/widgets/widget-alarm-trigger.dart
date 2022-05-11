// *********************************
// This is the third page for showing the alarm
// *********************************

import 'package:flutter/material.dart'; //Google Material Design assets
import 'package:intl/intl.dart';
import 'dart:async';
import 'dart:developer' as dev;
import '../alarm.dart'; // functions and more for the alarm
import '../global.dart'; // global variables and general outsourced stuff
import '../widgets/widget-challenge.dart'; // widget for the challenge
import 'widget-home-alarm-overview.dart'; // widget for the homepage


class ShowAlarmPage extends StatefulWidget {
  final CustomAlarm? triggeredAlarm;
  final int alarmNumber;

  const ShowAlarmPage(this.triggeredAlarm, this.alarmNumber);

  @override
  State<ShowAlarmPage> createState() => _MyShowAlarmPageState();
}

class _MyShowAlarmPageState extends State<ShowAlarmPage> {
  //vars here
  //functions here

  DateTime _now = DateTime
      .now(); // init it once, otherwise it will show NULL in the beginning
  String _dateString = DateFormat("EEEE, MMMM dd").format(DateTime
      .now()); // init it once, otherwise it will show NULL in the beginning
  String _timeStringShort = DateFormat("HH:mm").format(DateTime
      .now()); // init it once, otherwise it will show NULL in the beginning

  late Timer
  _refreshTimer; //timer to refresh the screen like for the current time

  /// refresh the presented strings for the current time etc.
  void _updateTime() {
    setState(() {
      // setState tells the Flutter framework that something has changed in this state, which causes it to rerun the build method
      _now = DateTime.now();
      _dateString = DateFormat("EEEE, MMMM dd").format(_now);
      _timeStringShort = DateFormat("HH:mm").format(_now);
    });
  }

  //todo das klappt nur bei non-recurring..muss ich noch ändern
  /// function to deactivate an alarm //todo
  List<CustomAlarm?> _deactivateAlarm(CustomAlarm? triggeredAlarm, alarmIndex) {
    return deactivateAlarm(triggeredAlarm, alarmIndex);
  }

  @override
  void initState() {
    _refreshTimer = Timer.periodic(everySecond, (Timer t) => _updateTime());
    super.initState();
  }

  @override
  void dispose() {
    _refreshTimer.cancel();
    super.dispose();
  }

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
                  children: <Widget>[SizedBox(height: 70)],
                ),
                // Add some distance between the next row
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Text(
                      "Alarm",
                      style: Theme.of(context).textTheme.headline6,
                    ),
                  ],
                ),
                Row(
                  children: <Widget>[SizedBox(height: 10)],
                ),
                // Add some distance between the next row
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Text(
                      "${widget.triggeredAlarm?.nameOfAlarm}",
                      style: TextStyle(
                          color: Colors.deepPurple,
                          fontSize: 25,
                          fontWeight: FontWeight.w500 //, spacing...: 0.15
                      ),
                    ),
                  ],
                ),
                Row(
                  children: <Widget>[SizedBox(height: 100)],
                ),
                // Add some distance between the next row
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Text(
                      "It's",
                      style: TextStyle(
                          color: Colors.black54,
                          fontSize: 18,
                          fontWeight: FontWeight.w500 //, spacing...: 0.15
                      ),
                    ),
                  ],
                ),
                Row(
                  children: <Widget>[SizedBox(height: 5)],
                ),
                // Add some distance between the next row
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Text(
                      _timeStringShort,
                      style: TextStyle(
                          color: Colors.black,
                          fontSize: 60,
                          fontWeight: FontWeight.w600 //, spacing...: 0.15
                      ),
                    ),
                  ],
                ),
                Row(
                  children: <Widget>[SizedBox(height: 10)],
                ),
                // Add some distance between the next row
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Text(
                      _dateString,
                      style: TextStyle(
                          color: Colors.black54,
                          fontSize: 20,
                          fontWeight: FontWeight.w400 //, spacing...: 0.15
                      ),
                    ),
                  ],
                ),
                Row(
                  children: <Widget>[SizedBox(height: 80)],
                ),
                // Add some distance between the next row
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    ElevatedButton(
                      // if challenge mode is active, go to page 4, otherwise to page 1 and turn off the alarm
                      onPressed: () {
                        if (widget.triggeredAlarm?.challengeMode == true) {
                          // challenge mode
                          playAlarmSound(0.1); // make alarm a bit more silent
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => ShowChallengePage(
                                    widget.triggeredAlarm, widget.alarmNumber)),
                          );
                        } else {
                          // no challenge mode
                          _deactivateAlarm(
                              widget.triggeredAlarm, widget.alarmNumber);
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) =>
                                const MyHomePage(title: appTitleHome)),
                          );
                        }
                      },

                      child: const Text('Stop'),
                      //
                    ),
                  ],
                ),
              ],
            ),
          ),
        ));
  }
}

