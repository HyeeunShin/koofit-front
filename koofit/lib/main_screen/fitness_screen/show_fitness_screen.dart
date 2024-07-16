import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:koofit/main_screen/fitness_screen/add_fitness_screen.dart';
import 'package:koofit/main_screen/main_diet_screen/diet_screen.dart';
import 'package:koofit/main_screen/search_tab_menu/add_diet_screen.dart';
import 'package:koofit/model/HiveFitnessHelper.dart';
import 'package:koofit/model/config/palette.dart';
import 'package:koofit/model/data/fitness.dart';
import 'package:koofit/fitness/core/app_export.dart';
import 'package:get/get.dart';

class FitnessModalBottomSheet extends StatefulWidget {
  final String selectedDate;
  final List<Fitness> todayFitness;

  const FitnessModalBottomSheet(
      {super.key, required this.selectedDate, required this.todayFitness});

  @override
  _FitnessModalBottomSheetState createState() =>
      _FitnessModalBottomSheetState();
}

class _FitnessModalBottomSheetState extends State<FitnessModalBottomSheet> {
  late List<bool> isSelected;
  String result = '';

  bool isWeak = true;
  bool isMiddle = false;
  bool isStrong = false;

  List<String> fitnessCheckList = [];

  List<String> whatFitnessList = [];
  String time = '';
  String strong = '';
  late TextEditingController timeController = TextEditingController();

  late List<Fitness> _todayFitness = [];

  @override
  void initState() {
    isSelected = [isStrong, isMiddle, isWeak];
    super.initState();
    print(widget.selectedDate);

    _todayFitness = widget.todayFitness;
  }

  void toggleSelect(value) {
    if (value == 0) {
      isStrong = true;
      isMiddle = false;
      isWeak = false;
    } else if (value == 1) {
      isStrong = false;
      isMiddle = true;
      isWeak = false;
    } else {
      isStrong = false;
      isMiddle = false;
      isWeak = true;
    }
    setState(() {
      isSelected = [isStrong, isMiddle, isWeak];
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
        color: Colors.white,
        padding: EdgeInsets.only(top: 20, left: 20, right: 20, bottom: 35),
        child: SingleChildScrollView(
            child: Column(
          children: <Widget>[
            Text(
              "오늘의 운동을 기록해볼까요?",
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 25),
            _todayFitness.isNotEmpty
                ? Padding(
                    padding: EdgeInsets.all(10.0),
                    child: Column(children: [
                      for (var fitness in _todayFitness) todayGraphCard(fitness)
                    ]))
                : Container(),
            SizedBox(height: 25),
            addBtn(),
            SizedBox(height: 15),
          ],
        ))); // Your existing build method content
  }

  Widget todayGraphCard(Fitness fitness) {
    return Card(
        color: Color(0xFFEFEFEF),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10), // 모서리를 둥글게 만드는 값 설정
        ),
        child: Padding(
            padding: EdgeInsets.all(20.0),
            child: Column(
                crossAxisAlignment: CrossAxisAlignment.center, // 시작에 배치
                children: [
                  Row(children: [
                    Text(
                      "운동 종류 | ",
                      style:
                          TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                    ),
                    for (var whatFitness in fitness.whatFitnessList)
                      Text(
                        " ${whatFitness}",
                        style: TextStyle(
                            fontWeight: FontWeight.bold, color: Colors.black54),
                      )
                  ]),
                  Row(children: [
                    Text(
                      "운동 시간 | ",
                      style:
                          TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                    ),
                    Text(
                      " ${fitness.time} 분 ",
                      style: TextStyle(
                          fontWeight: FontWeight.bold, color: Colors.black54),
                    )
                  ]),
                  Row(children: [
                    Text(
                      "운동 강도 | ",
                      style:
                          TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                    ),
                    Text(
                      " ${fitness.strong} ",
                      style: TextStyle(
                          fontWeight: FontWeight.bold, color: Colors.black54),
                    )
                  ]),
                ])));
  }

  /// Section Widget
  Widget addBtn() {
    return SizedBox(
        width: double.infinity,
        height: 50.h,
        child: ElevatedButton(
            style: ElevatedButton.styleFrom(
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(15)),
                backgroundColor: Palette.mainSkyBlue,
                disabledBackgroundColor: Palette.mainSkyBlue.withOpacity(0.12)),
            onPressed: () async {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) =>
                      AddFitness(selectedDate: widget.selectedDate),
                ),
              );
            },
            child: Text('+',
                style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 30,
                    color: Colors.white))));
  }
}

Future<void> ShowFitness(
    BuildContext context, String date, List<Fitness> todayFitness) async {
  mediaQueryData = MediaQuery.of(context);

  await showModalBottomSheet<void>(
    context: context,
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(20),
    ),
    useSafeArea: true,
    enableDrag: true,
    isScrollControlled: true,
    elevation: 50,
    constraints: const BoxConstraints(
      minWidth: double.infinity,
      maxHeight: 697,
    ),
    builder: (BuildContext context) {
      return ClipRRect(
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(20),
          topRight: Radius.circular(20),
        ),
        child: FitnessModalBottomSheet(
          selectedDate: date,
          todayFitness: todayFitness,
        ),
      );
    },
  );
}
