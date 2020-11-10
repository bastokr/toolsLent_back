import 'package:fish_redux/fish_redux.dart';

import 'action.dart';
import 'state.dart';

Reducer<LoginState> buildReducer() {
  return asReducer(
    <Object, Reducer<LoginState>>{
      LoginAction.action: _onAction,
      LoginAction.onChangeLoding: _onChangeLoding,
    },
  );
}

LoginState _onAction(LoginState state, Action action) {
  final LoginState newState = state.clone();
  return newState;
}

bool isLoading;
LoginState _onChangeLoding(LoginState state, Action action) {
  if (isLoading == true)
    return state.clone()..isLoading = false;
  else
    return state.clone()..isLoading = false;
}
