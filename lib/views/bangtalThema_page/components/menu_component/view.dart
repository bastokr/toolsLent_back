import 'dart:ui' as ui;
import 'package:cached_network_image/cached_network_image.dart';
import 'package:fish_redux/fish_redux.dart';
import 'package:flutter/material.dart';
import 'package:escroomtok/actions/adapt.dart';
import 'package:escroomtok/actions/imageurl.dart';
import 'package:escroomtok/widgets/medialist_card.dart';
import 'package:escroomtok/models/enums/imagesize.dart';
import 'package:escroomtok/models/enums/media_type.dart';

import 'action.dart';
import 'state.dart';

Widget buildView(MenuState state, Dispatch dispatch, ViewService viewService) {
  Widget _buildListTitel(IconData icon, String title, void onTap(),
      {Color iconColor = const Color.fromRGBO(50, 50, 50, 1)}) {
    TextStyle titleStyle =
        TextStyle(color: Color.fromRGBO(50, 50, 50, 1), fontSize: Adapt.px(40));
    return ListTile(
      leading: Icon(
        icon,
        color: iconColor,
      ),
      title: Text(title, style: titleStyle),
      onTap: onTap,
    );
  }

  void _addToList() {
    Navigator.of(viewService.context).pop();
    showDialog(
        context: viewService.context,
        builder: (ctx) {
          return MediaListCardDialog(
            type: MediaType.movie,
            mediaId: state.id,
          );
        });
  }

  void _rateIt() {
    Navigator.of(viewService.context).pop();
    showDialog(
        context: viewService.context,
        builder: (ctx) {
          double rate = state.accountState.rated?.value ?? 0;
        });
  }

  return Container(
    decoration: BoxDecoration(
        color: Colors.white,
        borderRadius:
            BorderRadius.vertical(top: Radius.circular(Adapt.px(50)))),
    //padding: EdgeInsets.only(top:Adapt.px(30)),
    child: ListView(
      physics: ClampingScrollPhysics(),
      children: <Widget>[
        Container(
          margin: EdgeInsets.all(Adapt.px(20)),
          height: Adapt.px(100),
          child: Row(
            children: <Widget>[
              Container(
                height: Adapt.px(100),
                width: Adapt.px(100),
                decoration: BoxDecoration(
                    color: Colors.grey,
                    borderRadius: BorderRadius.circular(Adapt.px(50)),
                    image: DecorationImage(
                        fit: BoxFit.cover,
                        image: CachedNetworkImageProvider(
                            ImageUrl.getUrl(state.posterPic, ImageSize.w300)))),
              ),
              SizedBox(
                width: Adapt.px(30),
              ),
              SizedBox(
                  width: Adapt.screenW() - Adapt.px(170),
                  child: Text(
                    state.name,
                    style: TextStyle(
                        color: Colors.black,
                        fontSize: Adapt.px(40),
                        fontWeight: FontWeight.bold),
                  )),
            ],
          ),
        ),
        Divider(
          height: 1,
        ),
        _buildListTitel(Icons.format_list_bulleted, 'Add to List', _addToList),
        Divider(
          height: Adapt.px(10),
        ),
        _buildListTitel(
            state.accountState.favorite
                ? Icons.favorite
                : Icons.favorite_border,
            'Mark as Favorite', () {
          Navigator.of(viewService.context).pop();
          dispatch(MenuActionCreator.setFavorite(!state.accountState.favorite));
        },
            iconColor: state.accountState.favorite
                ? Colors.pink[400]
                : Color.fromRGBO(50, 50, 50, 1)),
        Divider(
          height: Adapt.px(10),
        ),
        _buildListTitel(
          Icons.flag,
          'Add to your Watchlist',
          () {
            Navigator.of(viewService.context).pop();
            dispatch(
                MenuActionCreator.setWatchlist(!state.accountState.watchlist));
          },
          iconColor: state.accountState.watchlist
              ? Colors.red
              : Color.fromRGBO(50, 50, 50, 1),
        ),
        Divider(
          height: Adapt.px(10),
        ),
        _buildListTitel(
            state.accountState.isRated == true ? Icons.star : Icons.star_border,
            'Rate It',
            _rateIt,
            iconColor: state.accountState.isRated == true
                ? Colors.amber
                : Color.fromRGBO(50, 50, 50, 1)),
        Divider(
          height: Adapt.px(10),
        ),

        ///  _buildListTitel(Icons.share, 'Share', _share),
        Divider(
          height: Adapt.px(10),
        ),
      ],
    ),
  );
}
