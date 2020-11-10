import 'package:fish_redux/fish_redux.dart';
import 'package:flutter/material.dart';
import 'package:escroomtok/globalbasestate/state.dart';
import 'package:escroomtok/models/base_api_model/user_list.dart';
import 'package:escroomtok/models/app_user.dart';

class BangtalCreateState
    implements GlobalBaseState, Cloneable<BangtalCreateState> {
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
  String joincountTotal;
  DateTime mDate;
  TextEditingController nameTextController;
  TextEditingController descriptionTextController;
  FocusNode nameFoucsNode;
  FocusNode descriptionFoucsNode;
  bool loading;
  @override
  BangtalCreateState clone() {
    return BangtalCreateState()
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
      ..joincountTotal = joincountTotal
      ..contsCon = contsCon;
  }

  @override
  Locale locale;

  @override
  Color themeColor;

  @override
  AppUser user;
}

BangtalCreateState initState(Map<String, dynamic> args) {
  BangtalCreateState state = BangtalCreateState();
  UserList _listData = args != null ? args['list'] : null;
  state.listData = _listData;
  state.name = _listData != null ? _listData.listName : '';
  state.backGroundUrl = _listData != null ? _listData.backGroundUrl : '';
  state.description = _listData != null ? _listData.description : '';
  state.nameFoucsNode = FocusNode();
  state.descriptionFoucsNode = FocusNode();
  state.loading = false;
  state.selectCafeName = '';
  state.selectThemaName = '';
  state.scaffoldkey = GlobalKey<ScaffoldState>();
  state.cafeList = [];
  state.themaList = [];
  state.desc = '';
  state.joincountTotal = '4';
  state.mDate = DateTime.now();
  return state;
}
