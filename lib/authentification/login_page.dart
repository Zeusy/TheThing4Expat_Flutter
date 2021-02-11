import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_app_test/authentification/sign_in.dart';
import 'package:flutter_app_test/first_screen.dart';
import 'package:flutter_app_test/models/menu_provider.dart';
import 'package:sign_button/sign_button.dart';

import 'package:provider/provider.dart';

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
    return SignInButton(
      buttonType: ButtonType.google,
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
    );
  }
}
