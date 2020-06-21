import 'package:flutter/material.dart';
import 'package:flutter_time_picker_spinner/flutter_time_picker_spinner.dart';
import 'package:shared_preferences/shared_preferences.dart';

class InputTimeDialog extends StatefulWidget {
  InputTimeDialog({Key key}) : super(key: key);

  @override
  _InputTimeDialogState createState() => _InputTimeDialogState();
}

class _InputTimeDialogState extends State<InputTimeDialog> {
  final challengeNameController = TextEditingController();
  final challengeTimeController = TextEditingController();
  List challenges = [];

  void save(List challenges) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setStringList('challenges', challenges);
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
       content: Container(
         child: Column(
           mainAxisAlignment: MainAxisAlignment.center,
           mainAxisSize: MainAxisSize.min,
           children: <Widget>[
             TextField(
               obscureText: false,
               decoration: InputDecoration(
                 border: OutlineInputBorder(),
                 labelText: 'ChallengeName',
               ),
               controller: challengeNameController,
             ),
             SizedBox(height: 10),
             TextField(
               obscureText: false,
               decoration: InputDecoration(
                 border: OutlineInputBorder(),
                 labelText: 'ChallengeTime',
                 hintText: 'minute'
               ),
               controller: challengeTimeController,
             ),
           ],
         ),
       ),
       actions: <Widget>[
         FlatButton(
          child: Text("Close"),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        FlatButton(
          child: Text("Done"),
          onPressed: () {
            print(challengeNameController.text);
            print(challengeTimeController.text);
            Map<String, String> challenge = {challengeNameController.text: challengeTimeController.text};
            challenges.add(challenge);
            save(challenges);
            Navigator.pop(context);
          },
        ),
       ]
    );
  }

  // Widget timePicker() {
  //   return new TimePickerSpinner(
  //     is24HourMode: true,
  //     isShowSeconds: true,
  //     normalTextStyle: TextStyle(
  //       fontSize: 20,
  //       color: Colors.deepOrange
  //     ),
  //     highlightedTextStyle: TextStyle(
  //       fontSize: 20,
  //       color: Colors.yellow
  //     ),
  //     spacing: 30,
  //     itemHeight: 50,
  //     isForce2Digits: true,
  //     onTimeChange: (item) {
  //       print(item);
  //       setState(() {
  //       });
  //     },
  //   );
  // }
}
