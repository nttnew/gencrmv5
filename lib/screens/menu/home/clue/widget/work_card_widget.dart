import 'package:flutter/material.dart';
import 'package:gen_crm/src/app_const.dart';
import 'package:gen_crm/src/src_index.dart';
import '../../../../../src/models/model_generator/customer_clue.dart';

class WorkCardWidget extends StatelessWidget {
  final String? nameCustomer;
  final String? nameJob;
  final String? statusJob;
  final String? startDate;
  final int? totalComment;
  final String? color;
  final Customer? productCustomer;

  WorkCardWidget({
    required this.color,
    required this.nameCustomer,
    required this.nameJob,
    required this.statusJob,
    required this.startDate,
    required this.totalComment,
    required this.productCustomer,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(
        bottom: 16,
        right: 16,
        left: 16,
      ),
      padding: EdgeInsets.all(16),
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
          itemTextIconStart(
            title: nameJob ?? '',
            icon: ICONS.IC_CLUE_3X_PNG,
            isSVG: false,
            color: color,
          ),
          itemTextIcon(
            text: nameCustomer ?? '',
            icon: ICONS.IC_AVATAR_SVG,
          ),
          itemTextIcon(
              text: productCustomer?.name ?? '',
              icon: ICONS.IC_CHANCE_3X_PNG,
              isSVG: false,
              colorText: COLORS.TEXT_BLUE_BOLD,
              onTap: () {
                if (productCustomer?.id != '' && productCustomer?.id != null)
                  AppNavigator.navigateDetailProductCustomer2(
                    productCustomer,
                  );
              }),
          itemTextIcon(
            text: statusJob ?? '',
            icon: ICONS.IC_ICON3_SVG,
          ),
          itemTextEnd(
            title: startDate ?? '',
            content: totalComment.toString(),
            icon: ICONS.IC_ICON4_SVG,
          ),
        ],
      ),
    );
  }
}
