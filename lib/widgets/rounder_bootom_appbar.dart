import 'package:flutter/material.dart';
import '../src/src_index.dart';

class RoundedAppBar extends StatelessWidget implements PreferredSizeWidget {
  @override
  Widget build(BuildContext context) {
    return Stack(
      alignment: Alignment.center,
      children: [
        Align(
          child: new SizedBox.fromSize(
            size: preferredSize,
            child: new LayoutBuilder(builder: (context, constraint) {
              final width = constraint.maxWidth * 8;
              return new ClipRect(
                child: new OverflowBox(
                  maxHeight: double.infinity,
                  maxWidth: double.infinity,
                  child: new SizedBox(
                    width: width,
                    height: width,
                    child: new Padding(
                      padding: new EdgeInsets.only(
                          bottom: width / 2 - preferredSize.height / 2),
                      child: new DecoratedBox(
                        decoration: new BoxDecoration(
                          color: COLORS.SECONDS_COLOR,
                          shape: BoxShape.circle,
                        ),
                      ),
                    ),
                  ),
                ),
              );
            }),
          ),
        ),
        Padding(
          padding: EdgeInsets.only(top: AppValue.heights * 0.08),
          child: Image.asset(
            ICONS.IC_LOGO_PNG,
            width: AppValue.widths * 0.45,
            fit: BoxFit.contain,
          ),
        )
      ],
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(200.0);
}
