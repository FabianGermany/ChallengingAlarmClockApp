# Challenging Alarm Clock App

This repo is about creating an alarm clock app that is challenging the user by making him/her to solve a problem before the alarm sound stops.

## Getting Started


To run and debug the app, 
run ```main.dart``` on a device like on a physically available smartphone, 
on a virtually created smartphone
or on the Chrome browser for example.
To refresh the project, it's possible to use the hot reload function. 

To see the wireframe of the app, click on "Open Flutter DevTools" in the debug window below 
while running the debug mode.



## To Do MT
- Use Expanded etc. to avoid text overflow

## To Do LT
- Handle time zone issue
- For change the menu, there are also some nice animations like described in [here](https://github.com/flutter/packages/tree/master/packages/animations).
- Design Changes (e.g. display weekdays etc on both pages)
- Exceptions: e.g. Text Input too long for displaying it etc.
- Edit alarm via GestureDetector; I tried this in another branch, but it's a lot of work, so I didn't implement it in the main branch
- Snooze function
- Functions to change sound, vibration pattern, volume, snooze etc. (and integrate in CustomAlarm class)
  // Todo: alarm sound, vibration pattern, snooze, ...
- Sort alarms via date (I currently sort via dataframe index) via regularly called function _sortDatafrane
- The app is not really responsive so far; heights etc. are partially absolute; use more Flexible/Expanded etc. to avoid overflows and to make the app work on every device
- Use bloclibrary.dev
- Different challenge modes (quiz, mathematical problem etc.)
  - Quiz can be done via some API like [this](https://the-trivia-api.com/)
  - Mathematical questions are probably easier without API
- Challenge should be adapted to the user's cognitive characteristics (e.g. easier challenge for children etc.)
- Better UX, e.g. by creating a toast/snackbar "Alarm has been created" and "Alarm has been set / Alarm will ring in xx hours and xx minutes" etc.


## General Remarks
- Don't use ```print``` in production code, it's better to use ``` debugPrint```  or ``` log``` is even more powerful.