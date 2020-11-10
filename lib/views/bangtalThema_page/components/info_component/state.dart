import 'package:fish_redux/fish_redux.dart';
import 'package:escroomtok/models/movie_detail.dart';

import '../../state.dart';

class InfoState implements Cloneable<InfoState> {
  MovieDetailModel movieDetailModel;

  @override
  InfoState clone() {
    return InfoState();
  }
}

class InfoConnector extends ConnOp<BangtalThemaPageState, InfoState> {
  @override
  InfoState get(BangtalThemaPageState state) {
    InfoState substate = new InfoState();
    substate.movieDetailModel = state.movieDetailModel;
    return substate;
  }
}
