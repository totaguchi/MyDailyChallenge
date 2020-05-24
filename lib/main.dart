import 'package:flutter/material.dart';
import 'package:table_calendar/table_calendar.dart';

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
  final List<String> challenges = <String>['筋トレ', '読書'];

  @override
  initState() {
    super.initState();
    _calendarController = CalendarController();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("ホーム")
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
      child: Row(
        children: <Widget>[
        Expanded(
          child: Container(
            child: Text(challenges[index]),
          )
        ),
        Container(
          padding: EdgeInsets.all(4),
          child: RaisedButton(
            child:Text("start"),
            color:  Colors.lightBlue,
            onPressed: () {},
          ),
        ),
        Container(
          padding: EdgeInsets.all(4),
          child: RaisedButton(
            child:Text("delete"),
            color: Colors.red,
            onPressed: () {},
          ),
        )
      ]
      ),
    );
  }
}
