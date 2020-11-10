import 'package:escroomtok/actions/pop_result.dart';
import 'package:escroomtok/routes/routes.dart';
import 'package:escroomtok/views/main_page/action.dart';
//import 'package:escroomtok/views/register_page/page.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fish_redux/fish_redux.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:escroomtok/actions/adapt.dart';
import 'package:escroomtok/actions/imageurl.dart';
import 'package:escroomtok/generated/i18n.dart';
import 'package:escroomtok/models/enums/imagesize.dart';
import 'package:escroomtok/models/video_list.dart';
import 'package:escroomtok/style/themestyle.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:parallax_image/parallax_image.dart';
import 'package:shimmer/shimmer.dart';

import 'action.dart';
import 'state.dart';

Widget buildView(
    PopularPosterState state, Dispatch dispatch, ViewService viewService) {
  return Column(
    children: <Widget>[
      _FrontTitel(
        showMovie: state.showmovie,
        dispatch: dispatch,
      ),
      SizedBox(height: Adapt.px(30)),
      for (int i = 0; i < state.boardList.length; i++)
        (_Boarditem(index: i, boardList: state.boardList)),
    ],
  );
}

class _ShimmerCell extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: Adapt.px(250),
      height: Adapt.px(350),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Container(
            width: Adapt.px(250),
            height: Adapt.px(350),
            decoration: BoxDecoration(
              color: const Color(0xFFEEEEEE),
              borderRadius: BorderRadius.circular(Adapt.px(15)),
            ),
          ),
          SizedBox(
            height: Adapt.px(20),
          ),
          Container(
            width: Adapt.px(220),
            height: Adapt.px(30),
            color: const Color(0xFFEEEEEE),
          )
        ],
      ),
    );
  }
}

class _ShimmerList extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final ThemeData _theme = ThemeStyle.getTheme(context);
    return Shimmer.fromColors(
        baseColor: _theme.primaryColorDark,
        highlightColor: _theme.primaryColorLight,
        child: ListView.separated(
          scrollDirection: Axis.horizontal,
          padding: EdgeInsets.symmetric(horizontal: Adapt.px(30)),
          separatorBuilder: (_, __) => SizedBox(width: Adapt.px(30)),
          itemCount: 4,
          itemBuilder: (_, __) => _ShimmerCell(),
        ));
  }
}

class _Cell extends StatelessWidget {
  final VideoListResult data;
  final Function onTap;
  const _Cell({@required this.data, this.onTap});

  @override
  Widget build(BuildContext context) {
    final ThemeData _theme = ThemeStyle.getTheme(context);
    return GestureDetector(
      key: ValueKey(data.id),
      onTap: onTap,
      child: Column(
        children: <Widget>[
          Container(
            width: Adapt.px(250),
            height: Adapt.px(350),
            decoration: BoxDecoration(
              color: _theme.primaryColorDark,
              borderRadius: BorderRadius.circular(Adapt.px(15)),
              image: DecorationImage(
                fit: BoxFit.cover,
                image: CachedNetworkImageProvider(
                  ImageUrl.getUrl(data.posterPath, ImageSize.w400),
                ),
              ),
            ),
          ),
          Container(
            //alignment: Alignment.bottomCenter,
            width: Adapt.px(250),
            padding: EdgeInsets.all(Adapt.px(10)),
            child: Text(
              data.title ?? data.name,
              maxLines: 2,
              //textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: Adapt.px(28),
                fontWeight: FontWeight.bold,
              ),
            ),
          )
        ],
      ),
    );
  }
}

class _MoreCell extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final ThemeData _theme = ThemeStyle.getTheme(context);
    return Column(
      children: <Widget>[
        Container(
          decoration: BoxDecoration(
            color: _theme.primaryColorLight,
            borderRadius: BorderRadius.circular(Adapt.px(15)),
          ),
          width: Adapt.px(250),
          height: Adapt.px(350),
          child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Text(
                  I18n.of(context).more,
                  style: TextStyle(fontSize: Adapt.px(35)),
                ),
                Icon(Icons.arrow_forward, size: Adapt.px(35))
              ]),
        )
      ],
    );
  }
}

class _FrontTitel extends StatelessWidget {
  final bool showMovie;
  final Dispatch dispatch;
  const _FrontTitel({this.showMovie, this.dispatch});
  @override
  Widget build(BuildContext context) {
    final TextStyle _selectPopStyle = TextStyle(
      fontSize: Adapt.px(24),
      fontWeight: FontWeight.bold,
    );

    final TextStyle _unselectPopStyle =
        TextStyle(fontSize: Adapt.px(24), color: const Color(0xFF9E9E9E));
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: Adapt.px(30)),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.end,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[
          Text(
            "구인게시판",
            style:
                TextStyle(fontSize: Adapt.px(35), fontWeight: FontWeight.bold),
          ),
          Row(
            children: <Widget>[
              GestureDetector(
                onTap: () =>
                    Navigator.pushReplacementNamed(context, 'bangtalboardPage'),

                // final pageController = PageController();
                child: Text('더보기',
                    style: showMovie ? _selectPopStyle : _unselectPopStyle),
              ),
            ],
          )
        ],
      ),
    );
  }
}

class _ImageCell extends StatelessWidget {
  final String url;
  const _ImageCell({this.url});
  @override
  Widget build(BuildContext context) {
    final ThemeData _theme = ThemeStyle.getTheme(context);
    return Container(
      // color: Colors.red,
      width: Adapt.px(130),
      //height: Adapt.px(200),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(Adapt.px(30)),
        child: Container(
          color: _theme.primaryColorDark,
          child: ParallaxImage(
            extent: Adapt.px(200),
            image: url != ''
                ? CachedNetworkImageProvider(
                    ImageUrlDefault.getUrl(url, ImageSize.w200),
                  )
                : AssetImage("assets/icon/launcher_icon.png"),
          ),
        ),
      ),
    );
  }
}

/*
 Navigator.of(ctx.context)
      .pushNamed('bangtalDetailPage', arguments: action.payload)
*/
class _Boarditem extends StatelessWidget {
  final index;
  final List<DocumentSnapshot> boardList;

  const _Boarditem({this.index, this.boardList});
  @override
  Widget build(BuildContext context) {
    return Card(
        child: Container(
            padding: const EdgeInsets.all(5),
            child: GestureDetector(
                onTap: () => {
                      Navigator.of(context).pushNamed('bangtalDetailPage',
                          arguments: {'bangtalboardDetail': boardList[index]})
                    },
                // final pageController = PageController();
                child: Container(
                    //color: Colors.w,
                    padding: const EdgeInsets.all(0),
                    child: Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: <Widget>[
                          SizedBox(
                            width: 70, // hard coding child width
                            child: Column(
                              children: <Widget>[
                                Container(
                                  alignment: Alignment.centerLeft,
                                  //color: ,
                                  child: Column(
                                    children: [
                                      _ImageCell(
                                          url: boardList[index]["photoUrl"] ??
                                              ''),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ),
                          SizedBox(
                            width: 10,
                          ),
                          SizedBox(
                              width: MediaQuery.of(context).size.width - 110,
                              child: Column(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: <Widget>[
                                    Container(
                                      alignment: Alignment.centerLeft,
                                      child: Row(
                                        children: [
                                          Text(boardList[index]["cafe_name"],
                                              style: TextStyle(
                                                  color:
                                                      const Color(0xFF9E9E9E),
                                                  fontSize: Adapt.px(22))),
                                        ],
                                      ),
                                    ),
                                    Container(
                                      alignment: Alignment.centerLeft,
                                      child: Row(
                                        children: [
                                          Text(boardList[index]["cafe_thema"],
                                              style: TextStyle(
                                                  //   color: const Color(
                                                  //     0xFF9E9E9E),
                                                  fontSize: Adapt.px(25))),
                                        ],
                                      ),
                                    ),
                                    SizedBox(
                                        width: Adapt.screenW() - Adapt.px(300),
                                        child: Text(
                                          boardList[index]["CONTS"],
                                          style: TextStyle(
                                              color: const Color(0xFF9E9E9E),
                                              fontSize: Adapt.px(22)),
                                        )),
                                    SizedBox(
                                      height: 10,
                                    ),
                                    Container(
                                      alignment: Alignment.centerLeft,
                                      child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.end,
                                        children: [
                                          Text(
                                            boardList[index]["MDATE"]
                                                .toDate()
                                                .toString()
                                                .substring(0, 14),
                                          ),
                                          Icon(
                                            Icons.access_alarms,
                                          ),
                                          SizedBox(
                                            height: 5,
                                          ),
                                        ],
                                      ),
                                    ),
                                    Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: [
                                          Row(children: <Widget>[
                                            //SizedBox(width: Adapt.px(30)),
                                            //  Text('(Join:'),
                                            Text(boardList[index]["joinCount"]
                                                    .toString() ??
                                                ''),
                                            Text('/'),
                                            Text(boardList[index]
                                                        ["joincountTotal"]
                                                    .toString() ??
                                                ''),
                                            // Text(')'),
                                            //style: TextStyle(fontSize: 13, color: Colors.black54))
                                          ]),
                                        ])
                                  ]))
                        ])))));
  }
}
