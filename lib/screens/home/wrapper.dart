import 'package:brewcrew/model/user.dart';
import 'package:brewcrew/screens/authenticate/authenticate.dart';
import 'package:brewcrew/screens/home/home.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class Wrapper extends StatelessWidget {
  @override
  Widget build(BuildContext context){
    final user = Provider.of<User>(context);
    if(user == null) {
      return Auth();
    }
    return Home();
  }
}
