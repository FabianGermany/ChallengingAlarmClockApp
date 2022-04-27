// Define the class for a alarm and define default values
class customAlarm {
  bool isActive = false;
  bool isRinging = false;
  String nameOfAlarm = "New alarm";
  DateTime alarmTime = DateTime(DateTime.now().year, DateTime.now().month, DateTime.now().day, DateTime.now().hour + 2, DateTime.now().minute); // default alarm is going off in 2 hours
  bool isRecurrent = false; //default value is single time alarm
  List<bool> weekdayRecurrence = [false, false, false, false, false, false, false]; //from Monday to Sunday
  bool challengeMode = false;
  //todo: alarm sound, vibration pattern, snooze, ...

  //todo getter and setter methods

  void setNameOfAlarm(String var_nameOfAlarm)
  {
    nameOfAlarm = var_nameOfAlarm;
  }

  String getNameOfAlarm()
  {
    return nameOfAlarm;
  }

//todo remove
/* // constructor
  customAlarm(
      bool isActive,
      bool isRinging,
      String nameOfAlarm,
      DateTime alarmTime,
      bool isRecurrent,
      List<bool> weekdayRecurrence,
      bool challengeMode
      )
  {
    this.isActive = isActive;
    this.isRinging = isRinging;
    this.nameOfAlarm = nameOfAlarm;
    this.alarmTime = alarmTime;
    this.isRecurrent = isRecurrent;
    this.weekdayRecurrence = weekdayRecurrence;
    this.challengeMode = challengeMode;
  }
*/

}

void initGlobalVars()
{

}