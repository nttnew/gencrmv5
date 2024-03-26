import 'package:flutter/material.dart';
import 'package:hexcolor/hexcolor.dart';

class COLORS {
  COLORS._();
  static const PRIMARY_COLOR = const Color(0xffD0F1EB);
  static const SECONDS_COLOR = const Color(0xffD0F1EB);
  static const BLACK = const Color(0xFF000000);
  static final BLACK54 = Colors.black54;
  static const WHITE = const Color(0xffffffff);
  static final WHITE60 = Colors.white60;
  static final WHITE10 = Colors.white10;
  static const GREY = const Color(0xFF808080);
  static const GREY_400 = const Color(0xFFBDBDBD);
  static const LIGHT_GREY = const Color(0xEEEEEEEE);
  static const RED = const Color(0xffff0000);
  static const YELLOW = const Color(0xffd6ff00);
  static const GREEN = const Color(0xff008000);
  static const LIGHT_GREEN = const Color(0xff14cb3e);
  static const TRUE_GREEN = const Color(0xff08a413);
  static const ORANGE = Color(0xffffa500);
  static const BLUE = Color(0xff2196f3);
  static const LIGHT_BLUE = Color(0xff90caf9);
  static const BACKGROUND = Color(0xffE5E5E5);
  static const COLORS_BA = Color(0xffDBDBDB);
  static const TEXT_COLOR = Color(0xff006CB1);
  static const TEXT_GREY = Color(0xff697077);
  static const TEXT_GREY_BOLD = Color(0xff263238);
  static const TEXT_BLUE_BOLD = Color(0xff0052B4);
  static const GRAY_IMAGE = Color(0xffB4B6BC);
  static const TEXT_RED = Color(0xffD80027);
  static const ORANGE_IMAGE = Color(0xffE75D18);
  static const ff5D5FEF = Color(0xff5D5FEF);
  static const ff1AA928 = Color(0xff1AA928);
  static final ff006CB1 = HexColor("#006CB1");
  static final ff697077 = HexColor("#697077");
  static final ff89F0DD = HexColor("#89F0DD");
  static final ffC5EDFF = HexColor("#C5EDFF");
  static final ff838A91 = HexColor("#838A91");
  static final ffFCF1D4 = HexColor("#FCF1D4");
  static final ffBEB4B4 = HexColor("#BEB4B4");
}

List<BoxShadow> boxShadow1 = [
  BoxShadow(
    color: COLORS.BLACK.withOpacity(0.2),
    spreadRadius: 2,
    blurRadius: 5,
  )
];
