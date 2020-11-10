import 'package:fish_redux/fish_redux.dart';

enum BangtalCreatePageAction {
  action,
  uploadBackground,
  setBackground,
  setLoading,
  seThemma,
  submit,
  themaList,
  setJoincountTotal,
  showSnackBar
}

class BangtalCreatePageActionCreator {
  static Action onAction() {
    return const Action(BangtalCreatePageAction.action);
  }

  static Action onSubmit() {
    return const Action(BangtalCreatePageAction.submit);
  }

  static Action themaList() {
    return const Action(BangtalCreatePageAction.themaList);
  }

  static Action uploadBackground() {
    return const Action(BangtalCreatePageAction.uploadBackground);
  }

  static Action setBackground(String url) {
    return Action(BangtalCreatePageAction.setBackground, payload: url);
  }

  static Action setLoading(bool loading) {
    return Action(BangtalCreatePageAction.setLoading, payload: loading);
  }

  static Action seThemma(String value) {
    return Action(BangtalCreatePageAction.seThemma, payload: value);
  }

  static Action setJoincountTotal(String value) {
    return Action(BangtalCreatePageAction.setJoincountTotal, payload: value);
  }

  static Action showSnackBar(String message) {
    return Action(BangtalCreatePageAction.showSnackBar, payload: message);
  }
}
