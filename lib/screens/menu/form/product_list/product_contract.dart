import 'package:flutter/material.dart';
import 'package:gen_crm/api_resfull/api.dart';
import 'package:gen_crm/src/models/model_generator/add_customer.dart';
import 'package:gen_crm/src/src_index.dart';
import 'package:gen_crm/widgets/widgets.dart';
import '../../../../bloc/detail_product/detail_product_bloc.dart';
import '../../../../bloc/product_module/product_module_bloc.dart';
import '../../../../l10n/key_text.dart';
import '../../../../models/product_model.dart';
import '../../home/product/scanner_qrcode.dart';
import 'item_product.dart';

class ProductContract extends StatefulWidget {
  ProductContract({
    Key? key,
    required this.data,
    required this.addProduct,
    required this.reload,
    this.isDelete = false,
    this.listBtn,
  }) : super(key: key);
  final List<ProductModel> data;
  final Function addProduct;
  final Function reload;
  final bool isDelete;
  final List<ButtonRes>? listBtn;

  @override
  State<ProductContract> createState() => _ProductContractState();
}

class _ProductContractState extends State<ProductContract> {
  List<ProductModel> _productData = [];
  UserRepository _userRepository = UserRepository();
  List<List> _listDVT = [];
  List<List> _listVAT = [];

  @override
  void initState() {
    _productData = widget.data;
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) async {
      final response = await _userRepository.getListProduct(
          BASE_URL.PAGE_DEFAULT.toString(), '', null);
      if (isSuccess(response.code)) {
        if (_listVAT.isEmpty) {
          _listVAT = response.data?.vats ?? [];
        }
        if (_listDVT.isEmpty) {
          _listDVT = response.data?.units ?? [];
        }
      }
    });
    super.initState();
  }

  _reload(bool isSetState) async {
    await widget.reload();
    if (isSetState) {
      setState(() {});
    }
  }

  void _removeProduct(ProductModel productModel) {
    _productData.remove(productModel);
    _reload(true);
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        ListView.builder(
          padding: EdgeInsets.zero,
          shrinkWrap: true,
          physics: NeverScrollableScrollPhysics(),
          itemCount: _productData.length,
          itemBuilder: (context, index) => ItemProduct(
            key: Key('${_productData[index].item.product_id}'),
            onDelete: _removeProduct,
            isDelete: widget.isDelete,
            data: _productData[index].item,
            onChangeQuantity: (soLuong) {
              _productData[index].soLuong = double.parse(soLuong);
            },
            onDVT: (id, name) {
              _productData[index].nameDvt = name;
              _productData[index].item.dvt = id;
            },
            onVAT: (id, name) {
              _productData[index].nameVat = name;
              _productData[index].item.vat = id;
            },
            onGiamGia: (so, type) {
              _productData[index].giamGia = so;
              _productData[index].typeGiamGia = type;
            },
            onPrice: (price) {
              _productData[index].item.sell_price = price;
            },
            onIntoMoney: (intoMoney) {
              _productData[index].intoMoney = intoMoney;
            },
            model: _productData[index],
            listDvt: _listDVT,
            listVat: _listVAT,
            onReload: (bool v) {
              _reload(v);
            },
          ),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 16),
          child: Wrap(
            spacing: 10, // Khoảng cách giữa các item theo chiều ngang
            runSpacing: 10, // Khoảng cách giữa các dòng
            children: [
              itemBtnWrap(getT(KeyT.select_product), () {
                AppNavigator.navigateAddProduct(
                    widget.addProduct, _reload, _productData);
              }),
              itemBtnWrap(
                getT(KeyT.qr_bar_code),
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
                          title: getT(KeyT.notification),
                          content: getT(KeyT.no_data),
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
                    (item) => itemBtnWrap(
                      item.field_label ?? '',
                      () {
                        if (item.field_type == 'service') {
                          AppNavigator.navigateListServicePark(
                            widget.addProduct,
                            _reload,
                            _productData,
                            item.field_label ?? '',
                          );
                        } else {
                          AppNavigator.navigateAddProduct(
                            widget.addProduct,
                            _reload,
                            _productData,
                            group: item.field_url,
                          );
                        }
                      },
                      color: item.field_type == 'service'
                          ? COLORS.ORANGE
                          : COLORS.TEXT_GREY_BOLD,
                    ),
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
