import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import '../../../../../src/src_index.dart';
import '../../../../../widgets/widget_text.dart';

void onClickSoLuong(
  BuildContext context,
  TextEditingController controller,
  Function onClick,
) {
  showModalBottomSheet(
      enableDrag: false,
      isScrollControlled: true,
      context: context,
      builder: (BuildContext context) {
        return StatefulBuilder(
          builder: (context, setState1) {
            return Container(
              width: Get.width,
              padding: EdgeInsets.only(
                bottom: MediaQuery.of(context).viewInsets.bottom + 16,
                top: 16,
                left: 16,
                right: 16,
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Container(
                    width: Get.width,
                    child: WidgetText(
                      title:
                          AppLocalizations.of(Get.context!)?.enter_the_quantity,
                      style: AppStyle.DEFAULT_16_BOLD,
                      textAlign: TextAlign.center,
                    ),
                  ),
                  SizedBox(
                    height: 16,
                  ),
                  Row(
                    children: [
                      Expanded(
                          child: Container(
                        decoration: BoxDecoration(
                            border:
                                Border.all(width: 1, color: COLORS.GREY_400),
                            borderRadius: BorderRadius.circular(15)),
                        child: TextFormField(
                          controller: controller,
                          decoration: InputDecoration(
                              contentPadding:
                                  EdgeInsets.symmetric(horizontal: 10),
                              border: InputBorder.none,
                              disabledBorder: InputBorder.none,
                              focusedBorder: InputBorder.none,
                              errorBorder: InputBorder.none),
                          keyboardType: TextInputType.numberWithOptions(
                              decimal: true, signed: false),
                        ),
                      )),
                      SizedBox(
                        width: 8,
                      ),
                      GestureDetector(
                        onTap: () {
                          onClick(controller.text);
                        },
                        child: Container(
                          decoration: BoxDecoration(
                              color: COLORS.PRIMARY_COLOR,
                              borderRadius: BorderRadius.circular(30)),
                          padding:
                              EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                          child: WidgetText(
                            title: AppLocalizations.of(Get.context!)?.enter,
                            style: AppStyle.DEFAULT_16,
                          ),
                        ),
                      )
                    ],
                  )
                ],
              ),
            );
          },
        );
      });
}
