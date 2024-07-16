import 'package:flutter/material.dart';
import 'package:koofit/model/config/palette.dart';

class RectangleText extends StatelessWidget {
  final Color color;
  final int? realGram;

  const RectangleText(this.color, {super.key, this.realGram});

  @override
  Widget build(BuildContext context) {
    String text = '';

    if (color == Palette.tanSu) {
      text = '탄';
    } else if (color == Palette.danBaek) {
      text = '단';
    } else {
      text = '지';
    }

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 2),
      child: Row(
        children: [
          Container(
            width: 10,
            height: 10,
            decoration: BoxDecoration(
              color: color,
            ),
          ),
          const Padding(padding: EdgeInsets.symmetric(horizontal: 2)),
          Text(
            text,
            textAlign: TextAlign.center,
            style: const TextStyle(
              color: Color(0xA5222B45),
              fontSize: 10,
              fontWeight: FontWeight.w700,
            ),
          ),
          const Padding(padding: EdgeInsets.symmetric(horizontal: 3)),
          Row(
            children: [
              Text(
                '$realGram',
                style:
                    const TextStyle(fontWeight: FontWeight.bold, fontSize: 10),
              ),
              const Text(
                'g',
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: Color(0xC6222B45),
                  fontSize: 10,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
