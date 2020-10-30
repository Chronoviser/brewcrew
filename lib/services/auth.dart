import 'package:brewcrew/model/user.dart';
import 'package:firebase_auth/firebase_auth.dart';

class AuthService{
  final FirebaseAuth _auth = FirebaseAuth.instance;

  //this method converts Firebase user to User
  User _convertFirebaseUserToUser(FirebaseUser user){
    return user!=null?User(uid: user.uid):null;
  }
  //sign in anonum
   Future signInAnon() async{
    try{
     AuthResult authResult = await _auth.signInAnonymously();
     FirebaseUser user= authResult.user;
     return _convertFirebaseUserToUser(user);
    }catch (e){
      print(e.toString());
      return null;
    }
   }

   //we want user to move to home after signin and to Auth screen after signout
   // For this we need to keep track of _auth statechanges
   //onAuthStateChanged return FirebaseUser after login and null after logout    --> we convert the results to our custom USER
  Stream<User> get user{
    return _auth.onAuthStateChanged
                .map((FirebaseUser user) => _convertFirebaseUserToUser(user));
                 //same as
               //.map(_convertFirebaseUserToUser);
   }

  //sign in with email-pass
  Future signInWithEmailPass(String email,String pass) async{
    try{
      AuthResult result = await _auth.signInWithEmailAndPassword(email: email, password: pass);
      FirebaseUser user = result.user;
      return _convertFirebaseUserToUser(user);
    }
    catch(e){
      print(e.message);
      return null;
    }
  }
  //Register with email-pass
  Future registerWithEmailPass(String email,String pass) async{
    try{
      AuthResult result = await _auth.createUserWithEmailAndPassword(email: email, password: pass);
      FirebaseUser user = result.user;
      return _convertFirebaseUserToUser(user);
    }catch(e){
      print(e.message);
      return null;
    }
  }
  //signout
Future signOut() async{
    try{
      return await _auth.signOut();
    }
    catch(e){
      print(e);
      return null;
    }
}
}