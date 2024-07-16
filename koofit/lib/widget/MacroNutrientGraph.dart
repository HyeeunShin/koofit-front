import 'package:flutter/material.dart';
import 'package:koofit/model/config/palette.dart';

class MacroNutrientGraph extends StatelessWidget {
  final double carbPercentage;
  final double fatPercentage;
  final double proteinPercentage;

  MacroNutrientGraph({
    super.key,
    required this.carbPercentage,
    required this.fatPercentage,
    required this.proteinPercentage,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        MacroBar(
          percentage: carbPercentage,
          color: Palette.tanSu,
          label: '탄수화물',
        ),
        MacroBar(
          percentage: proteinPercentage,
          color: Palette.danBaek,
          label: '단백질',
        ),
        MacroBar(
          percentage: fatPercentage,
          color: Palette.jiBang,
          label: '지방',
        ),
      ],
    );
  }
}

class MacroBar extends StatelessWidget {
  final double percentage;
  final Color color;
  final String label;

  MacroBar({
    super.key,
    required this.percentage,
    required this.color,
    required this.label,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          width: percentage * 2,
          height: 15,
          color: color,
          alignment: Alignment.center,
          child: Text(
            '$percentage%',
            style: const TextStyle(color: Colors.white),
          ),
        ),
      ],
    );
  }
}
