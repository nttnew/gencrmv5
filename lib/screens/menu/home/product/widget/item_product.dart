import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:gen_crm/src/models/model_generator/list_product_response.dart';
import 'package:gen_crm/storages/share_local.dart';
import '../../../../../src/src_index.dart';

class ItemProductModule extends StatefulWidget {
  const ItemProductModule({
    Key? key,
    required this.productModule,
  }) : super(key: key);
  final ProductModule productModule;

  @override
  State<ItemProductModule> createState() => _ItemProductModuleState();
}

class _ItemProductModuleState extends State<ItemProductModule> {
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        AppNavigator.navigateDetailProduct(
          widget.productModule.id ?? '',
        );
      },
      child: Container(
        margin: EdgeInsets.only(
          left: 16,
          right: 16,
          bottom: 16,
        ),
        padding: EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: COLORS.WHITE,
          borderRadius: BorderRadius.all(
            Radius.circular(
              10,
            ),
          ),
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
              child: CachedNetworkImage(
                imageUrl: shareLocal.getString(PreferencesKey.URL_BASE) +
                    widget.productModule.avatar.toString(),
                errorWidget: (_, __, ___) {
                  return Icon(
                    Icons.error_outline_outlined,
                    color: Colors.black87,
                    size: 30,
                  );
                },
                fit: BoxFit.cover,
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
                        style: AppStyle.DEFAULT_18_BOLD,
                      ),
                      TextSpan(
                        text: widget.productModule.maSanPham != null
                            ? ' (${widget.productModule.maSanPham})'
                            : '',
                        style: AppStyle.DEFAULT_16_BOLD.copyWith(
                          color: Colors.grey,
                        ),
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
                    text: TextSpan(
                      children: [
                        TextSpan(
                          text: widget.productModule.phienBan ?? '',
                          style: AppStyle.DEFAULT_14.copyWith(
                            fontWeight: FontWeight.w400,
                          ),
                        ),
                        TextSpan(
                          text: widget.productModule.phienBan != null &&
                                  widget.productModule.phienBan != ''
                              ? ' | '
                              : '',
                          style: AppStyle.DEFAULT_14.copyWith(
                            fontWeight: FontWeight.w400,
                          ),
                        ),
                        TextSpan(
                          text: widget.productModule.coTheBan ?? '',
                          style: AppStyle.DEFAULT_14.copyWith(
                            color: COLORS.TEXT_COLOR,
                            fontWeight: FontWeight.w400,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}
