import 'package:flutter/material.dart';
import 'package:koofit/main_screen/main_diet_screen/keyTimeBox.dart';
import 'package:koofit/main_screen/main_diet_screen/today_calories_card.dart';
import 'package:koofit/main_screen/search_tab_menu/add_diet_screen.dart';
import 'package:koofit/main_screen/search_tab_menu/search_diet_screen.dart';
import 'package:koofit/model/HiveDietHelper.dart';
import 'package:koofit/model/HiveUserHelper.dart';
import 'package:koofit/model/config/palette.dart';
import 'package:koofit/model/data/Nutrient.dart';
import 'package:koofit/model/data/diet.dart';
import 'package:koofit/model/data/user.dart';
import 'package:koofit/widget/circleText.dart';
import 'package:koofit/widget/calText.dart';
import 'package:item_count_number_button/item_count_number_button.dart';
import 'package:koofit/widget/RectangleText.dart';
import 'package:koofit/widget/oneGraph.dart';

class DietModalBottomSheet extends StatefulWidget {
  final User user;
  final String selectedDate;

  const DietModalBottomSheet(
      {super.key, required this.user, required this.selectedDate});

  @override
  State<DietModalBottomSheet> createState() => _DietModalBottomSheetState();
}

class _DietModalBottomSheetState extends State<DietModalBottomSheet> {
  late String todayDate;
  late List<Diet> dietList;
  late Nutrient goalNutrient;
  late User user;

  int totalCalories = 0;
  int totalCarbo = 0;
  int totalProtein = 0;
  int totalFat = 0;
  int remainCalories = 0;

  int carboRate = 0;
  int proteinRate = 0;
  int fatRate = 0;

  bool isSuccess = false;

  List<String> keyTimes = ["아침", "점심", "저녁", "간식"];
  Map<String, bool> isKeyTimeList = {};
  List<String> selectedKeyTimes = [];
  Size deviceSize = const Size(700, 700);

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    todayDate = widget.selectedDate;
    print("tttttoday : ${todayDate}");
    _initializeData();
  }

  Future<void> _initializeData() async {
    user = widget.user; // Access the user from the widget property

    HiveDietHelper().searchDiet(todayDate).then((value) {
      dietList = value;
      print(dietList);

      // 총칼로리 data 추출, 탄단지 섭취율 계산
      totalCalories = (dietList.fold<int>(
          0, (sum, diet) => sum + (diet.nutrient.calories?.toInt() ?? 0)));
      totalCarbo = (dietList.fold<int>(
          0, (sum, diet) => sum + (diet.nutrient.carbo?.toInt() ?? 0)));
      totalProtein = (dietList.fold<int>(
          0, (sum, diet) => sum + (diet.nutrient.protein?.toInt() ?? 0)));
      totalFat = (dietList.fold<int>(
          0, (sum, diet) => sum + (diet.nutrient.fat?.toInt() ?? 0)));

      carboRate = (totalCarbo / user.goalNutrient!.carbo * 100).toInt();
      proteinRate = (totalProtein / user.goalNutrient!.protein * 100).toInt();
      fatRate = (totalFat / user.goalNutrient!.fat * 100).toInt();

      remainCalories = user.goalNutrient!.calories - totalCalories;

      // 아침/점심/저녁/간식 기록 있는지 확인
      keyTimes.forEach((keyTime) {
        isKeyTimeList[keyTime] =
            dietList.any((diet) => diet.keyTime == keyTime);
      });

      //true 인 것만 selectedKeyTimes에
      selectedKeyTimes = isKeyTimeList.entries
          .where((entry) => entry.value)
          .map((entry) => entry.key)
          .toList();

      setState(() {
        isSuccess = true;
      });
    });
  }

  Future<void> searchKeyTime() async {}

  @override
  Widget build(BuildContext context) {
    deviceSize = MediaQuery.of(context).size;

    return Container(
        color: Colors.white,
        width: double.infinity,
        // height: deviceSize.height * 0.7,
        padding:
        const EdgeInsets.only(top: 20, left: 20, right: 20, bottom: 35),
        child: SingleChildScrollView(
          child: Column(
            children: <Widget>[
              const Text(
                "오늘의 식단을 기록해볼까요?",
                style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 10),
              Card(
                color: Colors.white,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(30), // 모서리를 둥글게 만드는 값 설정
                ),
                child: Padding(
                    padding: const EdgeInsets.all(10.0),
                    child: Column(
                        crossAxisAlignment: CrossAxisAlignment.center, // 시작에 배치
                        children: [
                          nutrientBox(context),
                          selectedKeyTimes.isNotEmpty
                              ? Column(
                              children: selectedKeyTimes
                                  .map((keyTime) => keyTimeBox(
                                keyTime: keyTime,
                                keyTimeDietList: dietList,
                              ))
                                  .toList())
                              : Container()
                        ])),
              )
            ],
          ),
        ));
  }

  Widget nutrientBox(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 5),
      child: Column(
        children: [
          Row(
            children: [
              oneGraph(
                recommendedCarb: 50.0,
                recommendedProtein: 30.0,
                recommendedFat: 20.0,
                consumedCarb: (totalCarbo / user.goalNutrient!.carbo) *100,
                consumedProtein: (totalProtein /  user.goalNutrient!.protein) * 100,
                consumedFat: (totalFat/user.goalNutrient!.fat) *100,
              ),
              const SizedBox(width: 20),
              Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                CircleText(
                  Palette.tanSu,
                  carboRate,
                  false,
                  realGram: totalCarbo,
                  goalGram: user.goalNutrient!.carbo,
                ),
                CircleText(
                  Palette.danBaek,
                  proteinRate,
                  false,
                  realGram: totalProtein,
                  goalGram: user.goalNutrient!.protein,
                ),
                CircleText(
                  Palette.jiBang,
                  fatRate,
                  false,
                  realGram: totalFat,
                  goalGram: user.goalNutrient!.fat,
                )
              ])
            ],
          ),
          const SizedBox(height: 10),
          CalText(totalCalories, user.goalNutrient!.calories),
          const SizedBox(height: 20),
          Text(
            '$remainCalories kcal 더 먹을 수 있어요',
            textAlign: TextAlign.left,
            style: const TextStyle(
              color: Color(0xC6222B45),
              fontSize: 16,
              fontWeight: FontWeight.w700,
            ),
          ),
          const SizedBox(height: 15),
          ElevatedButton(
            onPressed: () async {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => SearchDietScreen(
                    userData: widget.user,
                    selectedDate: widget.selectedDate,
                  ),
                ),
              );
            },
            style: ElevatedButton.styleFrom(
                minimumSize: const Size(500, 20),
                backgroundColor: Palette.mainSkyBlue,
                padding: const EdgeInsets.symmetric(vertical: 1, horizontal: 2),
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(15))),
            child: const Text(
              '+',
              style: TextStyle(
                color: Colors.white,
                fontSize: 25,
                fontWeight: FontWeight.w800,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

Future<void> showTodayDiet(
    BuildContext context, User user, String date, Size deviceSize) async {
  await showModalBottomSheet<void>(
    context: context,
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(20),
    ),
    useSafeArea: true,
    enableDrag: true,
    isScrollControlled: true,
    elevation: 50,
    constraints: BoxConstraints(
      minWidth: double.infinity,
      minHeight: deviceSize.height * 0.6, //앱 화면 높이 double Ex> 692.0
    ),
    builder: (BuildContext context) {
      return ClipRRect(
          borderRadius: const BorderRadius.only(
            topLeft: Radius.circular(20),
            topRight: Radius.circular(20),
          ),
          child: DietModalBottomSheet(user: user, selectedDate: date));
    },
  );
}
