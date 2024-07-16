import 'dart:convert';
import 'package:koofit/widget/loading_view.dart';
import 'package:flutter/material.dart';
import 'package:koofit/main_screen/search_tab_menu/add_diet_screen.dart';
import 'package:koofit/model/DietSearcher.dart';
import 'package:koofit/model/config/palette.dart';

class TabKmuScreen extends StatefulWidget {
  final String selectedDate;

  const TabKmuScreen({Key? key, required this.selectedDate});

  @override
  State<TabKmuScreen> createState() => _TabKmuScreenState();
}

class _TabKmuScreenState extends State<TabKmuScreen> {
  Map<String, dynamic> bokjiMenu = {};
  Map<String, dynamic> beobgwanMenu = {};
  Map<String, dynamic> gyojeokwonMenu = {};
  Map<String, dynamic> selectedMenu = {};
  late Map<String, dynamic> result;
  final ScrollController _scrollController = ScrollController();
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    _updateData();
    setState(() {
      isLoading = false;
    });
  }

  void _updateData() async {
    String todayDate = widget.selectedDate;
    DietSearcher dietSearcher = DietSearcher(todayDate);
    result = await dietSearcher.performDietSearch();
    setState(() {
      bokjiMenu = result['학생식당(복지관 1층)'] ??
          {
            '식당': {"메뉴": "운영 안함", "가격": "없음"}
          };
      beobgwanMenu = result['교직원식당(복지관 1층)'] ??
          {
            '식당': {"메뉴": "운영 안함", "가격": "없음"}
          };
      gyojeokwonMenu = result['한울식당(법학관 지하1층)'] ??
          {
            '식당': {"메뉴": "운영 안함", "가격": "없음"}
          };
      // Set the initial selectedMenu to 복지관
      selectedMenu = bokjiMenu;
    });
  }

  @override
  Widget build(BuildContext context) {
    return isLoading
        ? loadingView()
        : Column(
            children: [
              WhereBtn(),
              const Padding(padding: EdgeInsets.symmetric(vertical: 5)),
              if (selectedMenu.isNotEmpty)
                Expanded(
                    child: SingleChildScrollView(
                  controller: _scrollController,
                  padding: const EdgeInsets.symmetric(horizontal: 10),
                  child: Column(
                    children: selectedMenu.entries.map((entry) {
                      String menuKey = entry.key.replaceAll(
                          RegExp(r'<br>', caseSensitive: false), '\n');

                      dynamic jsonString = entry.value;
                      // 백슬래시 이스케이프 처리 및 줄바꿈 문자(\n)로 치환

                      String cleanedString = jsonString.replaceAll('\\r\n', '');
                      Map<String, dynamic> menuMap = json.decode(cleanedString);
                      String menuText = menuMap['메뉴'] ?? '';
                      // Create a list to store widgets for each key-value pair in menuValue
                      List<Widget> keyValueWidgets = [];
                      // Iterate through entries in menuValue
                      keyValueWidgets.add(Container(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 5, vertical: 3),
                          width: MediaQuery.of(context).size.width * 0.47,
                          decoration: BoxDecoration(
                            color: Colors.white54,
                            borderRadius:
                                BorderRadius.circular(10.0), // 둥근 모서리 설정
                          ),
                          child: Text(menuText,
                              textAlign: TextAlign.center,
                              style: const TextStyle(
                                  fontWeight: FontWeight.w500, fontSize: 12))));

                      if (menuText == '') {
                        return Container();
                      }
                      return Card(
                        color: const Color(0xFFF2F3F3),
                        elevation: 2,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(15),
                        ),
                        child: Padding(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 8, vertical: 10),
                            child: Row(
                              children: [
                                Expanded(
                                    child: Text(menuKey,
                                        textAlign: TextAlign.center,
                                        style: const TextStyle(
                                          fontWeight: FontWeight.bold,
                                          fontSize: 14,
                                        ))),
                                const SizedBox(width: 15),
                                ...keyValueWidgets,
                                const SizedBox(width: 20),
                                AddDietBtnScreen(
                                  where: menuKey.replaceAll('\n', ' '),
                                  menu: menuText,
                                  fromScreen: 'add',
                                ),
                              ],
                            )),
                      );
                    }).toList(),
                  ),
                )),
            ],
          );
  }

  Widget WhereBtn() {
    return Row(mainAxisAlignment: MainAxisAlignment.start, children: [
      const SizedBox(
        width: 10,
      ),
      ToggleButtons(
        textStyle: TextStyle(fontWeight: FontWeight.w600, fontSize: 12),
        isSelected: [
          selectedMenu == bokjiMenu,
          selectedMenu == beobgwanMenu,
          selectedMenu == gyojeokwonMenu,
        ],
        borderRadius: BorderRadius.circular(20.0),
        constraints: const BoxConstraints(
          minHeight: 25.0,
          minWidth: 40.0,
        ),
        selectedBorderColor: Palette.mid_dark_mainSkyBlue,
        selectedColor: Colors.white,
        fillColor: Palette.mid_dark_mainSkyBlue,
        color: Colors.black38,
        onPressed: (index) {
          setState(() {
            if (index == 0) {
              selectedMenu = bokjiMenu;
            } else if (index == 1) {
              selectedMenu = beobgwanMenu;
            } else {
              selectedMenu = gyojeokwonMenu;
            }
          });
        },
        children: const [
          Padding(
              padding: EdgeInsets.symmetric(horizontal: 10),
              child: Text('복지관')),
          Padding(
              padding: EdgeInsets.symmetric(horizontal: 10),
              child: Text('법학관')),
          Padding(
              padding: EdgeInsets.symmetric(horizontal: 10),
              child: Text('교직원')),
        ],
      ),
    ]);
  }
}
