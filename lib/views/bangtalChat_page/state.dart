import 'package:firebase_auth/firebase_auth.dart';
import 'package:fish_redux/fish_redux.dart';
import 'package:flutter/material.dart';
import 'package:escroomtok/globalbasestate/state.dart';
import 'package:escroomtok/models/base_api_model/user_list.dart';
import 'package:escroomtok/models/app_user.dart';

class BangtalChatState implements GlobalBaseState, Cloneable<BangtalChatState> {
  UserList listData;
  GlobalKey<ScaffoldState> scaffoldkey;
  List<DropdownMenuItem> cafeList;
  List<DropdownMenuItem> themaList;
  TextEditingController contsCon = TextEditingController();
  TextEditingController mDateTimeController = TextEditingController();
  String name;
  String backGroundUrl;
  String description;
  String selectCafeName;
  String selectThemaName;
  String desc;
  String groupChatId;
  var bangtalboardDetail;
  DateTime mDate;
  TextEditingController nameTextController;
  TextEditingController descriptionTextController;
  FocusNode nameFoucsNode;
  FocusNode descriptionFoucsNode;
  bool loading;

  @override
  BangtalChatState clone() {
    return BangtalChatState()
      ..listData = listData
      ..name = name
      ..backGroundUrl = backGroundUrl
      ..description = description
      ..user = user
      ..nameTextController = nameTextController
      ..mDateTimeController = mDateTimeController
      ..descriptionTextController = descriptionTextController
      ..nameFoucsNode = nameFoucsNode
      ..descriptionFoucsNode = descriptionFoucsNode
      ..loading = loading
      ..themaList = themaList
      ..selectCafeName = selectCafeName
      ..selectThemaName = selectThemaName
      ..cafeList = cafeList
      ..scaffoldkey = scaffoldkey
      ..desc = desc
      ..mDate = mDate
      ..bangtalboardDetail = bangtalboardDetail
      ..contsCon = contsCon
      ..groupChatId = groupChatId;
  }

  @override
  Locale locale;

  @override
  Color themeColor;

  @override
  AppUser user;
}

BangtalChatState initState(Map<String, dynamic> args) {
  BangtalChatState state = BangtalChatState();
  state.loading = false;
  state.bangtalboardDetail = args['bangtalboardDetail'];
  return state;
}
