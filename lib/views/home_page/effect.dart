import 'package:escroomtok/views/views.dart';
import 'package:fish_redux/fish_redux.dart';
import 'package:flutter/material.dart' hide Action, Page;
import 'package:escroomtok/routes/routes.dart';
import 'package:escroomtok/widgets/searchbar_delegate.dart';
import 'package:escroomtok/models/enums/media_type.dart';
import 'package:escroomtok/models/enums/time_window.dart';
import 'action.dart';
import 'state.dart';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:fish_redux/fish_redux.dart';
import 'package:flutter/cupertino.dart' hide Action, Page;
import 'package:google_sign_in/google_sign_in.dart';

Effect<HomePageState> buildEffect() {
  return combineEffects(<Object, Effect<HomePageState>>{
    HomePageAction.action: _onAction,
    HomePageAction.moreTapped: _moreTapped,
    HomePageAction.searchBarTapped: _onSearchBarTapped,
    HomePageAction.cellTapped: _onCellTapped,
    HomePageAction.trendingMore: _trendingMore,
    HomePageAction.onCellTappedThema: _onCellTappedThema,
    Lifecycle.initState: _onInit,
    Lifecycle.dispose: _onDispose,
  });
}

void _onAction(Action action, Context<HomePageState> ctx) {}

Future _onInit(Action action, Context<HomePageState> ctx) async {
  final Object ticker = ctx.stfState;
  ctx.state.animatedController =
      AnimationController(vsync: ticker, duration: Duration(milliseconds: 600));

  ctx.state.scrollController = new ScrollController();

  final _bangtaktok = await Firestore.instance
      .collection('bangTalCafeThema')
      //.where("star", isGreaterThanOrEqualTo: 9)
      .orderBy('star', descending: true)
      .limit(20)
      .getDocuments();
//  if (_bangtaktok.documents.length > 0)
  ctx.dispatch(HomePageActionCreator.onInitBangTaktok(_bangtaktok.documents));

  final _banktalNewThema = await Firestore.instance
      .collection('bangTalCafeThema')
      .orderBy('cdate', descending: true)
      .limit(20)
      .getDocuments();
  if (_banktalNewThema.documents.length > 0)
    ctx.dispatch(HomePageActionCreator.onInitBangTakNewThema(
        _banktalNewThema.documents));

  final _boardList = await Firestore.instance
      .collection('bangTalBoard')
      .orderBy('CDATE', descending: true)
      .limit(10)
      .getDocuments();

  if (_boardList.documents.length > 0)
    ctx.dispatch(HomePageActionCreator.onInitBoardList(_boardList.documents));
  /*
  final _tmdb = TMDBApi.instance;
  final _baseApi = BaseApi.instance;
  final _movies = await _tmdb.getNowPlayingMovie();

  if (_movies.success)
    ctx.dispatch(HomePageActionCreator.onInitMovie(_movies.result));
 
  final _tv = await _tmdb.getTVOnTheAir();
  if (_tv.success) ctx.dispatch(HomePageActionCreator.onInitTV(_tv.result));
   
  final _trending = await _tmdb.getTrending(MediaType.all, TimeWindow.day);
  if (_trending.success)
    ctx.dispatch(HomePageActionCreator.initTrending(_trending.result));
  final _shareMovie = await _baseApi.getMovies(pageSize: 10);
  if (_shareMovie.success)
    ctx.dispatch(HomePageActionCreator.initShareMovies(_shareMovie.result));
  final _sharetv = await _baseApi.getTvShows(pageSize: 10);
  if (_sharetv.success)
    ctx.dispatch(HomePageActionCreator.initShareTvShows(_sharetv.result));
  final _popMovie = await _tmdb.getPopularMovies();
  if (_popMovie.success)
    ctx.dispatch(HomePageActionCreator.onInitPopularMovie(_popMovie.result));
  final _popTv = await _tmdb.getPopularTVShows();
  if (_popTv.success)
    ctx.dispatch(HomePageActionCreator.onInitPopularTV(_popTv.result));
    */
}

void _onDispose(Action action, Context<HomePageState> ctx) {
  ctx.state.animatedController.dispose();
  ctx.state.scrollController.dispose();
}

Future _moreTapped(Action action, Context<HomePageState> ctx) async {
  await Navigator.of(ctx.context).pushNamed('MoreMediaPage',
      arguments: {'list': action.payload[0], 'type': action.payload[1]});
}

Future _onSearchBarTapped(Action action, Context<HomePageState> ctx) async {
  await showSearch(context: ctx.context, delegate: SearchBarDelegate());
}

Future _onCellTapped(Action action, Context<HomePageState> ctx) async {
  final MediaType type = action.payload[4];
  final String id = action.payload[0];
  final String bgpic = action.payload[1];
  final String title = action.payload[2];
  final String posterpic = action.payload[3];
  final String pagename =
      type == MediaType.movie ? 'bangtalThemaPage' : 'tvShowDetailPage';
  var data = {
    'id': id,
    'bgpic': type == MediaType.movie ? posterpic : bgpic,
    'name': title,
    'posterpic': posterpic
  };
  Page page = BangtalThemaPage();
  await Navigator.of(ctx.context).push(PageRouteBuilder(
      settings: RouteSettings(name: pagename),
      pageBuilder: (context, animation, secAnimation) {
        return FadeTransition(
          opacity: animation,
          child: page.buildPage(data),
        );
      }));
  //await Navigator.of(ctx.context).pushNamed(pagename, arguments: data);
}

Future _onCellTappedThema(Action action, Context<HomePageState> ctx) async {
  final DocumentSnapshot document = action.payload[0];
  var data = {
    'document': document,
  };
  await Navigator.of(ctx.context).push(PageRouteBuilder(
      settings: RouteSettings(name: 'bangtalThemaPage'),
      pageBuilder: (context, animation, secAnimation) {
        return FadeTransition(
          opacity: animation,
          child: BangtalThemaPage().buildPage(data),
        );
      }));
  //await Navigator.of(ctx.context).pushNamed(pagename, arguments: data);
}

Future _trendingMore(Action action, Context<HomePageState> ctx) async {
  await Navigator.of(ctx.context)
      .push(PageRouteBuilder(pageBuilder: (context, animation, secAnimation) {
    return FadeTransition(
      opacity: animation,
      child:
          Routes.routes.buildPage('trendingPage', {'data': ctx.state.trending}),
    );
  }));
}
