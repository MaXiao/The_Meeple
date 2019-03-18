// Copyright 2018 The Flutter team. All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.
import 'package:flutter/cupertino.dart';
import 'package:flutter/widgets.dart';
import 'package:the_meeple/screens/record_screen.dart';
import 'package:the_meeple/screens/scoring_screen.dart';
import 'package:the_meeple/utils/MeepleColors.dart';
import 'package:the_meeple/screens/players/players_screen.dart';

class HomeScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return CupertinoTabScaffold(
      tabBar: CupertinoTabBar(
        items: [
          BottomNavigationBarItem(
            icon: Image.asset('assets/images/ic_tabbar_score_grey.png'),
            activeIcon: Image.asset('assets/images/ic_tabbar_score_blue.png'),
            title: Text(
              'Scoring',
              style: buildTextStyle(),
            ),
          ),
          BottomNavigationBarItem(
            icon: Image.asset('assets/images/ic_tabbar_record_grey.png'),
            activeIcon: Image.asset('assets/images/ic_tabbar_record_blue.png'),
            title: Text(
              'Record',
              style: buildTextStyle(),
            ),
          ),
          BottomNavigationBarItem(
            icon: Image.asset('assets/images/ic_tabbar_timer_grey.png'),
            activeIcon: Image.asset('assets/images/ic_tabbar_timer_blue.png'),
            title: Text(
              'Players',
              style: buildTextStyle(),
            ),
          ),
          BottomNavigationBarItem(
            icon: Image.asset('assets/images/ic_tabbar_more_grey.png'),
            activeIcon: Image.asset('assets/images/ic_tabbar_more_blue.png'),
            title: Text(
              'More',
              style: buildTextStyle(),
            ),
          ),
        ],
        activeColor: MeepleColors.primaryBlue,
      ),
      tabBuilder: (context, index) {
        if (index == 0) {
          return ScoringScreen();
        } else if (index == 2) {
          return PlayersScreen();
        } else {
          return RecordScreen();
        }
      },
    );
  }

  TextStyle buildTextStyle() {
    return TextStyle(
//        color: MeepleColors.primaryBlue,
        fontSize: 12,
        fontWeight: FontWeight.bold);
  }
}
