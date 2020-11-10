import 'package:fish_redux/fish_redux.dart';

enum BangtalDetailPageAction {
  action,
  uploadBackground,
  setBackground,
  setLoading,
  submit,
  onJoin,
  onJoinDelete,
  onDelete,
  joinCount,
  themaList,
  showSnackBar,
  goChat,
}

class BangtalDetailPageActionCreator {
  static Action onAction() {
    return const Action(BangtalDetailPageAction.action);
  }

  static Action onSubmit() {
    return const Action(BangtalDetailPageAction.submit);
  }

  static Action onJoin() {
    return const Action(BangtalDetailPageAction.onJoin);
  }

  static Action onDelete({Object d}) {
    return Action(BangtalDetailPageAction.onDelete, payload: d);
  }

  static Action onJoinDelete() {
    return const Action(BangtalDetailPageAction.onJoinDelete);
  }

  static Action joinCount(String joinCount) {
    return const Action(BangtalDetailPageAction.joinCount);
  }

  static Action themaList() {
    return const Action(BangtalDetailPageAction.themaList);
  }

  static Action uploadBackground() {
    return const Action(BangtalDetailPageAction.uploadBackground);
  }

  static Action setBackground(String url) {
    return Action(BangtalDetailPageAction.setBackground, payload: url);
  }

  static Action goChat({Object d}) {
    return Action(BangtalDetailPageAction.goChat, payload: d);
  }

  static Action setLoading(bool loading) {
    return Action(BangtalDetailPageAction.setLoading, payload: loading);
  }

  static Action showSnackBar(String message) {
    return Action(BangtalDetailPageAction.showSnackBar, payload: message);
  }
}
