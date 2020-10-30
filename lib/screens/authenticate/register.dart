import 'package:brewcrew/model/user.dart';
import 'package:brewcrew/services/auth.dart';
import 'package:brewcrew/services/database.dart';
import 'package:brewcrew/sharedWidgets/loadingwidget.dart';
import 'package:flutter/material.dart';

class Register extends StatefulWidget {
  final Function fun;

  Register({this.fun});

  @override
  _RegisterState createState() => _RegisterState();
}

class _RegisterState extends State<Register> {
  final AuthService _auth = AuthService();
  bool loading = false;
  final _formKey = GlobalKey<FormState>();
  String email, pass, error = '';

  @override
  Widget build(BuildContext context) {
    return loading?Loading():Scaffold(
      backgroundColor: Colors.brown[200],
      appBar: AppBar(
        elevation: 0.0,
        backgroundColor: Colors.brown[400],
        title: Text("Register to Brew ☕ Crew",
            style: TextStyle(color: Colors.white)),
        centerTitle: true,
        actions: [
          FlatButton(
            child: Text(
              "login",
              style: TextStyle(color: Colors.lightBlueAccent),
            ),
            onPressed: () {
              widget.fun();
            },
          )
        ],
      ),
      body: SingleChildScrollView(
        child: Card(
          color: Colors.brown[800],
          child: Form(
            key: _formKey,
            child: Column(
              children: [
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: TextFormField(
                    validator: (val) => val.isEmpty ? 'Enter an email' : null,
                    cursorColor: Colors.yellowAccent,
                    style: TextStyle(color: Colors.white, fontSize: 18),
                      decoration: InputDecoration(
                        hintText: "Email",
                          focusedBorder: OutlineInputBorder(
                              borderSide: BorderSide(color: Colors.greenAccent)),
                          enabledBorder: OutlineInputBorder(
                              borderSide: BorderSide(color: Colors.brown[200]))),
                    keyboardType: TextInputType.emailAddress,
                    maxLines: 1,
                    onChanged: (val) {
                      setState(() => email = val);
                    },
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: TextFormField(
                    validator: (val) => val.length < 6
                        ? 'Password must be at least 6 characters long'
                        : null,
                    cursorColor: Colors.yellowAccent,
                    style: TextStyle(color: Colors.white, fontSize: 18),
                    decoration: InputDecoration(
                      hintText: "Password",
                        focusedBorder: OutlineInputBorder(
                            borderSide: BorderSide(color: Colors.greenAccent)),
                        enabledBorder: OutlineInputBorder(
                            borderSide: BorderSide(color: Colors.brown[200]))),
                    maxLines: 1,
                    obscureText: true,
                    onChanged: (val) {
                      setState(() => pass = val);
                    },
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: RaisedButton(
                    color: Colors.brown[400],
                    child:
                        Text("Register", style: TextStyle(color: Colors.white)),
                    onPressed: () async {
                      if (_formKey.currentState.validate()) {
                        setState(() => loading = true);
                        dynamic res =
                            await _auth.registerWithEmailPass(email, pass);
                        if (res == null) {
                          setState(() {
                            error = "Check your Email";
                            loading = false;
                          });
                        }
                        else{
                          await DatabaseService(uid: (res as User).uid).updateUserData("0", "new user", 100);
                        }
                      }
                    },
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Text(error, style: TextStyle(color: Colors.red)),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
