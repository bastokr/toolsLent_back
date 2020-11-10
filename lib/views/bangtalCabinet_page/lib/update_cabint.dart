import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:escroomtok/actions/adapt.dart';
import 'package:escroomtok/globalbasestate/store.dart';
import 'package:escroomtok/models/base_api_model/user_list.dart';
import 'package:escroomtok/models/mylist_model.dart';
import 'package:escroomtok/models/response_model.dart';
import 'package:escroomtok/style/themestyle.dart';

class UpdateCabintDialog extends StatefulWidget {
  final String docId;
  final String selectCafeName;
  final String selectThemaName;
  final String hintCon;
  final String clearTimeConMm;
  final String clearTimeConSs;
  final String passYn;
  final String startCon;
  final String contsCon;

  UpdateCabintDialog(
      {@required this.docId,
      this.selectCafeName,
      this.selectThemaName,
      this.hintCon,
      this.clearTimeConMm,
      this.clearTimeConSs,
      this.passYn,
      this.startCon,
      this.contsCon});
  @override
  UpdateCabintDialogState createState() => UpdateCabintDialogState();
}

class UpdateCabintDialogState extends State<UpdateCabintDialog> {
  final scaffoldKey = GlobalKey<ScaffoldState>();
  Future<MyListModel> lists;
  ScrollController scrollController;
  Future<ResponseModel<UserListModel>> _userList;
  var mDate = DateTime.now();
  TextEditingController contsCon = TextEditingController();
  TextEditingController clearTimeConMm = TextEditingController();
  TextEditingController clearTimeConSs = TextEditingController();
  String startCon = '';
  String hintCon = '0';
  String complete = 'N';
  String selectCafeName = '';
  String selectThemaName = '';
  String passYn = '성공';
  String conts = '';

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

  Future<void> _submit() async {
    if (selectCafeName == '') {
      _showDialog('방탈출카페를 선택하세요^^');
      return;
    } else if (selectThemaName == '') {
      _showDialog('테마를 선택하세요^^');
      return;
    } else {
      Firestore.instance
          .collection("bangTalCabinet")
          .document(widget.docId)
          .updateData({
        'clear_time_mm': clearTimeConMm.text,
        'clear_time_ss': clearTimeConSs.text,
        'complete': 'Y',
        'hint_cnt': hintCon,
        'star_cnt': startCon,
        'pass_yn': passYn,
        'MDATE': mDate,
        'CDATE': Timestamp.now(),
        'conts': contsCon.text
      }).then((value) {
        Navigator.of(context).pop('등록완료되었습니다.');
      });
    }
  }

  @override
  void initState() {
    contsCon.text = widget.contsCon;
    conts = widget.contsCon;
    clearTimeConMm.text = widget.clearTimeConMm;
    clearTimeConSs.text = widget.clearTimeConSs;
    startCon = widget.startCon;
    hintCon = widget.hintCon;
    selectCafeName = widget.selectCafeName;
    selectThemaName = widget.selectThemaName;
    passYn = widget.passYn;
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
            //height: 250,
            child: SingleChildScrollView(
                reverse: true,
                child: Padding(
                  padding: EdgeInsets.all(10),
                  child: Column(
                    children: <Widget>[
                      Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            Container(
                              //width: 50.0,
                              child: TextFormField(
                                controller: contsCon,
                                maxLines: 5,
                                autofocus: false,
                                decoration: InputDecoration(
                                  border: OutlineInputBorder(),
                                  contentPadding: const EdgeInsets.all(16.0),
                                  labelText: '후기 작성해 주세요.',
                                  hintText: '후기 작성해 주세요.',
                                ),
                                validator: (value) {
                                  if (value.isEmpty) {
                                    return 'Please enter at least one grocery item';
                                  }
                                },
                                onSaved: (value) {
                                  conts = value;
                                  contsCon.text = value;
                                },
                              ),
                            ),
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
                                    child: Text("4",
                                        style: TextStyle(
                                            fontSize: 12, color: Colors.black)),
                                    value: '4',
                                  ),
                                  DropdownMenuItem(
                                    child: Text("5",
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
                                    value: '5',
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
                                  DropdownMenuItem(
                                    child: Text("0점",
                                        style: TextStyle(
                                            fontSize: 12, color: Colors.black)),
                                    value: '0',
                                  ),
                                  DropdownMenuItem(
                                    child: Text("선택",
                                        style: TextStyle(
                                            fontSize: 12, color: Colors.black)),
                                    value: '',
                                  ),
                                ],
                                onChanged: (value) {
                                  // state.startCon = value;
                                  setState(() {
                                    startCon = value;
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
