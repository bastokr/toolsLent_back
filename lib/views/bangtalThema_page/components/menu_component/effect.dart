import 'package:fish_redux/fish_redux.dart';
import 'package:escroomtok/models/enums/media_type.dart';
import 'package:escroomtok/views/bangtalThema_page/action.dart';
import 'action.dart';
import 'state.dart';

Effect<MenuState> buildEffect() {
  return combineEffects(<Object, Effect<MenuState>>{
    MenuAction.action: _onAction,
    MenuAction.setRating: _setRating,
    MenuAction.setFavorite: _setFavorite,
    MenuAction.setWatchlist: _setWatchlist
  });
}

void _onAction(Action action, Context<MenuState> ctx) {}

Future _setRating(Action action, Context<MenuState> ctx) async {
  ctx.dispatch(MenuActionCreator.updateRating(action.payload));
}

Future _setFavorite(Action action, Context<MenuState> ctx) async {
  final bool f = action.payload;
  ctx.dispatch(MenuActionCreator.updateFavorite(f));
}

Future _setWatchlist(Action action, Context<MenuState> ctx) async {
  final bool f = action.payload;
  ctx.dispatch(MenuActionCreator.updateWatctlist(f));
}
