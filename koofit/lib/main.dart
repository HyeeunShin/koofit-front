import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:koofit/diet/tab_menu/search_diet_screen.dart';

import 'package:koofit/login/login_screen.dart';
import 'package:koofit/login/sign_up_screen.dart';
import 'package:koofit/login/body_size_sign_up_screen.dart';
import 'package:koofit/diet/main_diet_screen/diet_screen.dart';
import 'package:koofit/diet/tab_menu/search_diet_screen.dart';
import 'package:koofit/diet/add_diet_screen.dart';
import 'package:koofit/login/welcome_screen.dart';
import 'package:koofit/presentation/k0_screen/k0_screen.dart';


void main() {
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
              // navigatorObservers: <NavigatorObserver>[observer],
              initialRoute: 'excercise',
              routes: {
                // SplashScreen.routeName: (context) => SplashScreen(),
                'home': (context) => const LoginScreen(),
                'signUp': (context) => const SignUpScreen(),
                'BodySignUp': (context) => const BodySignUpScreen(),
                'welcomeScreen' : (context) => const WelcomeScreen(),
                'main_diet': (context) => const DietScreen(),
                'search_diet' : (context) => SearchDietScreen(),
                'excercise' : (context) => K0Screen(),
              });
        });
  }
}
