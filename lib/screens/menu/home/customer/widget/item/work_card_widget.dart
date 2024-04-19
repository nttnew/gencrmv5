import 'package:flutter/material.dart';
import 'package:gen_crm/src/app_const.dart';
import 'package:hexcolor/hexcolor.dart';
import '../../../../../../src/models/model_generator/job_customer.dart';
import '../../../../../../src/src_index.dart';

class WorkCardWidget extends StatelessWidget {
  WorkCardWidget({
    Key? key,
    required this.data,
    required this.onTap,
  }) : super(key: key);
  final JobCustomerData data;
  final Function onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        onTap();
      },
      child: Container(
        margin: EdgeInsets.only(
          right: 16,
          left: 16,
          bottom: 16,
        ),
        padding: EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: COLORS.WHITE,
          borderRadius: BorderRadius.all(Radius.circular(10)),
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
            itemTextIconStart(
              title: data.name ?? '',
              icon: ICONS.IC_WORK_3X_PNG,
              color: data.color,
              isSVG: false,
            ),
            itemTextIcon(
              text: data.user ?? '',
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
              text: data.status ?? '',
              icon: ICONS.IC_ICON3_SVG,
              colorIcon: data.color != '' && data.color != null
                  ? HexColor(data.color!)
                  : COLORS.PRIMARY_COLOR,
              colorText: data.color != '' && data.color != null
                  ? HexColor(data.color!)
                  : COLORS.PRIMARY_COLOR,
            ),
            itemTextEnd(
              title: AppValue.formatDate(data.start_date ?? ''),
              content: data.total_note ?? '',
              icon: ICONS.IC_ICON4_SVG,
            ),
          ],
        ),
      ),
    );
  }
}
