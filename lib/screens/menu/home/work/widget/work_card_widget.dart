import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:gen_crm/src/app_const.dart';
import 'package:gen_crm/src/src_index.dart';
import 'package:gen_crm/widgets/widget_text.dart';
import 'package:hexcolor/hexcolor.dart';
import '../../../../../src/models/model_generator/work.dart';

class WorkCardWidget extends StatefulWidget {
  WorkCardWidget({
    Key? key,
    required this.item,
    required this.onTap,
  }) : super(key: key);

  final WorkItemData item;
  final Function onTap;

  @override
  State<WorkCardWidget> createState() => _WorkCardWidgetState();
}

class _WorkCardWidgetState extends State<WorkCardWidget> {
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        widget.onTap();
      },
      child: Container(
        margin: EdgeInsets.only(
          bottom: 16,
          left: 16,
          right: 16,
        ),
        padding: EdgeInsets.all(
          16,
        ),
        decoration: BoxDecoration(
          color: COLORS.WHITE,
          borderRadius: BorderRadius.all(
            Radius.circular(
              10,
            ),
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(0.3),
              spreadRadius: 3,
              blurRadius: 5,
              offset: Offset(0, 0), // changes position of shadow
            ),
          ],
        ),
        child: Column(
          children: [
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                if (widget.item.location != null &&
                    widget.item.location?.trim() != '') ...[
                  Container(
                    height: 16,
                    width: 16,
                    child: SvgPicture.asset(
                      ICONS.IC_LOCATION_SVG,
                      fit: BoxFit.contain,
                    ),
                  ),
                  SizedBox(
                    width: 8,
                  ),
                ],
                Expanded(
                  child: WidgetText(
                    title: widget.item.name_job ?? '',
                    style: AppStyle.DEFAULT_16_BOLD.copyWith(
                      color: COLORS.TEXT_COLOR,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ),
                Container(
                  decoration: BoxDecoration(
                      color: widget.item.status_color != null
                          ? HexColor(widget.item.status_color!)
                          : COLORS.PRIMARY_COLOR,
                      borderRadius: BorderRadius.circular(99)),
                  width: AppValue.widths * 0.1,
                  height: AppValue.heights * 0.02,
                )
              ],
            ),
            itemTextIcon(
              text: widget.item.user_work_name ?? '',
              icon: ICONS.IC_AVATAR_SVG,
            ),
            itemTextIcon(
              text: widget.item.status_job ?? '',
              icon: ICONS.IC_ICON3_SVG,
              colorIcon: widget.item.status_color != null
                  ? HexColor(widget.item.status_color!)
                  : COLORS.PRIMARY_COLOR,
            ),
            itemTextIcon(
                text: widget.item.product_customer?.name ?? '',
                icon: ICONS.IC_CHANCE_3X_PNG,
                isSVG: false,
                colorText: COLORS.TEXT_BLUE_BOLD,
                onTap: () {
                  if (widget.item.product_customer?.id != '' &&
                      widget.item.product_customer?.id != null)
                    AppNavigator.navigateDetailProductCustomer(
                      widget.item.product_customer?.id ?? '',
                    );
                }),
            itemTextEnd(
              title: widget.item.start_date ?? '',
              content: widget.item.total_comment.toString(),
              icon: ICONS.IC_ICON4_SVG,
            ),
          ],
        ),
      ),
    );
  }
}
