import 'package:flutter/material.dart';
import 'package:hexcolor/hexcolor.dart';

class LineHorizontal extends StatelessWidget {
  const LineHorizontal({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
        width: double.maxFinite, height: 1, color: HexColor("#697077"));
  }
}
