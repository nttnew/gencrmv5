import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';
import 'package:gen_crm/widgets/widget_text.dart';
import 'package:hexcolor/hexcolor.dart';
import '../bloc/unread_list_notification/unread_list_notifi_bloc.dart';
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
      title: GestureDetector(
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
      leading: GestureDetector(
        onTap: () {
          if (_drawerKey.currentContext != null &&
              !_drawerKey.currentState!.isDrawerOpen) {
            _drawerKey.currentState!.openDrawer();
          }
        },
        child: Padding(
            padding: EdgeInsets.only(left: 40),
            child: SvgPicture.asset(ICONS.IC_MENU_SVG)),
      ),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(
          bottom: Radius.circular(15),
        ),
      ),
      actions: [
        Padding(
            padding: EdgeInsets.only(right: 30),
            child: GestureDetector(
              onTap: () => AppNavigator.navigateNotification(),
              child:
                  BlocBuilder<GetListUnReadNotifiBloc, UnReadListNotifiState>(
                      builder: (context, state) {
                if (state is NotificationNeedRead) {
                  return SvgPicture.asset(ICONS.IC_NOTIFICATION_SVG);
                } else {
                  return SvgPicture.asset(ICONS.IC_NOTIFICATION2_SVG);
                }
              }),
            ))
      ],
    );
