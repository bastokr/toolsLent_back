import 'package:fish_redux/fish_redux.dart';

enum BangtalCabinetPageAction {
  action,
  uploadBackground,
  setBackground,
  setLoading,
  seThemma,
  submit,
  onAdd,
  onComplete,
  onDelete,
  joinCount,
  themaList,
  showSnackBar,
  goChat,
}

class BangtalCabinetPageActionCreator {
  static Action onAction() {
    return const Action(BangtalCabinetPageAction.action);
  }

  static Action onSubmit() {
    return const Action(BangtalCabinetPageAction.submit);
  }

  static Action onAdd() {
    return const Action(BangtalCabinetPageAction.onAdd);
  }

  static Action onDelete(String documentID) {
    return Action(BangtalCabinetPageAction.onDelete, payload: documentID);
  }

  static Action onComplete(String documentID) {
    return Action(BangtalCabinetPageAction.onComplete, payload: documentID);
  }

  static Action joinCount(String joinCount) {
    return const Action(BangtalCabinetPageAction.joinCount);
  }

  static Action themaList() {
    return const Action(BangtalCabinetPageAction.themaList);
  }

  static Action uploadBackground() {
    return const Action(BangtalCabinetPageAction.uploadBackground);
  }

  static Action setBackground(String url) {
    return Action(BangtalCabinetPageAction.setBackground, payload: url);
  }

  static Action goChat({Object d}) {
    return Action(BangtalCabinetPageAction.goChat, payload: d);
  }

  static Action setLoading(bool loading) {
    return Action(BangtalCabinetPageAction.setLoading, payload: loading);
  }

  static Action seThemma(String value) {
    return Action(BangtalCabinetPageAction.seThemma, payload: value);
  }

  static Action showSnackBar(String message) {
    return Action(BangtalCabinetPageAction.showSnackBar, payload: message);
  }
}
