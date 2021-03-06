import 'dart:ui' as ui;
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';

import 'package:firebase_core/firebase_core.dart';

import 'package:easy_localization/easy_localization.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:progressive_image/progressive_image.dart';
import 'package:http/http.dart' as httpLib;
import 'package:provider/provider.dart';

import 'package:flutter_app_test/home_screen.dart';

import 'constants/globals.dart';
import 'home_screen.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();

  googleSignIn = GoogleSignIn(
    scopes: <String>[
      'openid',
      'email',
      'https://www.googleapis.com/auth/contacts.readonly',
      'https://www.googleapis.com/auth/userinfo.profile',
      'https://www.googleapis.com/auth/userinfo.email',
    ],
  );

  runApp(EasyLocalization(
    child: MyApp(),
    path: 'assets/langs',
    supportedLocales: MyApp.listLocal,
    useOnlyLangCode: true,
  ));
}

class MyApp extends StatelessWidget {
  static const listLocal = [
    Locale('en', 'US'),
    Locale('fr', 'FR'),
  ];

  @override
  Widget build(BuildContext context) {
    final windowLocale = ui.window.locale;
    Locale locale;
    try {
      final first = MyApp.listLocal?.firstWhere((elem) => elem?.languageCode == windowLocale?.languageCode);
      locale = first !=null ? first : Locale('en', 'US');
    } catch(e) {
      print(e);
    }

    return MaterialApp(
      title: 'Flutter Demo',
      onGenerateTitle: (context) => tr("app_name"),
      debugShowCheckedModeBanner: false, // fait disparaitre la banière débug
      localizationsDelegates: [
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        EasyLocalization.of(context).delegate,
      ],
      supportedLocales: EasyLocalization.of(context).supportedLocales,
      locale: locale,
      theme: ThemeData(
        primarySwatch: Colors.lime,
        accentColor: Colors.redAccent[700],
        buttonColor: Colors.pink,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      //home: MyHomePage(title: 'Flux Reader with flutter'),
      home: ChangeNotifierProvider(
        create: (_) => MenuProvider(),
        child: HomeScreen(),
      ),
    );
  }
}


class ProgressiveImageExample extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      child: ProgressiveImage(
        placeholder: NetworkImage('https://i.imgur.com/7XL923M.jpg'),//AssetImage('assets/placeholder.jpg'),
        thumbnail: NetworkImage('https://i.imgur.com/7XL923M.jpg'),
        image: NetworkImage('https://i.imgur.com/xVS07vQ.jpg'),
        height: 300,
        width: 500,
      ),
    );
  }
}


