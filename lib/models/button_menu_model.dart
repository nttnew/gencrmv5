import 'package:flutter/cupertino.dart';

class ButtonMenuModel {
  final String image;
  final String title;
  final GestureTapCallback onTap;
  final Color backgroundColor;

  ButtonMenuModel({
    required this.backgroundColor,
    required this.image,
    required this.title,
    required this.onTap,
  });
}
