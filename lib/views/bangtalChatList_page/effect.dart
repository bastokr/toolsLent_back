import 'dart:io';

import 'package:escroomtok/views/bangtalCabinet_page/effect.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fish_redux/fish_redux.dart';
import 'package:flutter/cupertino.dart' hide Action, Page;
import 'package:fluttertoast/fluttertoast.dart';
import 'action.dart';
import 'state.dart';

Effect<BangtalChatListState> buildEffect() {
  return combineEffects(<Object, Effect<BangtalChatListState>>{
    BangtalChatListAction.action: _onAction,
    BangtalChatListAction.clickFromFirebase: _clickFromFirebase,
    BangtalChatListAction.createList: _createList,
    BangtalChatListAction.reflash: _reflash,
    BangtalChatListAction.detailList: _detailList,
    BangtalChatListAction.goChat: _goChat,
    Lifecycle.initState: _onInit,
    Lifecycle.dispose: _onDispose,
  });
}

void _onInit(Action action, Context<BangtalChatListState> ctx) {
  final Object _ticker = ctx.stfState;
  // _clickFromFirebase(ctx);
  // final Object ticker = ctx.stfState;
  ctx.state.animationController = AnimationController(
      vsync: _ticker, duration: Duration(milliseconds: 300));
  ctx.state.cellAnimationController = AnimationController(
      vsync: _ticker, duration: Duration(milliseconds: 1000));
  ctx.state.refreshController = AnimationController(
      vsync: _ticker, duration: Duration(milliseconds: 100));
  ctx.state.controller = ScrollController()
    ..addListener(() {
      if (ctx.state.controller.position.pixels ==
          ctx.state.controller.position.maxScrollExtent) {
        _loadMore(ctx);
      } //_loadMore(ctx);
    });

  ctx.dispatch(BangtalChatListActionCreator.clickFromFirebase());
}

Future _onDispose(Action action, Context<BangtalChatListState> ctx) async {}

void _onAction(Action action, Context<BangtalChatListState> ctx) {
  ctx.state.controller.dispose();
}

Future _clickFromFirebase(
    Action action, Context<BangtalChatListState> ctx) async {
  print(ctx.state.user.firebaseUser.uid);
  var r = await Firestore.instance
      .collection('bangTalBoardJoin')
      .where('USER_ID', isEqualTo: ctx.state.user.firebaseUser.uid)
      .orderBy('CDATE', descending: true)
      .limit(10)
      .getDocuments();
  if (r.documents.length > 0) {
    ctx.state.isLoading = false;
    ctx.dispatch(BangtalChatListActionCreator.loadFromFirebase(r.documents));
  }
}

Future _loadMore(Context<BangtalChatListState> ctx) async {
  var r = await Firestore.instance
      .collection('bangTalBoardJoin')
      .where('USER_ID', isEqualTo: ctx.state.user.firebaseUser.uid)
      .orderBy('CDATE', descending: true)
      .startAfterDocument(ctx.state.data[ctx.state.data.length - 1])
      .limit(10)
      .getDocuments();

  if (r.documents.length > 0) {
    ctx.dispatch(BangtalChatListActionCreator.loadFromFirebase(r.documents));
  }
//  ctx.state.isLoading = false;
  //ctx.dispatch(BangtalChatListActionCreator.stopLodingbar());
}

Future _reflash(Action action, Context<BangtalChatListState> ctx) async {
  var r = await Firestore.instance
      .collection('bangTalBoardJoin')
      .where('USER_ID', isEqualTo: ctx.state.user.firebaseUser.uid)
      .orderBy('CDATE', descending: true)
      .limit(10)
      .getDocuments();
  if (r.documents.length > 0) {
    ctx.state.isLoading = false;
    ctx.dispatch(BangtalChatListActionCreator.reflashFromFirebase(r.documents));
  }
}

void _createList(Action action, Context<BangtalChatListState> ctx) async {
  ctx.state.animationController.value = 0;
  ctx.state.cellAnimationController.reset();
  // ctx.dispatch(BangtalChatListActionCreator.onEdit(false));
  await Navigator.of(ctx.context)
      .pushNamed('bangtalCreatePage', arguments: action.payload)
      .then((d) {
    ctx.dispatch(BangtalChatListActionCreator.reflash());
    //if (d != null) {
    // ctx.state.listData.data.insert(0, d);
    ctx.dispatch(BangtalChatListActionCreator.reflash());
    //}
  });
}

void _detailList(Action action, Context<BangtalChatListState> ctx) async {
  ctx.state.animationController.value = 0;
  ctx.state.cellAnimationController.reset();
  // ctx.dispatch(BangtalChatListActionCreator.onEdit(false));
  await Navigator.of(ctx.context)
      .pushNamed('bangtalDetailPage', arguments: action.payload)
      .then((d) {
    ctx.dispatch(BangtalChatListActionCreator.reflash());
    // if (d != null) {
    // ctx.state.listData.data.insert(0, d);

    //  }
  });
}

void _goChat(Action action, Context<BangtalChatListState> ctx) async {
  registerNotification(action, ctx);

  var bangtalboardDetail = action.payload['bangtalboardDetail'];

  //var bangtalboardDetail2 = action.payload(0)['bangtalboardDetail'];

  print(bangtalboardDetail['boardId']);
  print(bangtalboardDetail.data['boardId']);

  Firestore.instance
      .collection('bangTalBoard')
      .document(bangtalboardDetail['boardId'])
      .get()
      .then((DocumentSnapshot ds) {
    //ds.data["title"];

    print(ds.documentID);
    Navigator.of(ctx.context).pushNamed('bangtalChatPage',
        arguments: {'bangtalboardDetail': ds}).then((d) {
      if (d != null) {}
    });
  });
}

void registerNotification(Action action, Context<BangtalChatListState> ctx) {
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
    print(err);
    //   Fluttertoast.showToast(msg: err.message.toString());
  });
}
