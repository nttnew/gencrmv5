import 'package:flutter/material.dart';
import 'package:gen_crm/src/color.dart';
import 'package:gen_crm/src/values.dart';
class AppStyle {
  AppStyle._();
  //DEFAULT STYLE
  static const DEFAULT_TITLE_APPBAR = TextStyle(
      fontFamily: 'Montserrat',
      fontSize: AppValue.FONT_SIZE_18,
      color: Colors.black,
      fontWeight: FontWeight.w700,
      height: 1.4);
  static const DEFAULT_TITLE_PRODUCT = TextStyle(
      fontFamily: 'Quicksand',
      fontSize: AppValue.FONT_SIZE_18,
      color: Color(0xff006CB1),
      fontWeight: FontWeight.w700,
      height: 1.4);
  static const DEFAULT_LABEL_PRODUCT = TextStyle(
      fontFamily: 'Roboto',
      fontSize: AppValue.FONT_SIZE_14,
      color: Colors.black,
      fontWeight: FontWeight.w400,
      height: 1.4);
  static const DEFAULT_LABEL_TARBAR = TextStyle(
      fontFamily: 'Quicksand',
      fontSize: AppValue.FONT_SIZE_16,
      color: Colors.black,
      fontWeight: FontWeight.w700,
      height: 1.4);

  static const DEFAULT_16_T = TextStyle(
      fontFamily: 'Quicksand',fontSize: AppValue.FONT_SIZE_16, color: COLORS.BLACK,fontWeight: FontWeight.w600, height: 1.4);

  static const DEFAULT_12 = TextStyle(
      fontFamily: 'Quicksand',fontSize: AppValue.FONT_SIZE_12, color: COLORS.BLACK, height: 1.4);

  static const DEFAULT_14 = TextStyle(
      fontFamily: 'Quicksand',fontSize: AppValue.FONT_SIZE_14, color: COLORS.BLACK, fontWeight: FontWeight.w600, height: 1.4);

  static const DEFAULT_16 = TextStyle(
      fontFamily: 'Quicksand',fontSize: AppValue.FONT_SIZE_16, color: COLORS.BLACK,  height: 1.4);
  
  static const DEFAULT_18 = TextStyle(
      fontFamily: 'Quicksand',fontSize: AppValue.FONT_SIZE_18, color: COLORS.BLACK, height: 1.4);

  static const DEFAULT_MEDIUM_LINK = TextStyle(
      fontFamily: 'Quicksand',fontSize: AppValue.FONT_SIZE_16, color: COLORS.BLUE, height: 1.4, decoration: TextDecoration.underline);

  static const DEFAULT_20 = TextStyle(
      fontFamily: 'Quicksand',fontSize: AppValue.FONT_SIZE_20, color: COLORS.BLACK, height: 1.4);

  static const DEFAULT_24 = TextStyle(
      fontFamily: 'Quicksand', fontSize: AppValue.FONT_SIZE_24,
      color: COLORS.BLACK,
      height: 1.4);

  static const APP_MEDIUM = TextStyle(
      fontSize: AppValue.FONT_SIZE_16,
      color: COLORS.PRIMARY_COLOR,
      height: 1.4);

  //DEFAULT STYLE MIX
  // ignore: non_constant_identifier_names
  static final DEFAULT_12_BOLD =
  DEFAULT_12.copyWith(fontWeight: FontWeight.bold);
  // ignore: non_constant_identifier_names
  static final DEFAULT_14_BOLD =
  DEFAULT_14.copyWith(fontWeight: FontWeight.bold);
  // ignore: non_constant_identifier_names
  static final DEFAULT_16_BOLD =
  DEFAULT_16.copyWith(fontWeight: FontWeight.bold);
  // ignore: non_constant_identifier_names
  static final DEFAULT_18_BOLD =
  DEFAULT_18.copyWith(fontWeight: FontWeight.bold);
  // ignore: non_constant_identifier_names
  static final DEFAULT_20_BOLD =
  DEFAULT_20.copyWith(fontWeight: FontWeight.bold);
  // ignore: non_constant_identifier_names
  static final DEFAULT_24_BOLD =
  DEFAULT_24.copyWith(fontWeight: FontWeight.bold);
  // ignore: non_constant_identifier_names
  static final RED_HINT_SMALL = DEFAULT_12.copyWith(color: Colors.red);
  // ignore: non_constant_identifier_names
  static final PRODUCT_SALE_PRICE = DEFAULT_12.copyWith(
    height: 1.4,
    color: Color(0xFF960909),
  );
  // ignore: non_constant_identifier_names
  static final PRODUCT_PRICE_DETAIL = DEFAULT_16.copyWith(
      color: COLORS.GREY, decoration: TextDecoration.lineThrough);
  // ignore: non_constant_identifier_names
  static final PRODUCT_SALE_PRICE_DETAIL = DEFAULT_16.copyWith(
    color: Color(0xFF960909),
  );
}

