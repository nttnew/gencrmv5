import 'package:flutter/material.dart';

class ImageBaseDefault extends StatelessWidget {
  const ImageBaseDefault({
    Key? key,
    required this.icon,
    this.width,
    this.height,
  }) : super(key: key);
  final String icon;
  final double? width;
  final double? height;

  @override
  Widget build(BuildContext context) {
    return Container(
        width: width ?? 20,
        height: height ?? 20,
        child: Image.asset(
          icon,
          fit: BoxFit.contain,
        ));
  }
}
