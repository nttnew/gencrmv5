import 'package:gen_crm/src/src_index.dart';
import 'package:flutter/material.dart';

class WidgetBackButton extends StatelessWidget {
  final Function? onTap;
  final Color? color, bgColors;
  final String? icon;
  final double? width, height;
  const WidgetBackButton(
      {Key? key,
      this.onTap,
      this.color,
      this.bgColors,
      this.icon,
      this.width,
      this.height})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return WidgetContainerImage(
      boxDecoration: BoxDecoration(shape: BoxShape.circle, color: bgColors),
      image: ICONS.ICON_BACK,
      onTap: () => AppNavigator.navigateBack(),
    );
  }
}
