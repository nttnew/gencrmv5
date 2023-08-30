import 'package:flutter/material.dart';
import 'package:gen_crm/api_resfull/api.dart';
import 'package:gen_crm/src/models/model_generator/add_customer.dart';
import 'package:gen_crm/src/src_index.dart';
import 'package:gen_crm/widgets/widgets.dart';
import '../../../../bloc/detail_product/detail_product_bloc.dart';
import '../../../../bloc/product_module/product_module_bloc.dart';
import '../../../../models/product_model.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:get/get.dart';

import '../../home/product/scanner_qrcode.dart';
import 'item_product.dart';

class ProductContract extends StatefulWidget {
  ProductContract({
    Key? key,
    required this.data,
    required this.addProduct,
    required this.reload,
    this.neverHidden = false,
    this.canDelete = false,
    this.listBtn,
  }) : super(key: key);
  final List<ProductModel> data;
  final Function addProduct;
  final Function reload;
  final bool neverHidden;
  final bool canDelete;
  final List<ButtonRes>? listBtn;

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
    productData = widget.data;
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) async {
      final response = await userRepository.getListProduct(
          BASE_URL.PAGE_DEFAULT.toString(), '', null);
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
    return Column(
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
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 16),
          child: Wrap(
            spacing: 10, // Khoảng cách giữa các item theo chiều ngang
            runSpacing: 10, // Khoảng cách giữa các dòng
            children: [
              itemBtnWrap(
                  AppLocalizations.of(Get.context!)?.select_product ?? '', () {
                AppNavigator.navigateAddProduct(
                    widget.addProduct, reload, productData);
              }),
              itemBtnWrap(
                'QR/Bar Code',
                () {
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
                              AppLocalizations.of(Get.context!)?.no_data ?? '',
                        );
                      }
                    }
                  });
                },
                icon: Padding(
                  padding: const EdgeInsets.only(right: 4),
                  child: Icon(
                    Icons.qr_code_scanner,
                    size: 14,
                    color: Colors.white,
                  ),
                ),
              ),
              ...(widget.listBtn ?? [])
                  .map(
                    (item) => itemBtnWrap(item.field_label ?? '', () {
                      if (item.field_type == 'service') {
                        AppNavigator.navigateListServicePark(
                          widget.addProduct,
                          reload,
                          productData,
                          item.field_label ?? '',
                        );
                      } else {
                        AppNavigator.navigateAddProduct(
                            widget.addProduct, reload, productData,
                            group: item.field_url);
                      }
                    },
                        color: item.field_type == 'service'
                            ? COLORS.ORANGE
                            : COLORS.TEXT_GREY_BOLD),
                  )
                  .toList()
            ],
          ),
        )
      ],
    );
  }

  Widget itemBtnWrap(String title, Function onTap,
          {Widget? icon, Color? color}) =>
      GestureDetector(
        onTap: () => onTap(),
        child: Container(
          padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          decoration: BoxDecoration(
            boxShadow: [
              BoxShadow(
                color: COLORS.BLACK.withOpacity(0.1),
                spreadRadius: 2,
                blurRadius: 5,
              )
            ],
            color: color ?? COLORS.TEXT_COLOR,
            borderRadius: BorderRadius.all(Radius.circular(16)),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              if (icon != null) icon,
              WidgetText(
                title: title,
                style: AppStyle.DEFAULT_14_BOLD.copyWith(color: COLORS.WHITE),
              ),
            ],
          ),
        ),
      );
}
