import 'package:flutter/material.dart';
import 'package:koofit/model/config/palette.dart';
import 'package:koofit/model/data/diet.dart';
import 'package:koofit/widget/RectangleText.dart';

class keyTimeBox extends StatefulWidget {
  final String keyTime;
  final List<Diet> keyTimeDietList;

  const keyTimeBox(
      {super.key, required this.keyTime, required this.keyTimeDietList});

  @override
  State<keyTimeBox> createState() => _keyTimeBoxState();
}

class _keyTimeBoxState extends State<keyTimeBox> {
  List<Diet> keyTimeDiets = [];

  int totalCalories = 0;
  int totalCarbo = 0;
  int totalProtein = 0;
  int totalFat = 0;

  String keyTime = '';
  List<Row> morningRows = [];
  Size deviceSize = const Size(350, 680);

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    keyTime = widget.keyTime;
    print(keyTime);
    keyTimeDiets = widget.keyTimeDietList
        .where((diet) => diet.keyTime == widget.keyTime)
        .toList();

    // 총칼로리 data 추출, 탄단지 섭취율 계산
    totalCalories = (keyTimeDiets.fold<int>(
        0, (sum, diet) => sum + (diet.nutrient.calories?.toInt() ?? 0)));
    totalCarbo = (keyTimeDiets.fold<int>(
        0, (sum, diet) => sum + (diet.nutrient.carbo?.toInt() ?? 0)));
    totalProtein = (keyTimeDiets.fold<int>(
        0, (sum, diet) => sum + (diet.nutrient.protein?.toInt() ?? 0)));
    totalFat = (keyTimeDiets.fold<int>(
        0, (sum, diet) => sum + (diet.nutrient.fat?.toInt() ?? 0)));

    // morningDiets를 사용하여 Row 위젯을 생성합니다.
    morningRows = keyTimeDiets.map((diet) {
      return Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          SizedBox(
              width: deviceSize.width * 0.4,
              child: Text(
                diet.foodName,
                textAlign: TextAlign.start,
                maxLines: 1,
                overflow: TextOverflow.fade,
                style: const TextStyle(
                  fontSize: 12,
                  color: Color(0xC6222B45),
                  fontWeight: FontWeight.w500,
                ),
              )),
          Text(
            '${diet.nutrient.calories!.toInt()} kcal',
            textAlign: TextAlign.right,
            style: const TextStyle(
              color: Color(0xc6222B45),
              fontSize: 10,
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      );
    }).toList();
  }

  @override
  Widget build(BuildContext context) {
    deviceSize = MediaQuery.of(context).size;
    return Container(
        margin: const EdgeInsets.symmetric(vertical: 10, horizontal: 5),
        width: double.infinity,
        child: IntrinsicHeight(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Expanded(
                    child: Container(
                      decoration: const BoxDecoration(
                        color: Palette.mainSkyBlue,
                        borderRadius: BorderRadius.only(
                          topLeft: Radius.circular(20.0),
                          bottomLeft: Radius.circular(20.0),
                        ),
                      ),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Image.asset('assets/images/healthy_food.png',
                              width: 20, height: 20),
                          Text(
                            keyTime,
                            style: const TextStyle(
                                fontWeight: FontWeight.bold, fontSize: 18),
                          ),
                        ],
                      ),
                    )),
                Container(
                  width: deviceSize.width * 0.6,
                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
                  decoration: const BoxDecoration(
                    color: Color(0xefcfcfaee),
                    borderRadius: BorderRadius.only(
                      topRight: Radius.circular(15.0),
                      bottomRight: Radius.circular(15.0),
                    ),
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        // Align children to both ends
                        children: [
                          const Text(
                            "총 칼로리",
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 15,
                            ),
                          ),
                          Text(
                            '$totalCalories kcal',
                            style: const TextStyle(
                              color: Color(0xC6222B45),
                              fontSize: 15,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 10),
                      ...morningRows,
                      const SizedBox(height: 10),
                      Row(
                        children: [
                          RectangleText(
                            Palette.tanSu,
                            realGram: totalCarbo,
                          ),
                          const SizedBox(width: 10),
                          RectangleText(
                            Palette.danBaek,
                            realGram: totalProtein,
                          ),
                          const SizedBox(width: 10),
                          RectangleText(
                            Palette.jiBang,
                            realGram: totalFat,
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            )));
  }
}
