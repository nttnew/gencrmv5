import 'package:flutter/material.dart';
import 'package:gen_crm/src/app_const.dart';
import '../src/src_index.dart';

class RoundedAppBar extends StatelessWidget implements PreferredSizeWidget {
  @override
  Widget build(BuildContext context) {
    return Stack(
      alignment: Alignment.center,
      children: [
        Align(
          child:  SizedBox.fromSize(
            size: preferredSize,
            child:  LayoutBuilder(builder: (context, constraint) {
              final width = constraint.maxWidth * 8;
              return  ClipRect(
                child:  OverflowBox(
                  maxHeight: double.infinity,
                  maxWidth: double.infinity,
                  child:  SizedBox(
                    width: width,
                    height: width,
                    child:  Padding(
                      padding:  EdgeInsets.only(
                          bottom: width / 2 - preferredSize.height / 2),
                      child:  DecoratedBox(
                        decoration:  BoxDecoration(
                          color: getBackgroundWithIsCar(),
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
