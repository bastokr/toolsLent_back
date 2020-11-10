import 'package:fish_redux/fish_redux.dart';
import 'package:flutter/material.dart';
import 'package:escroomtok/globalbasestate/state.dart';
import 'package:escroomtok/models/base_api_model/user_list.dart';
import 'package:escroomtok/models/app_user.dart';

class BangtalDetailState
    implements GlobalBaseState, Cloneable<BangtalDetailState> {
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
  String joinDesc;
  String boardId;
  String joinCount;
  var bangtalboardDetail;
  DateTime mDate;
  TextEditingController nameTextController;
  TextEditingController descriptionTextController;
  FocusNode nameFoucsNode;
  FocusNode descriptionFoucsNode;
  bool loading;
  @override
  BangtalDetailState clone() {
    return BangtalDetailState()
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
      ..joinDesc = joinDesc
      ..mDate = mDate
      ..joinCount = joinCount
      ..bangtalboardDetail = bangtalboardDetail
      ..contsCon = contsCon;
  }

  @override
  Locale locale;

  @override
  Color themeColor;

  @override
  AppUser user;
}

BangtalDetailState initState(Map<String, dynamic> args) {
  BangtalDetailState state = BangtalDetailState();
  UserList _listData = args != null ? args['list'] : null;

  state.listData = _listData;
  state.name = _listData != null ? _listData.listName : '';
  state.backGroundUrl = _listData != null ? _listData.backGroundUrl : '';
  state.description = _listData != null ? _listData.description : '';
  state.nameFoucsNode = FocusNode();
  state.descriptionFoucsNode = FocusNode();
  state.loading = false;
  state.selectCafeName = args['bangtalboardDetail']['cafe_name'];
  state.selectThemaName = args['bangtalboardDetail']['cafe_thema'];
  state.scaffoldkey = GlobalKey<ScaffoldState>();
  state.cafeList = [];
  state.themaList = [];
  state.joinCount = '1';
  state.bangtalboardDetail = args['bangtalboardDetail'];
  state.mDate = DateTime.now();
  return state;
}
