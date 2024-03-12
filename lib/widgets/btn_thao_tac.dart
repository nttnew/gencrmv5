import 'package:flutter/material.dart';
import 'package:hexcolor/hexcolor.dart';
import '../../l10n/key_text.dart';

class ButtonThaoTac extends StatelessWidget {
  const ButtonThaoTac({
    Key? key,
    required this.onTap,
    this.title,
    this.marginHorizontal,
  }) : super(key: key);

  final Function() onTap;
  final String? title;
  final double? marginHorizontal;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => onTap(),
      child: Container(
        width: double.infinity,
        padding: EdgeInsets.all(16),
        margin: EdgeInsets.symmetric(
          vertical: 16,
          horizontal: marginHorizontal ?? 16,
        ),
        decoration: BoxDecoration(
          color: HexColor("#D0F1EB"),
          borderRadius: BorderRadius.circular(10),
        ),
        child: Center(
          child: Text(
            title ?? getT(KeyT.action),
            style: TextStyle(
              fontFamily: "Quicksand",
              fontWeight: FontWeight.w700,
              fontSize: 16,
            ),
          ),
        ),
      ),
    );
  }
}

class ButtonBaseSmall extends StatelessWidget {
  const ButtonBaseSmall({
    Key? key,
    required this.onTap,
    this.title,
  }) : super(key: key);

  final Function() onTap;
  final String? title;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => onTap(),
      child: Container(
        width: double.infinity,
        height: 40,
        decoration: BoxDecoration(
          color: HexColor("#D0F1EB"),
          borderRadius: BorderRadius.circular(10),
        ),
        child: Center(
          child: Text(
            title ?? getT(KeyT.action),
            style: TextStyle(
              fontFamily: "Quicksand",
              fontWeight: FontWeight.w700,
              fontSize: 14,
            ),
            textAlign: TextAlign.center,
            maxLines: 2,
          ),
        ),
      ),
    );
  }
}
