import 'package:fish_redux/fish_redux.dart';
import 'package:escroomtok/models/image_model.dart';
import 'package:escroomtok/models/media_account_state_model.dart';
import 'package:escroomtok/models/movie_detail.dart';
import 'package:escroomtok/models/review.dart';
import 'package:escroomtok/models/video_model.dart';
import 'package:palette_generator/palette_generator.dart';

import 'action.dart';
import 'state.dart';

Reducer<BangtalThemaPageState> buildReducer() {
  return asReducer(
    <Object, Reducer<BangtalThemaPageState>>{
      BangtalThemaPageAction.action: _onAction,
      BangtalThemaPageAction.init: _onInit,
      BangtalThemaPageAction.setbgcolor: _onSetColor,
      BangtalThemaPageAction.setImages: _onSetImages,
      BangtalThemaPageAction.setReviews: _onSetReviews,
      BangtalThemaPageAction.setVideos: _onSetVideos,
      BangtalThemaPageAction.setAccountState: _onSetAccountState
    },
  );
}

BangtalThemaPageState _onAction(BangtalThemaPageState state, Action action) {
  final BangtalThemaPageState newState = state.clone();
  return newState;
}

BangtalThemaPageState _onInit(BangtalThemaPageState state, Action action) {
  MovieDetailModel model = action.payload ?? new MovieDetailModel.fromParams();
  final BangtalThemaPageState newState = state.clone();
  newState.movieDetailModel = model;
  newState.backdropPic = model.backdropPath;
  newState.posterPic = model.posterPath;
  newState.title = model.title;
  return newState;
}

BangtalThemaPageState _onSetColor(BangtalThemaPageState state, Action action) {
  PaletteGenerator c = action.payload;
  final BangtalThemaPageState newState = state.clone();
  newState.palette = c;
  return newState;
}

BangtalThemaPageState _onSetImages(BangtalThemaPageState state, Action action) {
  ImageModel c = action.payload;
  final BangtalThemaPageState newState = state.clone();
  newState.imagesmodel = c;
  return newState;
}

BangtalThemaPageState _onSetReviews(
    BangtalThemaPageState state, Action action) {
  ReviewModel c = action.payload;
  final BangtalThemaPageState newState = state.clone();
  newState.reviewModel = c;
  return newState;
}

BangtalThemaPageState _onSetVideos(BangtalThemaPageState state, Action action) {
  VideoModel c = action.payload;
  final BangtalThemaPageState newState = state.clone();
  newState.videomodel = c;
  return newState;
}

BangtalThemaPageState _onSetAccountState(
    BangtalThemaPageState state, Action action) {
  MediaAccountStateModel c = action.payload;
  final BangtalThemaPageState newState = state.clone();
  newState.accountState = c;
  return newState;
}
