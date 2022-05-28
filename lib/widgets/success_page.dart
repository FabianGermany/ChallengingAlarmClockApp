// *********************************
// This is the fifth page for temporarily show the success
// *********************************

import 'package:flutter/material.dart'; //Google Material Design assets
import 'dart:developer' as dev;
import '../global.dart'; // global variables and general outsourced stuff
import 'homepage_alarm_overview.dart';
import 'dart:async';


class ShowSuccessPage extends StatefulWidget {
  const ShowSuccessPage({Key? key}) : super(key: key);

  @override
  State<ShowSuccessPage> createState() => _MyShowSuccessPageState();
}

class _MyShowSuccessPageState extends State<ShowSuccessPage> {

  late Timer _ChangePangeTimer; // timer to change to another page


  @override
  void initState() {
    // update the in the UI presented current time regularly
    _ChangePangeTimer = Timer(Duration(milliseconds: 1200), () {
      _goBackToHomePage();
    });
    super.initState();
  }

  @override
  void dispose() {
    _ChangePangeTimer.cancel();
    super.dispose();
  }

  void _goBackToHomePage(){
    Navigator.push(
      context,
      MaterialPageRoute(
          builder: (context) => const HomePageAlarmOverview(title: appTitleHome)),
    );
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
                  children: <Widget>[SizedBox(height: 50)],
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Text(
                      "Current Score:\n$targetScore / $targetScore",
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
                      'Good job!',
                      style: TextStyle(
                          color: Colors.deepPurple,
                          fontSize: 30,
                          fontWeight: FontWeight.w500 //, spacing...: 0.15
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
