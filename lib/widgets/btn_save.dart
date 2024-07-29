import 'package:flutter/material.dart';
import 'package:gen_crm/src/src_index.dart';

import '../l10n/key_text.dart';

class ButtonSave extends StatelessWidget {
  const ButtonSave({
    Key? key,
    this.onTap,
    this.title,
    this.textColor,
    this.background,
    this.paddingHorizontal,
    this.radius,
  }) : super(key: key);
  final Function()? onTap;
  final String? title;
  final Color? textColor;
  final Color? background;
  final double? paddingHorizontal;
  final double? radius;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(
        horizontal: paddingHorizontal ?? 0,
      ),
      child: ElevatedButton(
        onPressed: onTap,
        style: ElevatedButton.styleFrom(
          backgroundColor: background ?? COLORS.ffF1A400,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(radius ?? 10),
          ),
        ),
        child: Text(
          title ?? getT(KeyT.save),
          style: AppStyle.DEFAULT_16_BOLD.copyWith(
            color: textColor ?? COLORS.WHITE,
          ),
        ),
      ),
    );
  }
}
