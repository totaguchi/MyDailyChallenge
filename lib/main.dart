import 'package:flutter/material.dart';
import 'package:my_daily_challenge/model/challenge.dart';
import 'package:my_daily_challenge/model/shared_pref.dart';
import 'package:my_daily_challenge/widget/input_time_dialog.dart';
import 'package:table_calendar/table_calendar.dart';
import 'package:my_daily_challenge/widget/timer_dialog.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'My Daily Challenge',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: HomeScreen(),
    );
  }
}

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key key}) : super(key: key);

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  CalendarController _calendarController;
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
  initState() {
    super.initState();
    _calendarController = CalendarController();
    this.loadSharedPrefs();
    print("init");
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Home"),
        actions: <Widget>[
          IconButton(
            icon: Icon(Icons.add_circle_outline),
            onPressed: () {
              showDialog(
                context: context,
                builder: (_) => InputTimeDialog(),
              ).then((value) => setState(() {
                this.loadSharedPrefs();
              }));
            }
          ),
        ]
      ),
      body: ListView.builder(
        padding: EdgeInsets.all(6),
        itemCount: challenges.length + 1,
        itemBuilder: (BuildContext context, int index) {
          if (index == 0) {
            return _buildTableCalendar();
          }
          return _myChanllenge(index - 1);
        }
      )
      // body: SingleChildScrollView(
      //   child: Column(
      //     crossAxisAlignment: CrossAxisAlignment.start,
      //     children: <Widget>[
      //       _buildTableCalendar(),
      //       SizedBox(height: 20,),
      //       Container(
      //         height: 300,
      //         child: ListView.builder(
      //           padding: EdgeInsets.all(6),
      //           itemCount: challenges.length,
      //           itemBuilder: (BuildContext context, int index) =>
      //             _myChanllenge(index),
      //         ),
      //       ),             
      //     ],
      //   ),
      // ),
    );
  }

  Widget _buildTableCalendar() {
    return TableCalendar(
      headerStyle: HeaderStyle(
        formatButtonShowsNext: false,
      ),
      builders: CalendarBuilders(
        //todayDayBuilder: 
      ),
      calendarController: _calendarController,
    );
  }

  Widget _myChanllenge(int index) {
    return Container(
      child: Card(
        margin: EdgeInsets.all(5),
        color: Colors.lightBlue[50],
        child: Row(
          children: <Widget>[
          Expanded(
            child: Container(
              child: Text(challenges[index].name),
            )
          ),
          Container(
            padding: EdgeInsets.all(4),
            child: RaisedButton(
              child:Text("start"),
              color:  Colors.lightBlue,
              onPressed: () {
                showDialog(
                  context: context,
                  builder: (_) => TimerDialog(
                    challengeTime: challenges[index].time, 
                    challengeName: challenges[index].name
                  ),
                );
              }
            ),
          ),
          Container(
            padding: EdgeInsets.all(4),
            child: RaisedButton(
              child:Text("delete"),
              color: Colors.red,
              onPressed: () {
                openConfirmAlert(index);
              },
            ),
          )
        ]
        ),
      ),
    );
  }

  //削除時の確認アラート
  void openConfirmAlert(int index) {
    showDialog(
      context: context,
      builder: (context) {
        return Container(
          child: AlertDialog(
            title: Text("Challenge Give Up?"),
            actions: <Widget>[
              FlatButton(
               child: Text("No"),
               onPressed: () {
                 Navigator.pop(context);
               },
              ),
              FlatButton(
                child: Text("Yes"),
                onPressed: () {
                  deleteChallenge(index);
                },
              ),
            ],
          ),
        );      
      }
    );
  }
  
  //チャレンジの削除
  void deleteChallenge(int index) {
    Navigator.pop(context);
    setState(() {
      challenges.removeAt(index);
      sharedPref.save("challenges", challenges);
      this.loadSharedPrefs();
    });
    print(index);
    print(challenges);
  }
  
}
