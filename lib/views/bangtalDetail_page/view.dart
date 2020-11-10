import 'package:escroomtok/actions/imageurl.dart';
import 'package:escroomtok/models/enums/imagesize.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fish_redux/fish_redux.dart';
import 'package:flutter/material.dart';
import 'package:escroomtok/actions/adapt.dart';
import 'package:escroomtok/models/base_api_model/user_list.dart';
import 'package:escroomtok/style/themestyle.dart';
import 'package:escroomtok/widgets/loading_layout.dart';
import 'package:intl/intl.dart';
import 'package:parallax_image/parallax_image.dart';
import 'action.dart';
import 'state.dart';
import 'package:datetime_picker_formfield/datetime_picker_formfield.dart';

Widget buildView(
    BangtalDetailState state, Dispatch dispatch, ViewService viewService) {
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
                title: Text('방탈출 참여',
                    style: TextStyle(color: _theme.primaryColorLight)),
                actions: <Widget>[
                  /*
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
                              BangtalDetailPageActionCreator.onSubmit()),
                          child: Text('등록',
                              style: TextStyle(
                                color: _theme.primaryColorLight,
                              ))))
                */
                ],
              ),
              body: SingleChildScrollView(
                  reverse: true,
                  child: Padding(
                    padding: EdgeInsets.only(bottom: bottom),
                    child: _JoinList(
                      //  방탈출 참여리스트
                      backGroundUrl: state.backGroundUrl,
                      descriptionTextController:
                          state.descriptionTextController,
                      listData: state.listData,
                      nameTextController: state.nameTextController,
                      dispatch: dispatch,
                      nameFoucsNode: state.nameFoucsNode,
                      descriptionFoucsNode: state.descriptionFoucsNode,
                      onUploadImage: () => dispatch(
                          BangtalDetailPageActionCreator.uploadBackground()),
                      cafeList: state.cafeList,
                      themaList: state.themaList,
                      state: state,
                    ),
                  ))),
          /* LoadingLayout(
            title: 'loading...',
            show: state.loading,
          )
          */
        ],
      );
    },
  );
}

class _JoinList extends StatelessWidget {
  // 방탈출 참여 리스트
  final TextEditingController nameTextController;
  final String backGroundUrl;
  final TextEditingController descriptionTextController;
  final FocusNode nameFoucsNode;
  final FocusNode descriptionFoucsNode;
  final UserList listData;
  final Dispatch dispatch;
  final Function onUploadImage;
  final Function deleteF;
  BangtalDetailState state;
  String selectedValue;
  String selectCafeName;
  String preselectedValue = "dolor sit";
  /*
  var defaultfontcolor = Colors.white;
  var defaultfontcolor50 = Colors.blueGrey[50];
  var defaultbackcolor = Colors.black;
*/
  var defaultfontcolor = Colors.black45;
  var defaultfontcolor50 = Colors.black;
  var defaultbackcolor = Colors.white;

  final List<DropdownMenuItem> cafeList;
  final List<DropdownMenuItem> themaList;
  _JoinList({
    this.backGroundUrl,
    this.descriptionTextController,
    this.dispatch,
    this.listData,
    this.nameTextController,
    this.descriptionFoucsNode,
    this.nameFoucsNode,
    this.onUploadImage,
    this.deleteF,
    this.cafeList,
    this.themaList,
    this.state,
  });
  @override
  Widget build(BuildContext context) {
    Timestamp timestamp = state.bangtalboardDetail['MDATE'];
    timestamp..toDate();
    return Container(
      width: MediaQuery.of(context).size.width,
      padding: EdgeInsets.all(Adapt.px(5)),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Card(
            child: Container(
                padding: const EdgeInsets.all(5),
                child: Container(
                  color: defaultbackcolor,
                  padding: const EdgeInsets.all(0),
                  child: Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: <Widget>[
                        SizedBox(
                          width: 100, // hard coding child width
                          child: Column(
                            children: <Widget>[
                              Container(
                                alignment: Alignment.centerLeft,
                                //color: ,
                                child: Column(
                                  children: [
                                    _ImageCell(
                                        url: state
                                            .bangtalboardDetail['photoUrl']),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                        SizedBox(
                          width: 10,
                        ),
                        SizedBox(
                          width: MediaQuery.of(context).size.width - 150,
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: <Widget>[
                              Container(
                                alignment: Alignment.centerLeft,
                                child: Row(
                                  children: [
                                    Text(state.bangtalboardDetail['cafe_name'],
                                        style: TextStyle(
                                            //  color: defaultfontcolor,
                                            fontSize: 12)),
                                  ],
                                ),
                              ),
                              /*
                              Container(
                                alignment: Alignment.centerLeft,
                                child: Row(
                                  children: [
                                    Text(
                                      state.bangtalboardDetail['cafe_thema'],
                                      style: TextStyle(
                                        color: defaultfontcolor50,
                                        fontSize: 15,
                                        //fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              */
                              SizedBox(
                                width: Adapt.screenW() - Adapt.px(300),
                                child: Text(
                                  state.bangtalboardDetail['cafe_thema'] ?? "-",
                                  style: TextStyle(
                                      fontSize: Adapt.px(28),
                                      fontWeight: FontWeight.w700),
                                ),
                              ),
                              Container(
                                alignment: Alignment.centerLeft,
                                child: Row(
                                  children: [
                                    Text(state.bangtalboardDetail['CONTS'],
                                        style: TextStyle(
                                            color: const Color(0xFF9E9E9E),
                                            fontSize: Adapt.px(22))),
                                  ],
                                ),
                              ),
                              SizedBox(
                                height: 10,
                              ),
                              Container(
                                alignment: Alignment.centerLeft,
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.end,
                                  children: [
                                    Icon(Icons.access_alarms,
                                        color: defaultfontcolor),
                                    SizedBox(
                                      height: 5,
                                    ),
                                    Text(
                                      timestamp
                                          .toDate()
                                          .toString()
                                          .substring(0, 16),
                                      style: TextStyle(color: defaultfontcolor),
                                    ),
                                  ],
                                ),
                              ),
                              InkWell(
                                onTap: () => {
                                  Navigator.of(context).pushNamed('profileView',
                                      arguments: {
                                        'userId':
                                            state.bangtalboardDetail['USER_ID']
                                      }),
                                },
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.end,
                                  children: [
                                    Text(
                                      state.bangtalboardDetail['USER_NAME'],
                                      style: TextStyle(
                                          color: defaultfontcolor,
                                          fontSize: Adapt.px(26)),
                                    ),
                                    SizedBox(
                                      height: 10,
                                    ),
                                    CircleAvatar(
                                      backgroundImage: NetworkImage(state
                                          .bangtalboardDetail["USER_photoUrl"]),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                      ]),
                )),
          ),
          /*
          SizedBox(
            height: 5,
          ),
          */
          Container(
              padding: const EdgeInsets.all(5.0),
              child: TextFormField(
                //  readOnly: true,
                controller: state.contsCon,
                focusNode: state.descriptionFoucsNode,
                maxLines: 3,
                autofocus: false,
                decoration: InputDecoration(
                  border: OutlineInputBorder(),
                  contentPadding: const EdgeInsets.all(10.0),
                  labelText: '참여 작성후 참여버튼을 눌러주세요 \n이미 참여중인 경우  수정됩니다. ',
                  //  hintText: '간단한 참여 작성해 주세요.',
                ),
                onSaved: (value) {
                  state.joinDesc = value;
                },
              )),
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: <Widget>[
              state.bangtalboardDetail['USER_ID'] == state.user.firebaseUser.uid
                  ? SizedBox.fromSize(
                      size: Size(56, 56), // button width and height
                      child: ClipOval(
                        child: Material(
                          //  color: Colors.orange, // button color
                          child: InkWell(
                            splashColor: Colors.green, // splash color
                            onTap: () => {
                              _asyncDeleteConfirmDialog(
                                      context,
                                      "구인게시판",
                                      state.bangtalboardDetail['cafe_thema'],
                                      dispatch,
                                      state)
                                  .then((value) => {
                                        print('삭제 완료')
                                        //Navigator.pop(context)
                                      })
                            }, // button pressed
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: <Widget>[
                                Icon(Icons.delete), // icon
                                Text("삭제"), // text
                              ],
                            ),
                          ),
                        ),
                      ),
                    )
                  : SizedBox(
                      width: 0,
                    ),
              SizedBox(
                width: 10,
              ),
              SizedBox.fromSize(
                size: Size(56, 56), // button width and height
                child: ClipOval(
                  child: Material(
                    //  color: Colors.orange, // button color
                    child: InkWell(
                      splashColor: Colors.green, // splash color
                      onTap: () => dispatch(
                          BangtalDetailPageActionCreator.goChat(d: {
                        'bangtalboardDetail': state.bangtalboardDetail
                      })), // button pressed
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: <Widget>[
                          Icon(Icons.chat), // icon
                          Text("chat"), // text
                        ],
                      ),
                    ),
                  ),
                ),
              ),

              SizedBox(
                width: 0,
              ),

              SizedBox.fromSize(
                size: Size(56, 56), // button width and height
                child: ClipOval(
                  child: Material(
                    //  color: Colors.orange[100], // button color
                    child: InkWell(
                      splashColor: Colors.blue, // splash color
                      onTap: () => dispatch(BangtalDetailPageActionCreator
                          .onJoin()), // button pressed
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: <Widget>[
                          Icon(Icons.control_point), // icon
                          Text("참여"), // text
                        ],
                      ),
                    ),
                  ),
                ),
              ),
              // give it width
            ],
          ),
          Text('참여자 신청 리스트 ' + state.joinCount),
          Container(
            height: MediaQuery.of(context).size.height - 510,
            child: StreamBuilder<QuerySnapshot>(
              stream: Firestore.instance
                  .collection("bangTalBoardJoin")
                  .where('boardId',
                      isEqualTo: state.bangtalboardDetail.documentID)
                  .snapshots(),
              builder: (BuildContext context,
                  AsyncSnapshot<QuerySnapshot> snapshot) {
                if (snapshot.data == null) return CircularProgressIndicator();
                if (snapshot.hasError) return Text("Error: ${snapshot.error}");
                switch (snapshot.connectionState) {
                  case ConnectionState.waiting:
                  //  return Text("Loading...");
                  default:
                    return ListView(
                      children: snapshot.data.documents
                          .map((DocumentSnapshot document) {
                        Timestamp ts = document["CDATE"];
                        String dt = timestampToStrDateTime(ts);
                        return Card(
                          elevation: 0,
                          child: Column(
                            children: <Widget>[
                              ListTile(
                                leading: CircleAvatar(
                                  backgroundImage:
                                      NetworkImage(document["photoUrl"]),
                                ),
                                title: Text(document["USER_NAME"]),
                                subtitle: Text(document["joinDesc"]),
                                trailing: document["USER_ID"] ==
                                        state.user.firebaseUser.uid
                                    ? InkWell(
                                        splashColor:
                                            Colors.green, // splash color
                                        onTap: () => {
                                          _asyncCancelJoinConfirmDialog(
                                                  context,
                                                  "참여취소",
                                                  state.bangtalboardDetail[
                                                      'cafe_thema'],
                                                  dispatch,
                                                  state)
                                              .then((value) => {
                                                    print('삭제 완료')
                                                    //Navigator.pop(context)
                                                  })
                                        }, // button pressed
                                        child: Column(
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
                                          children: <Widget>[
                                            Icon(Icons.delete), // icon
                                            Text("취소"), // text
                                          ],
                                        ),
                                      )
                                    : Text('-'),
                              )
                            ],
                          ),
                        );
                      }).toList(),
                    );
                }
              },
            ),
          ),
        ],
      ),
    );
  }
}

String timestampToStrDateTime(Timestamp ts) {
  return DateTime.fromMicrosecondsSinceEpoch(ts.microsecondsSinceEpoch)
      .toString();
}

class _ImageCell extends StatelessWidget {
  final String url;
  const _ImageCell({this.url});
  @override
  Widget build(BuildContext context) {
    final ThemeData _theme = ThemeStyle.getTheme(context);
    return Container(
      // color: Colors.red,
      width: Adapt.px(130),
      //height: Adapt.px(200),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(Adapt.px(30)),
        child: Container(
          color: _theme.primaryColorDark,
          child: ParallaxImage(
            extent: Adapt.px(200),
            image: (url == null || url == '')
                ? AssetImage("assets/icon/launcher_icon.png")
                : CachedNetworkImageProvider(
                    ImageUrlDefault.getUrl(url, ImageSize.w200),
                  ),
          ),
        ),
      ),
    );
  }
}

Future<void> _asyncDeleteConfirmDialog(
    BuildContext context, cafe_thema, docuId, dispatch, state) async {
  return showDialog<void>(
    context: context,
    builder: (context) {
      return AlertDialog(
        title: Container(
          child: Row(
            children: [
              Icon(Icons.delete, color: Colors.red),
              Text(
                cafe_thema.toString().length < 15
                    ? cafe_thema
                    : cafe_thema.toString().substring(0, 15) + '..',
                style: TextStyle(fontSize: 15),
                maxLines: 1,
                softWrap: false,
                overflow: TextOverflow.ellipsis,
              )
            ],
          ),
        ),
        //title: Text(cafe_thema),
        content: Text('삭제하시겠습니까?'),
        actions: <Widget>[
          FlatButton(
            child: Text('취소'),
            onPressed: () {
              Navigator.pop(context);
              print('취소되었습');
            },
          ),
          FlatButton(
            child: Text(
              '삭제',
              style: TextStyle(color: Colors.red),
            ),
            onPressed: () => {
              dispatch(BangtalDetailPageActionCreator.onDelete(
                  d: {'bangtalboardDetail': state.bangtalboardDetail}))
            },

            // Navigator.of(context).pop('삭제되었습니다.');
          )
        ],
      );
    },
  );
}

/*참여 취소*/

Future<void> _asyncCancelJoinConfirmDialog(
    BuildContext context, cafe_thema, docuId, dispatch, state) async {
  return showDialog<void>(
    context: context,
    builder: (context) {
      return AlertDialog(
        title: Container(
          child: Row(
            children: [
              Icon(Icons.delete, color: Colors.red),
              Text(
                cafe_thema.toString().length < 15
                    ? cafe_thema
                    : cafe_thema.toString().substring(0, 15) + '..',
                style: TextStyle(fontSize: 15),
                maxLines: 1,
                softWrap: false,
                overflow: TextOverflow.ellipsis,
              )
            ],
          ),
        ),
        //title: Text(cafe_thema),
        content: Text('참여취소 하시겠습니까?'),
        actions: <Widget>[
          FlatButton(
            child: Text('닫기'),
            onPressed: () {
              Navigator.pop(context);
              print('취소되었습');
            },
          ),
          FlatButton(
            child: Text(
              '참여취소',
              style: TextStyle(color: Colors.red),
            ),
            onPressed: () =>
                {dispatch(BangtalDetailPageActionCreator.onJoinDelete())},

            // Navigator.of(context).pop('삭제되었습니다.');
          )
        ],
      );
    },
  );
}
