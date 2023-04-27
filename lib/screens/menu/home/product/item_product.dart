import 'package:flutter/material.dart';
import 'package:gen_crm/src/models/model_generator/list_product_response.dart';
import 'package:gen_crm/widgets/widget_text.dart';

import '../../../../src/src_index.dart';

class ItemProductModule extends StatefulWidget {
  const ItemProductModule({Key? key, required this.productModule})
      : super(key: key);
  final ProductModule productModule;

  @override
  State<ItemProductModule> createState() => _ItemProductModuleState();
}

class _ItemProductModuleState extends State<ItemProductModule> {
  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(
        left: AppValue.widths * 0.05,
        right: AppValue.widths * 0.05,
        bottom: 16,
      ),
      padding: EdgeInsets.all(8),
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
      child: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            height: 80,
            width: 80,
            color: Colors.grey,
            child: Image.network(
              widget.productModule.avatar.toString(),
              errorBuilder: (_, __, ___) {
                return Icon(
                  Icons.error_outline_outlined,
                  color: Colors.black87,
                  size: 30,
                );
              },
              fit: BoxFit.contain,
            ),
          ),
          SizedBox(
            width: 16,
          ),
          Expanded(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                RichText(
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  textScaleFactor: MediaQuery.of(context).textScaleFactor,
                  text: TextSpan(children: [
                    TextSpan(
                      text: widget.productModule.tenSanPham,
                      style: AppStyle.DEFAULT_20_BOLD,
                    ),
                    TextSpan(
                      text: ' (${widget.productModule.maSanPham})',
                      style:
                          AppStyle.DEFAULT_18_BOLD.copyWith(color: Colors.grey),
                    ),
                  ]),
                ),
                SizedBox(
                  height: 8,
                ),
                RichText(
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  textScaleFactor: MediaQuery.of(context).textScaleFactor,
                  text: TextSpan(children: [
                    TextSpan(
                      text:
                          '${widget.productModule.phienBan ?? 0} phiên bản | có thể ',
                      style: AppStyle.DEFAULT_18_BOLD,
                    ),
                    TextSpan(
                      text: widget.productModule.coTheBan ?? '0',
                      style:
                          AppStyle.DEFAULT_18_BOLD.copyWith(color: COLORS.TEXT_COLOR),
                    ),
                  ]),
                ),
              ],
            ),
          )
        ],
      ),
    );
  }
}
