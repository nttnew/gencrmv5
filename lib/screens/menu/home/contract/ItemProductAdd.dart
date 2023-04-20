import 'package:flutter/material.dart';
import 'package:gen_crm/models/product_model.dart';

import '../../../../src/src_index.dart';
import '../../../../widgets/widget_text.dart';

class ItemProductAdd extends StatefulWidget {
  ItemProductAdd({Key? key, required this.data}) : super(key: key);

  ProductModel data;

  @override
  State<ItemProductAdd> createState() => _ItemProductAddState();
}

class _ItemProductAddState extends State<ItemProductAdd> {
  String soLuong = "0";
  String Dvt = "";
  String Vat = "";
  String giamGia = "0";

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
          border: Border(bottom: BorderSide(width: 1, color: COLORS.GREY_400))),
      margin: EdgeInsets.only(top: 8, left: 16, right: 16),
      padding: EdgeInsets.only(bottom: 16),
      child: Row(
        children: [
          WidgetContainerImage(
            image: ICONS.IC_CART_PNG,
            width: 25,
            height: 25,
            fit: BoxFit.contain,
            borderRadius: BorderRadius.circular(0),
            colorImage: COLORS.BLUE,
          ),
          SizedBox(
            width: 8,
          ),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                WidgetText(
                  title: widget.data.item.product_name ?? '',
                  style: AppStyle.DEFAULT_14_BOLD
                      .copyWith(color: COLORS.TEXT_GREY),
                ),
                SizedBox(
                  height: 3,
                ),
                WidgetText(
                  title: "Mã sản phẩm: " +
                      "${widget.data.item.product_code ?? ''}",
                  style: AppStyle.DEFAULT_14_BOLD
                      .copyWith(color: COLORS.TEXT_GREY),
                ),
                SizedBox(
                  height: 3,
                ),
                WidgetText(
                  title: "Giá: " +
                      "${widget.data.item.sell_price != null ? AppValue.format_money(double.parse(widget.data.item.sell_price!)) : ''}" +
                      "VNĐ",
                  style: AppStyle.DEFAULT_14_BOLD
                      .copyWith(color: COLORS.TEXT_GREY),
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(
                      height: 5,
                    ),
                    Row(
                      children: [
                        Container(
                          decoration: BoxDecoration(
                              border: Border.all(
                                  width: 1, color: COLORS.ORANGE_IMAGE),
                              borderRadius: BorderRadius.circular(7)),
                          padding: EdgeInsets.symmetric(horizontal: 10),
                          child: WidgetText(
                            title: "ĐVT: " + "${widget.data.nameDvt}",
                            style: AppStyle.DEFAULT_14
                                .copyWith(color: COLORS.ORANGE_IMAGE),
                          ),
                        ),
                        SizedBox(
                          width: 5,
                        ),
                        Container(
                          decoration: BoxDecoration(
                              border: Border.all(
                                  width: 1, color: COLORS.ORANGE_IMAGE),
                              borderRadius: BorderRadius.circular(7)),
                          padding: EdgeInsets.symmetric(horizontal: 10),
                          child: WidgetText(
                            title: "VAT: " + "${widget.data.nameVat}",
                            style: AppStyle.DEFAULT_14
                                .copyWith(color: COLORS.ORANGE_IMAGE),
                          ),
                        )
                      ],
                    ),
                    SizedBox(
                      height: 5,
                    ),
                    Container(
                      decoration: BoxDecoration(
                          border: Border.all(width: 1, color: COLORS.BLUE),
                          borderRadius: BorderRadius.circular(7)),
                      padding: EdgeInsets.symmetric(horizontal: 10),
                      child: WidgetText(
                        title: "Giảm giá: " +
                            widget.data.giamGia +
                            widget.data.typeGiamGia,
                        style: AppStyle.DEFAULT_14.copyWith(color: COLORS.BLUE),
                      ),
                    ),
                  ],
                )
              ],
            ),
          ),
          WidgetText(
            title: widget.data.soLuong.toString(),
            style: AppStyle.DEFAULT_14,
          )
        ],
      ),
    );
  }
}
