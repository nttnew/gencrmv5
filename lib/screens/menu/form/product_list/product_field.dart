import 'package:flutter/material.dart';
import 'package:gen_crm/src/models/model_generator/add_customer.dart';
import 'package:gen_crm/src/src_index.dart';
import 'package:gen_crm/widgets/loading_api.dart';
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
class ProductField extends StatefulWidget {
  ProductField({
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
  State<ProductField> createState() => _ProductFieldState();
}

class _ProductFieldState extends State<ProductField> {
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
    _listKey.removeAt(_productData.indexWhere((element) => v == element));
    _productData.remove(v);
    _onChangeMain(_productData);
    setState(() {});
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
            runSpacing: 10,
            spacing: 10, // Khoảng cách giữa các item theo chiều ngang
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
                    if (value != '' && value != null) {
                      try {
                        final result = await ProductModuleBloc.of(context)
                            .getListProduct(querySearch: value);
                        if (result?.data?.lists?.isNotEmpty ?? false) {
                          final ProductsRes? data =
                              await DetailProductBloc.of(context)
                                  .getDetailProductQR(
                                      id: result?.data?.lists?.first.id ?? '');
                          if (data != null) {
                            final index = _productData.indexWhere((element) =>
                                element.productId == data.productId &&
                                element.comboId == data.comboId);
                            if (index == -1) {
                              _addProduct(data);
                            } else {
                              final dataSelect = _productData[index];
                              for (int i = 0;
                                  i < (dataSelect.form?.length ?? 0);
                                  i++) {
                                if (dataSelect.form?[i].fieldType == COUNT) {
                                  dataSelect.form?[i].fieldSetValue += 1;
                                  dataSelect.form?[i].fieldValue =
                                      dataSelect.form?[i].fieldSetValue;
                                }
                              }
                              _updateProduct(dataSelect, index);
                            }
                            _reloadKey();
                            _reload();
                          }
                        } else {
                          Loading().popLoading();
                          ShowDialogCustom.showDialogBase(
                            title: getT(KeyT.notification),
                            content: getT(KeyT.no_data),
                          );
                        }
                      } catch (e) {
                        Loading().popLoading();
                        ShowDialogCustom.showDialogBase(
                          title: getT(KeyT.notification),
                          content: getT(KeyT.an_error_occurred),
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
}

Widget itemBtnWrap(
  String title,
  Function onTap, {
  Widget? icon,
  Color? color,
}) =>
    ElevatedButton(
      style: ElevatedButton.styleFrom(
        tapTargetSize: MaterialTapTargetSize.shrinkWrap,
        minimumSize: Size(0, 0),
        padding: EdgeInsets.symmetric(
          horizontal: 16,
          vertical: 8,
        ),
        backgroundColor: color ?? COLORS.TEXT_COLOR,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.all(
            Radius.circular(
              16,
            ),
          ),
        ),
      ),
      onPressed: () => onTap(),
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
    );
