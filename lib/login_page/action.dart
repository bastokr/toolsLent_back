import 'package:fish_redux/fish_redux.dart';
import 'package:google_sign_in/google_sign_in.dart';

//TODO replace with your own action
enum LoginAction { action, handleSignIn, onChangeLoding, onHomeScreen }

class LoginActionCreator {
  static Action onAction() {
    return const Action(LoginAction.action);
  }

  static Action handleSignInAction() {
    return const Action(LoginAction.handleSignIn);
  }

  static Action onLodingAction() {
    return const Action(LoginAction.onChangeLoding);
  }

  static Action onHomeScreen() {
    return const Action(LoginAction.onHomeScreen);
  }
}
