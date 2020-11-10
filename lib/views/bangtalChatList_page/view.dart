import 'package:fish_redux/fish_redux.dart';
import 'package:flutter/material.dart';
import 'package:escroomtok/actions/adapt.dart';
import 'package:escroomtok/style/themestyle.dart';

import 'action.dart';
import 'state.dart';

Widget buildView(
    BangtalChatListState state, Dispatch dispatch, ViewService viewService) {
  // final _adapter = viewService.buildAdapter();
  final _adapter = viewService.buildAdapter();
  return Builder(builder: (context) {
    final ThemeData _theme = ThemeStyle.getTheme(context);
    return Scaffold(
        appBar: AppBar(
          brightness: _theme.brightness,
          backgroundColor: _theme.bottomAppBarColor,
          elevation: 0.0,
          iconTheme: _theme.iconTheme,
          title: Text('방탈출 채팅방',
              style: TextStyle(color: _theme.primaryColorLight)),
          actions: <Widget>[
            Padding(
                padding: const EdgeInsets.all(10.0),
                child: FlatButton(
                    color: _theme.indicatorColor,
                    textColor: Colors.white,
                    disabledColor: Colors.grey,
                    disabledTextColor: Colors.black,
                    padding: EdgeInsets.all(8.0),
                    splashColor: Colors.blueAccent,
                    onPressed: () =>
                        dispatch(BangtalChatListActionCreator.createList()),
                    child: Text('등록하기',
                        style: TextStyle(
                          color: _theme.primaryColorLight,
                        ))))
          ],
        ),
        body: RefreshIndicator(
          onRefresh: () => dispatch(BangtalChatListActionCreator.reflash()),
          child: CustomScrollView(
            key: ValueKey(state.hashCode),
            physics: BouncingScrollPhysics(),
            controller: state.controller,
            slivers: <Widget>[
              //  viewService.buildComponent('filter'),
              //_Refreshing(refreshController: state.refreshController),
              SliverToBoxAdapter(
                child: SizedBox(height: Adapt.px(20)),
              ),
              SliverList(
                delegate: SliverChildBuilderDelegate((ctx, index) {
                  return _adapter.itemBuilder(ctx, index);
                }, childCount: _adapter.itemCount),
              ),
              //   if (state.isLoading) _Loading(),
            ],
          ),
        ));
  });
}

class _Refreshing extends StatelessWidget {
  final AnimationController refreshController;
  const _Refreshing({this.refreshController});
  @override
  Widget build(BuildContext context) {
    return SliverToBoxAdapter(
      child: FadeTransition(
        opacity: Tween<double>(begin: 0.0, end: 1.0).animate(CurvedAnimation(
          parent: refreshController,
          curve: Curves.ease,
        )),
        child: SizedBox(
          height: Adapt.px(5),
          child: LinearProgressIndicator(
            backgroundColor: Colors.white,
            valueColor: AlwaysStoppedAnimation<Color>(Color(0xFF505050)),
          ),
        ),
      ),
    );
  }
}

class _Loading extends StatelessWidget {
  const _Loading();
  @override
  Widget build(BuildContext context) {
    final ThemeData _theme = ThemeStyle.getTheme(context);
    return SliverToBoxAdapter(
      child: Container(
        padding: EdgeInsets.only(bottom: Adapt.px(10)),
        alignment: Alignment.center,
        child: CircularProgressIndicator(
          valueColor: AlwaysStoppedAnimation<Color>(_theme.iconTheme.color),
        ),
      ),
    );
  }
}
