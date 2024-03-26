import 'package:flutter/material.dart';
import '../src/color.dart';

class LineHorizontal extends StatelessWidget {
  const LineHorizontal({Key? key, this.color}) : super(key: key);
  final Color? color;
  @override
  Widget build(BuildContext context) {
    return Container(
        width: double.maxFinite, height: 1, color:color?? COLORS.ff697077);
  }
}
