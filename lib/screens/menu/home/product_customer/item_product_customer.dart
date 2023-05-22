import 'package:flutter/material.dart';
import 'package:gen_crm/src/models/model_generator/list_product_customer_response.dart';
import 'package:hexcolor/hexcolor.dart';
import '../../../../src/app_const.dart';
import '../../../../src/src_index.dart';

class ItemProductCustomer extends StatelessWidget {
  const ItemProductCustomer(
      {Key? key, required this.productModule, required this.onTap})
      : super(key: key);
  final ProductCustomerResponse productModule;
  final Function() onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => onTap(),
      child: Container(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            itemTextIcon(
              paddingTop: 0,
              text: productModule.name ?? 'Chưa có',
              icon: ICONS.IC_CHANCE_3X_PNG,
              isSVG: false,
              styleText: AppStyle.DEFAULT_18.copyWith(
                  color: HexColor("#006CB1"), fontWeight: FontWeight.w700),
            ),
            itemTextIcon(
              text: productModule.customer?.name ?? 'Chưa có',
              icon: ICONS.IC_USER2_SVG,
            ),
            itemTextIcon(
              text: productModule.trangThai ?? 'Chưa có',
              icon: ICONS.IC_DANG_XU_LY_SVG,
              colorIcon: COLORS.GREY,
            ),
            itemTextIcon(
              text: productModule.loai ?? 'Chưa có',
              icon: Icon(
                Icons.insert_drive_file_outlined,
                color: COLORS.GREY,
                size: 16,
              ),
            ),
          ],
        ),
        margin: EdgeInsets.only(left: 25, right: 25, bottom: 20),
        padding: EdgeInsets.all(15),
        decoration: BoxDecoration(
          color: Colors.white,
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
      ),
    );
  }
}
