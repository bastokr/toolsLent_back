import 'package:escroomtok/globalbasestate/state.dart';
import 'package:escroomtok/models/app_user.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fish_redux/fish_redux.dart';
import 'package:flutter/cupertino.dart';

import 'itemDetail_component/state.dart';

class BangtalboardState extends MutableSource
    implements GlobalBaseState, Cloneable<BangtalboardState> {
  List data = [];
  ScrollController controller;
  bool isLoading = true;
  String reload = '';

  AnimationController animationController;
  AnimationController cellAnimationController;
  AnimationController refreshController;
  @override
  BangtalboardState clone() {
    return BangtalboardState()
      ..data = data
      ..controller = controller
      ..animationController = animationController
      ..refreshController = refreshController
      ..cellAnimationController = cellAnimationController;
  }

  @override
  Object getItemData(int index) => ItemDetailState(
        itemDetailData: data[index],
        index: index,
        nickname: data[index]['nickname'],
        cellAnimationController: cellAnimationController,
        animationController: animationController,
      );

  @override
  String getItemType(int index) => 'detail';

  @override
  void setItemData(int index, Object data) {
    // TODO: implement setItemData
  }

  @override
  int get itemCount => data.length ?? 0;

  @override
  Locale locale;

  @override
  Color themeColor;

  @override
  AppUser user;
}

BangtalboardState initState(Map<String, dynamic> args) {
  BangtalboardState state = BangtalboardState();
  state.reload = args != null ? args['reload'] : null;

  return state;
}
