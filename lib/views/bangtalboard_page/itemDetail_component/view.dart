/*import 'package:fish_redux/fish_redux.dart';
import 'package:flutter/material.dart';

import 'action.dart';
import 'state.dart';

Widget buildView(
    ItemDetailState state, Dispatch dispatch, ViewService viewService) {
  return Text("===========>" + state.nickname);
}*/

import 'package:cached_network_image/cached_network_image.dart';
import 'package:fish_redux/fish_redux.dart';
import 'package:flutter/material.dart';
import 'package:escroomtok/actions/adapt.dart';
import 'package:escroomtok/actions/imageurl.dart';
import 'package:escroomtok/models/enums/imagesize.dart';
import 'package:escroomtok/style/themestyle.dart';
import 'package:parallax_image/parallax_image.dart';

import 'package:escroomtok/views/bangtalboard_page/action.dart';

//import 'action.dart';
import 'state.dart';

Widget buildView(
    ItemDetailState state, Dispatch dispatch, ViewService viewService) {
  final ThemeData _theme = ThemeStyle.getTheme(viewService.context);
  var itemDetailData = state.itemDetailData;

  return GestureDetector(
    key: ValueKey(
        'itemDetailData${itemDetailData['USER_NAME']}+${itemDetailData['cafe_name']}'),
    onTap: () => {print('test')},
    child: Container(
      margin: EdgeInsets.only(
          bottom: Adapt.px(10), left: Adapt.px(20), right: Adapt.px(20)),
      decoration: BoxDecoration(
        color: _theme.cardColor,
        boxShadow: <BoxShadow>[
          BoxShadow(
              blurRadius: Adapt.px(15),
              offset: Offset(Adapt.px(10), Adapt.px(15)),
              color: _theme.primaryColorDark)
        ],
        borderRadius: BorderRadius.circular(Adapt.px(30)),
      ),
      child: GestureDetector(
        onTap: () => dispatch(BangtalboardActionCreator.detailList(
            d: {'bangtalboardDetail': itemDetailData})),
        child: Column(
          children: <Widget>[
            Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      _ImageCell(url: itemDetailData['photoUrl'] ?? ''),
                    ]),
                SizedBox(width: Adapt.px(20)),
                _Info(
                  itemDetailData: itemDetailData,
                  index: state.index,
                ),
                // SizedBox(width: Adapt.px(50)),
                Column(
                  children: [
                    Row(children: <Widget>[
                      //SizedBox(width: Adapt.px(30)),
                      //  Text('(Join:'),
                      Text(itemDetailData["joinCount"].toString() ?? ''),
                      Text('/'),
                      Text(itemDetailData["joincountTotal"].toString() ?? ''),
                      // Text(')'),
                      //style: TextStyle(fontSize: 13, color: Colors.black54))
                    ]),
                  ],
                )
              ],
            ),
            Row(mainAxisAlignment: MainAxisAlignment.end, children: <Widget>[
              Row(
                children: <Widget>[
                  SizedBox(width: 20),
                  Image.network(
                    itemDetailData['USER_photoUrl'],
                    width: 20,
                  ),
                  SizedBox(width: 10),
                  Text(itemDetailData['USER_NAME']), // give it width
                  SizedBox(width: 20),
                ],
              ),
              Row(
                children: <Widget>[
                  Text(
                    itemDetailData["MDATE"]
                        .toDate()
                        .toString()
                        .substring(0, 16),
                  ),
                  Icon(
                    Icons.access_alarms,
                  ),
                ],
              )
            ])
          ],
        ),
      ),
    ),
  );
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

class _Info extends StatelessWidget {
  final int index;
  final itemDetailData;
  const _Info({this.itemDetailData, this.index});
  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        SizedBox(
          height: Adapt.px(20),
        ),
        Text(
          itemDetailData['cafe_name'],
          style: TextStyle(fontSize: Adapt.px(22), fontWeight: FontWeight.w800),
        ),
        SizedBox(
          width: Adapt.screenW() - Adapt.px(300),
          child: Text(
            itemDetailData['cafe_thema'] ?? "-",
            style:
                TextStyle(fontSize: Adapt.px(28), fontWeight: FontWeight.w700),
          ),
        ),
        SizedBox(height: Adapt.px(10)),
        SizedBox(
            width: Adapt.screenW() - Adapt.px(300),
            child: Text(
              itemDetailData['CONTS'],
              style: TextStyle(
                  color: const Color(0xFF9E9E9E), fontSize: Adapt.px(22)),
            ))
      ],
    );
  }
}
