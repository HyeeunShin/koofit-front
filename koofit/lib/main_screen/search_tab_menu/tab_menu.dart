import 'package:flutter/material.dart';
import 'package:koofit/main_screen/search_tab_menu/tab_favoite_screen.dart';
import 'package:koofit/main_screen/search_tab_menu/tab_kmu_screen.dart';
import 'package:koofit/model/config/palette.dart';
import 'package:koofit/model/data/user.dart';

class TabMenu extends StatefulWidget {
  final User UserData;
  final String selectedDate;
  const TabMenu({super.key, required this.UserData, required this.selectedDate});

  @override
  State<TabMenu> createState() => _TabMenuState();
}

class _TabMenuState extends State<TabMenu> {
  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
        length: 2, // Number of tabs
        child: Column(children: [
          const TabBar(
            tabs: [
              Tab(text: "KMU"),
              Tab(text: '즐겨찾기'),
              // Tab(text: '직접 입력'),
            ],
            labelColor: Colors.black87,
            labelStyle: TextStyle(fontSize: 15, fontWeight: FontWeight.bold),
           // dividerHeight: 0,
            indicatorWeight: 3,
            indicatorColor: Palette.mainSkyBlue,
            indicatorSize: TabBarIndicatorSize.tab,
            indicatorPadding: EdgeInsets.all(1),
          ),
          Expanded(
            child: TabBarView(
              children: [
                // Content for Tab 1
                TabKmuScreen(selectedDate: widget.selectedDate),
                // Content for Tab 2
                TabFavoriteScreen(UserData: widget.UserData, selectedDate: widget.selectedDate,),
                // Content for Tab 3
                // Text('Tab 3 Content')
              ],
            ),
          )
        ]));
  }
}