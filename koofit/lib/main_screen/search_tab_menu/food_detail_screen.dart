import 'package:flutter/material.dart';
import 'package:koofit/main_screen/main_diet_screen/diet_screen.dart';
import 'package:koofit/model/HiveDietHelper.dart';
import 'package:koofit/model/HiveUserHelper.dart';
import 'package:koofit/model/config/palette.dart';
import 'package:koofit/model/data/food.dart';
import 'package:koofit/model/data/diet.dart';
import 'package:koofit/model/data/user.dart';
import 'package:get/get.dart';

class DetailsPage extends StatefulWidget {
  final List<String> rowData;
  final User userData;
  final String selectedDate;

  // Make either rowData or foodData required, not both
  const DetailsPage(
      {super.key,
      required this.rowData,
      required this.userData,
      required this.selectedDate});

  @override
  DetailsPageState createState() => DetailsPageState();
}

class DetailsPageState extends State<DetailsPage> {
  late Food food;
  late Diet diet;
  late User _userData;
  bool isFavorite = false;
  bool isSuccess = false;

  String keyTime = '아침';
  int num = 1;

  @override
  void initState() {
    super.initState();
    _userData = widget.userData;
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (widget.rowData.length >= 21) {
      food = Food(
        foodCode: widget.rowData[0],
        foodName: widget.rowData[1],
        manufacturer: widget.rowData[2],
        foodWeight: widget.rowData[14],
        calories: double.tryParse(widget.rowData[16]),
        protein: double.tryParse(widget.rowData[17]),
        fat: double.tryParse(widget.rowData[18]),
        carbo: double.tryParse(widget.rowData[19]),
        sugar: double.tryParse(widget.rowData[20]),
      );
    }
  }

  onHeartTap() async {
    setState(() {
      isFavorite = !isFavorite;
    });

    if (isFavorite) {
      _userData.favorieFoodList.add(food);
    } else {
      _userData.favorieFoodList.remove(food);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Palette.mainSkyBlue,
        title: const Text(
          '영양성분',
          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
        ),
        actions: [
          IconButton(
              onPressed: onHeartTap,
              icon: Icon(
                isFavorite ? Icons.favorite : Icons.favorite_outline_rounded,
                size: 29,
              )),
          IconButton(
            icon: const Icon(
              Icons.add,
              size: 29,
            ),
            onPressed: () async {
              saveFoodToHiveBox(food, isFavorite)
                  .then((value) => _showdialog(context, keyTime));
            },
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: SingleChildScrollView(
            child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const SizedBox(height: 5),
            _buildTile('식품명', food.foodName),
            _buildTile('식품 중량(g)',
                '${food.foodWeight != null ? (double.parse(widget.rowData[14].replaceAll('g', ''))) * num : '정보없음'}'),
            _buildTile(
                '에너지(kcal)',
                food.calories != null
                    ? (double.parse(widget.rowData[16]) * num)
                        .toStringAsFixed(2)
                    : '정보없음'),
            _buildTile(
                '탄수화물(g)',
                food.carbo != null
                    ? (double.parse(widget.rowData[19]) * num)
                        .toStringAsFixed(2)
                    : '정보없음'),
            _buildTile(
                '당류(g)',
                food.sugar != null
                    ? (double.parse(widget.rowData[20]) * num)
                        .toStringAsFixed(2)
                    : '정보없음'),
            _buildTile(
                '단백질(g)',
                food.protein != null
                    ? (double.parse(widget.rowData[17]) * num)
                        .toStringAsFixed(2)
                    : '정보없음'),
            _buildTile(
                '지방(g)',
                food.fat != null
                    ? (double.parse(widget.rowData[18]) * num)
                        .toStringAsFixed(2)
                    : '정보없음'),
            const SizedBox(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                DecoratedBox(
                  decoration: BoxDecoration(
                    color: Palette.mainSkyBlue,
                    //background color of dropdown button
                    border: Border.all(color: Palette.mainSkyBlue, width: 1),
                    //border of dropdown button
                    borderRadius: BorderRadius.circular(
                        20), //border raiuds of dropdown button
                  ),
                  child: Row(
                    children: [
                      IconButton(
                        onPressed: () {
                          print(widget.rowData);
                          if (num > 1) {
                            num--;
                          }
                          print(num);
                          setState(() {});
                        },
                        icon: const Icon(
                          Icons.remove,
                          size: 29,
                        ),
                      ),
                      Text(
                        '$num',
                        style: const TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                            color: Colors.white),
                      ),
                      IconButton(
                        onPressed: () {
                          print(widget.rowData);
                          num++;
                          print(num);
                          setState(() {});
                        },
                        icon: const Icon(
                          Icons.add,
                          size: 29,
                        ),
                      ),
                    ],
                  ),
                )
              ],
            ),
            const SizedBox(height: 25),
            Row(mainAxisAlignment: MainAxisAlignment.center, children: [
              DecoratedBox(
                  decoration: BoxDecoration(
                    color: Palette.mainSkyBlue,
                    //background color of dropdown button
                    border: Border.all(color: Palette.mainSkyBlue, width: 1),
                    //border of dropdown button
                    borderRadius: BorderRadius.circular(
                        20), //border raiuds of dropdown button
                  ),
                  child: Padding(
                      padding: const EdgeInsets.only(left: 10, right: 10),
                      child: DropdownButton(
                        iconSize: 25,
                        dropdownColor: Palette.mainSkyBlue,
                        style: const TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                            color: Colors.white),
                        value: keyTime,
                        items: const [
                          DropdownMenuItem(value: '아침', child: Text('아침')),
                          DropdownMenuItem(value: '점심', child: Text('점심')),
                          DropdownMenuItem(value: '저녁', child: Text('저녁')),
                          DropdownMenuItem(value: '간식', child: Text('간식')),
                        ],
                        onChanged: (String? value) {
                          setState(() {
                            keyTime = value!;
                          });
                        },
                      ))),
              const SizedBox(width: 10),
              const Text(
                "에 먹었어요",
                style: TextStyle(
                    fontSize: 20,
                    color: Colors.black38,
                    fontWeight: FontWeight.bold),
              )
            ])
          ],
        )),
      ),
    );
  }

  Future<dynamic> _showdialog(BuildContext context, String time) {
    return showDialog(
      context: context,
      builder: (BuildContext context) => AlertDialog(
        title: Text(time, style: const TextStyle(fontWeight: FontWeight.bold)),
        content: const Text('저장되었습니다'),
        actions: [
          ElevatedButton(
              onPressed: () => Get.offAll(() => const DietScreen()),
              child: const Text('확인')),
        ],
      ),
    );
  }

  Widget _buildTile(String title, String value) {
    double? updatedValue;

    if (title != '식품명') {
      updatedValue = double.tryParse(value) ?? null;
      // 문자열을 double로 변환하고 실패할 경우 그대로 사용합니다.

      // 업데이트된 값을 food 객체에 저장합니다.
      if (title == '식품 중량(g)') {
        food.foodWeight = updatedValue?.toStringAsFixed(2);
      } else if (title == '에너지(kcal)') {
        food.calories = updatedValue;
      } else if (title == '탄수화물(g)') {
        food.carbo = updatedValue;
      } else if (title == '당류(g)') {
        food.sugar = updatedValue;
      } else if (title == '단백질(g)') {
        food.protein = updatedValue;
      } else if (title == '지방(g)') {
        food.fat = updatedValue;
      }
    }
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 2),
      child: Card(
        color: Colors.white,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        elevation: 2.0,
        child: ListTile(
          title: Row(
            children: [
              Text(
                '$title  : ',
                style:
                    const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
              ),
              Text(
                value, // 업데이트된 값을 표시합니다.
                style: const TextStyle(fontSize: 15),
                overflow: TextOverflow.fade,
              )
            ],
          ),
        ),
      ),
    );
  }

  Future<void> saveFoodToHiveBox(Food food, bool isFavoite) async {
    String date = widget.selectedDate;

    diet = Diet(
        stuNumber: '111',
        date: date,
        keyTime: keyTime,
        foodName: food.foodName,
        nutrient: food);

    if (food != null) {
      HiveDietHelper().createDiet(diet).then((value) {
        isSuccess = true;
      });

      if (isFavoite) {
        HiveUserHelper().updateUser(0, _userData);
      }
    }
  }
}
