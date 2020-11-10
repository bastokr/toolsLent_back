import 'package:escroomtok/views/bangtalCabinet_page/effect.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fish_redux/fish_redux.dart';
import 'package:flutter/cupertino.dart' hide Action, Page;
import 'package:fluttertoast/fluttertoast.dart';
import 'action.dart';
import 'state.dart';
import 'dart:io';

Effect<ItemDetailState> buildEffect() {
  return combineEffects(<Object, Effect<ItemDetailState>>{
    ItemDetailAction.action: _onAction,
    ItemDetailAction.detailList: _detailList,
    ItemDetailAction.reflash: _reflash,
    ItemDetailAction.goChat: _goChat
  });
}

void _onAction(Action action, Context<ItemDetailState> ctx) {}

void _detailList(Action action, Context<ItemDetailState> ctx) async {
  ctx.state.animationController.value = 0;
  ctx.state.cellAnimationController.reset();
  // ctx.dispatch(BangtalChatListActionCreator.onEdit(false));
  await Navigator.of(ctx.context)
      .pushNamed('bangtalDetailPage', arguments: action.payload)
      .then((d) {
    if (d != null) {
      //\\ ctx.state.listData.data.insert(0, d);
      ctx.dispatch(ItemDetailActionCreator.reflash());
    }
  });
}

Future _reflash(Action action, Context<ItemDetailState> ctx) async {
  var r = await Firestore.instance
      .collection('bangTalBoard')
      .orderBy('timestamp', descending: true)
      .getDocuments();
  if (r.documents.length > 0) {
    //ctx.state.isLoading = false;
    ctx.dispatch(ItemDetailActionCreator.reflashFromFirebase(r.documents));
  }
}

void _goChat(Action action, Context<ItemDetailState> ctx) async {
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

void registerNotification(Action action, Context<ItemDetailState> ctx) {
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
