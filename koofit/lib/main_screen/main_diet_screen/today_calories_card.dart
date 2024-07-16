import 'package:flutter/material.dart';
import 'package:koofit/main_screen/main_diet_screen/show_diet_screen.dart';
import 'package:koofit/main_screen/search_tab_menu/search_diet_screen.dart';
import 'package:koofit/model/HiveDietHelper.dart';
import 'package:koofit/model/HiveUserHelper.dart';
import 'package:koofit/model/config/palette.dart';
import 'package:get/get.dart';
import 'package:koofit/model/data/Nutrient.dart';
import 'package:koofit/model/data/diet.dart';
import 'package:koofit/model/data/user.dart';
import 'package:koofit/widget/circleText.dart';
import 'package:koofit/widget/loading_view.dart';

class TodayCalorieCard extends StatefulWidget {
  final String selectedDate;

  const TodayCalorieCard({super.key, required this.selectedDate});

  @override
  State<TodayCalorieCard> createState() => _TodayCalorieCardState();
}

class _TodayCalorieCardState extends State<TodayCalorieCard> {
  bool isOuter = true;
  bool isSuccess = false;

  late String todayDate;
  late List<Diet> dietList;

  int totalCalories = 0;
  int totalCarbo = 0;
  int totalProtein = 0;
  int totalFat = 0;
  int remainCalories = 0;
  int carboRate = 0;
  int proteinRate = 0;
  int fatRate = 0;

  User user = User(
      uid: "",
      name: "name",
      gender: "gender",
      stuNumber: "stuNumber",
      number: "number",
      age: "age",
      height: 0,
      curWeight: 0,
      goalWeight: 0,
      todayNutrientList: [],
      goalNutrient:
          Nutrient(calories: 0, carbo: 0, protein: 0, fat: 0, fitnessTime: 30),
      fitnessList: [],
      recordedDayList: [],
      favorieFoodList: []);

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    todayDate = widget.selectedDate;
    _initializeData(todayDate);
  }

  @override
  void didUpdateWidget(covariant TodayCalorieCard oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.selectedDate != widget.selectedDate) {
      _initializeData(widget.selectedDate);

      print("selected Date: ${widget.selectedDate}");
    }
  }

  Future<void> _initializeData(String date) async {
    user = await HiveUserHelper().readUser();

    HiveDietHelper().searchDiet(date).then((value) {
      dietList = value;
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

      print("$totalProtein ///$carboRate, $proteinRate, $fatRate");
      remainCalories = user.goalNutrient!.calories - totalCalories;
      setState(() {
        isSuccess = true;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    Size deviceSize = MediaQuery.of(context).size;

    return Container(
        decoration: BoxDecoration(
          borderRadius:
              BorderRadius.circular(35), // 여기서 숫자를 조절하여 둥근 정도를 결정할 수 있습니다.
        ),
        child: isSuccess
            ? InkWell(
                onTap: () async {
                  await showTodayDiet(
                      context, user, widget.selectedDate, deviceSize);
                },
                child: Card(
                  color: Colors.white,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 15, vertical: 10),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const SizedBox(height: 5),
                            const Text(
                              "식단",
                              style: TextStyle(
                                color: Color(0xA5222B45),
                                fontSize: 15,
                                fontWeight: FontWeight.w700,
                              ),
                            ),
                            const SizedBox(
                              height: 5,
                            ),
                            Row(
                              children: [
                                Text(
                                  "$totalCalories",
                                  style: const TextStyle(
                                    color: Color(0xFF222B45),
                                    fontSize: 18,
                                    fontWeight: FontWeight.w700,
                                  ),
                                ),
                                Text(
                                  " / ${user.goalNutrient!.calories}kal",
                                  style: const TextStyle(
                                    color: Colors.black26,
                                    fontSize: 18,
                                    fontWeight: FontWeight.w700,
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(
                              height: 13,
                            ),
                            CircleText(Palette.tanSu, carboRate, isOuter),
                            CircleText(Palette.danBaek, proteinRate, isOuter),
                            CircleText(Palette.jiBang, fatRate, isOuter),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              )
            : const Center(
                child: CircularProgressIndicator(
                color: Palette.mainSkyBlue,
              )));
  }
}
