import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../../../l10n/key_text.dart';
import '../../../../../src/src_index.dart';
import '../../../../../widgets/widget_text.dart';

void onClickDVT(
  BuildContext context,
  List listDvt,
  Function onClick,
) {
  showModalBottomSheet(
      enableDrag: false,
      isScrollControlled: true,
      context: context,
      constraints:
          BoxConstraints(maxHeight: Get.height * 0.55, minWidth: Get.width),
      builder: (BuildContext context) {
        return Container(
          padding: EdgeInsets.all(16),
          width: Get.width,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                width: Get.width,
                child: WidgetText(
                  title: getT(KeyT.select),
                  style: AppStyle.DEFAULT_16_BOLD,
                  textAlign: TextAlign.center,
                ),
              ),
              Expanded(
                  child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: List.generate(
                      listDvt.length,
                      (index) => GestureDetector(
                            onTap: () {
                              onClick(listDvt[index]);
                            },
                            child: Container(
                              padding: EdgeInsets.symmetric(vertical: 8),
                              width: Get.width,
                              decoration: BoxDecoration(
                                  border: Border(
                                      bottom: BorderSide(
                                          width: 1, color: COLORS.GREY_400))),
                              child: WidgetText(
                                title: listDvt[index][1].toString(),
                                style: AppStyle.DEFAULT_16
                                    .copyWith(color: COLORS.TEXT_BLUE_BOLD),
                              ),
                            ),
                          )),
                ),
              ))
            ],
          ),
        );
      });
}
