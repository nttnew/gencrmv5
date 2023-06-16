import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:gen_crm/widgets/widget_appbar.dart';
import 'package:gen_crm/widgets/widget_text.dart';
import 'package:hexcolor/hexcolor.dart';
import '../src/src_index.dart';

PreferredSizeWidget AppbarBaseNormal(String title) => AppBar(
      toolbarHeight: AppValue.heights * 0.1,
      backgroundColor: HexColor("#D0F1EB"),
      title: Text(title,
          style: TextStyle(
              color: Colors.black,
              fontFamily: "Montserrat",
              fontWeight: FontWeight.w700,
              fontSize: 16)),
      leading: IconButton(
        onPressed: () {
          AppNavigator.navigateBack();
        },
        icon: Image.asset(
          ICONS.IC_BACK_PNG,
          height: 28,
          width: 28,
          color: COLORS.BLACK,
        ),
      ),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(
          bottom: Radius.circular(15),
        ),
      ),
    );

PreferredSizeWidget AppbarBase(
        GlobalKey<ScaffoldState> _drawerKey, String title) =>
    AppBar(
      toolbarHeight: AppValue.heights * 0.1,
      backgroundColor: HexColor("#D0F1EB"),
      centerTitle: false,
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
                title: title,
                style: TextStyle(
                  color: Colors.black,
                  fontFamily: "Montserrat",
                  fontWeight: FontWeight.w700,
                  fontSize: 16,
                ),
              ),
            ),
          ),
          rightAppBar(),
          SizedBox(
            width: 9,
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
            padding: EdgeInsets.only(left: 25),
            child: Container(
              child: SvgPicture.asset(
                ICONS.IC_MENU_SVG,
                fit: BoxFit.contain,
                width: 24,
                height: 24,
              ),
            )),
      ),
      leadingWidth: 49,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(
          bottom: Radius.circular(15),
        ),
      ),
    );
