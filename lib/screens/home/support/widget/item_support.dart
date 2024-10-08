import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:gen_crm/screens/widget/box_item.dart';
import 'package:hexcolor/hexcolor.dart';
import '../../../../../src/app_const.dart';
import '../../../../../src/models/model_generator/support.dart';
import '../../../../../src/src_index.dart';
import '../../../../../widgets/widget_text.dart';

class ItemSupport extends StatelessWidget {
  const ItemSupport({
    Key? key,
    required this.data,
    required this.onRefreshForm,
  }) : super(key: key);
  final SupportItemData data;
  final Function onRefreshForm;

  @override
  Widget build(BuildContext context) {
    return BoxItem(
      onTap: () => AppNavigator.navigateDetailSupport(
        data.id.toString(),
        onRefreshForm: () {
          onRefreshForm();
        },
      ),
      child: Column(
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              if (data.location != null && data.location != '') ...[
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
                  title: data.ten_ho_tro ?? '',
                  style: TextStyle(
                    color: COLORS.ff006CB1,
                    fontFamily: "Quicksand",
                    fontWeight: FontWeight.w700,
                    fontSize: 18,
                  ),
                ),
              ),
              SizedBox(
                width: 8,
              ),
              Container(
                decoration: BoxDecoration(
                    color: data.color != ""
                        ? HexColor(data.color!)
                        : COLORS.PRIMARY_COLOR,
                    borderRadius: BorderRadius.circular(99)),
                width: AppValue.widths * 0.1,
                height: AppValue.heights * 0.02,
              )
            ],
          ),
          itemTextIcon(
            text: data.customer?.name ?? '',
            icon: ICONS.IC_AVATAR_SVG,
          ),
          itemTextIcon(
              text: data.product_customer?.name ?? '',
              icon: ICONS.IC_CHANCE_3X_PNG,
              isSVG: false,
              colorText: COLORS.TEXT_BLUE_BOLD,
              onTap: () {
                if (data.product_customer?.id != '' &&
                    data.product_customer?.id != null)
                  AppNavigator.navigateDetailProductCustomer(
                    data.product_customer?.id ?? '',
                  );
              }),
          itemTextIcon(
            text: data.trang_thai ?? '',
            styleText: AppStyle.DEFAULT_14.copyWith(
                color: data.color != ""
                    ? HexColor(data.color!)
                    : COLORS.PRIMARY_COLOR),
            colorIcon:
                data.color != "" ? HexColor(data.color!) : COLORS.PRIMARY_COLOR,
            icon: ICONS.IC_ICON3_SVG,
          ),
          itemTextEnd(
            title: data.created_date ?? '',
            content: data.total_note ?? '',
            icon: ICONS.IC_ICON4_SVG,
          ),
        ],
      ),
    );
  }
}
