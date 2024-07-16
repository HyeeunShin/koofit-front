//Palette.mainSkyBlue
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:koofit/model/config/palette.dart';
import 'package:koofit/model/data/Nutrient.dart';
import 'package:koofit/model/data/user.dart';

class SignUpScreen extends StatefulWidget {
  const SignUpScreen({super.key});

  @override
  State<SignUpScreen> createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
  final formKey = GlobalKey<FormState>();

  final List<String> _textList = [
    '이름을 입력해주세요.',
    '성별을 선택해주세요.',
    '휴대폰 번호를 입력해주세요.',
    '나이를 입력해주세요.',
    '학번(8자리)를 입력해주세요.'
  ];

  FocusNode node1 = FocusNode();
  FocusNode numberField = FocusNode();
  FocusNode genderField = FocusNode();
  FocusNode ageField = FocusNode();
  FocusNode stuNumField = FocusNode();

  bool isNameFilled = false;
  bool isNumberFilled = false;
  bool isAgeFilled = false;
  bool isGenderSelected = false;
  bool isStuNumFilled = false;
  bool isButtonActive = false;

  int titleIndex = 0;

  String _name = '';
  String _age = '';
  String _number = '';
  String _stuNum = '';
  String _gender = '';

  @override
  Widget build(BuildContext context) {
    // final args = ModalRoute.of(context)!.settings.arguments as User;

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
                            //학번 입력
                            visible: isAgeFilled,
                            child: TextFormField(
                              onSaved: (val) {
                                setState(() {
                                  _stuNum = val.toString();
                                });
                              },
                              validator: (val) {
                                if (val != null) {
                                } else {
                                  return '학번을 입력해주세요';
                                }
                                return null;
                              },
                              keyboardType: TextInputType.number,
                              inputFormatters: <TextInputFormatter>[
                                FilteringTextInputFormatter.digitsOnly
                              ],
                              onChanged: (text) {
                                setState(() {
                                  _stuNum = text;
                                  if (titleIndex == 4) {
                                    if (_name.isNotEmpty &&
                                        _number.length == 11 &&
                                        _age.length == 2 &&
                                        _stuNum.length == 8) {
                                      isButtonActive = true;
                                    } else {
                                      isButtonActive = false;
                                    }
                                  }
                                });
                              },
                              maxLength: 8,
                              autofocus: true,
                              focusNode: stuNumField,
                              decoration: const InputDecoration(
                                  counterText: '',
                                  focusedBorder: UnderlineInputBorder(
                                      borderSide: BorderSide(
                                          color: Palette.mainSkyBlue)),
                                  labelText: "학번",
                                  labelStyle: TextStyle(
                                      color:
                                          Color.fromARGB(255, 182, 183, 184))),
                            ),
                          ),
                          Visibility(
                            //나이 입력
                            visible: isNumberFilled,
                            child: TextFormField(
                              onSaved: (val) {
                                setState(() {
                                  _age = val.toString();
                                });
                              },
                              validator: (val) {
                                if (val != null) {
                                } else {
                                  return '나이를 입력해주세요';
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
                                  _age = text;
                                  print("${titleIndex}");
                                  if (titleIndex == 3) {
                                    if (_name.isNotEmpty &&
                                        _number.length == 11 &&
                                        _age.length == 2) {
                                      stuNumField.requestFocus();
                                      titleIndex = 4;
                                      isAgeFilled = true;
                                    } else {}
                                  }
                                });
                              },
                              maxLength: 2,
                              focusNode: ageField,
                              autofocus: true,
                              decoration: const InputDecoration(
                                  counterText: '',
                                  focusedBorder: UnderlineInputBorder(
                                      borderSide: BorderSide(
                                          color: Palette.mainSkyBlue)),
                                  labelText: "나이",
                                  labelStyle: TextStyle(
                                      color:
                                          Color.fromARGB(255, 182, 183, 184))),
                            ),
                          ),
                          Visibility(
                            visible: isGenderSelected,
                            child: TextFormField(
                              onSaved: (val) {
                                setState(() {
                                  _number = val.toString();
                                });
                              },
                              validator: (val) {
                                if (val != null) {
                                  if (val.length != 11) {
                                    return '올바른 휴대폰 번호를 입력해주세요';
                                  } else {
                                    if (!val.startsWith('010')) {
                                      return "'010'으로 시작하는 올바른 휴대폰 번호를 입력해주세요";
                                    } else {
                                      return null;
                                    }
                                  }
                                } else {
                                  return '휴대폰 번호를 입력해주세요';
                                }
                              },
                              autofocus: true,
                              focusNode: numberField,
                              maxLength: 11,
                              keyboardType: TextInputType.number,
                              inputFormatters: <TextInputFormatter>[
                                FilteringTextInputFormatter.digitsOnly
                              ],
                              onChanged: (text) {
                                setState(() {
                                  _number = text;
                                  if (titleIndex == 2) {
                                    if (text.length == 11) {
                                      ageField.requestFocus();
                                      isNumberFilled = true;
                                      titleIndex = 3;
                                    }
                                  } else if (titleIndex == 2) {
                                    if (_name.isNotEmpty &&
                                        _number.length == 11 &&
                                        _age.length == 2) {
                                      isButtonActive = true;
                                    } else {
                                      isButtonActive = false;
                                    }
                                  }
                                });
                              },
                              decoration: const InputDecoration(
                                  counterText: '',
                                  focusedBorder: UnderlineInputBorder(
                                      borderSide: BorderSide(
                                          color: Palette.mainSkyBlue)),
                                  labelText: "휴대폰 번호",
                                  labelStyle: TextStyle(
                                      color:
                                          Color.fromARGB(255, 182, 183, 184))),
                            ),
                          ),
                          Visibility(
                              visible: isNameFilled,
                              child: DropdownButtonFormField<String>(
                                autofocus: true,
                                focusNode: genderField,
                                decoration: const InputDecoration(
                                    focusedBorder: UnderlineInputBorder(
                                        borderSide: BorderSide(
                                            color: Palette.mainSkyBlue)),
                                    labelText: "성별",
                                    labelStyle: TextStyle(
                                        color: Color.fromARGB(
                                            255, 182, 183, 184))),
                                onChanged: (text) {
                                  setState(() {
                                    _gender = text!;
                                    print("ㅇㅇㅇㅇ ${titleIndex}, ${_gender}");

                                    if (titleIndex == 1) {
                                      if (_gender.length == 1) {
                                        numberField.requestFocus();
                                        isGenderSelected = true;
                                        titleIndex = 2;
                                      }
                                    }
                                  });
                                },
                                items: ['M', 'F']
                                    .map<DropdownMenuItem<String>>((String i) {
                                  return DropdownMenuItem<String>(
                                    value: i,
                                    child: Text({'M': '남성', 'F': '여성'}[i]!),
                                  );
                                }).toList(),
                              )),
                          TextFormField(
                            inputFormatters: [
                              FilteringTextInputFormatter.allow(
                                  RegExp('[ㄱ-ㅎㅏ-ㅣ가-힣]')),
                            ],
                            onSaved: (val) {
                              setState(() {
                                _name = val.toString();
                              });
                            },
                            validator: (val) {
                              if (val != null) {
                                final consonantsPattern = RegExp(
                                    r'^[ㄱ-ㅎ]*$'); // 한글 모음을 정규표현식으로 나타낸 패턴
                                final vowelsPattern = RegExp(
                                    r'^[ㅏ-ㅣ]*$'); // 한글 모음을 정규표현식으로 나타낸 패턴

                                for (var i = 0; i < val.length; i++) {
                                  if (consonantsPattern.hasMatch(val[i]) ||
                                      vowelsPattern.hasMatch(val[i])) {
                                    return '올바른 이름을 한글로 입력해주세요';
                                  }
                                }
                                return null;
                              } else {
                                return '이름을 입력해주세요';
                              }
                            },
                            focusNode: node1,
                            autofocus: true,
                            onChanged: (value) {
                              setState(() {
                                _name = value;
                                if (titleIndex == 0) {
                                  isButtonActive = value.isNotEmpty;
                                } else if (titleIndex == 2) {
                                  if (_name.isNotEmpty &&
                                      _number.length == 11 &&
                                      _age.length == 2) {
                                    genderField.requestFocus();
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
                                labelText: "이름",
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
                                        disabledForegroundColor: titleIndex == 4
                                            ? Colors.white
                                            : null,
                                        disabledBackgroundColor: titleIndex == 4
                                            ? Palette.mainSkyBlue
                                                .withOpacity(0.12)
                                            : null),
                                    onPressed: () {
                                      print(titleIndex);
                                      if (titleIndex == 0) {
                                        setState(() {
                                          numberField.requestFocus();
                                          isButtonActive = false;
                                          isNameFilled = true;
                                          titleIndex = 1;
                                        });
                                      } else if (titleIndex == 1) {
                                        isGenderSelected = true;
                                      } else {
                                        if (formKey.currentState != null) {
                                          // 만약, currentState 있다면
                                          if (formKey.currentState!
                                              .validate()) {
                                            formKey.currentState!.save();
                                            User _userData = User(
                                                uid: "임의의숫자2222",
                                                name: _name,
                                                age: _age,
                                                number: _number,
                                                stuNumber: _stuNum,
                                                gender: _gender,
                                                height: 0,
                                                curWeight: 0,
                                                goalNutrient: Nutrient(
                                                    calories: 0,
                                                    carbo: 0,
                                                    protein: 0,
                                                    fat: 0,
                                                    fitnessTime: 30),
                                                goalWeight: 0,
                                                fitnessList: [],
                                                todayNutrientList: [],
                                                recordedDayList: [],
                                                favorieFoodList: []);
                                            Navigator.pushNamed(
                                                context, 'BodySignUp',
                                                arguments: _userData);
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
