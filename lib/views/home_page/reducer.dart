import 'package:fish_redux/fish_redux.dart';
import 'package:escroomtok/models/base_api_model/base_movie.dart';
import 'package:escroomtok/models/base_api_model/base_tvshow.dart';
import 'package:escroomtok/models/search_result.dart';
import 'package:escroomtok/models/video_list.dart';

import 'action.dart';
import 'state.dart';

Reducer<HomePageState> buildReducer() {
  return asReducer(
    <Object, Reducer<HomePageState>>{
      HomePageAction.action: _onAction,
      HomePageAction.initMovie: _onInitMovie,
      HomePageAction.initescroomtok: _onInitescroomtok,
      HomePageAction.initBangTalNewThema: _onInitBangTakNewThema,
      HomePageAction.initTV: _onInitTV,
      HomePageAction.initPopularMovies: _onInitPopularMovie,
      HomePageAction.initPopularTVShows: _onInitPopularTVShows,
      HomePageAction.initTrending: _onInitTrending,
      HomePageAction.initShareMovies: _onInitShareMovies,
      HomePageAction.initShareTvShows: _onInitShareTvShows,
      HomePageAction.initBoardList: _onInitBoardList,
    },
  );
}

HomePageState _onAction(HomePageState state, Action action) {
  final HomePageState newState = state.clone();
  return newState;
}

HomePageState _onInitShareMovies(HomePageState state, Action action) {
  final BaseMovieModel d = action.payload;
  final HomePageState newState = state.clone();
  newState.shareMovies = d;
  return newState;
}

HomePageState _onInitShareTvShows(HomePageState state, Action action) {
  final BaseTvShowModel d = action.payload;
  final HomePageState newState = state.clone();
  newState.shareTvshows = d;
  return newState;
}

HomePageState _onInitMovie(HomePageState state, Action action) {
  final VideoListModel model = action.payload ?? null;
  final HomePageState newState = state.clone();
  newState.movie = model;
  return newState;
}

HomePageState _onInitescroomtok(HomePageState state, Action action) {
  final List model = action.payload ?? null;
  final HomePageState newState = state.clone();
  newState.banktaltok = model;
  return newState;
}

HomePageState _onInitBoardList(HomePageState state, Action action) {
  final List model = action.payload ?? null;
  final HomePageState newState = state.clone();
  newState.boardList = model;
  return newState;
}

HomePageState _onInitBangTakNewThema(HomePageState state, Action action) {
  final List model = action.payload ?? null;
  final HomePageState newState = state.clone();
  newState.banktalNewThema = model;
  return newState;
}

HomePageState _onInitTV(HomePageState state, Action action) {
  final VideoListModel model = action.payload ?? null;
  final HomePageState newState = state.clone();
  newState.tv = model;
  return newState;
}

HomePageState _onInitPopularMovie(HomePageState state, Action action) {
  final VideoListModel model = action.payload ?? null;
  final HomePageState newState = state.clone();
  newState.popularMovies = model;
  return newState;
}

HomePageState _onInitPopularTVShows(HomePageState state, Action action) {
  final VideoListModel model = action.payload ?? null;
  final HomePageState newState = state.clone();
  newState.popularTVShows = model;
  return newState;
}

HomePageState _onInitTrending(HomePageState state, Action action) {
  final SearchResultModel model = action.payload ?? null;
  final HomePageState newState = state.clone();
  newState.trending = model;
  return newState;
}
