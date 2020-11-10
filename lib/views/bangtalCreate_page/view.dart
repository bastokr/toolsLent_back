import 'package:fish_redux/fish_redux.dart';
import 'package:flutter/material.dart';
import 'package:escroomtok/actions/adapt.dart';
import 'package:escroomtok/models/base_api_model/user_list.dart';
import 'package:escroomtok/style/themestyle.dart';
import 'package:escroomtok/widgets/loading_layout.dart';
import 'package:intl/intl.dart';
import 'action.dart';
import 'state.dart';
import 'package:searchable_dropdown/searchable_dropdown.dart';
import 'package:datetime_picker_formfield/datetime_picker_formfield.dart';

Widget buildView(
    BangtalCreateState state, Dispatch dispatch, ViewService viewService) {
  return Builder(
    builder: (context) {
      final bottom = MediaQuery.of(context).viewInsets.bottom;

      final ThemeData _theme = ThemeStyle.getTheme(context);
      return Stack(
        children: [
          Scaffold(
              key: state.scaffoldkey,
              appBar: AppBar(
                brightness: _theme.brightness,
                backgroundColor: _theme.bottomAppBarColor,
                elevation: 0.0,
                //  iconTheme: _theme.iconTheme,
                title: Text('방탈출 게시판 등록',
                    style: TextStyle(color: _theme.primaryColorLight)),
                actions: <Widget>[
                  Padding(
                      padding: const EdgeInsets.all(12.0),
                      child: FlatButton(
                          color: _theme.indicatorColor,
                          textColor: Colors.white,
                          disabledColor: Colors.grey,
                          disabledTextColor: Colors.black,
                          padding: EdgeInsets.all(4.0),
                          splashColor: Colors.blueAccent,
                          onPressed: () => dispatch(
                              BangtalCreatePageActionCreator.onSubmit()),
                          child: Text('등록',
                              style: TextStyle(
                                color: _theme.primaryColorLight,
                              ))))
                ],
              ),
              body: SingleChildScrollView(
                  reverse: true,
                  child: Padding(
                    padding: EdgeInsets.only(bottom: bottom),
                    child: _Body(
                      backGroundUrl: state.backGroundUrl,
                      descriptionTextController:
                          state.descriptionTextController,
                      listData: state.listData,
                      nameTextController: state.nameTextController,
                      dispatch: dispatch,
                      nameFoucsNode: state.nameFoucsNode,
                      descriptionFoucsNode: state.descriptionFoucsNode,
                      onUploadImage: () => dispatch(
                          BangtalCreatePageActionCreator.uploadBackground()),
                      cafeList: state.cafeList,
                      themaList: state.themaList,
                      state: state,
                    ),
                  ))),
          LoadingLayout(
            title: 'loading...',
            show: state.loading,
          )
        ],
      );
    },
  );
}

class _Body extends StatelessWidget {
  final TextEditingController nameTextController;
  final String backGroundUrl;
  final TextEditingController descriptionTextController;
  final FocusNode nameFoucsNode;
  final FocusNode descriptionFoucsNode;
  final UserList listData;
  final Dispatch dispatch;
  final Function onUploadImage;
  BangtalCreateState state;
  String selectedValue;
  String selectCafeName;
  String preselectedValue = "dolor sit";
  final List<DropdownMenuItem> cafeList;
  final List<DropdownMenuItem> themaList;
  _Body({
    this.backGroundUrl,
    this.descriptionTextController,
    this.dispatch,
    this.listData,
    this.nameTextController,
    this.descriptionFoucsNode,
    this.nameFoucsNode,
    this.onUploadImage,
    this.cafeList,
    this.themaList,
    this.state,
  });
  @override
  Widget build(BuildContext context) {
    final dateFormat = DateFormat("EEEE, MMMM d, yyyy 'at' h:mma");
    final timeFormat = DateFormat("h:mm a");
    DateTime date;
    TimeOfDay time;
    DateTime value;
    TextEditingController _startTimeController = TextEditingController();
    bool showThema = false;
    String _date = "Not set";
    String _time = "Not set";
    String joincountTotal = '4';
    DateTime currentValue = DateTime.now();
    return Container(
      width: MediaQuery.of(context).size.width,
      padding: EdgeInsets.all(Adapt.px(40)),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          //FeaturesSinglePopup(),
          Container(
            width: MediaQuery.of(context).size.width,
            //height: 100,
            child: Row(children: [
              Icon(Icons.access_alarm),
              Text('예상 날짜 시간 :', style: TextStyle(fontSize: 12))
            ]),
          ),
          //Text('Basic date & time field (${format.pattern})'),

          DateTimeField(
              initialValue: DateTime.now(),
              format: DateFormat("yyyy. MM. dd. HH:mm"),
              style: TextStyle(fontSize: 18, color: Colors.black),
              onShowPicker: (context, currentValue) async {
                final date = await showDatePicker(
                    context: context,
                    firstDate: DateTime(currentValue.year),
                    initialDate: currentValue ?? DateTime.now(),
                    lastDate: DateTime(currentValue.year + 1));

                if (date != null) {
                  final time = await showTimePicker(
                    context: context,
                    initialTime:
                        TimeOfDay.fromDateTime(currentValue ?? DateTime.now()),
                  );
                  return DateTimeField.combine(date, time);
                } else {
                  return currentValue;
                }
              },
              onSaved: (DateTime dateTime) => state.mDate = dateTime,
              onChanged: (DateTime dateTime) => {
                    print(dateTime),
                    state.mDate = dateTime,
                  }),

          SizedBox(
            height: 20.0,
          ),

          SearchableDropdown.single(
            items: cafeList,
            value: selectCafeName,
            label: "카페:",
            hint: "선택",
            searchHint: "선택",
            onChanged: (value) => {
              selectCafeName = value,
              state.selectCafeName = value,
              state.selectThemaName = '',
              dispatch(BangtalCreatePageActionCreator.themaList()),
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
            style: TextStyle(fontSize: 18, color: Colors.black),
          ),
          SizedBox(
            height: 20.0,
          ),
          DropdownButton(
              isExpanded: true,
              hint: Text('테마'),
              value: state.selectThemaName,
              items: state.themaList,
              onChanged: (value) => {
                    dispatch(BangtalCreatePageActionCreator.seThemma(value)),
                  }),
          /*
          SearchableDropdown.single(
              isCaseSensitiveSearch: true,
              items: state.themaList,
              value: state.selectThemaName,
              label: "테마:",
              hint: "선택",
              searchHint: "선택",
              onChanged: (value) {
                print(value.toString().length);
                print(value);

                //selectedValue = value;
                state.selectThemaName = value;
              },
              isExpanded: true,
              style: TextStyle(fontSize: 18, color: Colors.black)),
*/
          Row(
            children: <Widget>[
              Text('  최대 참여 인원    :         '),
              DropdownButton(
                  value: state.joincountTotal,
                  items: [
                    DropdownMenuItem(
                      child: Text("5명",
                          style: TextStyle(fontSize: 15, color: Colors.black)),
                      value: '',
                    ),
                    DropdownMenuItem(
                      child: Text("4명",
                          style: TextStyle(fontSize: 15, color: Colors.black)),
                      value: '4',
                    ),
                    DropdownMenuItem(
                      child: Text("3명",
                          style: TextStyle(fontSize: 15, color: Colors.black)),
                      value: '3',
                    ),
                    DropdownMenuItem(
                      child: Text("2명",
                          style: TextStyle(fontSize: 15, color: Colors.black)),
                      value: '2',
                    ),
                  ],
                  onChanged: (value) {
                    //  joincountTotal = value;
                    dispatch(BangtalCreatePageActionCreator.setJoincountTotal(
                        value));
                  }),
            ],
          ),

          Container(
              child: TextFormField(
            controller: state.contsCon,
            maxLines: 5,
            autofocus: false,
            decoration: InputDecoration(
              border: OutlineInputBorder(),
              contentPadding: const EdgeInsets.all(16.0),
              labelText: '간단한 소개글을 작성해 주세요.',
              hintText: '간단한 소개글을 작성해 주세요.',
            ),
            validator: (value) {
              if (value.isEmpty) {
                return 'Please enter at least one grocery item';
              }
            },
            onSaved: (value) {
              state.desc = value;
            },
          )),
        ],
      ),
    );
  }
}

class _CustomTextField extends StatelessWidget {
  final String title;
  final double width;
  final int maxLines;
  final FocusNode focusNode;
  final TextEditingController controller;
  const _CustomTextField(
      {this.title,
      this.width,
      this.maxLines = 1,
      this.controller,
      this.focusNode});
  @override
  Widget build(BuildContext context) {
    final double _fontSize = 20;
    final Size _size = MediaQuery.of(context).size;
    final _intputBorder = OutlineInputBorder(
        borderRadius: BorderRadius.circular(8),
        borderSide: BorderSide(color: const Color(0xFF9E9E9E)));
    return Container(
      width: width ?? _size.width,
      padding: EdgeInsets.only(bottom: 30),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(title, style: TextStyle(fontSize: _fontSize)),
          SizedBox(height: 10),
          TextField(
            controller: controller,
            maxLines: maxLines,
            focusNode: focusNode,
            cursorColor: const Color(0xFF9E9E9E),
            decoration: InputDecoration(
              contentPadding: EdgeInsets.symmetric(horizontal: 10, vertical: 8),
              enabledBorder: _intputBorder,
              disabledBorder: _intputBorder,
              focusedBorder: _intputBorder,
            ),
          ),
        ],
      ),
    );
  }
}

class _BackGroundUpLoad extends StatelessWidget {
  final String url;
  final Function onTap;
  const _BackGroundUpLoad({this.onTap, this.url});
  @override
  Widget build(BuildContext context) {
    final _theme = ThemeStyle.getTheme(context);
    final _size = MediaQuery.of(context).size;
    return Padding(
      padding: EdgeInsets.only(bottom: 30),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('Background', style: TextStyle(fontSize: 20)),
          SizedBox(height: 10),
          GestureDetector(
            onTap: onTap,
            child: Container(
              height: 50,
              padding: EdgeInsets.symmetric(horizontal: 10),
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(color: const Color(0xFF9E9E9E))),
              child: Row(
                children: [
                  SizedBox(
                    width: _size.width - 120,
                    child: Text(
                      url ?? '',
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                  Spacer(),
                  Container(
                    width: 30,
                    height: 30,
                    decoration: BoxDecoration(
                      color: _theme.iconTheme.color,
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Icon(
                      Icons.file_upload,
                      color: _theme.accentIconTheme.color,
                      size: 20,
                    ),
                  ),
                ],
              ),
            ),
          )
        ],
      ),
    );
  }
}
/*
_openPopup(context) {
  Alert(
      context: context,
      title: "LOGIN",
      content: Column(
        children: <Widget>[
          TextField(
            decoration: InputDecoration(
              icon: Icon(Icons.account_circle),
              labelText: 'Username',
            ),
          ),
          TextField(
            obscureText: true,
            decoration: InputDecoration(
              icon: Icon(Icons.lock),
              labelText: 'Password',
            ),
          ),
        ],
      ),
      buttons: [
        DialogButton(
          onPressed: () => Navigator.pop(context),
          child: Text(
            "LOGIN",
            style: TextStyle(color: Colors.white, fontSize: 20),
          ),
        )
      ]).show();
}
*/

_openPopup2(context) {
  final _formKey = GlobalKey<FormState>();
  Center(
    child: RaisedButton(
      onPressed: () {
        showDialog(
            context: context,
            builder: (BuildContext context) {
              return AlertDialog(
                content: Stack(
                  overflow: Overflow.visible,
                  children: <Widget>[
                    Positioned(
                      right: -40.0,
                      top: -40.0,
                      child: InkResponse(
                        onTap: () {
                          Navigator.of(context).pop();
                        },
                        child: CircleAvatar(
                          child: Icon(Icons.close),
                          backgroundColor: Colors.red,
                        ),
                      ),
                    ),
                    Form(
                      key: _formKey,
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: <Widget>[
                          Padding(
                            padding: EdgeInsets.all(8.0),
                            child: TextFormField(),
                          ),
                          Padding(
                            padding: EdgeInsets.all(8.0),
                            child: TextFormField(),
                          ),
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: RaisedButton(
                              child: Text("Submitß"),
                              onPressed: () {
                                if (_formKey.currentState.validate()) {
                                  _formKey.currentState.save();
                                }
                              },
                            ),
                          )
                        ],
                      ),
                    ),
                  ],
                ),
              );
            });
      },
      child: Text("Open Popup"),
    ),
  );
}

class BasicDateTimeField extends StatelessWidget {
  final format = DateFormat("yyyy-MM-dd HH:mm");
  @override
  Widget build(BuildContext context) {
    return Column(children: <Widget>[
      Text('Basic date & time field (${format.pattern})'),
      DateTimeField(
        format: format,
        onShowPicker: (context, currentValue) async {
          final date = await showDatePicker(
              context: context,
              firstDate: DateTime(1900),
              initialDate: currentValue ?? DateTime.now(),
              lastDate: DateTime(2100));
          if (date != null) {
            final time = await showTimePicker(
              context: context,
              initialTime:
                  TimeOfDay.fromDateTime(currentValue ?? DateTime.now()),
            );
            return DateTimeField.combine(date, time);
          } else {
            return currentValue;
          }
        },
      ),
    ]);
  }
}
