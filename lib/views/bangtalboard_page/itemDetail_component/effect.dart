import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fish_redux/fish_redux.dart';
import 'package:flutter/cupertino.dart' hide Action, Page;
import 'action.dart';
import 'state.dart';

Effect<ItemDetailState> buildEffect() {
  return combineEffects(<Object, Effect<ItemDetailState>>{
    ItemDetailAction.action: _onAction,
    ItemDetailAction.detailList: _detailList,
    ItemDetailAction.reflash: _reflash,
  });
}

void _onAction(Action action, Context<ItemDetailState> ctx) {}

void _detailList(Action action, Context<ItemDetailState> ctx) async {
  ctx.state.animationController.value = 0;
  ctx.state.cellAnimationController.reset();
  // ctx.dispatch(BangtalboardActionCreator.onEdit(false));
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
      .orderBy('MDATE', descending: true)
      .getDocuments();
  if (r.documents.length > 0) {
    //ctx.state.isLoading = false;
    ctx.dispatch(ItemDetailActionCreator.reflashFromFirebase(r.documents));
  }
}
