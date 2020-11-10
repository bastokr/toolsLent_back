import 'package:fish_redux/fish_redux.dart';

enum BangtalChatPageAction {
  action,
  uploadBackground,
  setBackground,
  setLoading,
  submit,
  themaList,
  showSnackBar
}

class BangtalChatPageActionCreator {
  static Action onAction() {
    return const Action(BangtalChatPageAction.action);
  }

  static Action onSubmit() {
    return const Action(BangtalChatPageAction.submit);
  }

  static Action themaList() {
    return const Action(BangtalChatPageAction.themaList);
  }

  static Action uploadBackground() {
    return const Action(BangtalChatPageAction.uploadBackground);
  }

  static Action setBackground(String url) {
    return Action(BangtalChatPageAction.setBackground, payload: url);
  }

  static Action setLoading(bool loading) {
    return Action(BangtalChatPageAction.setLoading, payload: loading);
  }

  static Action showSnackBar(String message) {
    return Action(BangtalChatPageAction.showSnackBar, payload: message);
  }
}
