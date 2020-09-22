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
  final challengeMinuteController = TextEditingController();
  final challengeSecondsController = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  List challenges = [];
  SharedPref sharedPref = SharedPref();
  Challenge challenge = Challenge();

  loadSharedPrefs() async {
    try {
      challenges = await sharedPref.read("challenges");
    } catch (Exception) {}
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
          child: Form(
            key: _formKey,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                TextFormField(
                  validator: (value) {
                    if (value.isEmpty) {
                      return "Pelease enter some challenge";
                    }
                    return null;
                  },
                  obscureText: false,
                  decoration: InputDecoration(
                    border: OutlineInputBorder(),
                    labelText: 'ChallengeName',
                  ),
                  controller: challengeNameController,
                ),
                SizedBox(height: 10),
                Row(
                  children: [
                    Expanded(
                      child: TextFormField(
                        validator: (value) {
                          if (value.isEmpty) {
                            return "Pelease enter some minute";
                          }
                          return null;
                        },
                        obscureText: false,
                        decoration: InputDecoration(
                            border: OutlineInputBorder(),
                            labelText: 'minute',
                            hintText: 'minute'),
                        controller: challengeMinuteController,
                        keyboardType: TextInputType.number,
                        inputFormatters: <TextInputFormatter>[
                          WhitelistingTextInputFormatter.digitsOnly
                        ],
                      ),
                    ),
                    Text(
                      " : ",
                      style: TextStyle(fontSize: 25),
                    ),
                    Expanded(
                      child: TextFormField(
                        validator: (value) {
                          if (value.isEmpty) {
                            return "Pelease enter some seconds";
                          }
                          return null;
                        },
                        obscureText: false,
                        decoration: InputDecoration(
                            border: OutlineInputBorder(),
                            labelText: 'seconds',
                            hintText: 'seconds'),
                        controller: challengeSecondsController,
                        keyboardType: TextInputType.number,
                        inputFormatters: <TextInputFormatter>[
                          WhitelistingTextInputFormatter.digitsOnly
                        ],
                      ),
                    ),
                  ],
                ),
              ],
            ),
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
              if (_formKey.currentState.validate()) {
                challenge.name = challengeNameController.text;
                if (challengeMinuteController.text.isEmpty) {
                  challengeMinuteController.text = "0";
                }
                if (challengeSecondsController.text.isEmpty) {
                  challengeSecondsController.text = "0";
                }
                int challengeTime =
                    int.parse(challengeMinuteController.text) * 60 +
                        int.parse(challengeSecondsController.text);
                challenge.time = challengeTime;
                challenges.add(challenge);
                sharedPref.save("challenges", challenges);
                Navigator.pop(context);
              }
              print(challengeNameController.text);
              print(challengeMinuteController.text);
              print(challengeSecondsController.text);
            },
          ),
        ]);
  }
}
