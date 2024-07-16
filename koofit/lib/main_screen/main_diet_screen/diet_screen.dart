import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:koofit/main_screen/fitness_screen/fitness_card.dart';
import 'package:koofit/main_screen/main_diet_screen/today_calories_card.dart';
import 'package:koofit/widget/advanced_calender_lib/advanced_calendar.dart';
import 'package:intl/intl.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:koofit/model/config/palette.dart';
import 'univ_diet_card.dart';
import 'package:koofit/model/HiveUserHelper.dart';
import 'package:koofit/model/data/user.dart';

class DietScreen extends StatefulWidget {
  final User? user;

  const DietScreen({Key? key, this.user}) : super(key: key);

  @override
  State<DietScreen> createState() => _DietScreenState();
}

class _DietScreenState extends State<DietScreen> {
  var thisController = AdvancedCalendarController.today();
  final recordedDay = <DateTime>[
    DateTime.now(),
    DateTime(2023, 10, 10),
    DateTime(2023, 10, 12),
    DateTime(2023, 10, 14),
  ];

  // Use ValueNotifier for selectedDate
  DateTime _selectedDate = DateTime.now(); // Initialize with the current date

  @override
  void initState() {
    super.initState();

    initializeDateFormatting('ko', null);

    // HiveUserHelper().readUser();
  }

  @override
  Widget build(BuildContext context) {
    var theme = Theme.of(context);

    return Scaffold(
      body: Builder(
        builder: (context) {
          return Column(children: [
            advanced_calender(theme, thisController, recordedDay),
            ValueListenableBuilder<DateTime>(
              valueListenable: thisController,
              builder: (context, selectedDate, child) {
                _selectedDate = selectedDate;
                return DailyDietView(_selectedDate);
              },
            ),
          ]);
        },
      ),
    );
  }

  Widget advanced_calender(ThemeData theme, controller, recordedDay) {
    return Theme(
      data: theme.copyWith(
        textTheme: theme.textTheme.copyWith(
          titleMedium: theme.textTheme.titleMedium!.copyWith(
            fontSize: 16,
            fontWeight: FontWeight.w500,
            color: const Color.fromARGB(255, 0, 0, 0),
          ),
          bodyLarge: theme.textTheme.bodyLarge!.copyWith(
            fontSize: 14,
            color: Colors.black54,
          ),
          bodyMedium: theme.textTheme.bodyMedium!.copyWith(
              fontSize: 12, color: Colors.black87, fontWeight: FontWeight.w200),
        ),
        disabledColor: Colors.grey[60],
      ),
      child: AdvancedCalendar(
        controller: controller,
        events: recordedDay,
        weekLineHeight: 45.0,
        startWeekDay: 1,
        innerDot: true,
        keepLineSize: true,
        calendarTextStyle: const TextStyle(
          fontSize: 18,
          fontWeight: FontWeight.w400,
          height: 1.3125,
          letterSpacing: 0,
        ),
        todayStyle: const TextStyle(
          color: Colors.white,
          fontWeight: FontWeight.w500,
          fontSize: 21,
        ),
      ),
    );
  }

  Widget DailyDietView(DateTime date) {
    final DateFormat formatter = DateFormat('yyyy-MM-dd');

    return Expanded(
      child: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(15),
          child: Column(
            children: [
              Text(
                formatDate(date),
                style:
                    const TextStyle(fontWeight: FontWeight.bold, fontSize: 22),
              ),
              const Padding(padding: EdgeInsets.symmetric(vertical: 10)),
              UnivDietCard(selectedDate: formatter.format(date).toString()),
              const Padding(padding: EdgeInsets.symmetric(vertical: 5)),
              TodayCalorieCard(selectedDate: formatter.format(date).toString()),
              const Padding(padding: EdgeInsets.symmetric(vertical: 5)),
              FitnessCard(selectedDate: formatter.format(date).toString()),
            ],
          ),
        ),
      ),
    );
  }

  String formatDate(DateTime orgin_date) {
    var formatter =
        DateFormat('yyyy년 M월 d일 (E)', 'ko'); // 'ko'는 한국어로 표시하기 위한 로케일 코드입니다.
    return formatter.format(orgin_date);
  }
}
