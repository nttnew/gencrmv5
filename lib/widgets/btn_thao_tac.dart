import 'package:flutter/material.dart';
import 'package:hexcolor/hexcolor.dart';

class ButtonThaoTac extends StatelessWidget {
  const ButtonThaoTac({
    Key? key,
    required this.onTap,
    this.title,
  }) : super(key: key);
  final Function() onTap;
  final String? title;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () => onTap(),
      child: Container(
        width: double.infinity,
        padding: EdgeInsets.all(15),
        margin: EdgeInsets.symmetric(vertical: 15),
        decoration: BoxDecoration(
          color: HexColor("#D0F1EB"),
          borderRadius: BorderRadius.circular(15),
        ),
        child: Center(
          child: Text(
            title ?? "THAO TÁC",
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
