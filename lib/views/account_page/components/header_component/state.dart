import 'package:fish_redux/fish_redux.dart';
import 'package:escroomtok/models/app_user.dart';
import 'package:escroomtok/views/account_page/state.dart';

class HeaderState implements Cloneable<HeaderState> {
  AppUser user;
  @override
  HeaderState clone() {
    return HeaderState();
  }
}

class HeaderConnector extends ConnOp<AccountPageState, HeaderState> {
  @override
  HeaderState get(AccountPageState state) {
    HeaderState substate = new HeaderState();
    substate.user = state.user;
    return substate;
  }
}
