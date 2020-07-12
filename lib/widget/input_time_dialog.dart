import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:my_daily_challenge/model/challenge.dart';
import 'package:my_daily_challenge/model/shared_pref.dart';

class InputTimeDialog extends StatefulWidget {
  InputTimeDialog({Key key}) : super(key: key);

  @override
  _InputTimeDialogState createState() => _InputTimeDialogState();
}

class _InputTimeDialogState extends State<InputTimeDialog> {
  final challengeNameController = TextEditingController();
  final challengeTimeController = TextEditingController();
  List challenges = [];
  SharedPref sharedPref = SharedPref();
  Challenge challenge = Challenge();

  loadSharedPrefs() async {
    try {
      challenges = await sharedPref.read("challenges");
    } catch (Exception) {
    }
  }
  
  @override
  initState() {
    super.initState();
    this.loadSharedPrefs();
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
               keyboardType: TextInputType.number,
               inputFormatters: <TextInputFormatter>[
                 WhitelistingTextInputFormatter.digitsOnly
               ],
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
            challenge.name = challengeNameController.text;
            challenge.time = int.parse(challengeTimeController.text);
            challenges.add(challenge);
            sharedPref.save("challenges", challenges);
            Navigator.pop(context);
          },
        ),
       ]
    );
  }

}
