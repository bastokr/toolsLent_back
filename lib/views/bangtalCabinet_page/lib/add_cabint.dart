import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:escroomtok/actions/adapt.dart'; 
import 'package:escroomtok/globalbasestate/store.dart';
import 'package:escroomtok/models/base_api_model/user_list.dart';
import 'package:escroomtok/models/mylist_model.dart';
import 'package:escroomtok/models/response_model.dart';
import 'package:escroomtok/style/themestyle.dart';
import 'package:intl/intl.dart';
import 'package:searchable_dropdown/searchable_dropdown.dart';

import 'datetime_picker_formfield.dart';

class AddCabintDialog extends StatefulWidget {
  final String name;
  final double rated;
  final String photourl;
  final int runtime;
  final int revenue;
  final String releaseDate;

  AddCabintDialog(
      {this.name,
      this.rated,
      this.photourl,
      this.runtime = 0,
      this.revenue = 0,
      this.releaseDate});
  @override
  AddCabintDialogState createState() => AddCabintDialogState();
}

class AddCabintDialogState extends State<AddCabintDialog> {
  final scaffoldKey = GlobalKey<ScaffoldState>();
  Future<MyListModel> lists;
  ScrollController scrollController;
  Future<ResponseModel<UserListModel>> _userList;
  var mDate = DateTime.now();
  TextEditingController rnewNameCon = TextEditingController();
  TextEditingController newDescCon = TextEditingController();
  TextEditingController clearTimeConMm = TextEditingController();
  TextEditingController clearTimeConSs = TextEditingController();
  String startCon = '';
  String hintCon = '0';
  String complete = 'N';
  String selectCafeName = '';
  String selectThemaName = '';
  String passYn = '성공';
  List<DropdownMenuItem> cafeList = [];
  List<DropdownMenuItem> themaList = [
    DropdownMenuItem(
      // key: Key(element.documentID),
      child: Text('테마선택'),
      value: '',
      // key: items[element.documentID],
    )
  ];
  final _user = GlobalStore.store.getState().user;

  initUserlist() async {
    final _bangtaktok =
        await Firestore.instance.collection('bangTalCafe').getDocuments();
    final items = {};
    _bangtaktok.documents.forEach((element) {
      items.addAll({element.documentID: element.data['cafe_name']});
      setState(() {
        cafeList.add(DropdownMenuItem(
          child: Text(element.data['area'] + ' / ' + element.data['cafe_name']),
          value: element.data['cafe_name'],
        ));
      });
    });
  }

  void _createList(BuildContext context) async {
    if (_user != null) {
      setState(() {
        _userList = null;
      });
      await Navigator.of(context).pushNamed('createListPage');
      initUserlist();
    }
  }

  Future _submit() async {
    //  final _list = await _userList;
    // Navigator.of(context).pop();
    //String _mediaType = 'movie';

    _onAdd();
  }

  Future<void> _onAdd() async {
    if (selectCafeName == '') {
      _showDialog('방탈출카페를 선택하세요^^');
      return;
    } else if (selectThemaName == '') {
      _showDialog('테마를 선택하세요^^');
      return;
    } else {
      Firestore.instance.collection("bangTalCabinet").add({
        'cafe_name': selectCafeName,
        'cafe_thema': selectThemaName,
        'USER_NAME': _user.firebaseUser.displayName,
        'USER_ID': _user.firebaseUser.uid,
        'photoUrl': _user.firebaseUser.photoUrl,
        'clear_time_mm': clearTimeConMm.text,
        'clear_time_ss': clearTimeConSs.text,
        'complete': complete,
        'hint_cnt': hintCon,
        'star_cnt': startCon,
        'MDATE': mDate,
        'CDATE': Timestamp.now(),
        'pass_yn': passYn,
        'conts': ""
      }).then((value) {
        print(value.documentID);
        var doc = Firestore.instance
            .collection("bangTalCafeThema")
            .where('cafe_name', isEqualTo: selectCafeName)
            .where('thema', isEqualTo: selectThemaName)
            .getDocuments();

        doc.then((docId) => {
              Firestore.instance
                  .collection("bangTalCabinet")
                  .document(value.documentID)
                  .updateData({'posterPath': docId.documents[0]['posterPath']}),

              // print(data);
              //_showDialog('등록완료'),
              Navigator.of(context).pop('등록완료되었습니다.'),
              //Navigator.of(context).pop('등록완료'),

              // Future.delayed(Duration(seconds: 2)).then((_) {});
            });
      });
    }
  }

  void _onSelected(UserList userlist) async {
    final l = await _userList;
    l.result.data.forEach((f) {
      if (f.selected == 1) f.selected = 0;
    });
    userlist.selected = 1;
    setState(() {});
  }

  @override
  void initState() {
    initUserlist();

    scrollController = ScrollController();
    super.initState();
  }

  @override
  void dispose() {
    scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final bottom = MediaQuery.of(context).viewInsets.bottom;
    final Size _size = MediaQuery.of(context).size;
    return SimpleDialog(
        shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(Adapt.px(20))),
        title: _Title(onAdd: () => _createList(context)),
        children: <Widget>[
          Container(
            width: _size.width,
            height: 350,
            child: SingleChildScrollView(
                reverse: true,
                child: Padding(
                  padding: EdgeInsets.all(10),
                  child: Column(
                    children: <Widget>[
                      DateTimeField(
                          initialValue: DateTime.now(),
                          decoration: InputDecoration(
                              labelText: "플레이날짜",
                              hintText: "플레이날짜",
                              suffixIcon: IconButton(
                                  onPressed: () {
                                    // descriptionTextController.clear();
                                  },
                                  icon: Icon(Icons.calendar_today,
                                      color: Colors.black))),
                          format: DateFormat("yyyy. MM. dd. HH:mm"),
                          style: TextStyle(fontSize: 15, color: Colors.black),
                          onShowPicker: (context, currentValue) async {
                            final date = await showDatePicker(
                                context: context,
                                firstDate: DateTime(currentValue.year),
                                initialDate: currentValue ?? DateTime.now(),
                                lastDate: DateTime(currentValue.year + 1));

                            if (date != null) {
                              final time = await showTimePicker(
                                context: context,
                                initialTime: TimeOfDay.fromDateTime(
                                    currentValue ?? DateTime.now()),
                              );
                              return DateTimeField.combine(date, time);
                            } else {
                              return currentValue;
                            }
                          },
                          onSaved: (DateTime dateTime) => mDate = dateTime,
                          onChanged: (DateTime dateTime) => {
                                print(dateTime),
                                mDate = dateTime,
                              }),
                      SearchableDropdown.single(
                        items: cafeList,
                        value: selectCafeName,
                        label: "카페:",
                        hint: "선택",
                        searchHint: "선택",
                        onChanged: (value) {
                          themaList = [
                            DropdownMenuItem(child: Text('선택'), value: '')
                          ];
                          setState(() async {
                            selectCafeName = value;

                            selectThemaName = '';
                            final _bangtaktok = await Firestore.instance
                                .collection('bangTalCafeThema')
                                .where("cafe_name", isEqualTo: value)
                                .getDocuments();

                            _bangtaktok.documents.forEach((element) {
                              themaList.add(DropdownMenuItem(
                                child: Text(element.data['thema']),
                                value: element.data['thema'],
                              ));
                            });
                          });
                        },
                        doneButton: "적용",
                        displayItem: (item, selected) {
                          return (Row(children: [
                            selected
                                ? Icon(
                                    Icons.radio_button_checked,
                                    color: Colors.grey,
                                  )
                                : Icon(
                                    Icons.radio_button_unchecked,
                                    color: Colors.grey,
                                  ),
                            SizedBox(width: 7),
                            Expanded(
                              child: item,
                            ),
                          ]));
                        },
                        isExpanded: true,
                        style: TextStyle(fontSize: 14, color: Colors.black),
                      ),
                      SizedBox(
                        height: 0.0,
                      ),
                      DropdownButton(
                          isExpanded: true,
                          style:
                              new TextStyle(fontSize: 15, color: Colors.black),
                          hint: Text('테마선텍'),
                          value: selectThemaName,
                          items: themaList,
                          onChanged: (value) {
                            setState(() {
                              selectThemaName = value;
                            });
                          }),
                      Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text('성공여부:',
                                style: TextStyle(
                                    fontSize: 12, color: Colors.black)),
                            DropdownButton(
                                value: passYn,
                                items: [
                                  DropdownMenuItem(
                                    child: Text("성공",
                                        style: TextStyle(
                                            fontSize: 12, color: Colors.black)),
                                    value: '성공',
                                  ),
                                  DropdownMenuItem(
                                    child: Text("실패",
                                        style: TextStyle(
                                            fontSize: 12, color: Colors.black)),
                                    value: '실패',
                                  ),
                                ],
                                onChanged: (value) {
                                  setState(() {
                                    passYn = value;
                                  });
                                }),
                            Text('힌트수:',
                                style: TextStyle(
                                    fontSize: 12, color: Colors.black)),
                            DropdownButton(
                                value: hintCon,
                                items: [
                                  DropdownMenuItem(
                                    child: Text("No Hint",
                                        style: TextStyle(
                                            fontSize: 12, color: Colors.black)),
                                    value: '0',
                                  ),
                                  DropdownMenuItem(
                                    child: Text("1",
                                        style: TextStyle(
                                            fontSize: 12, color: Colors.black)),
                                    value: '1',
                                  ),
                                  DropdownMenuItem(
                                    child: Text("2",
                                        style: TextStyle(
                                            fontSize: 12, color: Colors.black)),
                                    value: '2',
                                  ),
                                  DropdownMenuItem(
                                    child: Text("3",
                                        style: TextStyle(
                                            fontSize: 12, color: Colors.black)),
                                    value: '3',
                                  ),
                                  DropdownMenuItem(
                                    child: Text("3",
                                        style: TextStyle(
                                            fontSize: 12, color: Colors.black)),
                                    value: '3',
                                  ),
                                  DropdownMenuItem(
                                    child: Text("5이상",
                                        style: TextStyle(
                                            fontSize: 12, color: Colors.black)),
                                    value: '5',
                                  ),
                                ],
                                onChanged: (value) {
                                  setState(() {
                                    hintCon = value;
                                  });
                                }),
                          ]),
                      Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            Text('클리어:',
                                style: TextStyle(
                                    fontSize: 12, color: Colors.black)),
                            SizedBox(
                              width: 50,
                            ),
                            Container(
                              width: 50.0,
                              child: TextField(
                                keyboardType: TextInputType.number,
                                autofocus: false,
                                decoration: InputDecoration(labelText: "mm"),
                                style: TextStyle(
                                    fontSize: 12, color: Colors.black),
                                controller: clearTimeConMm,
                              ),
                            ),
                            Text(':'),
                            Container(
                              width: 50.0,
                              child: TextField(
                                keyboardType: TextInputType.number,
                                autofocus: false,
                                decoration: InputDecoration(labelText: "ss"),
                                style: TextStyle(
                                    fontSize: 12, color: Colors.black),
                                controller: clearTimeConSs,
                              ),
                            ),
                            Text('(분:초)'),
                          ]),
                      Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text('별점:',
                                style: TextStyle(
                                    fontSize: 12, color: Colors.black)),
                            DropdownButton(
                                value: startCon,
                                items: [
                                  DropdownMenuItem(
                                    child: Text("5점",
                                        style: TextStyle(
                                            fontSize: 12, color: Colors.black)),
                                    value: '',
                                  ),
                                  DropdownMenuItem(
                                    child: Text("4점",
                                        style: TextStyle(
                                            fontSize: 12, color: Colors.black)),
                                    value: '4',
                                  ),
                                  DropdownMenuItem(
                                    child: Text("3점",
                                        style: TextStyle(
                                            fontSize: 12, color: Colors.black)),
                                    value: '3',
                                  ),
                                  DropdownMenuItem(
                                    child: Text("2점",
                                        style: TextStyle(
                                            fontSize: 12, color: Colors.black)),
                                    value: '2',
                                  ),
                                  DropdownMenuItem(
                                    child: Text("1점",
                                        style: TextStyle(
                                            fontSize: 12, color: Colors.black)),
                                    value: '1',
                                  ),
                                ],
                                onChanged: (value) {
                                  // state.startCon = value;
                                  setState(() {
                                    startCon = value;
                                  });
                                }),
                            Text('진행여부:',
                                style: TextStyle(
                                    fontSize: 12, color: Colors.black)),
                            DropdownButton(
                                value: complete,
                                items: [
                                  DropdownMenuItem(
                                    child: Text("진행중",
                                        style: TextStyle(
                                            fontSize: 12, color: Colors.black)),
                                    value: 'N',
                                  ),
                                  DropdownMenuItem(
                                    child: Text("완료",
                                        style: TextStyle(
                                            fontSize: 12, color: Colors.black)),
                                    value: 'Y',
                                  ),
                                ],
                                onChanged: (value) {
                                  // state.startCon = value;
                                  setState(() {
                                    complete = value;
                                  });
                                }),
                          ]),
                    ],
                  ),
                )),
          ),
          _ButtonPanel(
            onSubmit: _submit,
            onCancel: () => Navigator.of(context).pop(),
          )
        ]);
  }

  void _showDialog(text) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        // return object of type Dialog
        return AlertDialog(
          title: new Text("확인"),
          content: new Text(text),
          actions: <Widget>[
            new FlatButton(
              child: new Text("Close"),
              onPressed: () {
                Navigator.pop(context);
                //   return "닫기";
              },
            ),
          ],
        );
      },
    );
  }
}

class _Title extends StatelessWidget {
  final Function onAdd;
  const _Title({this.onAdd});
  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text('방탈출 신규등록'),
        GestureDetector(
          onTap: onAdd,
          child: Icon(Icons.add_circle),
        ),
      ],
    );
  }
}

class _ListCell extends StatelessWidget {
  final UserList data;
  final bool selected;
  final Function(UserList) onTap;
  const _ListCell({this.data, this.selected, this.onTap});
  @override
  Widget build(BuildContext context) {
    final _theme = ThemeStyle.getTheme(context);
    return GestureDetector(
        onTap: () => onTap(data),
        child: Container(
          padding: EdgeInsets.all(10),
          decoration: selected
              ? BoxDecoration(
                  border: Border.all(color: _theme.iconTheme.color),
                  borderRadius: BorderRadius.circular(5),
                )
              : null,
          child: Text(
            data.listName ?? '',
            style: TextStyle(fontSize: 18),
          ),
        ));
  }
}

class _ButtonPanel extends StatelessWidget {
  final Function onSubmit;
  final Function onCancel;
  const _ButtonPanel({this.onSubmit, this.onCancel});
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 14, vertical: 5),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          _Button(
            text: '취소',
            onPress: onCancel,
          ),
          SizedBox(width: 24),
          _Button(
            text: '등록',
            onPress: onSubmit,
          ),
        ],
      ),
    );
  }
}

class _Button extends StatelessWidget {
  final String text;
  final Function onPress;
  const _Button({this.onPress, this.text});
  @override
  Widget build(BuildContext context) {
    final _theme = ThemeStyle.getTheme(context);
    final _textStyle = TextStyle(
        fontSize: 16,
        color: _theme.brightness == Brightness.light
            ? const Color(0xFFFFFFFF)
            : const Color(0xFF000000));
    return InkWell(
      onTap: onPress,
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 8, vertical: 10),
        constraints: BoxConstraints(minWidth: 80),
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(5),
            color: _theme.iconTheme.color),
        child: Center(
          child: Text(
            text,
            style: _textStyle,
          ),
        ),
      ),
    );
  }
}
