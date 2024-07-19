import 'package:gen_crm/src/extensionss/string_ext.dart';
import 'package:gen_crm/widgets/widget_text.dart';
import 'package:get/get.dart';
import 'package:gen_crm/src/src_index.dart';
import 'package:flutter/material.dart';
import '../bloc/unread_list_notification/unread_list_notifi_bloc.dart';
import '../src/app_const.dart';

class WidgetAppbar extends StatelessWidget {
  final String? title;
  final Widget? widgetTitle;
  final Widget? left;
  final Widget? right;
  final Color? textColor, backgroundColor;
  final double? height;
  final bool? isTitleCenter;
  final bool? isDivider;
  final double? padding;

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
    this.padding,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.only(
        left: padding ?? 20,
        right: padding ?? 20,
        top: MediaQuery.of(context).padding.top,
      ),
      height: AppValue.heightsAppBar + MediaQuery.of(context).padding.top,
      decoration: BoxDecoration(
        color: isCarCrm() ? COLORS.PRIMARY_COLOR1 : COLORS.PRIMARY_COLOR,
      ),
      child: Row(
        children: [
          left ??
              IconButton(
                onPressed: () {
                  AppNavigator.navigateBack();
                },
                icon: Image.asset(
                  ICONS.IC_BACK_PNG,
                  height: 28,
                  width: 28,
                  color: isCarCrm() ? COLORS.LIGHT_GREY : COLORS.BLACK,
                ),
              ),
          Expanded(
            child: Container(
              padding: EdgeInsets.symmetric(
                horizontal: 16,
              ),
              child: Text(
                (title ?? '').htmlToString(),
                style: AppStyle.DEFAULT_16_BOLD.copyWith(
                  color: isCarCrm() ? COLORS.WHITE : null,
                ),
              ),
            ),
          ),
          right ?? rightAppBar(),
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
              stream: UnreadNotificationBloc.of(Get.context!).total,
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
