import 'package:fish_redux/fish_redux.dart';
import 'package:flutter/material.dart';
import 'package:escroomtok/globalbasestate/state.dart';
import 'package:escroomtok/models/base_api_model/user_list.dart';
import 'package:escroomtok/models/app_user.dart';

class BangtalCabinetState
    implements GlobalBaseState, Cloneable<BangtalCabinetState> {
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
  TextEditingController newNameCon;
  TextEditingController newDescCon;

  TextEditingController clearTimeCon;
  String hintCon;
  String startCon;

  var bangtalboardDetail;
  DateTime mDate;
  TextEditingController nameTextController;
  TextEditingController descriptionTextController;
  FocusNode nameFoucsNode;
  FocusNode descriptionFoucsNode;
  bool loading;
  @override
  BangtalCabinetState clone() {
    return BangtalCabinetState()
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
      ..newNameCon = newNameCon
      ..newDescCon = newDescCon
      ..clearTimeCon = clearTimeCon
      ..hintCon = hintCon
      ..startCon = startCon
      ..contsCon = contsCon;
  }

  @override
  Locale locale;

  @override
  Color themeColor;

  @override
  AppUser user;
}

BangtalCabinetState initState(Map<String, dynamic> args) {
  BangtalCabinetState state = BangtalCabinetState();
  UserList _listData = args != null ? args['list'] : null;

  state.listData = _listData;
  state.name = _listData != null ? _listData.listName : '';
  state.backGroundUrl = _listData != null ? _listData.backGroundUrl : '';
  state.description = _listData != null ? _listData.description : '';
  state.nameFoucsNode = FocusNode();
  state.descriptionFoucsNode = FocusNode();
  state.loading = false;
  state.selectCafeName = '진행중인 카페';
  state.selectThemaName = '';
  state.scaffoldkey = GlobalKey<ScaffoldState>();
  state.cafeList = [];
  state.themaList = [
    DropdownMenuItem(
      // key: Key(element.documentID),
      child: Text('선택'),
      value: '',
      // key: items[element.documentID],
    )
  ];
  state.joinCount = '1';
  state.bangtalboardDetail = '진행중인 테마 내용';
  state.mDate = DateTime.now();
  state.newNameCon = TextEditingController();
  state.newDescCon = TextEditingController();
  state.clearTimeCon = TextEditingController();

  return state;
}
