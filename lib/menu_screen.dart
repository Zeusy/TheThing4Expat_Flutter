import 'dart:io';

import 'package:easy_localization/easy_localization.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_app_test/constants/globals.dart';
import 'package:flutter_app_test/home_screen.dart';
import 'package:progressive_image/progressive_image.dart';
import 'package:provider/provider.dart';

class MenuScreen extends StatefulWidget {
  final List<MenuItem> mainMenu;
  final Function(int) callback;
  final int current;

  MenuScreen(
      this.mainMenu, {
        Key key,
        this.callback,
        this.current,
  });

  @override
  _MenuScreenState createState() => _MenuScreenState();
}

class _MenuScreenState extends State<MenuScreen> {
  final widthBox = SizedBox(
    width: 16.0,
  );

  String _name = tr("name");

  void changeName() => setState(() {
    if(currentUser != null)
      _name = currentUser.email;
    if(currentGoogleUser != null)
      _name = (currentGoogleUser.displayName != null)?currentGoogleUser.displayName:currentGoogleUser.email;
  });

  @override
  Widget build(BuildContext context) {
    final TextStyle androidStyle = const TextStyle(
      fontSize: 14,
      fontWeight: FontWeight.bold,
      color: Colors.white,
    );
    final TextStyle iosStyle = const TextStyle(color: Colors.white);
    final style = kIsWeb? androidStyle: Platform.isAndroid ? androidStyle : iosStyle;

    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [
              Theme.of(context).primaryColor,
              //Colors.indigo,
              Theme.of(context).accentColor,
            ],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        child: SafeArea(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Spacer(),
              Padding(padding: const EdgeInsets.only(bottom: 24.0, left: 24.0, right: 24.0),
                 child: ImageProfile(),
                /*child: Container(
                  width: 80,
                  height: 80,
                  decoration: BoxDecoration(
                    color: Colors.black,//grey[300],
                    shape: BoxShape.circle,
                  ),
                ),*/
              ),
              Padding(
                padding: const EdgeInsets.only(bottom: 24.0, left: 24.0, right: 24.0),
                child: Text(
                  '$_name',
                  style: TextStyle(
                    fontSize: 17,
                    color: Colors.white,
                    fontWeight: FontWeight.w900,
                  ),
                ),
              ),
              Selector<MenuProvider, int>(
                selector: (_, provider) => provider.currentPage,
                builder: (_, index, __) => Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    ...widget.mainMenu
                      .map((item) => MenuItemWidget(
                        key: Key(item.index.toString()),
                        item: item,
                        callback: widget.callback,
                        widthBox: widthBox,
                        style: style,
                        selected: index == item.index,
                      ))
                      .toList()
                  ],
                ),
              ),
              Spacer(),
              Padding(
                padding: const EdgeInsets.only(left: 24.0, right: 24.0),
                child: OutlineButton(
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Text(
                      tr("logout"),
                      style: TextStyle(fontSize: 18),
                    ),
                  ),
                  borderSide: BorderSide(color: Colors.white, width: 2.0),
                  onPressed: () async {
                    if(currentUser != null) {
                      await FirebaseAuth.instance.signOut();
                      currentUser = null;
                      changeName();
                    } else if (currentGoogleUser != null) {
                      await googleSignIn.signOut();
                    }
                  },
                  textColor: Colors.white,
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16.0)),
                ),
              ),
              Spacer(),
            ],
          ),
        ),
      ),
    );
  }
}

class MenuItemWidget extends StatelessWidget {
  final MenuItem item;
  final Widget widthBox;
  final TextStyle style;
  final Function callback;
  final bool selected;

  final white = Colors.white;

  const MenuItemWidget(
      {Key key,
      this.item,
      this.widthBox,
      this.style,
      this.callback,
      this.selected})
      : super(key : key);

  @override
  Widget build(BuildContext context) {
    return FlatButton(
        onPressed: () => callback(item.index),
        color: selected ? Color(0x44000000) : null,
        child: Row(
          mainAxisSize: MainAxisSize.max,
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Icon(
              item.icon,
              color: white,
              size: 24,
            ),
            widthBox,
            Expanded(child: Text(
              item.title,
              style: style,
            ),)
          ],
        ),);
  }
}

class MenuItem {
  final String title;
  final IconData icon;
  final int index;
  const MenuItem(this.title, this.icon, this.index);
}



class ImageProfile extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      child: ProgressiveImage(
        placeholder: NetworkImage('https://i.imgur.com/7XL923M.jpg'),//AssetImage('assets/placeholder.jpg'),
        thumbnail: NetworkImage('https://i.imgur.com/7XL923M.jpg'),
        image: NetworkImage('https://i.imgur.com/xVS07vQ.jpg'),
        height: 80,
        width: 80,
      ),
      decoration: BoxDecoration(
        //color: Colors.black,//grey[300],
        shape: BoxShape.circle,
      ),
    );
  }
}