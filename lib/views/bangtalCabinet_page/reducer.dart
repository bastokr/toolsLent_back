import 'package:fish_redux/fish_redux.dart';

import 'action.dart';
import 'state.dart';

Reducer<BangtalCabinetState> buildReducer() {
  return asReducer(
    <Object, Reducer<BangtalCabinetState>>{
      BangtalCabinetPageAction.action: _onAction,
      BangtalCabinetPageAction.setBackground: _setBackground,
      BangtalCabinetPageAction.setLoading: _setLoading,
      BangtalCabinetPageAction.seThemma: _seThemma,
    },
  );
}

BangtalCabinetState _onAction(BangtalCabinetState state, Action action) {
  final BangtalCabinetState newState = state.clone();
  return newState;
}

BangtalCabinetState _setBackground(BangtalCabinetState state, Action action) {
  final String _url = action.payload;
  final BangtalCabinetState newState = state.clone();
  newState.backGroundUrl = _url;
  return newState;
}

BangtalCabinetState _setLoading(BangtalCabinetState state, Action action) {
  final bool _loading = action.payload;
  final BangtalCabinetState newState = state.clone();
  print("selectThemaName2=" + newState.selectThemaName);
  newState.loading = _loading;
  return newState;
}

BangtalCabinetState _seThemma(BangtalCabinetState state, Action action) {
  final String _thema = action.payload;
  final BangtalCabinetState newState = state.clone();
  print("selectThemaName2=" + newState.selectThemaName);
  newState.selectThemaName = _thema;
  return newState;
}
