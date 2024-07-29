import 'package:flutter/material.dart';
import 'package:gen_crm/screens/menu/form/product_list/function_product/text_numeric_product.dart';
import 'package:gen_crm/screens/menu/form/product_list/item_products.dart';
import 'package:gen_crm/src/extensionss/common_ext.dart';
import 'package:get/get.dart';
import 'package:nb_utils/nb_utils.dart';
import '../../../../../l10n/key_text.dart';
import '../../../../../src/models/model_generator/products_response.dart';
import '../../../../../src/src_index.dart';
import '../../../../../widgets/btn_save.dart';

showDialogGui({
  dynamic donGia,
  int? soTienGui,
}) {
  return ShowDialogCustom.showDialogScreenBase(
    child: BodyGui(
      soTienGui: soTienGui,
      donGia: donGia,
    ),
  );
}

class BodyGui extends StatefulWidget {
  const BodyGui({
    Key? key,
    this.donGia,
    this.soTienGui,
  }) : super(key: key);

  final donGia;
  final int? soTienGui;

  @override
  State<BodyGui> createState() => _BodyGuiState();
}

class _BodyGuiState extends State<BodyGui> {
  int _donGia = 0;
  int _soTienGui = 0;

  @override
  void initState() {
    _donGia = widget.donGia ?? 0;
    _soTienGui = widget.soTienGui ?? 0;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => closeKey(),
      child: Container(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              getT(KeyT.xu_ly_so_tien_gui),
              style: AppStyle.DEFAULT_16_BOLD,
            ),
            AppValue.vSpace24,
            TextNumericProduct(
              formProduct: FormProduct(
                fieldLabel: getT(KeyT.don_gia),
                fieldSetValue: _donGia,
                fieldValue: _donGia,
              ),
              onChange: (
                String? v, {
                bool? isVND,
                bool? isDidUpdate,
              }) {
                _donGia = v.toInt();
                WidgetsBinding.instance.addPostFrameCallback((_) {
                  setState(() {});
                });
              },
            ),
            AppValue.vSpace10,
            TextNumericProduct(
              formProduct: FormProduct(
                fieldLabel: getT(KeyT.so_tien_gui),
                fieldSetValue: _soTienGui,
                fieldValue: _soTienGui,
              ),
              onChange: (
                String? v, {
                bool? isVND,
                bool? isDidUpdate,
              }) {
                _soTienGui = v.toInt();
                WidgetsBinding.instance.addPostFrameCallback((_) {
                  setState(() {});
                });
              },
            ),
            AppValue.vSpace10,
            TextNumericProduct(
              formProduct: FormProduct(
                fieldSetValue: _donGia + _soTienGui,
                fieldValue: _donGia + _soTienGui,
                fieldReadOnly: 1,
                fieldLabel: getT(KeyT.tong_don_gia),
              ),
              onChange: (
                String? v, {
                bool? isVND,
                bool? isDidUpdate,
              }) {},
            ),
            AppValue.vSpaceSmall,
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              mainAxisSize: MainAxisSize.max,
              children: [
                ButtonSave(onTap: () {
                  closeKey();
                  Future.delayed(Duration(milliseconds: 100), () {
                    Get.back(result: {
                      SO_TIEN_GUI: _soTienGui,
                      THANH_TIEN_GUI: _donGia + _soTienGui,
                    });
                  });
                }),
                AppValue.hSpace10,
                ButtonSave(
                  onTap: () {
                    Get.back();
                  },
                  background: COLORS.GREY,
                  title: getT(KeyT.close),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
