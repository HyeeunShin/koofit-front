import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:koofit/main_screen/main_diet_screen/diet_screen.dart';
import 'package:koofit/model/HiveFitnessHelper.dart';
import 'package:koofit/model/config/palette.dart';
import 'package:koofit/model/data/fitness.dart';
import 'package:koofit/fitness/core/app_export.dart';
import 'package:get/get.dart';

class AddFitness extends StatefulWidget {
  final String selectedDate;

  const AddFitness({super.key, required this.selectedDate});

  @override
  _AddFitnessState createState() => _AddFitnessState();
}

class _AddFitnessState extends State<AddFitness> {
  late List<bool> isSelected;
  String result = '';

  bool isWeak = true;
  bool isMiddle = false;
  bool isStrong = false;

  bool _isCheckCardio = false;
  bool _isCheckWeight = false;
  bool _isCheckStretch = false;
  List<String> fitnessCheckList = [];

  TextStyle selectedTextStyle =
      const TextStyle(fontWeight: FontWeight.bold, color: Colors.white);
  TextStyle unselectedTextStyle = const TextStyle();
  FocusNode timeField = FocusNode();

  List<String> whatFitnessList = [];
  String time = '';
  String strong = '';
  late TextEditingController timeController = TextEditingController();

  @override
  void initState() {
    isSelected = [isStrong, isMiddle, isWeak];
    super.initState();
    print(widget.selectedDate);
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
    return Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.transparent,
          elevation: 0,
        ),
        body: GestureDetector(
            onTap: () {
              // 다른 부분을 터치하면 포커스 해제하여 키보드를 내립니다.
              FocusScope.of(context).requestFocus(FocusNode());
            },
            child: Container(
              color: Colors.white,
              padding: const EdgeInsets.only(
                  top: 5, left: 15, right: 15, bottom: 35),
              child: Column(
                children: <Widget>[
                  const Text(
                    "오늘의 운동을 기록해볼까요?",
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 35),
                  Padding(
                    padding: const EdgeInsets.all(10.0),
                    child: Column(
                      children: [
                        nameSection(),
                        SizedBox(height: 34.v),
                        timeSection(),
                        SizedBox(height: 35.v),
                        StrongSection(),
                        SizedBox(height: 60.v),
                      ],
                    ),
                  ),
                  const Spacer(),
                  buildSection(),
                ],
              ),
            ))); // Your existing build method content
  }

  Widget nameSection() {
    return Container(
        padding: EdgeInsets.symmetric(
          horizontal: 15.h,
          vertical: 10.v,
        ),
        decoration: AppDecoration.outlineBlack.copyWith(
          color: Colors.white,
          borderRadius: BorderRadiusStyle.roundedBorder30,
        ),
        child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const Text("운동 종류",
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 17)),
              Column(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(
                        height: 20,
                        child: Row(children: [
                          Checkbox(
                            value: _isCheckCardio,
                            onChanged: (value) {
                              setState(() {
                                _isCheckCardio = value!;
                              });
                            },
                            checkColor: Colors.white,
                            // Set the color when the checkbox is checked
                            activeColor: Palette.mid_dark_mainSkyBlue,
                            shape: RoundedRectangleBorder(
                              side: const BorderSide(
                                  width: 1, color: Colors.grey),
                              // Set the border thickness and color
                              borderRadius: BorderRadius.circular(
                                  5), // Adjust border radius if needed
                            ), // Set the color of the checkbox itself
                          ),
                          const Text("유산소"),
                          Checkbox(
                            value: _isCheckWeight,
                            onChanged: (value) {
                              setState(() {
                                _isCheckWeight = value!;
                              });
                            },
                            checkColor: Colors.white,
                            // Set the color when the checkbox is checked
                            activeColor: Palette.mid_dark_mainSkyBlue,
                            shape: RoundedRectangleBorder(
                              side: const BorderSide(
                                  width: 1, color: Colors.grey),
                              // Set the border thickness and color
                              borderRadius: BorderRadius.circular(
                                  5), // Adjust border radius if needed
                            ),
                          ),
                          const Text("무산소"),
                        ])),
                    const SizedBox(height: 8),
                    SizedBox(
                        height: 20,
                        child: Row(children: [
                          Checkbox(
                            value: _isCheckStretch,
                            onChanged: (value) {
                              setState(() {
                                _isCheckStretch = value!;
                              });
                            },
                            checkColor: Colors.white,
                            // Set the color when the checkbox is checked
                            activeColor: Palette.mid_dark_mainSkyBlue,
                            shape: RoundedRectangleBorder(
                              side: const BorderSide(
                                  width: 1, color: Colors.grey),
                              // Set the border thickness and color
                              borderRadius: BorderRadius.circular(
                                  5), // Adjust border radius if needed
                            ),
                          ),
                          const Text("스트레칭"),
                        ]))
                  ])
            ]));
  }

  /// Section Widget
  Widget timeSection() {
    return Container(
        padding: EdgeInsets.symmetric(
          horizontal: 20.h,
          vertical: 15.v,
        ),
        decoration: AppDecoration.outlineBlack.copyWith(
          color: Colors.white,
          borderRadius: BorderRadiusStyle.roundedBorder30,
        ),
        child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const Text("운동 시간",
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 17)),
              const Spacer(),
              SizedBox(
                  width: 60,
                  height: 20,
                  child: TextFormField(
                      controller: timeController,
                      // Add this line to use the controller
                      onSaved: (val) {
                        setState(() {
                          time = val.toString();
                        });
                      },
                      validator: (val) {
                        if (val != null) {
                        } else {
                          return '운동시간';
                        }
                        return null;
                      },
                      keyboardType: TextInputType.number,
                      inputFormatters: <TextInputFormatter>[
                        FilteringTextInputFormatter.digitsOnly
                      ],
                      onChanged: (text) {
                        setState(() {});
                      },
                      maxLength: 3,
                      textAlign: TextAlign.center,
                      decoration: const InputDecoration(
                          contentPadding: EdgeInsets.symmetric(vertical: 9),
                          counterText: '',
                          labelStyle: TextStyle(
                              fontWeight: FontWeight.bold, fontSize: 12),
                          focusedBorder: UnderlineInputBorder(
                              borderSide:
                                  BorderSide(color: Palette.mainSkyBlue))))),
              const Text(
                "분",
                style: TextStyle(color: Colors.black87, fontSize: 17),
              ),
            ]));
  }

  /// Section Widget
  Widget StrongSection() {
    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: 15.h,
        vertical: 10.v,
      ),
      decoration: AppDecoration.outlineBlack.copyWith(
        borderRadius: BorderRadiusStyle.roundedBorder30,
        color: Colors.white,
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          const Text("운동 강도",
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 17)),
          const SizedBox(width: 10),
          ToggleButtons(
            isSelected: isSelected,
            onPressed: toggleSelect,
            borderRadius: BorderRadius.circular(20.0),
            constraints: const BoxConstraints(
              minHeight: 33.0,
              maxWidth: 65.0,
            ),
            selectedColor: Colors.black54,
            fillColor: Palette.mid_dark_mainSkyBlue,
            color: Colors.black54,
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 9),
                child: Text('가볍게',
                    style: isSelected[0]
                        ? selectedTextStyle
                        : unselectedTextStyle),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 9),
                child: Text('적당히',
                    style: isSelected[1]
                        ? selectedTextStyle
                        : unselectedTextStyle),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 9),
                child: Text('격하게',
                    style: isSelected[2]
                        ? selectedTextStyle
                        : unselectedTextStyle),
              )
            ],
          )
        ],
      ),
    );
  }

  /// Section Widget
  Widget buildSection() {
    return SizedBox(
        width: double.infinity,
        height: 50.h,
        child: ElevatedButton(
            style: ElevatedButton.styleFrom(
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(15)),
                backgroundColor: Palette.mainSkyBlue,
                disabledBackgroundColor: Palette.mainSkyBlue.withOpacity(0.12)),
            onPressed: () {
              _saveData();
              _showdialog(context, "운동 잘하셨습니다!");
            },
            child: const Text('추가',
                style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 20,
                    color: Colors.white))));
  }

  void _saveData() {
    if (_isCheckCardio) {
      whatFitnessList.add('유산소');
    }
    if (_isCheckWeight) {
      whatFitnessList.add('무산소');
    }
    if (_isCheckStretch) {
      whatFitnessList.add('스트레칭');
    }

    time = timeController.text;

    // 예시: strong 변수에 선택된 강도 저장
    if (isStrong) {
      strong = '가볍게';
    } else if (isMiddle) {
      strong = '적당히';
    } else if (isWeak) {
      strong = '격하게';
    }

    HiveFitnessHelper().createFitness(Fitness(
        uid: "",
        stuNumber: "stuNumber",
        date: widget.selectedDate,
        whatFitnessList: whatFitnessList,
        time: int.parse(time),
        strong: strong));
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
}
