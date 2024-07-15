import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:kakao_flutter_sdk_user/kakao_flutter_sdk_user.dart';
import 'package:koofit/login/splash_screen.dart';
import 'package:koofit/login/login_screen.dart';
import 'package:koofit/login/sign_up_screen.dart';
import 'package:koofit/login/body_size_sign_up_screen.dart';
import 'package:koofit/main_screen/main_diet_screen/diet_screen.dart';
import 'package:koofit/main_screen/search_tab_menu/search_diet_screen.dart';
import 'package:koofit/main_screen/search_tab_menu/add_diet_screen.dart';
import 'package:koofit/login/welcome_screen.dart';
import 'package:koofit/main_screen/user_screen.dart';
import 'package:koofit/model/HiveDietHelper.dart';
import 'package:koofit/model/HiveFitnessHelper.dart';
import 'package:koofit/model/HiveUserHelper.dart';
import 'package:koofit/model/data/Nutrient.dart';
import 'package:koofit/model/data/fitness.dart';
import 'package:koofit/model/data/user.dart';
import 'package:koofit/model/data/diet.dart';
import 'package:koofit/model/data/food.dart';

void main() async {
  KakaoSdk.init(nativeAppKey: '03921b5c12528d3a6f58bffa6895ee10');
  await Hive.initFlutter();
  Hive.registerAdapter(FoodAdapter());
  Hive.registerAdapter(NutrientAdapter());

  Hive.registerAdapter(FitnessAdapter());
  await HiveFitnessHelper().openFitnessBox();

  Hive.registerAdapter(UserAdapter());
  await HiveUserHelper().openUserBox();

  Hive.registerAdapter(DietAdapter());
  await HiveDietHelper().openDietBox();

  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  // This widget is the root of your application.
  Widget build(BuildContext context) {
    return ScreenUtilInit(
        designSize: const Size(375, 844),
        minTextAdapt: true,
        builder: (context, child) {
          return GetMaterialApp(
              debugShowCheckedModeBanner: false,
              theme: ThemeData(
                scaffoldBackgroundColor: Colors.white,
                primaryColor: Colors.white,
                fontFamily: 'NotoSans'), //default 폰트 설정
              // navigatorObservers: <NavigatorObserver>[observer],
              initialRoute: SplashScreen.routeName,
              routes: {
                SplashScreen.routeName: (context) => SplashScreen(),
                'home': (context) => const LoginScreen(),
                'signUp': (context) => const SignUpScreen(),
                'BodySignUp': (context) => const BodySignUpScreen(),
                // 'welcomeScreen': (context) => const WelcomeScreen(),
                'main_diet': (context) => const DietScreen(),
                // 'search_diet': (context) => SearchDietScreen(),
                'userPage': (context) => UserPage(),
              });
        });
  }
}
