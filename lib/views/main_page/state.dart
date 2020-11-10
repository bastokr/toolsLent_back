import 'package:fish_redux/fish_redux.dart';
import 'package:flutter/material.dart';
import 'package:escroomtok/globalbasestate/state.dart';
import 'package:escroomtok/models/app_user.dart';

class MainPageState implements GlobalBaseState, Cloneable<MainPageState> {
  int selectedIndex = 0; // 초기 페이지 설정
  List<Widget> pages;
  PageController pageController;
  GlobalKey<ScaffoldState> scaffoldKey = GlobalKey<ScaffoldState>();
  @override
  MainPageState clone() {
    return MainPageState()
      ..pages = pages
      ..selectedIndex = selectedIndex
      ..scaffoldKey = scaffoldKey
      ..locale = locale;
  }

  @override
  Locale locale;

  @override
  Color themeColor;

  @override
  AppUser user;
}

MainPageState initState(Map<String, dynamic> args) {
  // MainPageState()..selectedIndex = args['page'];
  // return MainPageState()..pages = args['pages'];

  MainPageState state = MainPageState();
  if (args['page'] != null) state.selectedIndex = args['page'];
  state.pages = args['pages'];
  return state;
}
