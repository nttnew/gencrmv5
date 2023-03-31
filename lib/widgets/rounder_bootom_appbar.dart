import 'package:flutter/material.dart';
import 'package:hexcolor/hexcolor.dart';

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
                          color: HexColor("#D0F1EB"),
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
            "assets/icons/logo.png",
            width: AppValue.widths * 60 / 100,
            fit: BoxFit.contain,
          ),
        )
      ],
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(200.0);
}
