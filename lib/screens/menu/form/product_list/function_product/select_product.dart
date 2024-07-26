import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../../../l10n/key_text.dart';
import '../../../../../src/app_const.dart';
import '../../../../../src/models/model_generator/products_response.dart';
import '../../../../../src/src_index.dart';
import '../../../../../widgets/widget_text.dart';

class SelectProduct extends StatefulWidget {
  const SelectProduct({
    Key? key,
    required this.formProduct,
    required this.onChange,
  }) : super(key: key);
  final FormProduct formProduct;
  final Function(List<dynamic>) onChange;

  @override
  State<SelectProduct> createState() => _SelectProductState();
}

class _SelectProductState extends State<SelectProduct> {
  String valueName = '';

  @override
  void initState() {
    final setValue = widget.formProduct.fieldSetValueDatasource;
    if (setValue != null && setValue.length > 0) {
      valueName = '${setValue.first[1]}';
      widget.onChange(
        setValue.first,
      );
    }
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    bool fieldReadOnly = widget.formProduct.fieldReadOnly == 1;
    return InkWell(
      onTap: () {
        if (!fieldReadOnly)
          showSelectProduct(
            context,
            widget.formProduct.fieldDatasource ?? [],
            (List<dynamic> data) {
              widget.onChange(
                data,
              );
              valueName = '${data[1]}';
              Get.back();
              setState(() {});
            },
          );
      },
      child: Container(
        padding: EdgeInsets.symmetric(
          horizontal: 8,
        ),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.all(
            Radius.circular(
              4,
            ),
          ),
          border: Border.all(
            color: fieldReadOnly ? COLORS.GRAY_IMAGE : COLORS.BLUE,
          ),
        ),
        height: 40,
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              (widget.formProduct.fieldLabel ?? '') +
                  '${valueName != '' ? ': $valueName' : ''}',
              style: AppStyle.DEFAULT_14_BOLD,
            ),
          ],
        ),
      ),
    );
  }
}

void showSelectProduct(
  BuildContext context,
  List<List<dynamic>> listData,
  Function(List<dynamic>) onClick,
) {
  showBottomGenCRM(
    enableDrag: false,
    child: Container(
      padding: EdgeInsets.symmetric(
        horizontal: 16,
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          AppValue.vSpace10,
          Container(
            width: Get.width,
            child: WidgetText(
              title: getT(KeyT.select),
              style: AppStyle.DEFAULT_16_BOLD,
              textAlign: TextAlign.center,
            ),
          ),
          AppValue.vSpace10,
          Container(
            constraints: BoxConstraints(
              maxHeight: Get.height * 0.6,
              minWidth: Get.width,
            ),
            child: SingleChildScrollView(
              padding: EdgeInsets.only(
                bottom: 16,
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: List.generate(
                  listData.length,
                  (index) => GestureDetector(
                    onTap: () {
                      onClick(listData[index]);
                    },
                    child: Container(
                      padding: EdgeInsets.symmetric(vertical: 8),
                      width: Get.width,
                      decoration: BoxDecoration(
                        border: Border(
                          bottom: BorderSide(
                            width: 1,
                            color: COLORS.GREY_400,
                          ),
                        ),
                      ),
                      child: WidgetText(
                        title: listData[index][1].toString(),
                        style: AppStyle.DEFAULT_16.copyWith(
                          color: COLORS.TEXT_BLUE_BOLD,
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ),
          )
        ],
      ),
    ),
  );
}
