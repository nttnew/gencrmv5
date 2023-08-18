import 'package:flutter/material.dart';
import 'package:gen_crm/api_resfull/api.dart';
import 'package:gen_crm/src/src_index.dart';
import 'package:gen_crm/widgets/widgets.dart';
import '../../../../../bloc/detail_product/detail_product_bloc.dart';
import '../../../../../bloc/product_module/product_module_bloc.dart';
import '../../../../../models/product_model.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:get/get.dart';

import '../../product/scanner_qrcode.dart';
import 'item_product.dart';

class ProductContract extends StatefulWidget {
  ProductContract({
    Key? key,
    required this.data,
    required this.addProduct,
    required this.reload,
    this.neverHidden = false,
    this.canDelete = false,
  }) : super(key: key);
  final List<ProductModel> data;
  final Function addProduct;
  final Function reload;
  final bool neverHidden;
  final bool canDelete;

  @override
  State<ProductContract> createState() => _ProductContractState();
}

class _ProductContractState extends State<ProductContract> {
  List<ProductModel> productData = [];
  UserRepository userRepository = UserRepository();
  List<List> listDVT = [];
  List<List> listVAT = [];
  @override
  void initState() {
    setState(() {
      productData = widget.data;
    });
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) async {
      final response = await userRepository.getListProduct(
          BASE_URL.PAGE_DEFAULT.toString(), '');
      if ((response.code == BASE_URL.SUCCESS) ||
          (response.code == BASE_URL.SUCCESS_200)) {
        if (listVAT.isEmpty) {
          listVAT = response.data?.vats ?? [];
        }
        if (listDVT.isEmpty) {
          listDVT = response.data?.units ?? [];
        }
      }
    });
    super.initState();
  }

  reload() async {
    await widget.reload();
    setState(() {});
  }

  void removeProduct(ProductModel productModel) {
    setState(() {
      productData.remove(productModel);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Column(
        children: [
          productData.length > 0
              ? Column(
                  children: List.generate(
                      productData.length,
                      (index) => ItemProduct(
                            onDelete: removeProduct,
                            canDelete: widget.canDelete,
                            neverHidden: widget.neverHidden,
                            data: productData[index].item,
                            onChangeQuantity: (soLuong) {
                              productData[index].soLuong = double.parse(soLuong);
                            },
                            onDVT: (id, name) {
                              productData[index].nameDvt = name;
                              productData[index].item.dvt = id;
                            },
                            onVAT: (id, name) {
                              productData[index].nameVat = name;
                              productData[index].item.vat = id;
                            },
                            onGiamGia: (so, type) {
                              productData[index].giamGia = so;
                              productData[index].typeGiamGia = type;
                            },
                            onPrice: (price) {
                              productData[index].item.sell_price = price;
                            },
                            model: productData[index],
                            listDvt: listDVT,
                            listVat: listVAT,
                            onReload: () {
                              reload();
                            },
                          )),
                )
              : Container(),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: GestureDetector(
                  onTap: () {
                    AppNavigator.navigateAddProduct(
                        widget.addProduct, reload, productData);
                  },
                  child: Container(
                    margin: EdgeInsets.symmetric(
                      vertical: 8,
                    ),
                    padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                    decoration: BoxDecoration(
                        color: COLORS.TEXT_COLOR,
                        borderRadius: BorderRadius.all(Radius.circular(16)),
                        border: Border.all(
                          color: COLORS.TEXT_COLOR,
                        )),
                    child: Center(
                      child: WidgetText(
                        title:
                            AppLocalizations.of(Get.context!)?.select_product ??
                                '',
                        style: AppStyle.DEFAULT_14_BOLD
                            .copyWith(color: COLORS.WHITE),
                      ),
                    ),
                  ),
                ),
              ),
              SizedBox(
                width: 16,
              ),
              Expanded(
                child: GestureDetector(
                  onTap: () {
                    Navigator.of(context)
                        .push(MaterialPageRoute(
                            builder: (context) => ScannerQrcode()))
                        .then((value) async {
                      if (value != '') {
                        final result = await ProductModuleBloc.of(context)
                            .getListProduct(querySearch: value);
                        if (result?.data?.lists?.isNotEmpty ?? false) {
                          final data = await DetailProductBloc.of(context)
                              .getDetailProductQR(
                                  id: result?.data?.lists?.first.id ?? '');
                          widget.addProduct(data);
                          setState(() {});
                        } else {
                          ShowDialogCustom.showDialogBase(
                            title:
                                AppLocalizations.of(Get.context!)?.notification,
                            content:
                                AppLocalizations.of(Get.context!)?.no_data ??
                                    '',
                          );
                        }
                      }
                    });
                  },
                  child: Container(
                    margin: EdgeInsets.symmetric(
                      vertical: 8,
                    ),
                    padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                    decoration: BoxDecoration(
                        color: COLORS.TEXT_COLOR,
                        borderRadius: BorderRadius.all(Radius.circular(16)),
                        border: Border.all(
                          color: COLORS.TEXT_COLOR,
                        )),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.qr_code_scanner,
                          size: 14,
                          color: Colors.white,
                        ),
                        SizedBox(
                          width: 4,
                        ),
                        WidgetText(
                          title: 'QR/Bar Code',
                          style: AppStyle.DEFAULT_14_BOLD.copyWith(
                            color: COLORS.WHITE,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          )
        ],
      ),
    );
  }
}
