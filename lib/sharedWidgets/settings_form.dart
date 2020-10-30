import 'package:brewcrew/model/user.dart';
import 'package:brewcrew/services/database.dart';
import 'package:brewcrew/sharedWidgets/loadingwidget.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class SettingsForm extends StatefulWidget {
  @override
  _SettingsFormState createState() => _SettingsFormState();
}

class _SettingsFormState extends State<SettingsForm> {
  final _formKey = GlobalKey<FormState>();
  final List<String> sugars = ['0', '1', '2', '3', '4'];
  String _curName, _curSugars;
  int _curStrength;

  @override
  Widget build(BuildContext context) {
    final user = Provider.of<User>(context);
    return StreamBuilder<UserData>(
        stream: DatabaseService(uid: user.uid).userData,
        builder: (context, snapshot) {
          return !(snapshot.hasData)
              ? Loading()
              : Form(
                  key: _formKey,
                  child: Container(
                    color: Colors.brown[100],
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Column(
                        children: [
                          Text("Update your Brew Settings",
                              style: TextStyle(fontSize: 18)),
                          SizedBox(height: 30),
                          TextFormField(
                            initialValue: snapshot.data.name,
                            decoration: InputDecoration(
                                hintText: "Please Enter Your name",
                                focusedBorder: OutlineInputBorder(
                                    borderSide:
                                        BorderSide(color: Colors.greenAccent)),
                                enabledBorder: OutlineInputBorder(
                                    borderSide:
                                        BorderSide(color: Colors.brown[800]))),
                            validator: (val) =>
                                val.isEmpty ? 'Not Acceptable' : null,
                            cursorColor: Colors.yellowAccent,
                            style: TextStyle(color: Colors.black, fontSize: 18),
                            maxLines: 1,
                            onChanged: (val) {
                              setState(() => _curName = val);
                            },
                          ),
                          SizedBox(height: 20),
                          DropdownButtonFormField(
                              value: _curSugars ?? snapshot.data.sugars,
                              decoration: InputDecoration(
                                  focusedBorder: OutlineInputBorder(
                                      borderSide: BorderSide(
                                          color: Colors.greenAccent)),
                                  enabledBorder: OutlineInputBorder(
                                      borderSide: BorderSide(
                                          color: Colors.brown[800]))),
                              items: sugars.map((e) {
                                return DropdownMenuItem(
                                  value: e,
                                  child: Text('$e sugars'),
                                );
                              }).toList(),
                              onChanged: (val) {
                                setState(() => _curSugars = val);
                              }),
                          Slider(
                            value: (_curStrength ?? snapshot.data.strength)
                                .toDouble(),
                            label: "Strength",
                            activeColor: Colors.brown[_curStrength ?? 100],
                            inactiveColor: Colors.brown[_curStrength ?? 100],
                            min: 100.0,
                            max: 900.0,
                            divisions: 8,
                            onChanged: (val) {
                              setState(() => _curStrength = val.round());
                            },
                          ),
                          RaisedButton(
                            color: Colors.brown[900],
                            child: Text("Update",
                                style: TextStyle(color: Colors.white)),
                            onPressed: () async {
                              if (_formKey.currentState.validate()) {
                                await DatabaseService(uid: user.uid)
                                    .updateUserData(
                                        _curSugars ?? snapshot.data.sugars,
                                        _curName ?? snapshot.data.name,
                                        _curStrength ?? snapshot.data.strength);
                                Navigator.pop(context);
                              }
                            },
                          )
                        ],
                      ),
                    ),
                  ),
                );
        });
  }
}
