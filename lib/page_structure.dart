import 'dart:io';
import 'dart:math' show pi;

import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_app_test/authentification/formulaire_auth.dart';
import 'package:flutter_app_test/home_screen.dart';
import 'package:flutter_zoom_drawer/flutter_zoom_drawer.dart';
import 'package:provider/provider.dart';
import 'package:flutter_platform_widgets/flutter_platform_widgets.dart';

class PageStructure extends StatelessWidget {
  final String title;
  final Widget child;
  final List<Widget> actions;
  final Color backgroundColor;
  final double elevation;

  const PageStructure({
    Key key,
    this.title,
    this.child,
    this.actions,
    this.backgroundColor,
    this.elevation,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(home: PageContent(this.actions, this.elevation),
      debugShowCheckedModeBanner: false,
      theme: Theme.of(context),
    );
  }
}


class PageContent extends StatefulWidget {
  var elevation;
  var actions;

  PageContent(this.actions, this.elevation);
  @override
  _PageContentState createState() => _PageContentState(this.actions, this.elevation);
}

class _PageContentState extends State<PageContent> {
  var elevation;
  var actions;

  _PageContentState(this.actions, this.elevation);


  _myPage(int currentPage) {
    switch (currentPage) {
      case 0: {
        return Inscription();
        //return Center(child: Text("${tr("current")}: ${HomeScreen.mainMenu[currentPage].title}"));
      }
      break;
      default : {
        return Center(child: Text("${tr("current")}: ${HomeScreen.mainMenu[currentPage].title}"));
      }
      break;
    }
  }

  @override
  Widget build(BuildContext context) {
    final angle = ZoomDrawer.isRTL() ? 180 * pi / 180 : 0.0;

    final _currentPage = context.select<MenuProvider, int>((provider) => provider.currentPage);
    final container = Container(
      color: Colors.grey[300],
      child: _myPage(_currentPage),/*Center(
        child: Text("${tr("current")}: ${HomeScreen.mainMenu[_currentPage].title}"),
      ),*/
    );
    final color = Theme
        .of(context)
        .accentColor;
    final style = TextStyle(color: color);


    return PlatformScaffold(
      backgroundColor: Colors.transparent,
      appBar: PlatformAppBar(
        automaticallyImplyLeading: false,
        android: (_) => MaterialAppBarData(elevation: elevation),
        title: PlatformText(
          HomeScreen.mainMenu[_currentPage].title,
        ),
        leading: Transform.rotate(
          angle: angle,
          child: PlatformIconButton(
            icon: Icon(
              Icons.menu,
            ),
            onPressed: () {
              ZoomDrawer.of(context)/*.setState(() {
              });*/.toggle();
            },
          ),
        ),
        trailingActions: actions,
      ),
      bottomNavBar: PlatformNavBar(
        currentIndex: _currentPage,
        itemChanged: (index) => Provider.of<MenuProvider>(context, listen: false).updateCurrentPage(index),
        items: HomeScreen.mainMenu.map((item) => BottomNavigationBarItem(
          title: Text(
            item.title,
            style: style,
          ),
          icon: Icon(
            item.icon,
            color: color,
          ),
        ),).toList(),
      ),
      body: kIsWeb ? container : Platform.isAndroid ? container : SafeArea(child: container,),
    );
  }

}
