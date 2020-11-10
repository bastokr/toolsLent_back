import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
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

Effect<BangtalDetailState> buildEffect() {
  return combineEffects(<Object, Effect<BangtalDetailState>>{
    BangtalDetailPageAction.action: _onAction,
    BangtalDetailPageAction.submit: _submit,
    BangtalDetailPageAction.onJoin: _onJoin,
    BangtalDetailPageAction.onDelete: _onDelete,
    BangtalDetailPageAction.onJoinDelete: _onJoinDelete,
    BangtalDetailPageAction.joinCount: _joinCount,
    BangtalDetailPageAction.themaList: _themaList,
    BangtalDetailPageAction.uploadBackground: _uploadBackground,
    BangtalDetailPageAction.showSnackBar: _showSnackBar,
    BangtalDetailPageAction.goChat: _goChat,
    Lifecycle.initState: _onInit,
    Lifecycle.dispose: _onDispose,
  });
}

void _onAction(Action action, Context<BangtalDetailState> ctx) {}

Future<void> _onInit(Action action, Context<BangtalDetailState> ctx) async {
  ctx.state.nameTextController = TextEditingController(text: ctx.state.name);
  ctx.state.descriptionTextController =
      TextEditingController(text: ctx.state.description);
  final _bangtaktok =
      await Firestore.instance.collection('bangTalCafe').getDocuments();
  final items = {};
  _bangtaktok.documents.forEach((element) {
    items.addAll({element.documentID: element.data['cafe_name']});

    //  items.addAll({element.documentID , element.data['cafe_name'] + ' ' + element.data['thema']});
    //  print(element.data['cafe_name'] + ' ' + element.data['thema']);
    //  var string = element.documentID.toString();
    ctx.state.cafeList.add(DropdownMenuItem(
      // key: Key(element.documentID),
      child: Text(element.data['area'] + ' / ' + element.data['cafe_name']),
      value: element.data['cafe_name'],
      // key: items[element.documentID],
    ));
  });
  ctx.dispatch(BangtalDetailPageActionCreator.setLoading(false));

  _themaList(action, ctx);
}

Future<void> _onJoin(Action action, Context<BangtalDetailState> ctx) async {
  ctx.state.nameFoucsNode.unfocus();
  ctx.state.descriptionFoucsNode.unfocus();
  print(ctx.state.selectCafeName);
  print(ctx.state.selectThemaName);
  print(ctx.state.user);

  if (ctx.state.contsCon.text == '') {
    ctx.broadcast(
        BangtalDetailPageActionCreator.showSnackBar('간단한 참여글을 작성해 주세요^^'));
    Future.delayed(Duration(seconds: 2)).then((_) {
      //   ctx.dispatch(bantaltokWriteActionCreator.list());
      ctx.state.descriptionFoucsNode.nextFocus();
    });
    return;
  } else {
    Firestore.instance
        .collection("bangTalBoardJoin")
        .document(ctx.state.user.firebaseUser.uid +
            ctx.state.bangtalboardDetail.documentID)
        .setData({
      'cafe_name': ctx.state.selectCafeName,
      'cafe_thema': ctx.state.selectThemaName,
      'USER_NAME': ctx.state.user.firebaseUser.displayName,
      'USER_ID': ctx.state.user.firebaseUser.uid,
      'boardId': ctx.state.bangtalboardDetail.documentID,
      'photoUrl': ctx.state.user.firebaseUser.photoUrl,
      'joinDesc': ctx.state.contsCon.text,
      'confirmJoinYn': 'N',
      'chatYN': 'N',
      'MDATE': ctx.state.mDate,
      'CDATE': Timestamp.now(),
    }).then((value) {
      ctx.broadcast(BangtalDetailPageActionCreator.showSnackBar('참여신청 되었습니다.'));
      Future.delayed(Duration(seconds: 2)).then((_) {
        var doc = Firestore.instance
            .collection("bangTalBoardJoin")
            .where('boardId',
                isEqualTo: ctx.state.bangtalboardDetail.documentID)
            .getDocuments();
        doc.then((value) => {
              Firestore.instance
                  .collection("bangTalBoard")
                  .document(ctx.state.bangtalboardDetail.documentID)
                  .updateData({'joinCount': value.documents.length}),
              ctx.state.joinCount = value.documents.length.toString(),
              ctx.dispatch(BangtalDetailPageActionCreator.setLoading(false))
            });
      });
    });
  }
}

Future<void> _onDelete(Action action, Context<BangtalDetailState> ctx) async {
  ctx.state.nameFoucsNode.unfocus();
  ctx.state.descriptionFoucsNode.unfocus();
  print(ctx.state.selectCafeName);
  print(ctx.state.selectThemaName);
  print(ctx.state.user);

  Firestore.instance
      .collection("bangTalBoard")
      .document(ctx.state.bangtalboardDetail.documentID)
      .delete()
      .then((value) {
    ctx.broadcast(BangtalDetailPageActionCreator.showSnackBar('삭제되었습니다.'));
    Future.delayed(Duration(seconds: 2)).then((_) {
      Navigator.of(ctx.context).pop({'back': 'back'});
      Navigator.of(ctx.context).pop({'relaod': 'reload'});
    });
    //   Navigator.of(ctx.context).pop('reload');
  });
}

Future<void> _onJoinDelete(
    Action action, Context<BangtalDetailState> ctx) async {
  ctx.state.nameFoucsNode.unfocus();
  ctx.state.descriptionFoucsNode.unfocus();
  print(ctx.state.selectCafeName);
  print(ctx.state.selectThemaName);
  print(ctx.state.user);

  Firestore.instance
      .collection("bangTalBoardJoin")
      .document(ctx.state.user.firebaseUser.uid +
          ctx.state.bangtalboardDetail.documentID)
      .delete()
      .then((value) {
    ctx.broadcast(BangtalDetailPageActionCreator.showSnackBar('참여취소 되었습니다.'));
    Future.delayed(Duration(seconds: 2)).then((_) {
      var doc = Firestore.instance
          .collection("bangTalBoardJoin")
          .where('boardId', isEqualTo: ctx.state.bangtalboardDetail.documentID)
          .getDocuments();
      doc.then((value) => {
            Firestore.instance
                .collection("bangTalBoard")
                .document(ctx.state.bangtalboardDetail.documentID)
                .updateData({'joinCount': value.documents.length}),
            ctx.state.joinCount = value.documents.length.toString(),
            ctx.dispatch(BangtalDetailPageActionCreator.setLoading(false)),
            Navigator.of(ctx.context).pop({'back': 'back'})
          });
    });
  });
}

Future<void> _themaList(Action action, Context<BangtalDetailState> ctx) async {
  print(ctx.state.selectCafeName);
  final _bangtaktok = await Firestore.instance
      .collection('bangTalCafeThema')
      .where("cafe_name", isEqualTo: ctx.state.selectCafeName)
      //  .orderBy('CDATE', descending: true)
      .getDocuments();

  final items = {};
  ctx.state.themaList = [];
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

  ctx.dispatch(BangtalDetailPageActionCreator.setLoading(false));
}

void _onDispose(Action action, Context<BangtalDetailState> ctx) async {
  ctx.state.nameTextController?.dispose();
  ctx.state.descriptionTextController?.dispose();
  ctx.state.nameFoucsNode?.dispose();
  ctx.state.descriptionFoucsNode?.dispose();
}

Future<void> _submit(Action action, Context<BangtalDetailState> ctx) async {
  print('testttttttttttttt');
}

Future<void> _joinCount(Action action, Context<BangtalDetailState> ctx) async {
  print(action.payload);

  ctx.state.joinCount = action.payload;
  ctx.dispatch(BangtalDetailPageActionCreator.setLoading(false));
}

void _uploadBackground(Action action, Context<BangtalDetailState> ctx) async {
  final ImagePicker _imagePicker = ImagePicker();
  final _image = await _imagePicker.getImage(
      source: ImageSource.gallery, maxHeight: 1920, maxWidth: 1080);
  if (_image != null) {
    ctx.dispatch(BangtalDetailPageActionCreator.setLoading(true));
    StorageReference storageReference = FirebaseStorage.instance
        .ref()
        .child('avatar/${Path.basename(_image.path)}');
    StorageUploadTask uploadTask =
        storageReference.putData(await _image.readAsBytes());
    await uploadTask.onComplete;
    print('File Uploaded');
    storageReference.getDownloadURL().then((fileURL) {
      if (fileURL != null) {
        ctx.dispatch(BangtalDetailPageActionCreator.setBackground(fileURL));
      }
    });
    ctx.dispatch(BangtalDetailPageActionCreator.setLoading(false));
  }
}

void _showSnackBar(Action action, Context<BangtalDetailState> ctx) {
  ctx.state.scaffoldkey.currentState.showSnackBar(SnackBar(
    content: Text(action.payload ?? ''),
  ));
}

void _goChat(Action action, Context<BangtalDetailState> ctx) async {
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
void registerNotification(Action action, Context<BangtalDetailState> ctx) {
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
        ? 'com.shsoft.escroomtok'
        : 'com.shsssssssssssss.escroomtok',
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
