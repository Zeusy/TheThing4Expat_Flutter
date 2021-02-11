import 'package:flutter/material.dart';


class MenuProvider extends ChangeNotifier {
  int _currentPage = 0;

  void updateCurrentPage(int index) {
    if (index != currentPage) {
      _currentPage = index;
      notifyListeners();
    }
  }

  int get currentPage => _currentPage;
}