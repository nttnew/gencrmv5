import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import '../../../../../src/src_index.dart';
import '../../../../../widgets/widget_text.dart';

void onClickGiamGia(
  BuildContext context,
  bool isType,
  TextEditingController controller,
  Function(bool, String) onClick,
) {
  showModalBottomSheet(
      enableDrag: false,
      isScrollControlled: true,
      context: context,
      builder: (BuildContext context) {
        return StatefulBuilder(
          builder: (context, setState) {
            return Container(
              width: Get.width,
              padding: EdgeInsets.only(
                  bottom: MediaQuery.of(context).viewInsets.bottom + 16,
                  top: 16,
                  left: 16,
                  right: 16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Container(
                    width: Get.width,
                    child: WidgetText(
                      title:
                          AppLocalizations.of(Get.context!)?.enter_price_sale,
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
                        child: TextField(
                          controller: controller,
                          decoration: InputDecoration(
                              contentPadding:
                                  EdgeInsets.symmetric(horizontal: 10),
                              border: InputBorder.none,
                              disabledBorder: InputBorder.none,
                              focusedBorder: InputBorder.none,
                              errorBorder: InputBorder.none),
                          keyboardType:
                              TextInputType.numberWithOptions(decimal: true),
                        ),
                      )),
                      SizedBox(
                        width: 8,
                      ),
                      GestureDetector(
                        onTap: () {
                          isType = !isType;
                          setState(() {});
                        },
                        child: Container(
                          padding:
                              EdgeInsets.symmetric(horizontal: 5, vertical: 3),
                          decoration: BoxDecoration(
                              border: Border.all(width: 1, color: COLORS.BLUE),
                              borderRadius: BorderRadius.circular(10)),
                          width: 45,
                          child: WidgetText(
                            textAlign: TextAlign.center,
                            title: isType ? "đ" : "%",
                            style: AppStyle.DEFAULT_14,
                          ),
                        ),
                      ),
                      SizedBox(
                        width: 8,
                      ),
                      GestureDetector(
                        onTap: () {
                          onClick(isType, controller.text);
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
