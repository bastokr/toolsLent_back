import 'package:fish_redux/fish_redux.dart';

import 'action.dart';
import '../state.dart';

Reducer<BangtalChatListState> buildReducer() {
  return asReducer(
    <Object, Reducer<BangtalChatListState>>{
      AdapterAction.action: _onAction,
    },
  );
}

BangtalChatListState _onAction(BangtalChatListState state, Action action) {
  final BangtalChatListState newState = state.clone();
  return newState;
}
