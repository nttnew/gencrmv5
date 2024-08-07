import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:gen_crm/src/extensionss/string_ext.dart';
import 'package:gen_crm/widgets/widget_appbar.dart';
import 'package:gen_crm/widgets/widget_text.dart';
import '../src/app_const.dart';
import '../src/src_index.dart';

PreferredSizeWidget AppbarBaseNormal(
  String? title, {
  Function? onBack,
  double? h,
  bool? reload,
  Widget? widgetRight,
}) =>
    AppBar(
      toolbarHeight: h ?? AppValue.heightsAppBar,
      backgroundColor:
          getBackgroundWithIsCar(),
      elevation: 0,
      titleSpacing: 0,
      centerTitle: false,
      title: Text(
        (title ?? '').htmlToString(),
        style: TextStyle(
          color: getColorWithIsCar(),
          fontFamily: "Montserrat",
          fontWeight: FontWeight.w700,
          fontSize: 16,
        ),
      ),
      leading: IconButton(
        onPressed: () {
          if (onBack != null) {
            onBack();
          } else {
            AppNavigator.navigateBack(reload: reload);
          }
        },
        icon: Image.asset(
          ICONS.IC_BACK_PNG,
          height: 28,
          width: 28,
          color: getColorWithIsCar(),
        ),
      ),
      actions: [
        if (widgetRight != null) widgetRight,
      ],
    );

PreferredSizeWidget AppbarBase(
        GlobalKey<ScaffoldState> _drawerKey, String title) =>
    AppBar(
      toolbarHeight: AppValue.heightsAppBar,
      backgroundColor:
          getBackgroundWithIsCar(),
      centerTitle: false,
      elevation: 0,
      title: Row(
        children: [
          Expanded(
            child: GestureDetector(
              onTap: () {
                if (_drawerKey.currentContext != null &&
                    !_drawerKey.currentState!.isDrawerOpen) {
                  _drawerKey.currentState!.openDrawer();
                }
              },
              child: WidgetText(
                title: title.htmlToString(),
                style: TextStyle(
                  color: getColorWithIsCar(),
                  fontFamily: "Montserrat",
                  fontWeight: FontWeight.w700,
                  fontSize: 16,
                ),
              ),
            ),
          ),
          rightAppBar(),
          SizedBox(
            width: 8,
          ),
        ],
      ),
      leading: GestureDetector(
        onTap: () {
          if (_drawerKey.currentContext != null &&
              !_drawerKey.currentState!.isDrawerOpen) {
            _drawerKey.currentState!.openDrawer();
          }
        },
        child: Container(
          padding: EdgeInsets.only(left: 24),
          child: Container(
            child: SvgPicture.asset(
              ICONS.IC_MENU_SVG,
              fit: BoxFit.contain,
              width: 24,
              height: 24,
              color: isCarCrm() ? COLORS.LIGHT_GREY : null,
            ),
          ),
        ),
      ),
      leadingWidth: 48,
    );
