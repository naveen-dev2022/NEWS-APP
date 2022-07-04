import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:getx_pattern/app/modules/login/views/login_view.dart';
import 'package:getx_pattern/app/modules/mainscreen.dart';

class FirebaseAuthentication extends StatelessWidget {
  const FirebaseAuthentication({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(body: StreamBuilder(
      stream: FirebaseAuth.instance.authStateChanges(),
      builder: (context, snapshot) {
       if(snapshot.connectionState == ConnectionState.waiting){
         return Center(child: CircularProgressIndicator(),);
       }
       else if(snapshot.hasData){
         return MainScreen();
       }
       else if(snapshot.hasError){
         return Center(child: Text('Something went wrong'),);
       }
       else{
         return LoginView();
       }
      }
    ),);
  }
}
