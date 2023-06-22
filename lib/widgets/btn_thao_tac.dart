import 'package:flutter/material.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:get/get.dart';

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
    return GestureDetector(
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
            title ?? AppLocalizations.of(Get.context!)?.action ?? '',
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
