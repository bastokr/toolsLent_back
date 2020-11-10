import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:fish_redux/fish_redux.dart';
import 'package:flutter/material.dart' hide Action;
import 'package:flutter_local_notifications/flutter_local_notifications.dart';

import 'package:shared_preferences/shared_preferences.dart';
import 'action.dart';
import 'state.dart';

Effect<BangtalChatState> buildEffect() {
  return combineEffects(<Object, Effect<BangtalChatState>>{
    BangtalChatPageAction.action: _onAction,
    BangtalChatPageAction.submit: _submit,
    BangtalChatPageAction.themaList: _themaList,
    BangtalChatPageAction.uploadBackground: _uploadBackground,
    BangtalChatPageAction.showSnackBar: _showSnackBar,
    Lifecycle.initState: _onInit,
    Lifecycle.dispose: _onDispose,
  });
}

void _onAction(Action action, Context<BangtalChatState> ctx) {
  print(
      "===============================================================================111>");
}

final FirebaseMessaging firebaseMessaging = FirebaseMessaging();
final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
    FlutterLocalNotificationsPlugin();
Future<void> _onInit(Action action, Context<BangtalChatState> ctx) async {
  SharedPreferences prefs = await SharedPreferences.getInstance();

  FirebaseUser firebaseUser = ctx.state.user.firebaseUser;
  if (firebaseUser != null) {
    // Check is already sign up

    Firestore.instance
        .collection("bangTalBoardJoin")
        .document(ctx.state.user.firebaseUser.uid +
            ctx.state.bangtalboardDetail.documentID)
        .updateData({'chatYN': 'Y'});

    final QuerySnapshot result = await Firestore.instance
        .collection('users')
        .where('id', isEqualTo: firebaseUser.uid)
        .getDocuments();
    final List<DocumentSnapshot> documents = result.documents;
    if (documents.length > 0) {
      // Update data to server if new user
      Firestore.instance
          .collection('users')
          .document(firebaseUser.uid)
          .setData({
        'nickname': firebaseUser.displayName,
        'photoUrl': firebaseUser.photoUrl,
        'id': firebaseUser.uid,
        'createdAt': DateTime.now().millisecondsSinceEpoch.toString(),
        'chattingWith': null
      }).then((value) => {
                // registerNotification(action, ctx)
                firebaseMessaging.getToken().then((token) {
                  print('token: $token');
                  Firestore.instance
                      .collection('users')
                      .document(ctx.state.user.firebaseUser.uid)
                      .updateData({'pushToken': token});
                }).catchError((err) {
                  // Fluttertoast.showToast(msg: err.message.toString());
                })
              });

      // Write data to local

      await prefs.setString('id', firebaseUser.uid);
      await prefs.setString('nickname', firebaseUser.displayName);
      await prefs.setString('photoUrl', firebaseUser.photoUrl);
    } else {
      // Write data to local
      await prefs.setString('id', documents[0]['id']);
      await prefs.setString('nickname', documents[0]['nickname']);
      await prefs.setString('photoUrl', documents[0]['photoUrl']);
      await prefs.setString('aboutMe', documents[0]['aboutMe']);
    }
  }
}
/*
void registerNotification(Action action, Context<BangtalChatState> ctx) {
  firebaseMessaging.requestNotificationPermissions();

  firebaseMessaging.configure(onMessage: (Map<String, dynamic> message) {
    print('onMessage: $message');

    // 메시지를 어케 받는지 확인 됐다면...
    showDialog(
      context: ctx.context,
      builder: (context) => AlertDialog(
        content: ListTile(
          title: Text(message['data']['title']),
          subtitle: Text(message['data']['body']),
        ),
        actions: <Widget>[
          FlatButton(
            child: Text('확인'),
            onPressed: () => Navigator.of(context).pop(),
          ),
        ],
      ),
    );

    Platform.isAndroid
        ? showNotification(message['data'])
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
    // Fluttertoast.showToast(msg: err.message.toString());
  });
}

void showNotification(message) async {
  var androidPlatformChannelSpecifics = new AndroidNotificationDetails(
    Platform.isAndroid ? 'com.shsoft.escroomtok' : 'com.duytq.flutterchatdemo',
    '방탈출앱',
    '채팅알람',
    playSound: true,
    enableVibration: true,
    importance: Importance.Max,
    priority: Priority.High,
  );
  var iOSPlatformChannelSpecifics = new IOSNotificationDetails();
  var platformChannelSpecifics = new NotificationDetails(
      androidPlatformChannelSpecifics, iOSPlatformChannelSpecifics);

  print(message);
 
  await flutterLocalNotificationsPlugin.show(0, message['title'].toString(),
      message['body'].toString(), platformChannelSpecifics,
      payload: json.encode(message));
 
}
*/

Future<void> _submit(Action action, Context<BangtalChatState> ctx) async {}

Future<void> _themaList(Action action, Context<BangtalChatState> ctx) async {}

void _onDispose(Action action, Context<BangtalChatState> ctx) async {
  Firestore.instance
      .collection("bangTalBoardJoin")
      .document(ctx.state.user.firebaseUser.uid +
          ctx.state.bangtalboardDetail.documentID)
      .updateData({'chatYN': 'M'});
}

void _uploadBackground(Action action, Context<BangtalChatState> ctx) async {}

void _showSnackBar(Action action, Context<BangtalChatState> ctx) {
  ctx.state.scaffoldkey.currentState.showSnackBar(SnackBar(
    content: Text(action.payload ?? ''),
  ));
}
