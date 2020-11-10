import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fish_redux/fish_redux.dart';
import 'package:escroomtok/models/video_list.dart';
import 'package:escroomtok/views/home_page/state.dart';

class SwiperState implements Cloneable<SwiperState> {
  VideoListModel movie;
  VideoListModel tv;
  List<DocumentSnapshot> banktaltok;
  List<DocumentSnapshot> banktalNewThema;
  bool showHeaderMovie;
  @override
  SwiperState clone() {
    return SwiperState();
  }
}

class SwiperConnector extends ConnOp<HomePageState, SwiperState> {
  @override
  SwiperState get(HomePageState state) {
    SwiperState mstate = SwiperState();
    mstate.movie = state.movie;
    mstate.tv = state.tv;
    mstate.banktaltok = state.banktaltok;
    mstate.banktalNewThema = state.banktalNewThema;

    mstate.showHeaderMovie = state.showHeaderMovie;
    return mstate;
  }
}
