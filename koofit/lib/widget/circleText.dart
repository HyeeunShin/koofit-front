import 'package:flutter/material.dart';
import 'package:koofit/model/config/palette.dart';

class CircleText extends StatelessWidget {
  final Color color;
  final int percent;
  final bool isOuter;
  final int? realGram;
  final int? goalGram;

  CircleText(this.color, this.percent, this.isOuter,
      {super.key, this.realGram, this.goalGram});

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
              shape: BoxShape.circle,
            ),
          ),
          const Padding(padding: EdgeInsets.symmetric(horizontal: 5)),
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
          isOuter
              ? Text(
                  '$percent%',
                  textAlign: TextAlign.center,
                  style: const TextStyle(
                    color: Color(0xC6222B45),
                    fontSize: 10,
                    fontWeight: FontWeight.w700,
                  ),
                )
              : Row(
                  children: [
                    Text('$realGram',
                        style: const TextStyle(
                            fontWeight: FontWeight.bold, fontSize: 13)),
                    Text(' / $goalGram',
                        style: const TextStyle(
                            fontWeight: FontWeight.w500,
                            color: Colors.black38)),
                    const SizedBox(
                      width: 10,
                    ),
                    Text(
                      '$percent%',
                      textAlign: TextAlign.center,
                      style: const TextStyle(
                        color: Color(0xC6222B45),
                        fontSize: 10,
                        fontWeight: FontWeight.w700,
                      ),
                    )
                  ],
                ),
        ],
      ),
    );
  }
}
