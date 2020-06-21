import 'dart:async';

import 'package:flutter/material.dart';

class TimerDialog extends StatefulWidget {
  final int challengeTime;

  const TimerDialog({
    Key key,
    this.challengeTime,
  }) : super(key: key);

  @override
  _TimerDialogState createState() => _TimerDialogState();
}

class _TimerDialogState extends State<TimerDialog> {
  Timer _timer;
  int time;
  bool isStart = true;
  
  @override
  void initState() {
    super.initState();
    time = widget.challengeTime;
    countTime();
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      content: Container(
        child: Text("$time"),
      ),
      actions: <Widget>[
        FlatButton(
          child: Text("Close"),
          onPressed: () {
            _timer.cancel();
            Navigator.pop(context);
          },
        ),
        FlatButton(
          child: isStart? Text("Stop") : Text("Start"),
          onPressed: () {
            if (isStart) {
              _timer.cancel();
            } else {
              countTime();
            }
            setState(() {
              isStart = !isStart;   
            });
          },
        ),
      ],
    );
  }

  //1秒ずつカウントを行う
  void countTime() {
    const oneSec = const Duration(seconds: 1);
    _timer = new Timer.periodic(
      oneSec,
      (Timer timer) =>  setState(
        () {
          if (time < 1) {
            timer.cancel();
          } else {
            time = time -1;
            print(time);
          }
        },
      ),
    );
  }
}
