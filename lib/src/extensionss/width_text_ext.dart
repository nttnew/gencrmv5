import 'package:flutter/material.dart';

double measureCharacterWidth(String character, TextStyle style) {
  TextPainter textPainter = TextPainter(
    text: TextSpan(text: character, style: style),
    textDirection: TextDirection.ltr,
  );

  textPainter.layout();

  return textPainter.width;
}
