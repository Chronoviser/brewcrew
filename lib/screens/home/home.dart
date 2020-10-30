import 'package:brewcrew/model/brews.dart';
import 'package:brewcrew/screens/home/brew_list.dart';
import 'package:brewcrew/services/auth.dart';
import 'package:brewcrew/sharedWidgets/settings_form.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:brewcrew/services/database.dart';

class Home extends StatelessWidget {
  final AuthService _auth = AuthService();

  @override
  Widget build(BuildContext context) {
    return StreamProvider<List<Brew>>.value(
      value: DatabaseService().brews,
      child: Scaffold(
        backgroundColor: Colors.brown[200],
        appBar: AppBar(
          title: Text("Brew ☕ Crew"),
          centerTitle: true,
          backgroundColor: Colors.brown[400],
          actions: [
            Container(
              width: 50,
              child: FlatButton(
                child: Icon(Icons.settings, color: Colors.white),
                onPressed: () {
                  return showModalBottomSheet(
                      clipBehavior: Clip.hardEdge,
                      context: context,
                      builder: (context) {
                        return Container(
                          child: SettingsForm(),
                        );
                      });
                },
              ),
            ),
            Container(
                width: 50,
                child: FlatButton(
                  child: Icon(
                    Icons.exit_to_app,
                    color: Colors.white,
                  ),
                  onPressed: () async {
                    await _auth.signOut();
                  },
                )),
          ],
        ),
        body: Container(
            decoration: BoxDecoration(
                image: DecorationImage(
              image: AssetImage('assets/coffeebg.jpg'),
              fit: BoxFit.cover,
            )),
            child: BrewList()),
      ),
    );
  }
}
