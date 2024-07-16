import 'package:flutter/material.dart';
import 'package:koofit/model/config/palette.dart';

class CalText extends StatelessWidget {
  final int? realKol;
  final int? goalKol;

  CalText(this.realKol, this.goalKol, {super.key});

  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 2),
      child: Row(
        children: [
          Text('$realKol',
              style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 13)),
          Text(' / $goalKol',
              style: const TextStyle(
                  fontWeight: FontWeight.w500, color: Colors.black38)),
          const SizedBox(width: 10),
          const Text(
            'kcal',
            textAlign: TextAlign.center,
            style: TextStyle(
              color: Color(0xC6222B45),
              fontSize: 13,
              fontFamily: 'Poppins',
              fontWeight: FontWeight.w700,
            ),
          ),
        ],
      ),
    );
  }
}
