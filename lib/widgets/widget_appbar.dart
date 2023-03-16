import 'package:get/get.dart';
import 'package:gen_crm/src/src_index.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

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
            spreadRadius: 2                                                                                                       ,
            blurRadius: 2,
            // offset: Offset(0, 3), // changes position of shadow
        ),],
        borderRadius: BorderRadius.vertical(
          bottom: Radius.circular(20),
        ),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Container(
            width: Get.width,padding: EdgeInsets.only(top: 30),
            height: AppValue.heights*0.13,
            child: Stack(
              children: [
                left != null
                    ? Align(
                      alignment: Alignment.centerLeft,
                      child: Container(
                          padding: EdgeInsets.only(left: 16),
                          child: left
                        ),
                    )
                    : AppValue.kEmptyWidget,
                // AppValue.hSpace(16),
                //isTitleCenter == true ? Spacer() : AppValue.kEmptyWidget,
                Align(
                  alignment: isTitleCenter == true ? Alignment.center : Alignment.centerLeft,
                  child: Container(
                    width: MediaQuery.of(context).size.width/1.5,
                    margin: EdgeInsets.only(left: isTitleCenter == true ? 0 : 80, right: 16),
                    child: widgetTitle ?? Text(
                      title ?? "",
                      style: AppStyle.DEFAULT_18_BOLD.copyWith(color: Colors.black,fontFamily: 'Montserrat'),
                    ),
                  ),
                ),
                // Spacer(),
                // AppValue.hSpace(16),
                right != null
                    ? Align(
                        alignment: Alignment.centerRight,
                        child: Container(
                          padding: EdgeInsets.only(right: 16),
                          child: right
                ),
                    )
                    :
                AppValue.kEmptyWidget,
              ],
            ),
          ),
          isDivider == true ? Divider(
            color: COLORS.BACKGROUND,
            thickness: 0.8,
            height: 0,
          ) : AppValue.kEmptyWidget,
        ],
      ),
    );
  }
}
