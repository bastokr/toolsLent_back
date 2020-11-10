import 'package:fish_redux/fish_redux.dart';

import 'action.dart';
import 'state.dart';

Reducer<BangtalCreateState> buildReducer() {
  return asReducer(
    <Object, Reducer<BangtalCreateState>>{
      BangtalCreatePageAction.action: _onAction,
      BangtalCreatePageAction.setBackground: _setBackground,
      BangtalCreatePageAction.setLoading: _setLoading,
      BangtalCreatePageAction.seThemma: _seThemma,
      BangtalCreatePageAction.setJoincountTotal: _setJoincountTotal
    },
  );
}

BangtalCreateState _onAction(BangtalCreateState state, Action action) {
  final BangtalCreateState newState = state.clone();
  return newState;
}

BangtalCreateState _setBackground(BangtalCreateState state, Action action) {
  final String _url = action.payload;
  final BangtalCreateState newState = state.clone();
  newState.backGroundUrl = _url;
  return newState;
}

BangtalCreateState _setLoading(BangtalCreateState state, Action action) {
  final bool _loading = action.payload;
  final BangtalCreateState newState = state.clone();
  print("selectThemaName2=" + newState.selectThemaName);
  newState.loading = _loading;
  return newState;
}

BangtalCreateState _seThemma(BangtalCreateState state, Action action) {
  final String _thema = action.payload;
  final BangtalCreateState newState = state.clone();
  print("selectThemaName2=" + newState.selectThemaName);
  newState.selectThemaName = _thema;
  return newState;
}

BangtalCreateState _setJoincountTotal(BangtalCreateState state, Action action) {
  final String _joincountTotal = action.payload;
  final BangtalCreateState newState = state.clone();
  print("selectThemaName2=" + newState.joincountTotal);
  newState.joincountTotal = _joincountTotal;
  return newState;
}
