import 'package:flutter/cupertino.dart';

class ButtonMenuModel {
  final String? image;
  final String title;
  final GestureTapCallback? onTap;
  final Color? backgroundColor;

  ButtonMenuModel({
    this.backgroundColor,
    this.image,
    required this.title,
    this.onTap,
  });
}
