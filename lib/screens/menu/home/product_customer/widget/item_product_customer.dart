import 'package:flutter/material.dart';
import 'package:gen_crm/src/models/model_generator/list_product_customer_response.dart';
import '../../../../../l10n/key_text.dart';
import '../../../../../src/app_const.dart';
import '../../../../../src/src_index.dart';
import '../../../../../widgets/dialog_call.dart';

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
              text: productModule.name ?? getT(KeyT.not_yet),
              icon: ICONS.IC_CHANCE_3X_PNG,
              isSVG: false,
              styleText: AppStyle.DEFAULT_18.copyWith(
                  color: COLORS.ff006CB1, fontWeight: FontWeight.w700),
            ),
            GestureDetector(
              onTap: () {
                if (productModule.customer?.id != null &&
                    productModule.customer?.id != '')
                  AppNavigator.navigateDetailCustomer(
                      productModule.customer?.id ?? '',
                      productModule.customer?.name ?? '');
              },
              child: itemTextIcon(
                text: productModule.customer?.name ?? getT(KeyT.not_yet),
                icon: ICONS.IC_USER2_SVG,
                styleText: AppStyle.DEFAULT_LABEL_PRODUCT.copyWith(
                  color: COLORS.TEXT_BLUE_BOLD,
                  fontSize: 14,
                ),
              ),
            ),
            itemTextIcon(
              onTap: () {
                if ((productModule.phone?.val != null &&
                        productModule.phone?.val != "") &&
                    productModule.phone?.action != null) {
                  showDialog(
                    context: context,
                    builder: (BuildContext context) {
                      return DialogCall(
                        phone: '${productModule.phone?.val}',
                        name: '${productModule.name}',
                      );
                    },
                  );
                }
              },
              text: productModule.phone?.val ?? getT(KeyT.not_yet),
              styleText: AppStyle.DEFAULT_14.copyWith(
                fontWeight: FontWeight.w400,
                color: COLORS.TEXT_BLUE_BOLD,
              ),
              icon: ICONS.IC_PHONE_CUSTOMER_SVG,
            ),
            itemTextIcon(
              text: productModule.loai ?? getT(KeyT.not_yet),
              icon: Icon(
                Icons.insert_drive_file_outlined,
                color: COLORS.GREY,
                size: 16,
              ),
            ),
          ],
        ),
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
