

import 'package:flutter/material.dart';
import 'package:flutter_test_connection/routers/page_actions.dart';
import 'package:flutter_test_connection/routers/pages.dart';

class AppState extends ChangeNotifier {
  bool _loggedIn = false;
  bool get loggedIn  => _loggedIn;
  final cartItems = [];
  String emailAddress;
  String password;
  PageAction _currentAction = PageAction();
  PageAction get currentAction => _currentAction;

  set currentAction(PageAction action) {
    _currentAction = action;
    notifyListeners();
  }


  void resetCurrentAction() {
    _currentAction = PageAction();
  }

  void test() {


    _currentAction = PageAction(state: PageState.replaceAll, page: DetailsPageConfig);
    notifyListeners();
  }



}