import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:fish_redux/fish_redux.dart';
import 'package:flutter/material.dart' hide Action;
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path/path.dart' as Path;
import 'action.dart';
import 'state.dart';
import 'dart:io';

Effect<BangtalCabinetState> buildEffect() {
  return combineEffects(<Object, Effect<BangtalCabinetState>>{
    BangtalCabinetPageAction.action: _onAction,
    BangtalCabinetPageAction.submit: _submit,
    BangtalCabinetPageAction.onAdd: _onAdd,
    BangtalCabinetPageAction.onDelete: _onDelete,
    BangtalCabinetPageAction.onComplete: _onComplete,
    BangtalCabinetPageAction.joinCount: _joinCount,
    BangtalCabinetPageAction.themaList: _themaList,
    BangtalCabinetPageAction.uploadBackground: _uploadBackground,
    BangtalCabinetPageAction.showSnackBar: _showSnackBar,
    BangtalCabinetPageAction.goChat: _goChat,
    Lifecycle.initState: _onInit,
    Lifecycle.dispose: _onDispose,
  });
}

void _onAction(Action action, Context<BangtalCabinetState> ctx) {}

Future<void> _onInit(Action action, Context<BangtalCabinetState> ctx) async {
  ctx.state.nameTextController = TextEditingController(text: ctx.state.name);
  ctx.state.descriptionTextController =
      TextEditingController(text: ctx.state.description);
  final _bangtaktok =
      await Firestore.instance.collection('bangTalCafe').getDocuments();
  final items = {};
  _bangtaktok.documents.forEach((element) {
    items.addAll({element.documentID: element.data['cafe_name']});
    ctx.state.cafeList.add(DropdownMenuItem(
      child: Text(element.data['area'] + ' / ' + element.data['cafe_name']),
      value: element.data['cafe_name'],
    ));
  });
  ctx.dispatch(BangtalCabinetPageActionCreator.setLoading(false));

  _themaList(action, ctx);
}

Future<void> _onAdd(Action action, Context<BangtalCabinetState> ctx) async {
  if (ctx.state.selectCafeName == '') {
    ctx.broadcast(
        BangtalCabinetPageActionCreator.showSnackBar('간단한 참여글을 작성해 주세요^^'));
    Future.delayed(Duration(seconds: 2)).then((_) {
      ctx.state.descriptionFoucsNode.nextFocus();
    });
    return;
  } else {
    var doc = Firestore.instance
        .collection("bangTalCabinet")
        .where('USER_ID', isEqualTo: ctx.state.user.firebaseUser.uid)
        .where('complete', isEqualTo: 'N')
        .getDocuments();

    doc
        .then((docIdS) => {
              docIdS.documents.forEach((element) {
                Firestore.instance
                    .collection("bangTalCabinet")
                    .document(element.documentID)
                    .updateData({'complete': 'Y'});
              })
            })
        .then((value) => {
              Firestore.instance.collection("bangTalCabinet").add({
                'cafe_name': ctx.state.selectCafeName,
                'cafe_thema': ctx.state.selectThemaName,
                'USER_NAME': ctx.state.user.firebaseUser.displayName,
                'USER_ID': ctx.state.user.firebaseUser.uid,
                'photoUrl': ctx.state.user.firebaseUser.photoUrl,
                'clear_time': ctx.state.clearTimeCon.text,
                'hint_cnt': ctx.state.hintCon,
                'star_cnt': ctx.state.startCon,
                'MDATE': ctx.state.mDate,
                'CDATE': Timestamp.now(),
              }).then((value) {
                print(value.documentID);
                var doc = Firestore.instance
                    .collection("bangTalCafeThema")
                    .where('cafe_name', isEqualTo: ctx.state.selectCafeName)
                    .where('thema', isEqualTo: ctx.state.selectThemaName)
                    .getDocuments();

                doc.then((docId) => {
                      Firestore.instance
                          .collection("bangTalCabinet")
                          .document(value.documentID)
                          .updateData(
                              {'posterPath': docId.documents[0]['posterPath']}),

                      // print(data);

                      ctx.broadcast(
                          BangtalCabinetPageActionCreator.showSnackBar(
                              '등록되었습니다')),
                      Future.delayed(Duration(seconds: 2)).then((_) {
                        //   ctx.dispatch(bantaltokWriteActionCreator.list());
                        Navigator.of(ctx.context).pop('등록완료');
                      }),

                      // Future.delayed(Duration(seconds: 2)).then((_) {});
                    });
              })
            });
  }
}

Future<void> _onDelete(Action action, Context<BangtalCabinetState> ctx) async {
  Firestore.instance
      .collection("bangTalCabinet")
      .document(action.payload)
      .delete()
      .then((value) => Navigator.of(ctx.context).pop('삭제되었습니다.'));
}

Future<void> _onComplete(
    Action action, Context<BangtalCabinetState> ctx) async {
  /*   
  UserUpdateInfo userUpdateInfo = new UserUpdateInfo();
  userUpdateInfo.displayName = "방탈출톡대장";
  userUpdateInfo.photoUrl =
      "https://firebasestorage.googleapis.com/v0/b/escroomtok.appspot.com/o/avatar%2Fscaled_image_picker5784325979829087406.jpg?alt=media&token=ba765396-e5e7-4f22-8adc-1f06fc58efa4";

  ctx.state.user.firebaseUser..updateProfile(userUpdateInfo);
*/
  var doc = Firestore.instance
      .collection("bangTalCabinet")
      .where('USER_ID', isEqualTo: ctx.state.user.firebaseUser.uid)
      .where('complete', isEqualTo: 'N')
      .getDocuments();

  doc
      .then((docIdS) => {
            docIdS.documents.forEach((element) {
              Firestore.instance
                  .collection("bangTalCabinet")
                  .document(element.documentID)
                  .updateData({'complete': 'Y'});
            })
          })
      .then((value) => {
            Firestore.instance
                .collection("bangTalCabinet")
                .document(action.payload)
                .updateData({'complete': 'Y'}).then(
                    (value) => Navigator.of(ctx.context).pop('완료처리되었습니다.'))
          });
}

Future<void> _themaList(Action action, Context<BangtalCabinetState> ctx) async {
  //ctx.state.selectCafeName = action.payload;

  print(ctx.state.selectCafeName);
  final _bangtaktok = await Firestore.instance
      .collection('bangTalCafeThema')
      .where("cafe_name", isEqualTo: ctx.state.selectCafeName)
      //  .orderBy('CDATE', descending: true)
      .getDocuments();

  final items = {};
  ctx.state.themaList = [
    DropdownMenuItem(
      // key: Key(element.documentID),
      child: Text('선택'),
      value: '',
      // key: items[element.documentID],
    )
  ];
  _bangtaktok.documents.forEach((element) {
    items.addAll({element.documentID: element.data['cafe_name']});

    //  items.addAll({element.documentID , element.data['cafe_name'] + ' ' + element.data['thema']});
    //  print(element.data['cafe_name'] + ' ' + element.data['thema']);
    //  var string = element.documentID.toString();
    ctx.state.themaList.add(DropdownMenuItem(
      // key: Key(element.documentID),
      child: Text(element.data['thema']),
      value: element.data['thema'],
      // key: items[element.documentID],
    ));
  });

  //print(items);

  ctx.dispatch(BangtalCabinetPageActionCreator.setLoading(false));
}

void _onDispose(Action action, Context<BangtalCabinetState> ctx) async {
  ctx.state.nameTextController?.dispose();
  ctx.state.descriptionTextController?.dispose();
  ctx.state.nameFoucsNode?.dispose();
  ctx.state.descriptionFoucsNode?.dispose();
}

Future<void> _submit(Action action, Context<BangtalCabinetState> ctx) async {
  print('testttttttttttttt');
}

Future<void> _joinCount(Action action, Context<BangtalCabinetState> ctx) async {
  print(action.payload);

  ctx.state.joinCount = action.payload;
  ctx.dispatch(BangtalCabinetPageActionCreator.setLoading(false));
}

void _uploadBackground(Action action, Context<BangtalCabinetState> ctx) async {
  final ImagePicker _imagePicker = ImagePicker();
  final _image = await _imagePicker.getImage(
      source: ImageSource.gallery, maxHeight: 1920, maxWidth: 1080);
  if (_image != null) {
    ctx.dispatch(BangtalCabinetPageActionCreator.setLoading(true));
    StorageReference storageReference = FirebaseStorage.instance
        .ref()
        .child('avatar/${Path.basename(_image.path)}');
    StorageUploadTask uploadTask =
        storageReference.putData(await _image.readAsBytes());
    await uploadTask.onComplete;
    print('File Uploaded');
    storageReference.getDownloadURL().then((fileURL) {
      if (fileURL != null) {
        ctx.dispatch(BangtalCabinetPageActionCreator.setBackground(fileURL));
      }
    });
    ctx.dispatch(BangtalCabinetPageActionCreator.setLoading(false));
  }
}

void _showSnackBar(Action action, Context<BangtalCabinetState> ctx) {
  ctx.state.scaffoldkey.currentState.showSnackBar(SnackBar(
    content: Text(action.payload ?? ''),
  ));
}

void _goChat(Action action, Context<BangtalCabinetState> ctx) async {
  registerNotification(action, ctx);
  await Navigator.of(ctx.context)
      .pushNamed('bangtalChatPage', arguments: action.payload)
      .then((d) {
    if (d != null) {
      // ctx.state.listData.data.insert(0, d);
      //ctx.dispatch(ItemDetailActionCreator.reflash());
    }
  });
}

final FirebaseMessaging firebaseMessaging = FirebaseMessaging();
final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
    FlutterLocalNotificationsPlugin();
void registerNotification(Action action, Context<BangtalCabinetState> ctx) {
  firebaseMessaging.requestNotificationPermissions();

  firebaseMessaging.configure(onMessage: (Map<String, dynamic> message) {
    print('onMessage: $message');
    Platform.isAndroid
        ? showNotification(message['notification'])
        : showNotification(message['aps']['alert']);
    return;
  }, onResume: (Map<String, dynamic> message) {
    print('onResume: $message');
    return;
  }, onLaunch: (Map<String, dynamic> message) {
    print('onLaunch: $message');
    return;
  });

  firebaseMessaging.getToken().then((token) {
    print('token: $token');
    Firestore.instance
        .collection('users')
        .document(ctx.state.user.firebaseUser.uid)
        .updateData({'pushToken': token});
  }).catchError((err) {
    Fluttertoast.showToast(msg: err.message.toString());
  });
}

void configLocalNotification() {
  var initializationSettingsAndroid =
      new AndroidInitializationSettings('app_icon');
  var initializationSettingsIOS = new IOSInitializationSettings();
  var initializationSettings = new InitializationSettings(
      initializationSettingsAndroid, initializationSettingsIOS);
  flutterLocalNotificationsPlugin.initialize(initializationSettings);
}

void showNotification(message) async {
  var androidPlatformChannelSpecifics = new AndroidNotificationDetails(
    Platform.isAndroid
        ? 'com.dfa.flutterchatdemo'
        : 'com.duytq.flutterchatdemo',
    'Flutter chat demo',
    'your channel description',
    playSound: true,
    enableVibration: true,
    importance: Importance.Max,
    priority: Priority.High,
  );
  var iOSPlatformChannelSpecifics = new IOSNotificationDetails();
  var platformChannelSpecifics = new NotificationDetails(
      androidPlatformChannelSpecifics, iOSPlatformChannelSpecifics);

  print(message);
//    print(message['body'].toString());
//    print(json.encode(message));

  await flutterLocalNotificationsPlugin.show(0, message['title'].toString(),
      message['body'].toString(), platformChannelSpecifics,
      payload: json.encode(message));

//    await flutterLocalNotificationsPlugin.show(
//        0, 'plain title', 'plain body', platformChannelSpecifics,
//        payload: 'item x');
}
