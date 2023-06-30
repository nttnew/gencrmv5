import 'package:flutter/material.dart';
import 'package:gen_crm/src/color.dart';
import 'package:gen_crm/src/values.dart';

class AppStyle {
  AppStyle._();

  static const DEFAULT_TITLE_APPBAR = TextStyle(
      fontFamily: 'Montserrat',
      fontSize: AppValue.FONT_SIZE_18,
      color: COLORS.BLACK,
      fontWeight: FontWeight.w700,
      height: 1.4);

  static const DEFAULT_TITLE_PRODUCT = TextStyle(
      fontFamily: 'Quicksand',
      fontSize: AppValue.FONT_SIZE_18,
      color: COLORS.TEXT_COLOR,
      fontWeight: FontWeight.w700,
      height: 1.4);

  static const DEFAULT_LABEL_PRODUCT = TextStyle(
      fontFamily: 'Quicksand',
      fontSize: AppValue.FONT_SIZE_14,
      color: COLORS.BLACK,
      fontWeight: FontWeight.w400,
      height: 1.4);

  static const DEFAULT_LABEL_TARBAR = TextStyle(
      fontFamily: 'Quicksand',
      fontSize: AppValue.FONT_SIZE_16,
      color: COLORS.BLACK,
      fontWeight: FontWeight.w700,
      height: 1.4);

  static const DEFAULT_16_T = TextStyle(
    fontFamily: 'Quicksand',
    fontSize: AppValue.FONT_SIZE_16,
    color: COLORS.BLACK,
    fontWeight: FontWeight.w600,
    height: 1.4,
  );

  static const DEFAULT_14 = TextStyle(
    fontFamily: 'Quicksand',
    fontSize: AppValue.FONT_SIZE_14,
    color: COLORS.BLACK,
    fontWeight: FontWeight.w600,
    height: 1.4,
  );

  static const DEFAULT_16 = TextStyle(
      fontFamily: 'Quicksand',
      fontSize: AppValue.FONT_SIZE_16,
      color: COLORS.BLACK,
      height: 1.4);

  static const DEFAULT_18 = TextStyle(
      fontFamily: 'Quicksand',
      fontSize: AppValue.FONT_SIZE_18,
      color: COLORS.BLACK,
      height: 1.4);

  static const DEFAULT_MEDIUM_LINK = TextStyle(
      fontFamily: 'Quicksand',
      fontSize: AppValue.FONT_SIZE_16,
      color: COLORS.BLUE,
      height: 1.4,
      decoration: TextDecoration.underline);

  static const DEFAULT_20 = TextStyle(
      fontFamily: 'Quicksand',
      fontSize: AppValue.FONT_SIZE_20,
      color: COLORS.BLACK,
      height: 1.4);

  static const DEFAULT_24 = TextStyle(
      fontFamily: 'Quicksand',
      fontSize: AppValue.FONT_SIZE_24,
      color: COLORS.BLACK,
      height: 1.4);

  static const APP_MEDIUM = TextStyle(
      fontSize: AppValue.FONT_SIZE_16,
      color: COLORS.PRIMARY_COLOR,
      height: 1.4);

  static const DEFAULT_14W600 = TextStyle(
      fontFamily: 'Quicksand',
      fontSize: 14,
      fontWeight: FontWeight.w600,
      color: COLORS.BLACK);

  static const DEFAULT_14W600_RED = TextStyle(
      fontFamily: 'Quicksand',
      fontSize: 14,
      fontWeight: FontWeight.w600,
      color: COLORS.RED);

  static const DEFAULT_14W500 = TextStyle(
      fontFamily: 'Quicksand',
      fontSize: 14,
      fontWeight: FontWeight.w500,
      color: COLORS.BLACK);

  static final DEFAULT_14_BOLD =
      DEFAULT_14.copyWith(fontWeight: FontWeight.bold);

  static final DEFAULT_16_BOLD =
      DEFAULT_16.copyWith(fontWeight: FontWeight.bold);

  static final DEFAULT_18_BOLD =
      DEFAULT_18.copyWith(fontWeight: FontWeight.bold);

  static final DEFAULT_20_BOLD =
      DEFAULT_20.copyWith(fontWeight: FontWeight.bold);

  static final DEFAULT_24_BOLD =
      DEFAULT_24.copyWith(fontWeight: FontWeight.bold);

  static final RED_HINT_SMALL = DEFAULT_14.copyWith(color: COLORS.RED);

  static final PRODUCT_SALE_PRICE = DEFAULT_14.copyWith(
    height: 1.4,
    color: Color(0xFF960909),
  );

  static final PRODUCT_PRICE_DETAIL = DEFAULT_16.copyWith(
      color: COLORS.GREY, decoration: TextDecoration.lineThrough);

  static final PRODUCT_SALE_PRICE_DETAIL = DEFAULT_16.copyWith(
    color: Color(0xFF960909),
  );
}
