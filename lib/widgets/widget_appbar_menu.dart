import 'package:flutter/material.dart';
import 'package:gen_crm/src/src_index.dart';

class WidgetAppbarMenu extends StatelessWidget {
  final Function? onTap;
  final Widget? icon;
  final String? isIcon;

  const WidgetAppbarMenu({Key? key, this.onTap, this.icon, this.isIcon})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return AspectRatio(
      aspectRatio: 1,
      child: Stack(
        children: [
          Positioned.fill(
            child: FractionallySizedBox(
              widthFactor: 0.6,
              heightFactor:
                  Handle.isEqualString(isIcon, ICONS.IC_BACK_PNG) ? 0.6 : 0.4,
              child: Container(
                height: double.infinity,
                child: icon,
              ),
            ),
          ),
          Positioned.fill(
            child: Padding(
              padding: const EdgeInsets.all(2.0),
              child: Material(
                color: Colors.transparent,
                child: InkWell(
                  borderRadius: BorderRadius.circular(500),
                  onTap: onTap ?? AppNavigator.navigateBack(),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
