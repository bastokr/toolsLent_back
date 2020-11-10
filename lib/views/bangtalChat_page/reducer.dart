import 'package:fish_redux/fish_redux.dart';

import 'action.dart';
import 'state.dart';

Reducer<BangtalChatState> buildReducer() {
  return asReducer(
    <Object, Reducer<BangtalChatState>>{
      BangtalChatPageAction.action: _onAction,
      BangtalChatPageAction.setBackground: _setBackground,
      BangtalChatPageAction.setLoading: _setLoading,
    },
  );
}

BangtalChatState _onAction(BangtalChatState state, Action action) {
  final BangtalChatState newState = state.clone();
  return newState;
}

BangtalChatState _setBackground(BangtalChatState state, Action action) {
  final String _url = action.payload;
  final BangtalChatState newState = state.clone();
  newState.backGroundUrl = _url;
  return newState;
}

BangtalChatState _setLoading(BangtalChatState state, Action action) {
  final bool _loading = action.payload;
  final BangtalChatState newState = state.clone();
  print("selectThemaName2=" + newState.selectThemaName);
  newState.loading = _loading;
  return newState;
}
