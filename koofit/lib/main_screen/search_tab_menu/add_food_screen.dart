import 'package:flutter/material.dart';
import 'package:item_count_number_button/item_count_number_button.dart';
import 'package:koofit/main_screen/main_diet_screen/diet_screen.dart';
import 'package:koofit/model/HiveDietHelper.dart';
import 'package:koofit/model/config/palette.dart';
import 'package:koofit/model/data/diet.dart';
import 'package:koofit/model/data/food.dart';
import 'package:get/get.dart';

class AddFoodScreen extends StatefulWidget {
  final Food food;
  final String selectedDate;

  // 생성자 정의
  const AddFoodScreen({Key? key, required this.food, required this.selectedDate})
      : super(key: key);

  @override
  State<AddFoodScreen> createState() => _AddFoodScreenState();
}

class _AddFoodScreenState extends State<AddFoodScreen> {
  // late var _defaultValue;
  late String keyTime;
  bool isSuccess = false;
  final ValueNotifier<String> keyTimeNotifier = ValueNotifier<String>('아침');

  @override
  void initState() {
    super.initState();
    keyTime = '아침';
  }

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
        onPressed: () async {
          await _showNutrientSheet(context, widget.food);
        },
        style: ElevatedButton.styleFrom(
            minimumSize: const Size(50, 20),
            backgroundColor: Palette.mainSkyBlue,
            padding: const EdgeInsets.symmetric(vertical: 2, horizontal: 2),
            // 내부 패딩 조절
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(15))),
        child: const Text('+',
            style: TextStyle(
              color: Colors.white,
              fontSize: 21,
              fontWeight: FontWeight.w800,
            )));
  }

  Future<void> _showNutrientSheet(BuildContext context, Food foodData) async {
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
        maxHeight: 730,
      ),
      builder: (BuildContext context) {
        return ClipRRect(
            borderRadius: const BorderRadius.only(
              topLeft: Radius.circular(20),
              topRight: Radius.circular(20),
            ),
            child: Container(
              color: Colors.white,
              padding: const EdgeInsets.only(left: 30, right: 30, bottom: 35),
              child: Column(
                children: <Widget>[
                  SizedBox(height: 15),
                  Text(
                    "${foodData.foodName}",
                    style: const TextStyle(
                        color: Colors.black,
                        fontSize: 22,
                        fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 15),
                  Card(
                    color: Color(0xFFEFEFEF),
                    shape: RoundedRectangleBorder(
                      borderRadius:
                          BorderRadius.circular(30), // 모서리를 둥글게 만드는 값 설정
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(30.0),
                      child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          // 시작에 배치
                          children: [
                            Text(
                              "${foodData.calories}Kcal",
                              style: const TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 20,
                                color: Colors.black45,
                              ),
                            ),
                            const Divider(
                              color: Colors.black12, // 가로선의 색상 설정
                              thickness: 1, // 가로선의 두께 설정
                              height: 20, // 가로선의 높이 설정
                            ),
                            Padding(
                              padding: const EdgeInsets.symmetric(vertical: 10),
                              child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    const Text(
                                      "탄수화물",
                                      style: TextStyle(
                                          fontWeight: FontWeight.bold,
                                          fontSize: 15),
                                    ),
                                    Text(
                                      "${foodData.carbo}g",
                                      style: const TextStyle(
                                          fontWeight: FontWeight.bold,
                                          fontSize: 15),
                                    ),
                                  ]),
                            ),
                            Padding(
                              padding: EdgeInsets.all(5),
                              child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    const Text(
                                      "당류",
                                      style: TextStyle(
                                          fontWeight: FontWeight.bold,
                                          fontSize: 13,
                                          color: Colors.black45),
                                    ),
                                    Text(
                                      "${foodData.sugar}g",
                                      style: const TextStyle(
                                          fontWeight: FontWeight.bold,
                                          fontSize: 13,
                                          color: Colors.black45),
                                    ),
                                  ]),
                            ),
                            const Divider(
                              color: Colors.black12, // 가로선의 색상 설정
                              thickness: 1, // 가로선의 두께 설정
                              height: 20, // 가로선의 높이 설정
                            ),
                            Padding(
                              padding: const EdgeInsets.symmetric(vertical: 10),
                              child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    const Text(
                                      "단백질",
                                      style: TextStyle(
                                          fontWeight: FontWeight.bold,
                                          fontSize: 15),
                                    ),
                                    Text(
                                      "${foodData.protein}g",
                                      style: const TextStyle(
                                          fontWeight: FontWeight.bold,
                                          fontSize: 15),
                                    ),
                                  ]),
                            ),
                            const Divider(
                              color: Colors.black12, // 가로선의 색상 설정
                              thickness: 1, // 가로선의 두께 설정
                              height: 20, // 가로선의 높이 설정
                            ),
                            Padding(
                              padding: EdgeInsets.symmetric(vertical: 10),
                              child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    const Text(
                                      "지방",
                                      style: TextStyle(
                                          fontWeight: FontWeight.bold,
                                          fontSize: 15),
                                    ),
                                    Text(
                                      "${foodData.fat}g",
                                      style: TextStyle(
                                          fontWeight: FontWeight.bold,
                                          fontSize: 15),
                                    ),
                                  ]),
                            ),
                          ]),
                    ),
                  ),
                  const Spacer(),
                  //TODO : 영양성분 수정하는 버튼 추가
                  keyTimeSelecter(),
                  Container(
                      // padding: EdgeInsets.symmetric(vertical: 10),
                      margin: EdgeInsets.symmetric(vertical: 20),
                      width: double.infinity,
                      height: 50,
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                            backgroundColor: Palette.mainSkyBlue),
                        onPressed: () async {
                          print('Settings button pressed $keyTime');

                          saveFavoriteFoodToHiveBox(widget.food)
                              .then((value) => _showdialog(context, keyTime));
                        },
                        child: Text('저장하기',
                            style: TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                                fontSize: 20)),
                      ))
                ],
              ),
            ));
      },
    );
  }

  Future<dynamic> _showdialog(BuildContext context, String time) {
    return showDialog(
      context: context,
      builder: (BuildContext context) => AlertDialog(
        title: Text('${time}', style: TextStyle(fontWeight: FontWeight.bold)),
        content: Text('저장되었습니다'),
        actions: [
          ElevatedButton(
              onPressed: () => Get.offAll(() => DietScreen()),
              child: Text('확인')),
        ],
      ),
    );
  }

  Future<void> saveFavoriteFoodToHiveBox(Food food) async {
    String date = widget.selectedDate;
    print("saveFavorite dateeeee !!!  $date");

    Diet diet = Diet(
        stuNumber: '111',
        date: date,
        keyTime: keyTime,
        foodName: food.foodName,
        nutrient: food);

    if (food != null) {
      HiveDietHelper().createDiet(diet).then((value) {
        isSuccess = true;
      });
    }
  }

  Widget keyTimeSelecter() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        ValueListenableBuilder<String>(
          valueListenable: keyTimeNotifier,
          builder: (context, selectedValue, child) {
            return DecoratedBox(
              decoration: BoxDecoration(
                color: Palette.mainSkyBlue,
                border: Border.all(color: Palette.mainSkyBlue, width: 1),
                borderRadius: BorderRadius.circular(20),
              ),
              child: Padding(
                padding: EdgeInsets.only(left: 10, right: 10),
                child: DropdownButton(
                  iconSize: 20,
                  dropdownColor: Palette.mainSkyBlue,
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                  value: selectedValue,
                  items: [
                    DropdownMenuItem(value: '아침', child: Text('아침')),
                    DropdownMenuItem(value: '점심', child: Text('점심')),
                    DropdownMenuItem(value: '저녁', child: Text('저녁')),
                    DropdownMenuItem(value: '간식', child: Text('간식')),
                  ],
                  onChanged: (String? value) {
                    keyTimeNotifier.value = value ?? '아침';
                    keyTime = value ?? '아침';
                  },
                ),
              ),
            );
          },
        ),
        SizedBox(width: 10),
        Text(
          "에 먹었어요",
          style: TextStyle(
            fontSize: 20,
            color: Colors.black38,
            fontWeight: FontWeight.bold,
          ),
        )
      ],
    );
  }
}
