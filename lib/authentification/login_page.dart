import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_app_test/authentification/sign_in.dart';
import 'package:flutter_app_test/first_screen.dart';

class LoginPage extends StatefulWidget {
  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        color: Colors.white,
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            mainAxisSize: MainAxisSize.max,
            children: <Widget>[
              FlutterLogo(size: 150,),
              SizedBox(height: 50,),
              _signInButton(),
            ],
          ),
        ),
      ),
    );
  }

  Widget _signInButton() {
    return OutlineButton(
      splashColor: Colors.grey,
      onPressed: () {
        signInWithGoogle().then((result) {
          if (result != null){
            Navigator.of(context).push(
              MaterialPageRoute(builder: (context) {
                return FirstScreen();
              },),
            );
          }
        });
      },
      shape: RoundedRectangleBorder(borderRadius:  BorderRadius.circular(40)),
      highlightElevation: 0,
      borderSide: BorderSide(color:  Colors.grey),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Image(image: AssetImage("assets/images/google-logo.png"), height: 35.0,),
          Padding(
            padding: const EdgeInsets.only(left: 10),
            child: Text(
              tr('Sign in with Google'),
              style: TextStyle(
                fontSize: 20,
                color: Colors.grey,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
