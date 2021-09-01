import 'package:flutter/material.dart';

class MannerTemerature extends StatelessWidget {
  final double MannerTemp;
  int level = 0;
  final List<Color> temperColors = [
    Color(0xff072038),
    Color(0xff0d3a65),
    Color(0xff186ec0),
    Color(0xff37b24d),
    Color(0xffffad13),
    Color(0xfff76707),
  ];

  MannerTemerature({Key? key, required this.MannerTemp}) {
    _calcTempLevel();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              _makeTempLabelBar(),
              Container(
                margin: const EdgeInsets.only(left: 7),
                width: 30,
                height: 30,
                child: Image.asset("assets/images/level-$level.jpg"),
              )
            ],
          ),
          Text('매너온도',
              style: TextStyle(
                  fontSize: 12, color: Colors.grey, decoration: TextDecoration.underline))
        ],
      ),
    );
  }

  void _calcTempLevel() {
    if (MannerTemp <= 20) {
      level = 0;
    } else if (MannerTemp > 20 && MannerTemp <= 32) {
      level = 1;
    } else if (MannerTemp > 32 && MannerTemp <= 36.5) {
      level = 2;
    } else if (MannerTemp > 36.5 && MannerTemp <= 40) {
      level = 3;
    } else if (MannerTemp > 40 && MannerTemp <= 50) {
      level = 4;
    } else if (MannerTemp > 50) {
      level = 5;
    }
  }

  Widget _makeTempLabelBar() {
    double _width = 62;

    return Container(
      width: _width,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "$MannerTemp°C",
            style: TextStyle(
                color: temperColors[level], fontSize: 18, fontWeight: FontWeight.bold),
          ),
          ClipRRect(
            borderRadius: BorderRadius.circular(10),
            child: Container(
              height: 6,
              color: Colors.black.withOpacity(0.2),
              child: Row(
                children: [
                  Container(
                      height: 6,
                      width: _width / 99 * MannerTemp,
                      color: temperColors[level])
                ],
              ),
            ),
          )
        ],
      ),
    );
  }
}
