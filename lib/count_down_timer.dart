import 'package:flutter/material.dart';
import 'package:my_daily_challenge/custom_timer_painter.dart';
import 'package:my_daily_challenge/model/challenge.dart';
import 'package:my_daily_challenge/model/shared_pref.dart';

class CountDownTimer extends StatefulWidget {
  final int challengeTime;
  final String challengeName;
  final int challengeIndex;

  CountDownTimer({
    this.challengeTime,
    this.challengeName,
    this.challengeIndex,
    Key key,
  }) : super(key: key);

  @override
  _CountDownTimerState createState() => _CountDownTimerState();
}

class _CountDownTimerState extends State<CountDownTimer> with TickerProviderStateMixin {

  AnimationController controller;
  List<Challenge> challenges = [];
  SharedPref sharedPref = SharedPref();
  int time;
  String name;
  int index;
  bool isChallengeClear = false;

  String get timerString {
    Duration duration = controller.duration * controller.value;
    return '${duration.inMinutes}:${(duration.inSeconds % 60).toString().padLeft(2, '0')}';
  }

  loadSharedPrefs() async {
    try {
      List challengesJSON = await sharedPref.read("challenges");
      challenges = challengesJSON.map((challenge) => Challenge.fromJson(challenge)).toList();
    } catch (Exception) {
    }
  }
  saveResult() {
    try {
      isChallengeClear = true;
      challenges[index].achievedThisMonthList.add(DateTime.now().toString());
      sharedPref.save("challenges", challenges);
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
    controller = AnimationController(
      vsync: this,
      duration: Duration(seconds: time),
    )..addStatusListener((status) {
      if (status == AnimationStatus.dismissed) {
        this.saveResult();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: new AppBar(
        title: new Text(name),
      ),
      backgroundColor: Colors.white10,
      body: AnimatedBuilder(
        animation: controller, 
        builder: (context, child) {
          return Padding(
            padding: EdgeInsets.all(8.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                Expanded(
                  child: Align(
                    alignment: FractionalOffset.center,
                    child: AspectRatio(
                      aspectRatio: 1.0,
                      child: Stack(
                        children: <Widget>[
                          Positioned.fill(
                            child: AnimatedBuilder(
                              animation: controller,
                              builder: (BuildContext context, Widget child) {
                                return CustomPaint(
                                  painter: CustomTimerPainter(
                                    animation: controller,
                                    backgroundColor: Colors.white,
                                    color: Colors.lightBlue,
                                  ),
                                );
                              },
                            ),
                          ),
                          Align(
                            alignment: FractionalOffset.center,
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: <Widget>[
                                Text(
                                  name,
                                  style: TextStyle(
                                    fontSize: 20.0,
                                    color: Colors.white,
                                  ),
                                ),
                                AnimatedBuilder(
                                  animation:  controller,
                                  builder: (BuildContext context, Widget child) {
                                    return Text(
                                      timerString,
                                      style: TextStyle(
                                        fontSize: 112.0,
                                        color: Colors.white,
                                      ),
                                    );
                                  },
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
                AnimatedBuilder(animation: controller,
                  builder: (context, child) {
                    return FloatingActionButton.extended(
                      onPressed: () {
                        if (controller.isAnimating) {
                          controller.stop();
                        } else {
                          controller.reverse(
                            from: controller.value == 0.0
                                ? 1.0
                                : controller.value); 
                        }
                      },
                      icon: Icon(controller.isAnimating
                          ? Icons.pause
                          : Icons.play_arrow),
                      label: Text(
                        controller.isAnimating ? "Pause" : "Paly")
                    );
                  }
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}