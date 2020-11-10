import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fish_redux/fish_redux.dart';

//TODO replace with your own action
enum BangtalChatListAction {
  action,
  loadMore,
  startFromFirebase,
  clickFromFirebase,
  reflash,
  loadFromFirebase,
  createList,
  detailList,
  reflashFromFirebase,
  stopLodingbar,
  goChat
}

class BangtalChatListActionCreator {
  static Action onAction() {
    return const Action(BangtalChatListAction.action);
  }

  static Action startFromFirebase() {
    return const Action(BangtalChatListAction.startFromFirebase);
  }

  static Action clickFromFirebase() {
    return Action(BangtalChatListAction.clickFromFirebase);
  }

  static Action reflash() {
    return Action(BangtalChatListAction.reflash);
  }

  static Action loadFromFirebase(List d) {
    return Action(BangtalChatListAction.loadFromFirebase, payload: d);
  }

  static Action createList({Object d}) {
    return Action(BangtalChatListAction.createList, payload: d);
  }

  static Action detailList({Object d}) {
    return Action(BangtalChatListAction.detailList, payload: d);
  }

  static Action stopLodingbar() {
    return Action(BangtalChatListAction.stopLodingbar);
  }

  static Action reflashFromFirebase(List d) {
    return Action(BangtalChatListAction.reflashFromFirebase, payload: d);
  }

  static Action goChat({Object d}) {
    return Action(BangtalChatListAction.goChat, payload: d);
  }
}
