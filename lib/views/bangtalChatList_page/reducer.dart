import 'package:fish_redux/fish_redux.dart';

import 'action.dart';
import 'state.dart';

Reducer<BangtalChatListState> buildReducer() {
  return asReducer(
    <Object, Reducer<BangtalChatListState>>{
      BangtalChatListAction.action: _onAction,
      BangtalChatListAction.loadFromFirebase: _loadFromFirebase,
      BangtalChatListAction.reflashFromFirebase: _reflashFromFirebase,
      BangtalChatListAction.stopLodingbar: _stopLodingbar,
    },
  );
}

BangtalChatListState _onAction(BangtalChatListState state, Action action) {
  final BangtalChatListState newState = state.clone();
  return newState;
}

BangtalChatListState _loadFromFirebase(
    BangtalChatListState state, Action action) {
  final List _model = action.payload;
  final BangtalChatListState newState = state.clone();

  if (_model != null) {
    newState.data.addAll(_model);
  }

  return newState;
}

BangtalChatListState _reflashFromFirebase(
    BangtalChatListState state, Action action) {
  final List _model = action.payload;
  final BangtalChatListState newState = state.clone();
  newState.data = [];
  if (_model != null) {
    newState.data.addAll(_model);
  }

  return newState;
}

BangtalChatListState _stopLodingbar(BangtalChatListState state, Action action) {
  final BangtalChatListState newState = state.clone();
  // newState.isLoading = false;
  return newState;
}
