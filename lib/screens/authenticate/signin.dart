import 'package:brewcrew/services/auth.dart';
import 'package:brewcrew/sharedWidgets/loadingwidget.dart';
import 'package:flutter/material.dart';

class SignIn extends StatefulWidget {
  final Function fun;

  SignIn({this.fun});

  @override
  _SignInState createState() => _SignInState();
}

class _SignInState extends State<SignIn> {
  final AuthService _auth = AuthService();
  String email, pass, error = '';
  bool loading =  false;
  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return loading?Loading():Scaffold(
      backgroundColor: Colors.brown[200],
      appBar: AppBar(
        elevation: 0.0,
        backgroundColor: Colors.brown[800],
        title:
            Text("Login to Brew ☕ Crew", style: TextStyle(color: Colors.white)),
        centerTitle: true,
        actions: [
          FlatButton(
            child: Text(
              "new user?",
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
          color: Colors.brown[300],
          child: Form(
            key: _formKey,
            child: Column(
              children: [
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: TextFormField(
                    decoration: InputDecoration(
                        hintText: "Email",
                        focusedBorder: OutlineInputBorder(
                            borderSide: BorderSide(color: Colors.greenAccent)),
                        enabledBorder: OutlineInputBorder(
                            borderSide: BorderSide(color: Colors.brown[800]))),
                    validator: (val) => val.isEmpty ? 'Invalid Email' : null,
                    cursorColor: Colors.yellowAccent,
                    style: TextStyle(color: Colors.white, fontSize: 18),
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
                    validator: (val) =>
                        val.length < 6 ? 'Invalid Password' : null,
                    decoration: InputDecoration(
                        hintText: "Password",
                        focusedBorder: OutlineInputBorder(
                            borderSide: BorderSide(color: Colors.greenAccent)),
                        enabledBorder: OutlineInputBorder(
                            borderSide: BorderSide(color: Colors.brown[800]))),
                    cursorColor: Colors.yellowAccent,
                    style: TextStyle(color: Colors.white, fontSize: 18),
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
                    color: Colors.brown[800],
                    child:
                        Text("Sign In", style: TextStyle(color: Colors.white)),
                    onPressed: () async {
                      if (_formKey.currentState.validate()) {
                        setState(() {loading = true;});
                        dynamic res =
                            await _auth.signInWithEmailPass(email, pass);
                        if (res == null) {
                          setState(() {
                            error = "Email or Password is incorrect";
                            loading = false;
                          });
                        }
                      }
                    },
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Text(error, style: TextStyle(color: Colors.redAccent)),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
