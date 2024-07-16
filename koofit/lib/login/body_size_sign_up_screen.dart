//Palette.mainSkyBlue
// import 'dart:ffi';
// import 'dart:ui_web';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:koofit/login/welcome_screen.dart';
import 'package:koofit/model/HiveUserHelper.dart';
import 'package:koofit/model/config/palette.dart';
import 'package:koofit/model/data/Nutrient.dart';
import 'package:koofit/model/data/user.dart';

class BodySignUpScreen extends StatefulWidget {
  const BodySignUpScreen({super.key});

  @override
  State<BodySignUpScreen> createState() => _BodySignUpScreenState();
}

class _BodySignUpScreenState extends State<BodySignUpScreen> {
  final formKey = GlobalKey<FormState>();

  final List<String> _textList = [
    '키를 입력해주세요.',
    '몸무게를 입력해주세요.',
    '목표 몸무게를 입력해주세요.'
  ];

  FocusNode node1 = FocusNode();
  FocusNode curWeightField = FocusNode();
  FocusNode goalWeightField = FocusNode();

  bool isHeightFilled = false;
  bool isCurWeightFilled = false;
  bool isgoalWeightFilled = false;

  bool isButtonActive = false;
  int titleIndex = 0;

  String _height = '';
  String _curWeight = '';
  String _goalWeight = '';

  @override
  Widget build(BuildContext context) {
    final args = ModalRoute.of(context)!.settings.arguments as User;

    return WillPopScope(
        onWillPop: () async {
          return false;
        },
        child: GestureDetector(
            onTap: hideKeyboard,
            child: Scaffold(
                appBar: AppBar(
                  backgroundColor: Colors.transparent,
                  elevation: 0,
                ),
                backgroundColor: const Color(0xFFffffff),
                body: Container(
                  padding:
                      const EdgeInsets.only(left: 20, right: 20, bottom: 20).r,
                  child: Form(
                    key: formKey,
                    child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            _textList[titleIndex],
                            style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 22.sp,
                                color: const Color.fromARGB(255, 51, 61, 75)),
                          ),
                          Visibility(
                            visible: isCurWeightFilled,
                            child: TextFormField(
                              onSaved: (val) {
                                setState(() {
                                  _curWeight = val.toString();
                                });
                              },
                              validator: (val) {
                                if (val != null) {
                                } else {
                                  return '목표 몸무게를 입력해주세요';
                                }
                                return null;
                              },
                              keyboardType: TextInputType.number,
                              inputFormatters: <TextInputFormatter>[
                                FilteringTextInputFormatter.digitsOnly
                              ],
                              // focusNode: node1,
                              onChanged: (text) {
                                setState(() {
                                  _curWeight = text;
                                  if (titleIndex >= 2) {
                                    if (_height.length > 2 &&
                                            _goalWeight.length > 1 &&
                                            _curWeight.length > 1
                                        // int.parse(_weight) >= 15 &&
                                        // int.parse(_weight) <= 19
                                        ) {
                                      isButtonActive = true;
                                    } else {
                                      isButtonActive = false;
                                    }
                                  }
                                });
                              },
                              maxLength: 3,
                              focusNode: goalWeightField,
                              autofocus: true,
                              decoration: const InputDecoration(
                                  // errorText: _weight.isNotEmpty && _weight.length >2
                                  //     ? int.parse(_weight) >= 20
                                  //         ? '만 19세 이상은 서비스 이용이 제한됩니다.'
                                  //         : int.parse(_weight) < 15
                                  //             ? '15세 미만은 서비스 이용이 제한됩니다.'
                                  //             : null
                                  //     : null,
                                  counterText: '',
                                  focusedBorder: UnderlineInputBorder(
                                      borderSide: BorderSide(
                                          color: Palette.mainSkyBlue)),
                                  labelText: "목표 몸무게",
                                  labelStyle: TextStyle(
                                      color:
                                          Color.fromARGB(255, 182, 183, 184))),
                            ),
                          ),
                          Visibility(
                            visible: isHeightFilled,
                            child: TextFormField(
                              onSaved: (val) {
                                setState(() {
                                  _goalWeight = val.toString();
                                });
                              },
                              validator: (val) {
                                if (val != null) {
                                  if (val.length > 4) {
                                    return '올바른 몸무게를 입력해주세요';
                                  }
                                } else {
                                  return '몸무게를 입력해주세요';
                                }
                                return null;
                              },
                              autofocus: true,
                              focusNode: curWeightField,
                              maxLength: 3,
                              keyboardType: TextInputType.number,
                              inputFormatters: <TextInputFormatter>[
                                FilteringTextInputFormatter.digitsOnly
                              ],
                              onChanged: (text) {
                                setState(() {
                                  _goalWeight = text;
                                  if (titleIndex == 1) {
                                    if (text.length > 1) {
                                      titleIndex = 2;
                                      isCurWeightFilled = true;
                                    }
                                  } else if (titleIndex > 2) {
                                    if (_height.isNotEmpty &&
                                        _goalWeight.length > 2 &&
                                        _curWeight.length > 2) {
                                      isButtonActive = true;
                                    } else {
                                      isButtonActive = false;
                                    }
                                  }
                                });
                                print("ㅇㅇㅇㅇ ${titleIndex}, ${text}");
                              },
                              decoration: const InputDecoration(
                                  counterText: '',
                                  focusedBorder: UnderlineInputBorder(
                                      borderSide: BorderSide(
                                          color: Palette.mainSkyBlue)),
                                  labelText: "몸무게",
                                  labelStyle: TextStyle(
                                      color:
                                          Color.fromARGB(255, 182, 183, 184))),
                            ),
                          ),
                          TextFormField(
                            inputFormatters: <TextInputFormatter>[
                              FilteringTextInputFormatter.digitsOnly
                            ],
                            onSaved: (val) {
                              setState(() {
                                _height = val.toString();
                              });
                            },
                            validator: (val) {
                              if (val != null) {
                                return null;
                              } else {
                                return '키를 입력해주세요';
                              }
                            },
                            focusNode: node1,
                            autofocus: true,
                            onChanged: (value) {
                              setState(() {
                                _height = value;
                                print("_height : ${_height}, ${titleIndex}");
                                if (titleIndex == 0 && _height.length == 3) {
                                  curWeightField.requestFocus();
                                  titleIndex = 1;
                                  isHeightFilled = true;
                                } else if (titleIndex > 2) {
                                  if (_height.isNotEmpty &&
                                      _goalWeight.length > 2 &&
                                      _curWeight.length > 2) {
                                    isButtonActive = true;
                                  } else {
                                    isButtonActive = false;
                                  }
                                }
                              });
                            },
                            decoration: const InputDecoration(
                                focusedBorder: UnderlineInputBorder(
                                    borderSide:
                                        BorderSide(color: Palette.mainSkyBlue)),
                                labelText: "키",
                                labelStyle: TextStyle(
                                    color: Color.fromARGB(255, 182, 183, 184))),
                          ),
                          const Spacer(),
                          Visibility(
                              visible: isButtonActive,
                              child: SizedBox(
                                  width: double.infinity,
                                  height: 50.h,
                                  child: ElevatedButton(
                                    style: ElevatedButton.styleFrom(
                                        backgroundColor: Palette.mainSkyBlue,
                                        disabledForegroundColor: titleIndex > 2
                                            ? Colors.white
                                            : null,
                                        disabledBackgroundColor: titleIndex > 2
                                            ? Palette.mainSkyBlue
                                                .withOpacity(0.12)
                                            : null),
                                    onPressed: () {
                                      if (titleIndex == 0) {
                                        setState(() {
                                          curWeightField.requestFocus();
                                          isButtonActive = false;
                                          isHeightFilled = true;
                                          titleIndex = 1;
                                        });
                                      } else if (titleIndex == 1) {
                                        setState(() {
                                          goalWeightField.requestFocus();
                                          isButtonActive = false;
                                          isCurWeightFilled = true;
                                          titleIndex = 2;
                                        });
                                      } else {
                                        if (formKey.currentState != null) {
                                          // 만약, currentState 있다면
                                          if (formKey.currentState!
                                              .validate()) {
                                            formKey.currentState!.save();
                                            args.goalWeight =
                                                int.parse(_goalWeight);
                                            args.height = int.parse(_height);
                                            args.curWeight =
                                                int.parse(_curWeight);
                                            print("args : ${args}");

                                            //목표 칼로리, 영양성분 저장

                                            int caloriesValue =
                                                ((args.goalWeight!.toInt()) *
                                                        30 -
                                                    500);

                                            args.goalNutrient = Nutrient(
                                                calories: caloriesValue,
                                                carbo:
                                                    (caloriesValue * 0.5 ~/ 4),
                                                protein:
                                                    (caloriesValue * 0.2 ~/ 4),
                                                fat:
                                                    (caloriesValue * 0.25 ~/ 4),
                                                fitnessTime: 30);

                                            print(
                                                "goalNutrient: ${args.goalNutrient}");

                                            Navigator.push(
                                              context,
                                              MaterialPageRoute(
                                                builder: (context) =>
                                                    WelcomeScreen(user: args),
                                              ),
                                            );
                                          }
                                        }
                                      }
                                    },
                                    child: Text('확인',
                                        style: TextStyle(
                                            color: Colors.white,
                                            fontWeight: FontWeight.bold,
                                            fontSize: 20.sp)),
                                  ))),
                        ]),
                  ),
                ))));
  }

  void hideKeyboard() {
    FocusScope.of(context).unfocus();
  }
}
