import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';
import 'package:gen_crm/widgets/widget_text.dart';
import 'package:get/get.dart';
import 'package:gen_crm/src/src_index.dart';
import 'package:flutter/material.dart';

import '../bloc/unread_list_notification/unread_list_notifi_bloc.dart';

class WidgetAppbar extends StatelessWidget {
  final String? title;
  final Widget? widgetTitle;
  final Widget? left;
  final Widget? right;
  final Color? textColor, backgroundColor;
  final double? height;
  final bool? isTitleCenter;
  final bool? isDivider;

  const WidgetAppbar({
    Key? key,
    this.title,
    this.widgetTitle,
    this.left,
    this.right,
    this.backgroundColor,
    this.textColor = COLORS.WHITE,
    this.height,
    this.isTitleCenter = false,
    this.isDivider = false,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: COLORS.PRIMARY_COLOR,
        boxShadow: [
          BoxShadow(
            color: COLORS.BLACK.withOpacity(0.3),
            spreadRadius: 2,
            blurRadius: 2,
            // offset: Offset(0, 3), // changes position of shadow
          ),
        ],
        borderRadius: BorderRadius.vertical(
          bottom: Radius.circular(20),
        ),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Container(
            width: Get.width,
            padding: EdgeInsets.only(top: 30),
            height: AppValue.heights * 0.13,
            child: Stack(
              children: [
                left != null
                    ? Align(
                        alignment: Alignment.centerLeft,
                        child: Container(
                            padding: EdgeInsets.only(left: 25), child: left),
                      )
                    : AppValue.kEmptyWidget,
                Align(
                  alignment: isTitleCenter == true
                      ? Alignment.center
                      : Alignment.centerLeft,
                  child: Container(
                    width: MediaQuery.of(context).size.width / 1.5,
                    margin: EdgeInsets.only(
                        left: isTitleCenter == true ? 0 : 80, right: 16),
                    child: widgetTitle ??
                        Text(
                          title ?? "",
                          style: AppStyle.DEFAULT_18_BOLD.copyWith(
                              color: Colors.black, fontFamily: 'Montserrat'),
                        ),
                  ),
                ),
                // Spacer(),
                // AppValue.hSpace(16),
                right != null
                    ? Align(
                        alignment: Alignment.centerRight,
                        child: Container(
                            padding: EdgeInsets.only(right: 25), child: right),
                      )
                    : AppValue.kEmptyWidget,
              ],
            ),
          ),
          isDivider == true
              ? Divider(
                  color: COLORS.BACKGROUND,
                  thickness: 0.8,
                  height: 0,
                )
              : AppValue.kEmptyWidget,
        ],
      ),
    );
  }
}

Widget rightAppBar() => GestureDetector(onTap: () {
      return AppNavigator.navigateNotification();
    }, child: BlocBuilder<GetNotificationBloc, NotificationState>(
        builder: (context, state) {
      if (state is NotificationNeedRead) {
        return Stack(
          clipBehavior: Clip.none,
          children: [
            SvgPicture.asset(ICONS.IC_NOTIFICATION2_SVG),
            if (GetNotificationBloc.of(context).total != 0)
              Positioned(
                  top: -5,
                  right: -95,
                  child: Container(
                      width: 100,
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Container(
                            padding: EdgeInsets.all(2),
                            decoration: GetNotificationBloc.of(context).total <
                                10
                                ? BoxDecoration(
                              color: Colors.red,
                              shape: BoxShape.circle,
                            )
                                : BoxDecoration(
                                color: Colors.red,
                                borderRadius:
                                BorderRadius.all(Radius.circular(100))),
                            child: WidgetText(
                              title: '${GetNotificationBloc.of(context).total}',
                              style: AppStyle.APP_MEDIUM.copyWith(
                                  color: Colors.white,
                                  fontWeight: FontWeight.w400,
                                  fontSize: 8),
                            ),
                          ),
                        ],
                      )))
          ],
        );
      } else {
        return SvgPicture.asset(ICONS.IC_NOTIFICATION2_SVG);
      }
    }));
