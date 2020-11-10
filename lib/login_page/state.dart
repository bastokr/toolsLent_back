import 'package:fish_redux/fish_redux.dart';
import 'package:escroomtok/models/app_user.dart';

class LoginState implements Cloneable<LoginState> {
  bool isLoading = false;
  AppUser user;

  @override
  LoginState clone() {
    return LoginState();
  }
}

LoginState initState(Map<String, dynamic> args) {
  return LoginState();
}
