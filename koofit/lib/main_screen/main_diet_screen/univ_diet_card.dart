import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:koofit/main_screen/search_tab_menu/add_diet_screen.dart';
import 'package:koofit/model/config/palette.dart';
import 'package:koofit/model/DietSearcher.dart';

class UnivDietCard extends StatefulWidget {
  String selectedDate;

  // 생성자를 통해 selectedDate를 초기화할 수 있도록 변경
  UnivDietCard({required this.selectedDate});

  @override
  State<UnivDietCard> createState() => _UnivDietCardState();
}

class _UnivDietCardState extends State<UnivDietCard> {
  late Map<String, dynamic> result;
  Map<String, dynamic> bokjiMenu = {};
  Map<String, dynamic> beobgwanMenu = {};
  Map<String, dynamic> gyojeokwonMenu = {};
  Map<String, dynamic> selectedMenu = {};

  int clickedBtnIndex = 0;
  String btnText = '복지관';
  List<String> btnTxtList = ['복지관', '법학관', '교직원'];
  String cleanedString = '';
  String menuText = '복지관';

  late ScrollController _scrollController; // Declare _scrollController here

  void _scrollToTop() {
    // _scrollController가 할당되었을 때에만 jumpTo 메서드를 호출
    if (_scrollController.hasClients) {
      _scrollController.jumpTo(0.0);
    }
  }

  @override
  void initState() {
    super.initState();
    _scrollController = ScrollController(); // Initialize _scrollController
    _updateData(widget.selectedDate);
  }

  @override
  void didUpdateWidget(covariant UnivDietCard oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.selectedDate != widget.selectedDate) {
      _updateData(widget.selectedDate);
    }
  }

  void _updateData(String date) async {
    DietSearcher dietSearcher = DietSearcher(date);
    result = await dietSearcher.performDietSearch();
    setState(() {
      bokjiMenu = result['학생식당(복지관 1층)'] ?? {};
      beobgwanMenu = result['교직원식당(복지관 1층)'] ?? {};
      gyojeokwonMenu = result['한울식당(법학관 지하1층)'] ?? {};

      // Set the initial selectedMenu to 복지관
      selectedMenu = bokjiMenu.isNotEmpty ? bokjiMenu : {};
    });
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      child: Card(
        color: const Color(0xffFFFFFF),
        shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(30),
           ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Padding(padding: EdgeInsets.symmetric(vertical: 7)),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Image.asset('assets/images/healthy_food.png'),
                ),
                const Text(
                  "오늘의 학식",
                  style: TextStyle(
                      fontFamily: 'Poppins',
                      fontWeight: FontWeight.bold,
                      fontSize: 18),
                ),
              ],
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                ToggleButtons(
                  textStyle:
                  const TextStyle(fontWeight: FontWeight.w600, fontSize: 13),
                  isSelected: [
                    selectedMenu == bokjiMenu,
                    selectedMenu == beobgwanMenu,
                    selectedMenu == gyojeokwonMenu,
                  ],
                  borderRadius: BorderRadius.circular(20.0),
                  constraints: const BoxConstraints(
                    minHeight: 30.0,
                    minWidth: 25.0,
                  ),
                  selectedBorderColor: Palette.mid_dark_mainSkyBlue,
                  selectedColor: Colors.white,
                  fillColor: Palette.mid_dark_mainSkyBlue,
                  color: Colors.black54,
                  onPressed: (index) {
                    setState(() {
                      btnText = btnTxtList[index];
                      if (index == 0) {
                        selectedMenu = bokjiMenu;
                      } else if (index == 1) {
                        selectedMenu = beobgwanMenu;
                      } else {
                        selectedMenu = gyojeokwonMenu;
                      }

                      _scrollToTop();
                    });
                  },
                  children: const [
                    Padding(
                      padding: EdgeInsets.symmetric(horizontal: 13),
                      child: Text('복지관'),
                    ),
                    Padding(
                      padding: EdgeInsets.symmetric(horizontal: 13),
                      child: Text('법학관'),
                    ),
                    Padding(
                      padding: EdgeInsets.symmetric(horizontal: 13),
                      child: Text('교직원'),
                    ),
                  ],
                ),
              ],
            ),
            const Padding(padding: EdgeInsets.symmetric(vertical: 10)),
            if (selectedMenu.isNotEmpty)
              SingleChildScrollView(
                controller: _scrollController,
                scrollDirection: Axis.horizontal,
                padding: const EdgeInsets.symmetric(horizontal: 10),
                child: Row(
                  children: selectedMenu.entries.map((entry) {
                    String menuKey = entry.key
                        .replaceAll(RegExp(r'<br>', caseSensitive: false), '-');

                    cleanedString = cleaningString(entry.value.toString());
                    Map<String, dynamic> menuMap = json.decode(cleanedString);

                    String menuText = menuMap['메뉴'] ?? '';
                    // Create a list to store widgets for each key-value pair in menuValue
                    List<Widget> keyValueWidgets = [];
                    // Iterate through entries in menuValue

                    keyValueWidgets.add(Container(
                        padding: const EdgeInsets.all(8),
                        width: 130,
                        height: 100,
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius:
                          BorderRadius.circular(10.0), // 둥근 모서리 설정
                        ),
                        child: SingleChildScrollView(
                            child: Text(menuText,
                                textAlign: TextAlign.center,
                                style: const TextStyle(
                                    fontWeight: FontWeight.w400,
                                    fontSize: 12)))));

                    if (menuText == '') {
                      return Container();
                    }
                    return Card(
                      color: const Color(0xFFF1F1F1),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(15),
                      ),
                      child: Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 8),
                          child: Column(
                            children: [
                              const SizedBox(height: 15),
                              Text(
                                menuKey,
                                style: const TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 15,
                                    color: Colors.black87),
                              ),
                              const SizedBox(height: 8),
                              ...keyValueWidgets,
                              const SizedBox(height: 8),
                              AddDietBtnScreen(
                                where: btnText,
                                menu: menuText,
                                fromScreen: 'main',
                              ),
                              const SizedBox(height: 15),
                            ],
                          )),
                    );
                  }).toList(),
                ),
              ),
            const Padding(padding: EdgeInsets.symmetric(vertical: 10.0)),
          ],
        ),
      ),
    );
  }

  String cleaningString(String jsonString) {
    String cleanString = '';
// Check if jsonString is a string or a map
    if (jsonString is String) {
      // Handle the case where jsonString is a String
      // Your existing code for String type
      cleanString = jsonString.replaceAll('\\r\n', '\r\n');
      // Continue with the rest of your code
    } else if (jsonString is Map) {
      // Handle the case where jsonString is a Map
      // Convert the map to a String or handle it accordingly
      cleanString = jsonString.toString();
      // Continue with the rest of your code
    } else {
      // Handle other cases or raise an error, depending on your requirements
      print('Unexpected type for jsonString: ${jsonString.runtimeType}');
    }

    return cleanString;
  }
}
