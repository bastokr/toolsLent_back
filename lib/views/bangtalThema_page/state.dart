import 'dart:math';
import 'dart:ui';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fish_redux/fish_redux.dart';
import 'package:flutter/material.dart';
import 'package:escroomtok/globalbasestate/state.dart';
import 'package:escroomtok/models/app_user.dart';
import 'package:escroomtok/models/image_model.dart';
import 'package:escroomtok/models/media_account_state_model.dart';
import 'package:escroomtok/models/movie_detail.dart';
import 'package:escroomtok/models/review.dart';
import 'package:escroomtok/models/video_model.dart';
import 'package:palette_generator/palette_generator.dart';

class BangtalThemaPageState
    implements GlobalBaseState, Cloneable<BangtalThemaPageState> {
  GlobalKey<ScaffoldState> scaffoldkey;
  MovieDetailModel movieDetailModel;
  String backdropPic;
  String title;
  String posterPic;
  int movieid;
  Color mainColor;
  Color tabTintColor;
  PaletteGenerator palette;
  ImageModel imagesmodel;
  ReviewModel reviewModel;
  VideoModel videomodel;
  ScrollController scrollController;
  MediaAccountStateModel accountState;
  AnimationController animationController;
  DocumentSnapshot document;
  @override
  BangtalThemaPageState clone() {
    return BangtalThemaPageState()
      ..scaffoldkey = scaffoldkey
      ..movieDetailModel = movieDetailModel
      ..mainColor = mainColor
      ..tabTintColor = tabTintColor
      ..palette = palette
      ..movieid = movieid
      ..reviewModel = reviewModel
      ..imagesmodel = imagesmodel
      ..videomodel = videomodel
      ..backdropPic = backdropPic
      ..posterPic = posterPic
      ..title = title
      ..scrollController = scrollController
      ..accountState = accountState
      ..document = document
      ..animationController = animationController;
  }

  @override
  Color themeColor = Colors.black;

  @override
  Locale locale;

  @override
  AppUser user;
}

BangtalThemaPageState initState(Map<String, dynamic> args) {
  Random random = new Random(DateTime.now().millisecondsSinceEpoch);
  var state = BangtalThemaPageState();
  state.scaffoldkey = GlobalKey<ScaffoldState>();
  state.document = args['document'];
  state.movieDetailModel = new MovieDetailModel.fromParams();
  state.mainColor = Color.fromRGBO(
      random.nextInt(200), random.nextInt(100), random.nextInt(255), 1);
  state.tabTintColor = Color.fromRGBO(
      random.nextInt(200), random.nextInt(100), random.nextInt(255), 1);
  state.palette = new PaletteGenerator.fromColors(
      List<PaletteColor>()..add(new PaletteColor(Colors.black87, 0)));
  state.imagesmodel = new ImageModel.fromParams(
      posters: List<ImageData>(), backdrops: List<ImageData>());
  state.reviewModel = new ReviewModel.fromParams(results: List<ReviewResult>());
  state.videomodel = new VideoModel.fromParams(results: List<VideoResult>());
  state.accountState =
      new MediaAccountStateModel.fromParams(favorite: false, watchlist: false);
  return state;
}
