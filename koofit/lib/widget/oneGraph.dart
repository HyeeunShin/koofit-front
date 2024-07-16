import 'package:flutter/material.dart';
import 'dart:math';
import 'package:koofit/model/config/palette.dart';

class oneGraph extends StatelessWidget {
  final double recommendedCarb;
  final double recommendedProtein;
  final double recommendedFat;
  final double consumedCarb;
  final double consumedProtein;
  final double consumedFat;

  oneGraph({
    required this.recommendedCarb,
    required this.recommendedProtein,
    required this.recommendedFat,
    required this.consumedCarb,
    required this.consumedProtein,
    required this.consumedFat,
  });

  @override
  Widget build(BuildContext context) {
    return CustomPaint(
      size: const Size(130, 130),
      painter: OneGraphPainter(
        recommendedCarb: recommendedCarb,
        recommendedProtein: recommendedProtein,
        recommendedFat: recommendedFat,
        consumedCarb: consumedCarb,
        consumedProtein: consumedProtein,
        consumedFat: consumedFat,
      ),
    );
  }
}

class OneGraphPainter extends CustomPainter {
  final double recommendedCarb;
  final double recommendedProtein;
  final double recommendedFat;
  final double consumedCarb;
  final double consumedProtein;
  final double consumedFat;

  OneGraphPainter({
    required this.recommendedCarb,
    required this.recommendedProtein,
    required this.recommendedFat,
    required this.consumedCarb,
    required this.consumedProtein,
    required this.consumedFat,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final double centerX = size.width / 2;
    final double centerY = size.height / 2;
    final double radius = size.width / 2;

    final Paint recommendedCarbPaint = Paint()..color = Color(0xFFDCDCDC);
    final Paint recommendedProteinPaint = Paint()..color = Color(0xFFDCDCDC);
    final Paint recommendedFatPaint = Paint()..color = Color(0xFFDCDCDC);

    final Paint actualCarbPaint = Paint()
      ..color = consumedCarb > recommendedCarb ? Colors.red : Palette.tanSu;
    final Paint actualProteinPaint = Paint()
      ..color =
          consumedProtein > recommendedProtein ? Colors.red : Palette.danBaek;
    final Paint actualFatPaint = Paint()
      ..color = consumedFat > recommendedFat ? Colors.red : Palette.jiBang;

    double totalRecommended =
        recommendedCarb + recommendedProtein + recommendedFat;
    double startAngle = pi / 2;

    _drawArc(canvas, centerX, centerY, radius, startAngle,
        recommendedCarb / totalRecommended, recommendedCarbPaint);
    startAngle += 2 * pi * (recommendedCarb / totalRecommended);
    _drawArc(canvas, centerX, centerY, radius, startAngle,
        recommendedProtein / totalRecommended, recommendedProteinPaint);
    startAngle += 2 * pi * (recommendedProtein / totalRecommended);
    _drawArc(canvas, centerX, centerY, radius, startAngle,
        recommendedFat / totalRecommended, recommendedFatPaint);

    // Draw actual consumption
    startAngle = pi / 2; // Reset start angle
    _drawArc(canvas, centerX, centerY, radius, startAngle,
        consumedCarb / totalRecommended, actualCarbPaint);
    startAngle += 2 * pi * (recommendedCarb / totalRecommended);
    _drawArc(canvas, centerX, centerY, radius, startAngle,
        consumedProtein / totalRecommended, actualProteinPaint);
    startAngle += 2 * pi * (recommendedProtein / totalRecommended);
    _drawArc(canvas, centerX, centerY, radius, startAngle,
        consumedFat / totalRecommended, actualFatPaint);
  }

  void _drawArc(Canvas canvas, double centerX, double centerY, double radius,
      double startAngle, double percentage, Paint paint) {
    if (percentage > 0) {
      final double sweepAngle = 2 * pi * percentage;
      canvas.drawArc(
        Rect.fromCircle(center: Offset(centerX, centerY), radius: radius),
        startAngle,
        sweepAngle,
        true,
        paint,
      );
    }
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) => false;
}
