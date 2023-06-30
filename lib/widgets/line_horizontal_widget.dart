import 'package:flutter/material.dart';
import '../src/color.dart';

class LineHorizontal extends StatelessWidget {
  const LineHorizontal({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
        width: double.maxFinite, height: 1, color: COLORS.ff697077);
  }
}
