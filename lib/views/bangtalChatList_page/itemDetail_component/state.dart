import 'dart:ui';

import 'package:escroomtok/globalbasestate/state.dart';
import 'package:escroomtok/models/app_user.dart';
import 'package:fish_redux/fish_redux.dart';
import 'package:flutter/animation.dart';

import '../state.dart';

class ItemDetailState extends ConnOp<BangtalChatListState, ItemDetailState>
    implements GlobalBaseState, Cloneable<ItemDetailState> {
  @override
  ItemDetailState get(BangtalChatListState state) {
    ItemDetailState mstate = ItemDetailState();
    mstate.data = state.data;

    return mstate;
  }

  var itemDetailData;
  AnimationController cellAnimationController;

  AnimationController animationController;
  int index;
  String nickname = "";
  List data = [];
  ItemDetailState(
      {this.itemDetailData,
      this.index,
      this.data,
      this.nickname,
      this.cellAnimationController,
      this.animationController});

  @override
  ItemDetailState clone() {
    return ItemDetailState()
      ..itemDetailData = itemDetailData
      ..index = index
      ..data = data
      ..nickname = itemDetailData[index]['nickname']
      ..cellAnimationController = cellAnimationController
      ..animationController = animationController;
  }

  @override
  Locale locale;

  @override
  Color themeColor;

  @override
  AppUser user;
}

ItemDetailState initState(Map<String, dynamic> args) {
  return ItemDetailState();
}
