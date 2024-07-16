import 'package:flutter/material.dart';
import 'package:koofit/model/config/palette.dart';

Widget loadingView() {
  return WillPopScope(
    onWillPop: () async {
      return false;
    },
    child: const Scaffold(
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: const [
          Expanded(
            child: Center(
                child: CircularProgressIndicator(
              color: Palette.mainSkyBlue,
            )),
          ),
        ],
      ),
    ),
  );
}
