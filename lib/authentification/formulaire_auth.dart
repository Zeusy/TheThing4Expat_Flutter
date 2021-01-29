import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_app_test/authentification/connexion.dart';
import 'package:flutter_app_test/constants/globals.dart';
import 'package:sign_button/sign_button.dart';

class Inscription extends StatefulWidget {

  @override
  _InsciptionFormState createState() =>  _InsciptionFormState();
}

class _InsciptionFormState extends State<Inscription> {
  final _formKey = GlobalKey<FormState>();

  var nom = ' ';
  var email = ' ';
  var mdp = ' ';
  var confirmMdp = ' ';


  @override
  Widget build(BuildContext context) {
    var name = (nameUser != null && nameUser != "name") ? nameUser: currentUser?.email.toString();
    return (currentUser != null || currentGoogleUser != null) ? Container(
      child: Center(child: Text('Hello '+ name +' !'),),
    ):
    Container(
      padding: EdgeInsets.symmetric(vertical: 40.0, horizontal: 40.0),
      child: Form(
        key: _formKey,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            Center(
              child: Text('Créer un compte distant'),
            ),
            SizedBox(height: 15,),
            TextFormField(
              decoration: InputDecoration(
                labelText: 'Nom ou pseudo',
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(10.0)),
              ),
              validator: (value) => (value.isEmpty || value?.length < 3) ? 'Entrez votre nom ou pseudo':null,
              onChanged: (value) => nom = value,
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
            TextFormField(
              decoration: InputDecoration(
                labelText: 'Confirmation mot de passe',
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(10.0)),
              ),
              obscureText: true,
              onChanged: (value) => confirmMdp = value,
              validator: (value) => (confirmMdp.isEmpty || confirmMdp != mdp) ? 'Entrez un mot de passe identique' : null,
            ),
            FlatButton(
              onPressed: (){
                if(_formKey.currentState.validate()) {
                  Scaffold.of(context).showSnackBar(SnackBar(content: Text('Processing...')));
                }
              },
              child: Text('S\'inscrire'),
              color: Theme.of(context).accentColor,
              textColor: Colors.white,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20.0),),
            ),
            OutlineButton(
              onPressed: (){
                navigateToSubPage(context);
              },
              child: Text('Déjà un compte ?'),
              borderSide: BorderSide(width: 1.0),
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20.0),),
            ),
            SignInButton(
              buttonType: ButtonType.google,
              onPressed: (){
                setState((){
                });
              }),
          ],
        ),
      ),
    );
  }

  Future navigateToSubPage(context) async {
    Navigator.push(context, MaterialPageRoute(builder: (context) => Connexion()));
  }
}