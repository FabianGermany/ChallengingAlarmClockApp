// *********************************
// This is the second page for adding the alarm
// *********************************

import 'package:flutter/material.dart'; //Google Material Design assets
import 'package:intl/intl.dart';
import 'dart:developer' as dev;
import 'package:weekday_selector/weekday_selector.dart';
import '../alarm.dart'; // functions and more for the alarm
import '../global.dart'; // global variables and general outsourced stuff
import '../components.dart'; // outsourced widget components

class AddAlarmPage extends StatefulWidget {
  const AddAlarmPage({Key? key}) : super(key: key);

  @override
  State<AddAlarmPage> createState() => _MyAddAlarmPageState();
}

class _MyAddAlarmPageState extends State<AddAlarmPage> {
  TimeOfDay _chosenTime = TimeOfDay(hour: 8, minute: 00);
  DateTime _chosenDate = DateTime(DateTime.now().year, DateTime.now().month, DateTime.now().day + 1); // default today plus 1 day later; // DateTime(2022, 1, 1);
  List<bool> _chosenWeekdays = List.filled(7, false); // for weekday picker
  bool _challengingModeActive = false;
  bool _recurrentMode = false;

  // Create a text controller and use it to retrieve the current value
  // of the Alarm TextField.
  final _alarmNameController = TextEditingController(text: 'My personal alarm');

  @override
  void dispose() {
    _alarmNameController.dispose();
    super.dispose();
  }

  /// function to save the created/edited alarm
  List<CustomAlarm?> _saveAlarm(List<CustomAlarm?> currentAlarmList) {
    List<CustomAlarm?> alarmList = currentAlarmList;
    CustomAlarm? newCreatedAlarm = CustomAlarm(
      isActive: true,
      isRinging: false,
      nameOfAlarm: _alarmNameController.text,
      alarmTime: _chosenTime,
      alarmDate: _chosenDate,
      isRecurrent: _recurrentMode,
      weekdayRecurrence: _chosenWeekdays,
      challengeMode: _challengingModeActive,
    );
    alarmList.add(newCreatedAlarm); //add the alarm to the list
    dev.log("Alarm has been created!", name: 'Alarm');
    showAlarmCreationSnackBar(context); // Give feedback
    listOfSavedAlarms = alarmList; //save the local list back to the global one
    return alarmList;
  }

  /// Time selector
  void _selectTime() async {
    final TimeOfDay? newTime = await showTimePicker(
      context: context,
      initialTime: _chosenTime,
        builder: (context, childWidget) {
          return MediaQuery(
              data: MediaQuery.of(context).copyWith(
                  alwaysUse24HourFormat: true //24hr instead of 12hr AM/PM Format
              ),
              child: childWidget!);
        },
    );
    if (newTime != null) {
      setState(() {
        _chosenTime = newTime;
      });
    }
  }

  /// Date selector
  void _selectDate() async {
    final DateTime? newDate = await showDatePicker(
      context: context,
      locale: const Locale('en', 'GB'), // start week on Monday instead of Sunday
      initialDate: _chosenDate,
      firstDate: DateTime.now(),
      // today;
      lastDate: DateTime(
          DateTime.now().year + 5, DateTime.now().month, DateTime.now().day),
      // today plus later
      helpText: 'Select a date',
    );
    if (newDate != null) {
      //closes the menu and saves everything
      setState(() {
        _chosenDate = newDate;
        _recurrentMode =
        false; // if date is chosen and saved, set recurrent mode to false
        _chosenWeekdays = List.filled(7,
            false); // if date is chosen and saved, also make the recurrent buttons default again
      });
    }
  }

  // That's needed for the input of the alarm name
  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(appTitleAddAlarm),
      ),
      body: Container(
        margin: const EdgeInsets.all(20.0),
        child: Column(
          children: <Widget>[
            Row(
              // Time selector
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Expanded(
                  flex: 5,
                  child: ElevatedButton(
                    onPressed: _selectTime,
                    child: Text('Select time'),
                  ),
                ),
                Expanded(
                  flex: 5,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      GestureDetector(
                        onTap: _selectTime,
                        behavior: HitTestBehavior.opaque,
                        child:
                          Column(
                            children: <Widget>[
                              Row(
                                children: <Widget>[
                                  Text(
                                    'Selected time:',
                                  ),
                                ],
                              ),
                              Row(
                                children: <Widget>[
                                  SizedBox(height: 6),
                                ],
                              ),
                              Row(
                                children: <Widget>[
                                  Text(
                                    _chosenTime.to24hours(), //.format(context)
                                    style: Theme.of(context)
                                        .textTheme
                                        .headline6, //textTheme.subtitle1
                                  ),
                                ],
                              ),
                            ],
                          ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            Row(
              // Info text
              children: <Widget>[
                Expanded(
                  child: const Text(
                    '\nPlease chose either a concrete date for the alarm or - if it is repetitive - choose the desired weekdays.\n',
                  ),
                ),
              ],
            ),
            Row(
              // Date selector
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Expanded(
                  flex: 5,
                  child: ElevatedButton(
                    onPressed: _selectDate,
                    child: Text('Select date'),
                  ),
                ),
                Expanded(
                  flex: 5,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      GestureDetector(
                        onTap: _selectDate,
                        behavior: HitTestBehavior.opaque,
                        child:
                          Column(
                            children: <Widget>[
                              Row(
                                children: <Widget>[
                                  Text(
                                    'Selected date:',
                                    style: TextStyle(
                                        color: _recurrentMode == false
                                            ? Colors.black
                                            : Colors.black26),
                                  ),
                                ],
                              ),
                              Row(
                                children: <Widget>[
                                  SizedBox(height: 6),
                                ],
                              ),
                              Row(
                                children: <Widget>[
                                  Text(
                                    DateFormat('MMMEd').format(_chosenDate),
                                    style: TextStyle(
                                        color: _recurrentMode == false
                                            ? Colors.black
                                            : Colors.black26,
                                        fontSize: 20,
                                        fontWeight:
                                        FontWeight.w500 //, spacing...: 0.15
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                    ],
                  ),
                ),
              ],
            ),
            Row(
              // Add some space
              children: <Widget>[
                SizedBox(height: 10),
              ],
            ),
            Row(
              // Weekday picker
              children: <Widget>[
                Expanded(
                  child: WeekdaySelector(
                    firstDayOfWeek: DateTime.monday,
                    onChanged: (int day) {
                      setState(() {
                        final index = day % 7;
                        _chosenWeekdays[index] = !_chosenWeekdays[index];
                        // if any weekday is active, activate recurrent mode, otherwise not
                        if (_chosenWeekdays.any((e) => e == true)) {
                          _recurrentMode = true;
                        } else {
                          _recurrentMode = false;
                        }
                      });
                    },
                    values: _chosenWeekdays,
                  ),
                ),
              ],
            ),
            Row(
              // Add some space
              children: <Widget>[
                SizedBox(height: 10),
              ],
            ),

            // Type of alarm
            Row(
              children: <Widget>[
                Expanded(
                  flex: 8,
                  child: Form(
                    key: _formKey,
                    child: TextFormField(
                      controller: _alarmNameController,
                      decoration: InputDecoration(
                        labelText: 'Name of alarm',
                        border: OutlineInputBorder(),
                      ),
                      validator: (value) {
                        if (value == null ||
                            value.isEmpty ||
                            value.length > 20) {
                          return 'Please use a name between 1 and 20 characters.';
                        }
                        return null;
                      },
                    ),
                  ),
                ),
              ],
            ),

            Row(
              // Add some space
              children: <Widget>[
                SizedBox(height: 10),
              ],
            ),
            Row(
              // Toggle/Switch for Challenge Mode
              children: <Widget>[
                Expanded(
                  flex: 8,
                  child: Text(
                    'Challenge mode',
                    style: TextStyle(
                        color: (_challengingModeActive == true)
                            ? Colors.black
                            : Colors.black38),
                  ),
                ),
                Expanded(
                  flex: 2,
                  child: Switch(
                    value: _challengingModeActive,
                    activeColor: Color(0xFF6200EE),
                    onChanged: (bool value) {
                      setState(() {
                        _challengingModeActive = value;
                      });
                    },
                  ),
                ),
              ],
            ),
            Row(
              // Add some space
              children: <Widget>[
                SizedBox(height: 30),
              ],
            ),
            Row(
              // Cancel and confirm buttons
              children: <Widget>[
                // Cancel button
                Expanded(
                  flex: 30,
                  child: Center(
                    child: OutlinedButton(
                      onPressed: () {
                        Navigator.pop(context);
                      },
                      child: const Text('Cancel'),
                    ),
                  ),
                ),
                Expanded(
                  // Some space
                  flex: 40,
                  child: Center(),
                ),

                Expanded(
                  // Confirm button
                  flex: 30, // 30%
                  child: Center(
                    child: OutlinedButton(
                      //on pressed save the alarm and close the menu at the same time
                      // Validate returns true if the form is valid, or false otherwise.
                      onPressed: () {
                        if (_formKey.currentState!.validate()) {
                          // for multiple commands in onPressed this form should be used:
                          // () =>[command1, command2]
                          // but in if statement, it seems to be not necessary
                          _saveAlarm(listOfSavedAlarms); // save current alarm
                          saveData(); // backup alarmlist
                          Navigator.pop(context);
                        } else {
                          //don't save it
                        }
                      },
                      child: const Text('Confirm'),
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}