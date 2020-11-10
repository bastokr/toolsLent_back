import 'package:fish_redux/fish_redux.dart';

import 'action.dart';
import 'state.dart';

Reducer<BangtalDetailState> buildReducer() {
  return asReducer(
    <Object, Reducer<BangtalDetailState>>{
      BangtalDetailPageAction.action: _onAction,
      BangtalDetailPageAction.setBackground: _setBackground,
      BangtalDetailPageAction.setLoading: _setLoading,
    },
  );
}

BangtalDetailState _onAction(BangtalDetailState state, Action action) {
  final BangtalDetailState newState = state.clone();
  return newState;
}

BangtalDetailState _setBackground(BangtalDetailState state, Action action) {
  final String _url = action.payload;
  final BangtalDetailState newState = state.clone();
  newState.backGroundUrl = _url;
  return newState;
}

BangtalDetailState _setLoading(BangtalDetailState state, Action action) {
  final bool _loading = action.payload;
  final BangtalDetailState newState = state.clone();
  print("selectThemaName2=" + newState.selectThemaName);
  newState.loading = _loading;
  return newState;
}
