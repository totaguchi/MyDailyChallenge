import 'package:flutter/material.dart';
import 'package:my_daily_challenge/custom_timer_painter.dart';

class CountDownTimer extends StatefulWidget {
  //CountDownTimer({Key key}) : super(key: key);

  @override
  _CountDownTimerState createState() => _CountDownTimerState();
}

class _CountDownTimerState extends State<CountDownTimer> with TickerProviderStateMixin {

  AnimationController controller;

  String get timerString {
    Duration duration = controller.duration * controller.value;
    return '${duration.inMinutes}:${(duration.inSeconds % 60).toString().padLeft(2, '0')}';
  }

  @override
  void initState() {
    super.initState();
    controller = AnimationController(
      vsync: this,
      duration: Duration(seconds: 5),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: new AppBar(
        title: new Text('Timer'),
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
                                  "Count Down Timer",
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