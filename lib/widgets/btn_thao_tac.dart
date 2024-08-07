import 'package:flutter/material.dart';
import 'package:gen_crm/src/app_const.dart';
import 'package:gen_crm/src/src_index.dart';
import '../../l10n/key_text.dart';

class ButtonCustom extends StatelessWidget {
  const ButtonCustom({
    Key? key,
    this.onTap,
    this.title,
    this.marginHorizontal,
    this.backgroundColor,
    this.paddingAll,
    this.textColor,
    this.marginVertical, this.style,
  }) : super(key: key);

  final Function()? onTap;
  final String? title;
  final double? marginHorizontal;
  final double? marginVertical;
  final double? paddingAll;
  final Color? backgroundColor;
  final Color? textColor;
  final TextStyle? style;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      margin: EdgeInsets.symmetric(
        vertical: marginVertical ?? 16,
        horizontal: marginHorizontal ?? 16,
      ),
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          backgroundColor: backgroundColor ?? getBackgroundWithIsCar(),
          padding: EdgeInsets.all(paddingAll ?? 16),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
        ),
        onPressed: onTap,
        child: Text(
          title ?? getT(KeyT.action),
          style: style ??
              AppStyle.DEFAULT_16_BOLD.copyWith(
                color: textColor ?? getColorWithIsCar(),
              ),
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
        ),
      ),
    );
  }
}

class ButtonSmall extends StatelessWidget {
  const ButtonSmall({
    Key? key,
    required this.onTap,
    this.title,
    this.backGround,
  }) : super(key: key);

  final Function() onTap;
  final String? title;
  final Color? backGround;

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      style: ElevatedButton.styleFrom(
        backgroundColor: backGround ?? getBackgroundWithIsCar(),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(7),
        ),
      ),
      onPressed: () => onTap(),
      child: Text(
        title ?? getT(KeyT.action),
        style: AppStyle.DEFAULT_14_BOLD.copyWith(
          color: getColorWithIsCar(),
        ),
        textAlign: TextAlign.center,
        maxLines: 2,
      ),
    );
  }
}
