import 'dart:io';
import 'dart:isolate';
import 'dart:ui';

import 'package:escroomtok/routes/routes.dart';
import 'package:escroomtok/views/bangtalChatList_page/page.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:fish_redux/fish_redux.dart';
import 'package:flutter/material.dart' hide Action, Page;
import 'package:flutter_downloader/flutter_downloader.dart';
import 'package:escroomtok/actions/downloader_callback.dart';

import 'package:escroomtok/actions/local_notification.dart';
import 'package:escroomtok/actions/user_info_operate.dart';
import 'package:escroomtok/actions/version_comparison.dart';
import 'package:escroomtok/models/notification_model.dart';
//import 'package:escroomtok/views/tvshow_detail_page/page.dart';
//import 'package:escroomtok/widgets/update_info_dialog.dart';
//import 'package:escroomtok/views/detail_page/page.dart';
//import 'package:escroomtok/package_info.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'action.dart';
import 'state.dart';

Effect<MainPageState> buildEffect() {
  return combineEffects(<Object, Effect<MainPageState>>{
    MainPageAction.action: _onAction,
    Lifecycle.initState: _onInit,
    Lifecycle.dispose: _onDispose,
  });
}

ReceivePort _port = ReceivePort();
void _onAction(Action action, Context<MainPageState> ctx) {}

void _onInit(Action action, Context<MainPageState> ctx) async {
  await UserInfoOperate.whenAppStart();

  final _preferences = await SharedPreferences.getInstance();

  final _localNotification = LocalNotification.instance;

  await _localNotification.init();

  FirebaseMessaging().configure(onMessage: (message) async {
    print(ctx.state.selectedIndex);
    if (ctx.state.selectedIndex == 3) {
    } else {
      NotificationList _list;
      if (_preferences.containsKey('notifications')) {
        final String _notifications = _preferences.getString('notifications');
        _list = NotificationList(_notifications);
      }
      if (_list == null) _list = NotificationList.fromParams(notifications: []);
      final _notificationMessage = NotificationModel.fromMap(message);
      _list.notifications.add(_notificationMessage);
      _preferences.setString('notifications', _list.toString());
      _localNotification.sendNotification(
        _notificationMessage.notification.title,
        _notificationMessage.notification?.body ?? '',
        //   id: int.parse(_notificationMessage.id),
        //     payload: _notificationMessage.type
      );
      print(_list.toString());
    }
  }, onResume: (message) async {
    _pushBangtalChat(message, ctx);
  }, onLaunch: (message) async {
    _pushBangtalChat(message, ctx);
  });

  FlutterDownloader.registerCallback(DownloaderCallBack.callback);
}

void _onDispose(Action action, Context<MainPageState> ctx) {
  if (Platform.isAndroid) _unbindBackgroundIsolate();
}

Future _pushBangtalChat(
    Map<String, dynamic> message, Context<MainPageState> ctx) async {
  print(message['data']['boardId']);
  Firestore.instance
      .collection('bangTalBoard')
      .document(message['data']['boardId'])
      .get()
      .then((DocumentSnapshot ds) {
    print(ds.documentID);
    Navigator.of(ctx.context).pushNamed('bangtalChatPage',
        arguments: {'bangtalboardDetail': ds}).then((d) {
      if (d != null) {}
    });
  });
/*
  await Navigator.push(
      ctx.state.scaffoldKey.currentContext,
      PageRouteBuilder(
          pageBuilder: (_, __, ___) {
            return Routes.routes.buildPage('bangtalChatPage', {'pages': ''});
          },
          settings: RouteSettings(name: 'mainpage')));
*/
}

void _unbindBackgroundIsolate() {
  IsolateNameServer.removePortNameMapping('downloader_send_port');
}
