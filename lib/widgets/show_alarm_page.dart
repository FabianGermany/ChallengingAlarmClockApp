// *********************************
// This is the third page for showing the alarm
// *********************************

import 'package:flutter/material.dart'; //Google Material Design assets
import 'package:intl/intl.dart';
import 'dart:async';
import 'dart:developer' as dev;
import '../alarm.dart'; // functions and more for the alarm
import '../global.dart'; // global variables and general outsourced stuff
import '../widgets/show_challenge_page.dart'; // widget for the challenge
import 'homepage_alarm_overview.dart'; // widget for the homepage


class ShowAlarmPage extends StatefulWidget {
  final CustomAlarm? triggeredAlarm;
  final int alarmNumber;

  const ShowAlarmPage({Key? key, required this.triggeredAlarm, required this.alarmNumber}) : super(key: key);


  @override
  State<ShowAlarmPage> createState() => _MyShowAlarmPageState();
}

class _MyShowAlarmPageState extends State<ShowAlarmPage> {

  // init the vars, otherwise they will show NULL in the UI in the beginning
  DateTime _now = DateTime.now();
  String _dateString = DateFormat("EEEE, MMMM dd").format(DateTime.now());
  String _timeStringShort = DateFormat("HH:mm").format(DateTime.now());

  //timer to refresh the screen like for the current time
  late Timer _refreshTimer;

  /// refresh the presented strings for the current time etc.
  void _updateTime() {
    setState(() {
      // setState tells the Flutter framework that something has changed in this state, which causes it to rerun the build method
      _now = DateTime.now();
      _dateString = DateFormat("EEEE, MMMM dd").format(_now);
      _timeStringShort = DateFormat("HH:mm").format(_now);
    });
  }

  /// function to deactivate an alarm
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
                                    triggeredAlarm: widget.triggeredAlarm,
                                    alarmNumber: widget.alarmNumber)),
                          );
                        } else {
                          // no challenge mode
                          _deactivateAlarm(
                              widget.triggeredAlarm, widget.alarmNumber);
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) =>
                                const HomePageAlarmOverview(title: appTitleHome)),
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

