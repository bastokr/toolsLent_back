import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fish_redux/fish_redux.dart';
import 'package:flutter/cupertino.dart' hide Action, Page;
import 'action.dart';
import 'state.dart';

Effect<BangtalboardState> buildEffect() {
  return combineEffects(<Object, Effect<BangtalboardState>>{
    BangtalboardAction.action: _onAction,
    BangtalboardAction.clickFromFirebase: _clickFromFirebase,
    BangtalboardAction.createList: _createList,
    BangtalboardAction.reflash: _reflash,
    BangtalboardAction.detailList: _detailList,
    Lifecycle.initState: _onInit,
    Lifecycle.dispose: _onDispose,
  });
}

void _onInit(Action action, Context<BangtalboardState> ctx) {
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

  ctx.dispatch(BangtalboardActionCreator.clickFromFirebase());
}

Future _onDispose(Action action, Context<BangtalboardState> ctx) async {}

void _onAction(Action action, Context<BangtalboardState> ctx) {
  ctx.state.controller.dispose();
}

Future _clickFromFirebase(Action action, Context<BangtalboardState> ctx) async {
  var r = await Firestore.instance
      .collection('bangTalBoard')
      .orderBy('CDATE', descending: true)
      .limit(10)
      .getDocuments();
  if (r.documents.length > 0) {
    ctx.state.isLoading = false;
    ctx.dispatch(BangtalboardActionCreator.loadFromFirebase(r.documents));
  }
}

Future _loadMore(Context<BangtalboardState> ctx) async {
  var r = await Firestore.instance
      .collection('bangTalBoard')
      .orderBy('CDATE', descending: true)
      .startAfterDocument(ctx.state.data[ctx.state.data.length - 1])
      .limit(10)
      .getDocuments();

  if (r.documents.length > 0) {
    ctx.dispatch(BangtalboardActionCreator.loadFromFirebase(r.documents));
  }
//  ctx.state.isLoading = false;
  //ctx.dispatch(BangtalboardActionCreator.stopLodingbar());
}

Future _reflash(Action action, Context<BangtalboardState> ctx) async {
  var r = await Firestore.instance
      .collection('bangTalBoard')
      .orderBy('MDATE', descending: true)
      .getDocuments();
  if (r.documents.length > 0) {
    ctx.state.isLoading = false;
    ctx.dispatch(BangtalboardActionCreator.reflashFromFirebase(r.documents));
  }
}

void _createList(Action action, Context<BangtalboardState> ctx) async {
  ctx.state.animationController.value = 0;
  ctx.state.cellAnimationController.reset();
  // ctx.dispatch(BangtalboardActionCreator.onEdit(false));
  await Navigator.of(ctx.context)
      .pushNamed('bangtalCreatePage', arguments: action.payload)
      .then((d) {
    ctx.dispatch(BangtalboardActionCreator.reflash());
    //if (d != null) {
    // ctx.state.listData.data.insert(0, d);
    ctx.dispatch(BangtalboardActionCreator.reflash());
    //}
  });
}

void _detailList(Action action, Context<BangtalboardState> ctx) async {
  ctx.state.animationController.value = 0;
  ctx.state.cellAnimationController.reset();
  // ctx.dispatch(BangtalboardActionCreator.onEdit(false));
  await Navigator.of(ctx.context)
      .pushNamed('bangtalDetailPage', arguments: action.payload)
      .then((d) {
    ctx.dispatch(BangtalboardActionCreator.reflash());
    // if (d != null) {
    // ctx.state.listData.data.insert(0, d);

    //  }
  });
}
