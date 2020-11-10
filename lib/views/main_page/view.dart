import 'package:fish_redux/fish_redux.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:escroomtok/actions/adapt.dart';
import 'package:escroomtok/widgets/keepalive_widget.dart';
import 'package:escroomtok/generated/i18n.dart';

import 'action.dart';
import 'state.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

Widget buildView(
    MainPageState state, Dispatch dispatch, ViewService viewService) {
  return Builder(
    builder: (context) {
      Adapt.initContext(context);
      final pageController = PageController(initialPage: state.selectedIndex);
      final _lightTheme = ThemeData.light().copyWith(
          backgroundColor: Colors.white,
          tabBarTheme: TabBarTheme(
              labelColor: Color(0XFF505050),
              unselectedLabelColor: Colors.grey));
      final _darkTheme = ThemeData.dark().copyWith(
          backgroundColor: Color(0xFF303030),
          tabBarTheme: TabBarTheme(
              labelColor: Colors.white, unselectedLabelColor: Colors.grey));
      final MediaQueryData _mediaQuery = MediaQuery.of(context);
      final ThemeData _theme =
          _mediaQuery.platformBrightness == Brightness.light
              ? _lightTheme
              : _darkTheme;
      Widget _buildPage(Widget page) {
        return KeepAliveWidget(page);
      }

      return Scaffold(
        key: state.scaffoldKey,
        body: PageView(
          physics: NeverScrollableScrollPhysics(),
          children: state.pages.map(_buildPage).toList(),
          controller: pageController,
          onPageChanged: (int i) =>
              dispatch(MainPageActionCreator.onTabChanged(i)),
        ),
        bottomNavigationBar: BottomNavigationBar(
          backgroundColor: _theme.backgroundColor,
          items: <BottomNavigationBarItem>[
            BottomNavigationBarItem(
              icon: Icon(state.selectedIndex == 0 ? Icons.home : Icons.home,
                  size: Adapt.px(44)),
              title: Text(I18n.of(context).home),
            ),
            BottomNavigationBarItem(
              icon: Icon(
                  state.selectedIndex == 1 ? Icons.folder_open : Icons.folder,
                  size: Adapt.px(44)),
              title: Text(I18n.of(context).folder),
            ),
            BottomNavigationBarItem(
              icon: Icon(
                state.selectedIndex == 2 ? Icons.receipt : Icons.receipt,
                size: Adapt.px(44),
              ),
              title: Text(
                I18n.of(context).board,
                key: ValueKey(I18n.of(context).board),
              ),
            ),
            BottomNavigationBarItem(
              icon: FaIcon(
                  state.selectedIndex == 3
                      ? FontAwesomeIcons.comments
                      : FontAwesomeIcons.comments,
                  size: Adapt.px(44)),
              /*  Icon(
                state.selectedIndex == 3 ? Icons.sms : Icons.sms,
                size: Adapt.px(44),
              ),
              */
              title: Text(
                I18n.of(context).community,
                key: ValueKey(I18n.of(context).community),
              ),
            ),
            BottomNavigationBarItem(
              icon: Icon(
                state.selectedIndex == 4 ? Icons.more_horiz : Icons.more_horiz,
                size: Adapt.px(44),
              ),
              title: Text(
                I18n.of(context).addview,
                key: ValueKey(I18n.of(context).addview),
              ),
            ),
          ],
          currentIndex: state.selectedIndex,
          selectedItemColor: _theme.tabBarTheme.labelColor,
          unselectedItemColor: _theme.tabBarTheme.unselectedLabelColor,
          onTap: (int index) {
            pageController.jumpToPage(index);
          },
          type: BottomNavigationBarType.fixed,
        ),
      );
    },
  );
}
