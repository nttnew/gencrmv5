import 'package:gen_crm/widgets/widget_text.dart';
import 'package:get/get.dart';
import 'package:gen_crm/src/src_index.dart';
import 'package:flutter/material.dart';
import '../bloc/unread_list_notification/unread_list_notifi_bloc.dart';

class WidgetAppbar extends StatelessWidget {
  final String? title;
  final Widget? widgetTitle;
  final Widget left;
  final Widget right;
  final Color? textColor, backgroundColor;
  final double? height;
  final bool? isTitleCenter;
  final bool? isDivider;
  final bool isShaDow;

  const WidgetAppbar({
    Key? key,
    this.title,
    this.widgetTitle,
    required this.left,
    required this.right,
    this.backgroundColor,
    this.textColor = COLORS.WHITE,
    this.height,
    this.isTitleCenter = false,
    this.isDivider = false,
    this.isShaDow = true,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.only(
        left: 24,
        right: 24,
        top: MediaQuery.of(context).padding.top,
      ),
      height: AppValue.heights * 0.1 + MediaQuery.of(context).padding.top,
      decoration: BoxDecoration(
        color: !isShaDow ? COLORS.PRIMARY_COLOR1 : COLORS.PRIMARY_COLOR,
        boxShadow: isShaDow
            ? [
                BoxShadow(
                  color: COLORS.BLACK.withOpacity(0.3),
                  spreadRadius: 2,
                  blurRadius: 2,
                ),
              ]
            : null,
        borderRadius: !isShaDow
            ? null
            : BorderRadius.vertical(
                bottom: Radius.circular(20),
              ),
      ),
      child: Row(
        children: [
          left,
          Expanded(
            child: Container(
              padding: EdgeInsets.symmetric(
                horizontal: 16,
              ),
              child: Text(
                title ?? '',
                style: AppStyle.DEFAULT_18_BOLD.copyWith(
                  color: !isShaDow ? COLORS.WHITE : null,
                ),
              ),
            ),
          ),
          rightAppBar(),
        ],
      ),
    );
  }
}

Widget rightAppBar() => GestureDetector(
      onTap: () {
        return AppNavigator.navigateNotification();
      },
      child: Stack(
        clipBehavior: Clip.none,
        children: [
          Image.asset(
            ICONS.IC_NOTIFICATION_PNG,
            height: 24,
            width: 24,
          ),
          StreamBuilder<int>(
              stream: GetNotificationBloc.of(Get.context!).total,
              builder: (context, snapshot) {
                final int total = snapshot.data ?? 0;
                if (total != 0)
                  return Positioned(
                    top: -4,
                    right: -94,
                    child: Container(
                      width: 100,
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Container(
                            padding: EdgeInsets.all(2),
                            decoration: total < 10
                                ? BoxDecoration(
                                    color: COLORS.RED,
                                    shape: BoxShape.circle,
                                  )
                                : BoxDecoration(
                                    color: COLORS.RED,
                                    borderRadius: BorderRadius.all(
                                      Radius.circular(
                                        100,
                                      ),
                                    ),
                                  ),
                            child: WidgetText(
                              title: total.toString(),
                              style: AppStyle.APP_MEDIUM.copyWith(
                                color: COLORS.WHITE,
                                fontWeight: FontWeight.w400,
                                fontSize: 8,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                return SizedBox.shrink();
              })
        ],
      ),
    );
