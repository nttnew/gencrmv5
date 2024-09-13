import 'package:flutter/material.dart';
import 'package:gen_crm/src/app_const.dart';
import 'package:gen_crm/src/src_index.dart';
import '../../../../../src/models/model_generator/customer_clue.dart';
import '../../../widget/audio_widget.dart';
import '../../../widget/box_item.dart';

class WorkCardWidget extends StatelessWidget {
  final String? nameCustomer;
  final String? nameJob;
  final String? statusJob;
  final String? startDate;
  final int? totalComment;
  final String? color;
  final Customer? productCustomer;
  final Customer? customer;
  final String? recordUrl;
  final Function onTap;

  WorkCardWidget({
    required this.color,
    required this.nameCustomer,
    required this.nameJob,
    required this.statusJob,
    required this.startDate,
    required this.totalComment,
    required this.productCustomer,
    required this.onTap,
    this.customer,
    required this.recordUrl,
  });

  @override
  Widget build(BuildContext context) {
    return BoxItem(
      onTap: () {
        onTap();
      },
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
              icon: ICONS.IC_USER_NEW_PNG,
              isSVG: false,
              colorText: (customer?.id != '' && customer?.id != null)
                  ? COLORS.TEXT_BLUE_BOLD
                  : null,
              onTap: () {
                if (customer?.id != '' && customer?.id != null)
                  AppNavigator.navigateDetailCustomer(
                    customer?.id ?? '',
                  );
              }),
          itemTextIcon(
              text: productCustomer?.name ?? '',
              icon: ICONS.IC_CHANCE_3X_PNG,
              isSVG: false,
              colorText:
                  (productCustomer?.id != '' && productCustomer?.id != null)
                      ? COLORS.TEXT_BLUE_BOLD
                      : null,
              onTap: () {
                if (productCustomer?.id != '' && productCustomer?.id != null) {
                  AppNavigator.navigateDetailProductCustomer(
                    productCustomer?.id ?? '',
                  );
                }
              }),
          itemTextIcon(
            text: statusJob ?? '',
            icon: ICONS.IC_ICON3_SVG,
          ),
          AudioWidget(audioUrl: recordUrl ?? ''),
          itemTextEnd(
            marginD: 6,
            title: startDate ?? '',
            content: totalComment.toString(),
            icon: ICONS.IC_ICON4_SVG,
          ),
        ],
      ),
    );
  }
}
