import 'package:flutter/material.dart';
import 'package:gen_crm/src/models/model_generator/add_customer.dart';
import 'package:gen_crm/src/src_index.dart';
import 'package:gen_crm/widgets/widgets.dart';
import '../../../../bloc/detail_product/detail_product_bloc.dart';
import '../../../../bloc/product_module/product_module_bloc.dart';
import '../../../../l10n/key_text.dart';
import '../../../../src/models/model_generator/products_response.dart';
import '../../home/product/scanner_qrcode.dart';
import 'item_products.dart';

//typeContract
//1 số trường ẩn hiện theo loại hợp đồng có tùy chọn khác: 'TKCT'
// - thang_su_dung, ky_thanh_toan, ngay_bat_dau
//
// Trích dẫn #3
// Cập nhật bởi Dai Nguyen cách đây khoảng 18 giờ
// - Trường "Số lượt" hiển thị theo loại hợp đồng có tùy chọn khác là "SOLUOT"
class ProductContract extends StatefulWidget {
  ProductContract({
    Key? key,
    required this.data,
    required this.onChange,
    this.isDelete = false,
    this.listBtn,
    required this.typeContract,
  }) : super(key: key);
  final List<ProductsRes> data;
  final Function(List<ProductsRes>) onChange;
  final bool isDelete;
  final List<ButtonRes>? listBtn;
  final String typeContract;

  @override
  State<ProductContract> createState() => _ProductContractState();
}

class _ProductContractState extends State<ProductContract> {
  List<ProductsRes> _productData = [];
  List<Key> _listKey = [];
  String _typeContract = '';

  @override
  void initState() {
    _productData = widget.data;
    _typeContract = widget.typeContract;
    _listKey = _productData.map((e) => Key('${e.toJson()}')).toList();
    _onChangeMain(_productData);
    super.initState();
  }

  void _onChangeMain(List<ProductsRes> v) {
    widget.onChange(v);
  }

  _reloadKey() {
    _listKey = _productData.map((e) => Key('${e.toJson()}')).toList();
  }

  _reload() {
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      setState(() {});
    });
  }

  void _addProduct(ProductsRes item) {
    _productData.add(item);
    _onChangeMain(_productData);
  }

  void _removeItem(ProductsRes v) {
    _productData.remove(v);
    _onChangeMain(_productData);
    _reload();
  }

  void _updateProduct(ProductsRes v, int index) {
    _productData[index] = v;
    _onChangeMain(_productData);
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
          itemBuilder: (context, i) {
            return ItemProducts(
              isDelete: true,
              key: _listKey[i],
              onAdd: (v) {
                final index = _productData.indexWhere((element) =>
                    element.productId == v.productId &&
                    element.comboId == v.comboId);
                if (index == -1) {
                  _addProduct(v);
                } else {
                  _updateProduct(v, index);
                }
              },
              onDelete: (v) {
                _removeItem(v);
                _reloadKey();
              },
              paddingHorizontal: 0,
              data: _productData[i],
              typeContract: _typeContract,
            );
          },
        ),
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 16),
          child: Wrap(
            spacing: 10, // Khoảng cách giữa các item theo chiều ngang
            runSpacing: 10, // Khoảng cách giữa các dòng
            children: [
              itemBtnWrap(getT(KeyT.select_product), () {
                AppNavigator.navigateAddProduct(
                  _productData,
                  _typeContract,
                  (List<ProductsRes> v) {
                    _productData = v;
                    _onChangeMain(_productData);
                    _reloadKey();
                    _reload();
                  },
                );
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
                        final ProductsRes? data =
                            await DetailProductBloc.of(context)
                                .getDetailProductQR(
                                    id: result?.data?.lists?.first.id ?? '');
                        if (data != null) {
                          _addProduct(data);
                          _reload();
                        }
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
                            item.field_label ?? '',
                            (List<ProductsRes> v) {
                              v.forEach((element) {
                                _addProduct(element);
                                _reloadKey();
                                _reload();
                              });
                            },
                          );
                        } else {
                          AppNavigator.navigateAddProduct(
                            title: item.field_label,
                            group: item.field_url,
                            _productData,
                            _typeContract,
                            (List<ProductsRes> v) {
                              _productData = v;
                              _onChangeMain(_productData);
                              _reloadKey();
                              _reload();
                            },
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

  Widget itemBtnWrap(
    String title,
    Function onTap, {
    Widget? icon,
    Color? color,
  }) =>
      GestureDetector(
        onTap: () => onTap(),
        child: Container(
          padding: EdgeInsets.symmetric(
            horizontal: 16,
            vertical: 8,
          ),
          decoration: BoxDecoration(
            boxShadow: [
              BoxShadow(
                color: COLORS.BLACK.withOpacity(
                  0.1,
                ),
                spreadRadius: 2,
                blurRadius: 5,
              )
            ],
            color: color ?? COLORS.TEXT_COLOR,
            borderRadius: BorderRadius.all(
              Radius.circular(
                16,
              ),
            ),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              if (icon != null) icon,
              WidgetText(
                title: title,
                style: AppStyle.DEFAULT_14_BOLD.copyWith(
                  color: COLORS.WHITE,
                ),
              ),
            ],
          ),
        ),
      );
}
