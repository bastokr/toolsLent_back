import 'package:escroomtok/actions/imageurl.dart';
import 'package:escroomtok/models/enums/imagesize.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fish_redux/fish_redux.dart';
import 'package:flutter/material.dart';
import 'package:escroomtok/actions/adapt.dart';
import 'package:escroomtok/models/base_api_model/user_list.dart';
import 'package:escroomtok/style/themestyle.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:parallax_image/parallax_image.dart';
import 'action.dart';
//import 'lib/datetime_picker_formfield.dart';
import 'lib/update_cabint.dart';
import 'state.dart';
import 'lib/add_cabint.dart';

Widget buildView(
    BangtalCabinetState state, Dispatch dispatch, ViewService viewService) {
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
                title: Text('방탈출 캐비넷',
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
                          BangtalCabinetPageActionCreator.uploadBackground()),
                      cafeList: state.cafeList,
                      themaList: state.themaList,
                      state: state,
                    ),
                    // Text('test'),
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
  BangtalCabinetState state;
  String selectedValue;
  String selectCafeName;
  String selectThemaName;
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
    this.cafeList,
    this.themaList,
    this.selectThemaName,
    this.state,
  });
  @override
  Widget build(BuildContext context) {
    // Timestamp timestamp = state.bangtalboardDetail['MDATE'];
    //  timestamp..toDate();

    return Container(
      width: MediaQuery.of(context).size.width,
      padding: EdgeInsets.all(Adapt.px(1)),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Container(
            padding: const EdgeInsets.all(0),
            color: Colors.black87,
            alignment: Alignment.center,
            child: Text(
              "진행중인 테마",
              style: TextStyle(color: Colors.white),
            ),
          ),
          SizedBox(
            height: 1,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: <Widget>[
              SizedBox(
                width: 0,
              ),

              SizedBox.fromSize(
                //size: Size(70, 56), // button width and height
                child: ClipOval(
                  child: Material(
                    //  color: Colors.orange[100], // button color
                    child: InkWell(
                      splashColor: Colors.blue, // splash color
                      onTap: () {
                        showDialog(
                            context: context,
                            builder: (ctx) {
                              return AddCabintDialog();
                            }).then((value) => print('등록되었습니다.'));
                      }, // button pressed
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: <Widget>[
                          Icon(Icons.control_point), // icon
                          //Text("신규"), // text
                          Text('신규',
                              style: TextStyle(
                                  color: const Color(0xFF9E9E9E),
                                  fontSize: Adapt.px(22))),
                          SizedBox(
                            width: 20,
                            height: 30,
                          )
                        ],
                      ),
                    ),
                  ),
                ),
              ),
              // give it width
            ],
          ),
          Container(
            height: 120,
            child: StreamBuilder<QuerySnapshot>(
              stream: Firestore.instance
                  .collection("bangTalCabinet")
                  .where('USER_ID', isEqualTo: state.user.firebaseUser.uid)
                  .where('complete', isEqualTo: 'N')
                  .snapshots(),
              builder: (BuildContext context,
                  AsyncSnapshot<QuerySnapshot> snapshot) {
                if (snapshot.data == null) {
                  return Container(
                    color: defaultbackcolor,
                    padding: const EdgeInsets.all(0),
                    child: Center(child: CircularProgressIndicator()),
                  );
                }
                if (snapshot.data.documents.length == 0)
                  return Container(
                    color: defaultbackcolor,
                    padding: const EdgeInsets.all(0),
                    child: Center(child: Text("진행중인 테마가 없습니다.")),
                  );
                if (snapshot.hasError) return Text("Error: ${snapshot.error}");
                switch (snapshot.connectionState) {
                  case ConnectionState.waiting:
                  // return Text("Loading...");
                  default:
                    return ListView(
                      children: snapshot.data.documents
                          .map((DocumentSnapshot document) {
                        //   Timestamp ts = document["CDATE"];
                        //   String dt = timestampToStrDateTime(ts);
                        Timestamp timestamp = document['MDATE'];
                        timestamp.toDate().toString();
                        return Card(
                          child: Container(
                              padding: const EdgeInsets.all(5),
                              child: Container(
                                color: defaultbackcolor,
                                padding: const EdgeInsets.all(0),
                                child: Row(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    children: <Widget>[
                                      SizedBox(
                                        width: 70, // hard coding child width
                                        child: Column(
                                          children: <Widget>[
                                            Container(
                                              alignment: Alignment.centerLeft,
                                              //color: ,
                                              child: Column(
                                                children: [
                                                  _ImageCell(
                                                      url: document[
                                                              "posterPath"] ??
                                                          '/xDZ0tHXxesM34GGLJxr3CCnwPHU.jpg'),
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
                                        width:
                                            MediaQuery.of(context).size.width -
                                                110,
                                        child: Column(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceBetween,
                                          children: <Widget>[
                                            Container(
                                              alignment: Alignment.centerLeft,
                                              child: Row(
                                                children: [
                                                  Text(document["cafe_name"],
                                                      style: TextStyle(
                                                          color: const Color(
                                                              0xFF9E9E9E),
                                                          fontSize:
                                                              Adapt.px(22))),
                                                ],
                                              ),
                                            ),
                                            Container(
                                              alignment: Alignment.centerLeft,
                                              child: Row(
                                                children: [
                                                  Text(document["cafe_thema"],
                                                      style: TextStyle(
                                                          //   color: const Color(
                                                          //     0xFF9E9E9E),
                                                          fontSize:
                                                              Adapt.px(25))),
                                                ],
                                              ),
                                            ),
                                            SizedBox(
                                              height: 10,
                                            ),
                                            Container(
                                              alignment: Alignment.centerLeft,
                                              child: Row(
                                                mainAxisAlignment:
                                                    MainAxisAlignment.end,
                                                children: [
                                                  Text(
                                                    timestamp
                                                        .toDate()
                                                        .toString()
                                                        .substring(0, 16),
                                                    style: TextStyle(
                                                        color:
                                                            defaultfontcolor),
                                                  ),
                                                  Icon(Icons.access_alarms,
                                                      color: defaultfontcolor),
                                                  SizedBox(
                                                    height: 5,
                                                  ),
                                                  Text(
                                                    document["clear_time_mm"] +
                                                        ':' +
                                                        document[
                                                            "clear_time_ss"],
                                                    style: TextStyle(
                                                        color:
                                                            defaultfontcolor),
                                                  ),
                                                ],
                                              ),
                                            ),
                                            SizedBox(
                                              width: 10,
                                            ),
                                            Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.end,
                                              children: [
                                                InkWell(
                                                    child: Container(
                                                      padding:
                                                          EdgeInsets.all(0.0),
                                                      child: Row(
                                                          mainAxisAlignment:
                                                              MainAxisAlignment
                                                                  .start,
                                                          children: <Widget>[
                                                            Icon(
                                                              Icons.chat,
                                                              color: Colors
                                                                  .black87,
                                                            ),
                                                            Text(
                                                              '후기',
                                                              style: TextStyle(
                                                                  fontSize: 13,
                                                                  color: Colors
                                                                      .black54),
                                                            ),
                                                          ]),
                                                    ),
                                                    onTap: () => {
                                                          _asyncCompleteConfirmDialog(
                                                              context,
                                                              document[
                                                                  "cafe_thema"],
                                                              document
                                                                  .documentID,
                                                              dispatch)
                                                        }),
                                                SizedBox(
                                                  width: 10,
                                                ),

/*완료*/
                                                InkWell(
                                                    child: Container(
                                                      padding:
                                                          EdgeInsets.all(0.0),
                                                      child: Row(
                                                          mainAxisAlignment:
                                                              MainAxisAlignment
                                                                  .start,
                                                          children: <Widget>[
                                                            Icon(
                                                              Icons
                                                                  .move_to_inbox,
                                                              color: Colors
                                                                  .black87,
                                                            ),
                                                            Text(
                                                              '완료',
                                                              style: TextStyle(
                                                                  fontSize: 13,
                                                                  color: Colors
                                                                      .black54),
                                                            ),
                                                          ]),
                                                    ),
                                                    onTap: () => {
                                                          _asyncCompleteConfirmDialog(
                                                              context,
                                                              document[
                                                                  "cafe_thema"],
                                                              document
                                                                  .documentID,
                                                              dispatch)
                                                        }),
                                                SizedBox(
                                                  width: 10,
                                                ),
                                                InkWell(
                                                    child: Container(
                                                      padding:
                                                          EdgeInsets.all(0.0),
                                                      child: Row(
                                                          mainAxisAlignment:
                                                              MainAxisAlignment
                                                                  .start,
                                                          children: <Widget>[
                                                            Icon(
                                                              Icons.delete,
                                                              color: Colors.red,
                                                            ),
                                                            Text(
                                                              '삭제',
                                                              style: TextStyle(
                                                                  fontSize: 13,
                                                                  color: Colors
                                                                      .red),
                                                            ),
                                                          ]),
                                                    ),
                                                    onTap: () => {
                                                          _asyncDeleteConfirmDialog(
                                                              context,
                                                              document[
                                                                  "cafe_thema"],
                                                              document
                                                                  .documentID,
                                                              dispatch)
                                                        }),
                                              ],
                                            ),
                                          ],
                                        ),
                                      ),
                                    ]),
                              )),
                        );
                      }).toList(),
                    );
                }
              },
            ),
          ),
          Container(
            padding: const EdgeInsets.all(0),
            color: Colors.black54,
            alignment: Alignment.center,
            child: Text(
              "지난 테마",
              style: TextStyle(color: Colors.white),
            ),
          ),
          Container(
            height: MediaQuery.of(context).size.height - 350,
            child: StreamBuilder<QuerySnapshot>(
              stream: Firestore.instance
                  .collection("bangTalCabinet")
                  .where('USER_ID', isEqualTo: state.user.firebaseUser.uid)
                  .where('complete', isEqualTo: 'Y')
                  .snapshots(),
              builder: (BuildContext context,
                  AsyncSnapshot<QuerySnapshot> snapshot) {
                if (snapshot.data == null) {
                  return Container(
                    color: defaultbackcolor,
                    padding: const EdgeInsets.all(0),
                    child: Center(child: CircularProgressIndicator()),
                  );
                }
                if (snapshot.hasError) return Text("Error: ${snapshot.error}");
                switch (snapshot.connectionState) {
                  case ConnectionState.waiting:
                  //return Text("Loading...");
                  default:
                    return ListView(
                      children: snapshot.data.documents
                          .map((DocumentSnapshot document) {
                        //   Timestamp ts = document["CDATE"];
                        //   String dt = timestampToStrDateTime(ts);
                        Timestamp timestamp = document['MDATE'];
                        timestamp.toDate().toString();

                        return Card(
                          child: Container(
                              padding: const EdgeInsets.all(5),
                              child: Container(
                                color: defaultbackcolor,
                                padding: const EdgeInsets.all(0),
                                child: Row(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    children: <Widget>[
                                      SizedBox(
                                        width: 70, // hard coding child width
                                        child: Column(
                                          children: <Widget>[
                                            Container(
                                              alignment: Alignment.centerLeft,
                                              //color: ,
                                              child: Column(
                                                children: [
                                                  _ImageCell(
                                                      url: document[
                                                              "posterPath"] ??
                                                          ''),
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
                                        width:
                                            MediaQuery.of(context).size.width -
                                                110,
                                        child: Column(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceBetween,
                                          children: <Widget>[
                                            Container(
                                              alignment: Alignment.centerLeft,
                                              child: Row(
                                                children: [
                                                  Text(document["cafe_name"],
                                                      style: TextStyle(
                                                          color: const Color(
                                                              0xFF9E9E9E),
                                                          fontSize:
                                                              Adapt.px(22))),
                                                ],
                                              ),
                                            ),
                                            Container(
                                              alignment: Alignment.centerLeft,
                                              child: Row(
                                                children: [
                                                  Text(document["cafe_thema"],
                                                      style: TextStyle(
                                                          //   color: const Color(
                                                          //     0xFF9E9E9E),
                                                          fontSize:
                                                              Adapt.px(25))),
                                                ],
                                              ),
                                            ),
                                            SizedBox(
                                                width: Adapt.screenW() -
                                                    Adapt.px(300),
                                                child: Text(
                                                  document["conts"],
                                                  style: TextStyle(
                                                      color: const Color(
                                                          0xFF9E9E9E),
                                                      fontSize: Adapt.px(22)),
                                                )),
                                            SizedBox(
                                              height: 10,
                                            ),
                                            Container(
                                              alignment: Alignment.centerLeft,
                                              child: Row(
                                                mainAxisAlignment:
                                                    MainAxisAlignment.end,
                                                children: [
                                                  Text(
                                                    timestamp
                                                        .toDate()
                                                        .toString()
                                                        .substring(0, 16),
                                                    style: TextStyle(
                                                        color:
                                                            defaultfontcolor),
                                                  ),
                                                  Icon(Icons.access_alarms,
                                                      color: defaultfontcolor),
                                                  SizedBox(
                                                    height: 5,
                                                  ),
                                                  Text(
                                                    document["clear_time_mm"] +
                                                        ':' +
                                                        document[
                                                            "clear_time_ss"],
                                                    style: TextStyle(
                                                        color:
                                                            defaultfontcolor),
                                                  ),
                                                ],
                                              ),
                                            ),
                                            Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment
                                                      .spaceBetween,
                                              children: [
                                                Row(
                                                  children: <Widget>[
                                                    RatingBarIndicator(
                                                      rating: double.parse(
                                                          (document["star_cnt"] !=
                                                                      ''
                                                                  ? document[
                                                                      "star_cnt"]
                                                                  : '0') ??
                                                              0.0),
                                                      itemPadding:
                                                          EdgeInsets.only(
                                                              right:
                                                                  Adapt.px(8)),
                                                      itemCount: 5,
                                                      itemBuilder:
                                                          (context, _) => Icon(
                                                        Icons.star,
                                                        color: Colors.amber,
                                                      ),
                                                      unratedColor: Colors.grey,
                                                      itemSize: Adapt.px(25),
                                                    ),
                                                    Text(
                                                        ' (힌트:' +
                                                            document[
                                                                "hint_cnt"] +
                                                            ')',
                                                        style: TextStyle(
                                                            fontSize: 13,
                                                            color:
                                                                Colors.black54))
                                                  ],
                                                ),
                                                Row(children: <Widget>[
                                                  InkWell(
                                                      child: Container(
                                                        padding:
                                                            EdgeInsets.all(0.0),
                                                        child: Row(
                                                            mainAxisAlignment:
                                                                MainAxisAlignment
                                                                    .start,
                                                            children: <Widget>[
                                                              Icon(
                                                                Icons.chat,
                                                                color: Colors
                                                                    .black87,
                                                              ),
                                                              Text(
                                                                '후기',
                                                                style: TextStyle(
                                                                    fontSize:
                                                                        13,
                                                                    color: Colors
                                                                        .black54),
                                                              ),
                                                            ]),
                                                      ),
                                                      onTap: () => {
                                                            showDialog(
                                                                    context:
                                                                        context,
                                                                    builder: (ctx) {
                                                                      return UpdateCabintDialog(
                                                                        docId: document
                                                                            .documentID,
                                                                        selectCafeName:
                                                                            document["cafe_name"],
                                                                        selectThemaName:
                                                                            document["cafe_thema"],
                                                                        hintCon:
                                                                            document["hint_cnt"],
                                                                        clearTimeConMm:
                                                                            document["clear_time_mm"],
                                                                        clearTimeConSs:
                                                                            document["clear_time_ss"],
                                                                        passYn:
                                                                            document["pass_yn"],
                                                                        startCon:
                                                                            document["star_cnt"],
                                                                        contsCon:
                                                                            document["conts"],
                                                                      );
                                                                    })
                                                                .then((value) =>
                                                                    print(
                                                                        '등록되었습니다.'))
                                                          }),

/*완료*/
                                                  SizedBox(
                                                    width: 10,
                                                  ),
                                                  InkWell(
                                                      child: Container(
                                                        padding:
                                                            EdgeInsets.all(0.0),
                                                        child: Row(
                                                            mainAxisAlignment:
                                                                MainAxisAlignment
                                                                    .start,
                                                            children: <Widget>[
                                                              Icon(
                                                                Icons.delete,
                                                                color:
                                                                    Colors.red,
                                                              ),
                                                              Text(
                                                                '삭제',
                                                                style: TextStyle(
                                                                    fontSize:
                                                                        13,
                                                                    color: Colors
                                                                        .red),
                                                              ),
                                                            ]),
                                                      ),
                                                      onTap: () => {
                                                            _asyncDeleteConfirmDialog(
                                                                context,
                                                                document[
                                                                    "cafe_thema"],
                                                                document
                                                                    .documentID,
                                                                dispatch)
                                                          }),
                                                ]),
                                              ],
                                            ),
                                          ],
                                        ),
                                      ),
                                    ]),
                              )),
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

  Future<void> _asyncDeleteConfirmDialog(
      BuildContext context, cafe_thema, docuId, dispatch) async {
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
                Navigator.of(context).pop('취소되었습니다.');
              },
            ),
            FlatButton(
              child: Text(
                '삭제',
                style: TextStyle(color: Colors.red),
              ),

              onPressed: () =>
                  dispatch(BangtalCabinetPageActionCreator.onDelete(docuId)),

              // Navigator.of(context).pop('삭제되었습니다.');
            )
          ],
        );
      },
    );
  }

  Future<void> _asyncCompleteConfirmDialog(
      BuildContext context, cafe_thema, docuId, dispatch) async {
    return showDialog<void>(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Container(
            child: Row(
              children: [
                Icon(Icons.move_to_inbox, color: Colors.red),
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
          content: Text('완료처리 하시겠습니까?'),
          actions: <Widget>[
            FlatButton(
              child: Text('취소'),
              onPressed: () {
                Navigator.of(context).pop('취소되었습니다.');
              },
            ),
            FlatButton(
              child: Text(
                '완료',
                style: TextStyle(color: Colors.red),
              ),

              onPressed: () =>
                  dispatch(BangtalCabinetPageActionCreator.onComplete(docuId)),

              // Navigator.of(context).pop('삭제되었습니다.');
            )
          ],
        );
      },
    );
  }
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
            image: url != ''
                ? CachedNetworkImageProvider(
                    ImageUrlDefault.getUrl(url, ImageSize.w200),
                  )
                : AssetImage("assets/icon/launcher_icon.png"),
          ),
        ),
      ),
    );
  }
}
