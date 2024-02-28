import 'package:flutter/material.dart';
import 'package:gen_crm/l10n/key_text.dart';
import '../../../src/app_const.dart';
import '../../../src/models/model_generator/xe_dich_vu_response.dart';
import '../../../src/src_index.dart';
import '../../../widgets/dialog_call.dart';
import '../../../widgets/widget_text.dart';

class ItemCar extends StatelessWidget {
  const ItemCar({
    Key? key,
    required this.data,
    required this.onTap,
  }) : super(key: key);
  final XeDichVu data;
  final Function() onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => onTap(),
      child: Container(
        margin: EdgeInsets.only(
          left: 16,
          right: 16,
          bottom: 16,
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
              color: Colors.grey.withOpacity(
                0.3,
              ),
              spreadRadius: 3,
              blurRadius: 5,
              offset: Offset(0, 0), // changes position of shadow
            ),
          ],
        ),
        child: Column(
          children: [
            Row(
              children: [
                SizedBox(
                  width: 16,
                  height: 16,
                  child: Image.asset(
                    ICONS.IC_CAR_PNG,
                    fit: BoxFit.contain,
                  ),
                ),
                SizedBox(
                  width: 8,
                ),
                Expanded(
                  child: WidgetText(
                    title: data.bienSo ?? getT(KeyT.not_yet),
                    style: AppStyle.DEFAULT_18.copyWith(
                      color: COLORS.ff006CB1,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ),
                SizedBox(
                  width: 15,
                ),
                Container(
                  padding: EdgeInsets.symmetric(
                    horizontal: 8,
                    vertical: 2,
                  ),
                  decoration: BoxDecoration(
                    color: COLORS.PRIMARY_COLOR,
                    borderRadius: BorderRadius.circular(
                      99,
                    ),
                  ),
                  child: WidgetText(
                    title: data.chiNhanh ?? getT(KeyT.not_yet),
                    style: AppStyle.DEFAULT_14.copyWith(
                      fontSize: 12,
                    ),
                  ),
                ),
              ],
            ),
            GestureDetector(
              onTap: () {
                AppNavigator.navigateDetailCustomer(
                    data.khachHangId ?? '', data.tenKhachHang ?? '');
              },
              child: itemTextIcon(
                text: data.tenKhachHang ?? '',
                icon: ICONS.IC_USER2_SVG,
                colorIcon: COLORS.GREY,
                styleText: AppStyle.DEFAULT_LABEL_PRODUCT.copyWith(
                  color: COLORS.TEXT_BLUE_BOLD,
                  fontSize: 14,
                ),
              ),
            ),
            itemTextIcon(
              onTap: () {
                if (data.diDong != null && data.diDong != '') {
                  showDialog(
                    context: context,
                    builder: (BuildContext context) {
                      return DialogCall(
                        phone: '${data.diDong}',
                        name: '${data.tenKhachHang}',
                      );
                    },
                  );
                }
              },
              text: data.diDong ?? getT(KeyT.not_yet),
              styleText: AppStyle.DEFAULT_14.copyWith(
                fontWeight: FontWeight.w400,
                color: COLORS.TEXT_BLUE_BOLD,
              ),
              icon: ICONS.IC_PHONE_CUSTOMER_SVG,
            ),
            itemTextIcon(
              text: data.trangThai ?? getT(KeyT.not_yet),
              icon: ICONS.IC_DANG_XU_LY_SVG,
              colorIcon: COLORS.GREY,
              styleText: AppStyle.DEFAULT_14.copyWith(
                color: COLORS.ORANGE,
              ),
            ),
            itemTextIcon(
              styleText: AppStyle.DEFAULT_14.copyWith(
                fontWeight: FontWeight.w400,
                color: COLORS.TEXT_BLUE_BOLD,
              ),
              textPlus: getT(KeyT.so_phieu),
              text: data.soPhieu ?? '',
              icon: ICONS.IC_CART_PNG,
              isSVG: false,
              colorIcon: COLORS.GREY,
            ),
          ],
        ),
      ),
    );
  }
}
