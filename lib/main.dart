import 'dart:ui' as ui;
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';

import 'package:firebase_core/firebase_core.dart';

import 'package:easy_localization/easy_localization.dart';
import 'package:flutter_app_test/authentification/login_page.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:progressive_image/progressive_image.dart';
import 'package:provider/provider.dart';


import 'constants/globals.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  //await Firebase.initializeApp();

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
        primarySwatch: Colors.red,
        accentColor: Colors.redAccent,
        buttonColor: Colors.pink,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: LoginPage(),
      //home: MyHomePage(title: 'Flux Reader with flutter'),
      /*home: ChangeNotifierProvider(
        create: (_) => MenuProvider(),
        child: HomeScreen(),
      ),*/
    );
  }
}


