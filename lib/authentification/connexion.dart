import 'dart:convert';

import 'package:http/http.dart' as http;

import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_app_test/constants/globals.dart';
import 'package:flutter_app_test/menu_screen.dart';
import 'package:sign_button/sign_button.dart';

import 'package:google_sign_in/google_sign_in.dart';

class Connexion extends StatefulWidget {

  @override
  _ConnexionFormState createState() =>  _ConnexionFormState();
}

class _ConnexionFormState extends State<Connexion> {
  final _formKey = GlobalKey<FormState>();

  var email = ' ';
  var mdp = ' ';


  FirebaseAuth _auth = FirebaseAuth.instance;

  bool chargement = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text('Connexion'),
          backgroundColor: Theme.of(context).primaryColor,
        ),
        body: Container(
      padding: EdgeInsets.symmetric(vertical: 40.0, horizontal: 40.0),
      child: Form(
        key: _formKey,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            Center(
              child: Text('Connectez-vous à un compte distant'),
            ),
            SizedBox(height: 15,),
            TextFormField(
              decoration: InputDecoration(
                labelText: 'Email valide',
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(10.0)),
              ),
              validator: (value) => (value.isEmpty || value?.length < 3) ? 'Entrez votre email':null,
              onChanged: (value) => email = value,
            ),
            SizedBox(height: 15,),
            TextFormField(
              decoration: InputDecoration(
                labelText: 'Mot de passe',
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(10.0)),
              ),
              obscureText: true,
              onChanged:(value) => mdp = value,
              validator: (value) => value.length < 6 ? 'Entrez au moins 6 caractères' : null,
            ),
            SizedBox(height: 15,),
            FlatButton(
              onPressed: () async {
                if(_formKey.currentState.validate()) {
                  setState(() => chargement = true);
                  UserCredential result = await _auth.signInWithEmailAndPassword(email: email, password: mdp);
                  if(result == null) {
                    setState(() => chargement = false);
                  }
                  else {
                    print(currentUser);
                    User user = result.user;
                    result.user.email;
                    result.user.displayName;
                    currentUser = user;
                    print(currentUser);
                    backToSubPage(context);
                  }
                }
              },
              child: Text('Se connecter'),
              color: Theme.of(context).accentColor,
              textColor: Colors.white,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20.0),),
            ),
            OutlineButton(
              onPressed: (){
                backToSubPage(context);
              },
              child: Text('Besoin d\'un compte ?'),
              borderSide: BorderSide(width: 1.0),
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20.0),),
            ),
            SignInButton(
              buttonType: ButtonType.google,
              onPressed: (){
                setState(() async{
                  try {
                    if(googleSignIn != null)
                      await googleSignIn.signIn();
                  } catch (error) {
                    print(error);
                  }
              });
            }),
          ],
        ),
      ),
    ));
  }

  Future backToSubPage(context) async {
    Navigator.pop(context);
  }


  void initState() {
    super.initState();
    googleSignIn.onCurrentUserChanged.listen((GoogleSignInAccount account) {
      setState(() {
        currentGoogleUser = account;
      });
      if (currentGoogleUser != null) {
        _handleGetContact();
      }
    });
    googleSignIn.signInSilently();
  }


  Future<void> _handleGetContact() async {
    setState(() {
      print("Loading contact info...");
    });
    final http.Response response = await http.get(
      'https://people.googleapis.com/v1/people/me/connections'
          '?requestMask.includeField=person.names',
      headers: await currentGoogleUser.authHeaders,
    );
    if (response.statusCode != 200) {
      setState(() {
        print("People API gave a ${response.statusCode} "
            "response. Check logs for details.");
      });
      print('People API ${response.statusCode} response: ${response.body}');
      return;
    }
    final Map<String, dynamic> data = json.decode(response.body);
    final String namedContact = _pickFirstNamedContact(data);
    setState(() {
      if (namedContact != null) {
        print("I see you know $namedContact!");
        nameUser = namedContact;
      } else {
        print("No contacts to display.");
      }
    });
    backToSubPage(context);
  }

  String _pickFirstNamedContact(Map<String, dynamic> data) {
    final List<dynamic> connections = data['connections'];
    final Map<String, dynamic> contact = connections?.firstWhere(
          (dynamic contact) => contact['names'] != null,
      orElse: () => null,
    );
    if (contact != null) {
      final Map<String, dynamic> name = contact['names'].firstWhere(
            (dynamic name) => name['displayName'] != null,
        orElse: () => null,
      );
      if (name != null) {
        return name['displayName'];
      }
    }
    return null;
  }
}