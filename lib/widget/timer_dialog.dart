import 'dart:async';
import 'package:flutter/material.dart';
import 'package:my_daily_challenge/model/challenge.dart';
import 'package:my_daily_challenge/model/shared_pref.dart';

class TimerDialog extends StatefulWidget {
  final int challengeTime;
  final String challengeName;
  final int challengeIndex;

  const TimerDialog({
    Key key,
    this.challengeTime,
    this.challengeName,
    this.challengeIndex,
  }) : super(key: key);

  @override
  _TimerDialogState createState() => _TimerDialogState();
}

class _TimerDialogState extends State<TimerDialog> {
  Timer _timer;
  int time;
  String name;
  int index;
  bool isStart = true;
  bool isChallengeClear = false;
  List<Challenge> challenges = [];
  SharedPref sharedPref = SharedPref();

  loadSharedPrefs() async {
    try {
      List challengesJSON = await sharedPref.read("challenges");
      challenges = challengesJSON.map((challenge) => Challenge.fromJson(challenge)).toList();
      print("load");
      print(challenges);
    } catch (Exception) {
    }
  }
  
  @override
  void initState() {
    super.initState();
    this.loadSharedPrefs();
    time = widget.challengeTime;
    name = widget.challengeName;
    index = widget.challengeIndex;
    countTime();
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text(name),
      content: Container(
        child: isChallengeClear? Text("Completed！") : Text("$time"),
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
            //カウントが０になるとチャレンジ達成日を保存する
            timer.cancel();
            isChallengeClear = true;
            challenges[index].achievedThisMonthList.add(DateTime.now().toString());
            sharedPref.save("challenges", challenges);
          } else {
            time = time -1;
            print(time);
          }
        },
      ),
    );
  }
}
