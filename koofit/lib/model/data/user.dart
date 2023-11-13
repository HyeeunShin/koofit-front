
class User {
  String uid;
  String name;
  int gender; // 0:남자 1:여자
  String stuNumber; //학번
  String number; //핸드폰번호
  String age; //int
  String birthday;
  int curWeight; //현재 몸무게
  int goalWeight; //목표 몸무게
  Map<String, dynamic> goalNutrient; // 일일 권장 영양성분 {'탄수화물' : 22, '단백질' : 45, '지방' : 20, '목표 칼로리' : 2000}
  List<Map<String, dynamic>> todayNutrientList; //유저별 식단data 리스트 [{'20231109' : {'아침' : dietData, '점심' : dietData, '저녁' : dietData}, {...} ]
  List<Map<String, dynamic>> fitnessList; //유저 운동 데이터 리스트 [{'날짜' : Fitness.data, {..} ]
  bool serviceNeedsAgreement;
  bool privacyNeedsAgreement;

  User({
    required this.uid,
    required this.name,
    required this.gender,
    required this.stuNumber,
    required this.number,
    required this.age,
    required this.birthday,
    required this.curWeight,
    required this.goalWeight,
    required this.todayNutrientList,
    required this.goalNutrient,
    required this.fitnessList,
    required this.serviceNeedsAgreement,
    required this.privacyNeedsAgreement,
  });

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
        uid: json['uid'],
        name: json['name'],
        gender: json['gender'],
        stuNumber: json['stu_number'],
        number: json['number'],
        age: json['age'],
        birthday: json['birthday'],
        curWeight: json['cur_weight'],
        goalWeight: json['goal_weight'],
        todayNutrientList: List<Map<String, dynamic>>.from(
            json['todayNutrient']),
        goalNutrient: Map<String, dynamic> .from(json['goalNutrient']),
        fitnessList: List<Map<String, dynamic>> .from(json['fitnessList']),
        serviceNeedsAgreement: json['serviceNeedsAgreement'],
        privacyNeedsAgreement: json['privacyNeedsAgreement']);
  }

  Map<String, dynamic> toJson() {
    return {
      'uid': uid,
      'name': name,
      'gender': gender,
      'number': number,
      'stuNumber': stuNumber,
      'age': age,
      'birthday': birthday,
      'curWeight': curWeight,
      'goalWeight': goalWeight,
      'todayNutrientList': todayNutrientList,
      'goalNutrient': goalNutrient,
      'fitnessList': fitnessList,
      'serviceNeedsAgreement': serviceNeedsAgreement,
      'privacyNeedsAgreement': privacyNeedsAgreement,
    };
  }

  void updateUserFitnessList(List<Map<String, dynamic>> fitnessList) {
    this.fitnessList = fitnessList;
  }

  void updateTodayNutrientList(List<Map<String, dynamic>> todayNutrientList) {
    this.todayNutrientList = todayNutrientList;
  }

  void updateCurWeight(int curWeight) {
    this.curWeight = curWeight;
  }
}

