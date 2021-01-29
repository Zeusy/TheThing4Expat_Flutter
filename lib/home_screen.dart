import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_app_test/page_structure.dart';
import 'package:flutter_zoom_drawer/flutter_zoom_drawer.dart';
import 'package:provider/provider.dart';
import 'package:flutter_app_test/menu_screen.dart';

class HomeScreen extends StatefulWidget {
  static List<MenuItem> mainMenu = [
    MenuItem(tr("home"), Icons.home, 0),
    MenuItem(tr("payment"), Icons.payment, 1),
    MenuItem(tr("promos"), Icons.card_giftcard, 2),
    MenuItem(tr("notifications"), Icons.notifications, 3),
    MenuItem(tr("help"), Icons.help, 4),
    MenuItem(tr("about_us"), Icons.info_outline, 5),
  ];

  @override
  _HomeScreenState createState() => new _HomeScreenState();
}


class _HomeScreenState extends State<HomeScreen> {
  final _drawerController = ZoomDrawerController();
  int _currentPage = 0;

  @override
  Widget build(BuildContext context) {
    return ZoomDrawer(
      controller: _drawerController,
      menuScreen: MenuScreen(
        HomeScreen.mainMenu,
        callback: _updatePage,
        current: _currentPage,
      ),
      mainScreen: MainScreen(),
      borderRadius: 15.0,
      showShadow: true,
      angle: -10.0,//0.0,
      slideWidth: MediaQuery.of(context).size.width * (ZoomDrawer.isRTL() ? .45 : 0.65),
      openCurve: Curves.fastOutSlowIn,
      closeCurve: null,//Curves.bounceIn,
    );
  }

  void _updatePage(index) {
    Provider.of<MenuProvider>(context, listen: false).updateCurrentPage(index);
    _drawerController.toggle();
  }

}

class MainScreen extends StatefulWidget {
  @override
  _MainScreenState createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  @override
  Widget build(BuildContext context) {
    final rtl = ZoomDrawer.isRTL();
    return ValueListenableBuilder<DrawerState>(
        valueListenable: ZoomDrawer.of(context).stateNotifier,
        builder: (context, state, child) {
          return AbsorbPointer(
            absorbing: state != DrawerState.closed,
            child: child,
          );
        },
      child: GestureDetector(
        child: PageStructure(),
        onPanUpdate: (details) {
          if (details.delta.dx < 6 && !rtl || details.delta.dx < -6 && rtl) {
            ZoomDrawer.of(context).toggle();
          }
        },
      ),
    );
  }
}

class MenuProvider extends ChangeNotifier {
  int _currentPage = 0;
  int get currentPage => _currentPage;

  void updateCurrentPage(int index) {
    if (index != currentPage) {
      _currentPage = index;
      notifyListeners();
    }
  }
}