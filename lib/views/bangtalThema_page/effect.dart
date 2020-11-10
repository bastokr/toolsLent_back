import 'package:fish_redux/fish_redux.dart';
import 'package:flutter/material.dart' hide Action;
import 'package:flutter/widgets.dart' hide Action;
import 'action.dart';
import 'state.dart';

Effect<BangtalThemaPageState> buildEffect() {
  return combineEffects(<Object, Effect<BangtalThemaPageState>>{
    BangtalThemaPageAction.action: _onAction,
    BangtalThemaPageAction.openMenu: _openMenu,
    BangtalThemaPageAction.showSnackBar: _showSnackBar,
    Lifecycle.initState: _onInit,
  });
}

void _onAction(Action action, Context<BangtalThemaPageState> ctx) {}

Future _onInit(Action action, Context<BangtalThemaPageState> ctx) async {
  try {
    final Object ticker = ctx.stfState;
    ctx.state.animationController = AnimationController(
        vsync: ticker, duration: Duration(milliseconds: 1000));
    ctx.state.scrollController = new ScrollController();
    /*var paletteGenerator = await PaletteGenerator.fromImageProvider(
         CachedNetworkImageProvider(ImageUrl.getUrl(ctx.state.posterPic, ImageSize.w300)));
      ctx.dispatch(BangtalThemaPageActionCreator.onsetColor(paletteGenerator));*/
    ctx.state.animationController.forward();
  } on Exception catch (_) {}
}

Future _onRecommendationTapped() {}

Future _onCastCellTapped() {}

void _openMenu(Action action, Context<BangtalThemaPageState> ctx) {
  showModalBottomSheet(
      context: ctx.context,
      backgroundColor: Colors.transparent,
      builder: (context) {
        return ctx.buildComponent('menu');
      });
}

void _showSnackBar(Action action, Context<BangtalThemaPageState> ctx) {
  ctx.state.scaffoldkey.currentState.showSnackBar(SnackBar(
    content: Text(action.payload ?? ''),
  ));
}
