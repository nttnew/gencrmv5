import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:gen_crm/bloc/product/product_bloc.dart';
import 'package:gen_crm/widgets/btn_thao_tac.dart';
import '../../../../l10n/key_text.dart';
import 'package:get/get.dart';
import '../../../../src/models/model_generator/products_response.dart';
import '../../../../src/src_index.dart';
import '../../../../widgets/appbar_base.dart';
import '../../../../widgets/listview/list_load_infinity.dart';
import '../../../../widgets/search_base.dart';
import '../../home/product/scanner_qrcode.dart';
import 'item_products.dart';

class ListProduct extends StatefulWidget {
  ListProduct({Key? key}) : super(key: key);

  @override
  State<ListProduct> createState() => _ListProductState();
}

class _ListProductState extends State<ListProduct> {
  TextEditingController _editingController = TextEditingController();
  String? title = Get.arguments[0];
  String? group = Get.arguments[1];
  final List<ProductsRes> _listSelected = List.from(Get.arguments[2] ?? []);
  final String typeContract = Get.arguments[3];
  late final ProductBloc _bloc;
  List<ProductsRes> _listAddSelect = [];

  @override
  void initState() {
    _bloc = ProductBloc(userRepository: ProductBloc.of(context).userRepository);
    _coverList();
    super.initState();
  }

  _coverList() {
    // để k bị lỗi cùng vùng bộ nhớ
    for (int i = 0; i < _listSelected.length; i++) {
      _listAddSelect.add(ProductsRes(
        id: _listSelected[i].id,
        productId: _listSelected[i].productId,
        productCode: _listSelected[i].productCode,
        productEdit: _listSelected[i].productEdit,
        productName: _listSelected[i].productName,
        tenSanPhamEn: _listSelected[i].tenSanPhamEn,
        tenSanPhamCn: _listSelected[i].tenSanPhamCn,
        dvt: _listSelected[i].dvt,
        vat: _listSelected[i].vat,
        parentId: _listSelected[i].parentId,
        hasChild: _listSelected[i].hasChild,
        propertyId: _listSelected[i].propertyId,
        sellPrice: _listSelected[i].sellPrice,
        tenSanPhamJp: _listSelected[i].tenSanPhamJp,
        tenSanPhamKr: _listSelected[i].tenSanPhamKr,
        tenSanPhamBm: _listSelected[i].tenSanPhamBm,
        propertyName: _listSelected[i].propertyName,
        tenCombo: _listSelected[i].tenCombo,
        comboId: _listSelected[i].comboId,
        form: _listSelected[i]
            .form
            ?.map((e) => FormProduct(
                  fieldId: e.fieldId,
                  fieldName: e.fieldName,
                  fieldLabel: e.fieldLabel,
                  fieldType: e.fieldType,
                  typeOfSale: e.typeOfSale,
                  fieldRequire: e.fieldRequire,
                  fieldHidden: e.fieldHidden,
                  fieldDatasource: e.fieldDatasource,
                  fieldReadOnly: e.fieldReadOnly,
                  fieldSetValue: e.fieldSetValue,
                  fieldValue: e.fieldValue,
                  fieldSetValueDatasource: e.fieldSetValueDatasource,
                  listTypeContract: e.listTypeContract,
                  isShow: e.isShow,
                ))
            .toList(),
      ));
    }
  }

  @override
  void dispose() {
    _editingController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppbarBaseNormal(title != null
          ? getT(KeyT.select) + ' ${title?.toLowerCase() ?? ''}'
          : getT(KeyT.select_product)),
      bottomNavigationBar: Container(
        width: double.infinity,
        height: 65,
        padding: EdgeInsets.symmetric(
          horizontal: 16,
          vertical: 12,
        ),
        decoration: BoxDecoration(
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(0.3),
              spreadRadius: 1,
              blurRadius: 5,
              offset: Offset(0, 0), // changes position of shadow
            ),
          ],
          color: COLORS.WHITE,
        ),
        child: ButtonBaseSmall(
          title: getT(KeyT.select),
          onTap: () {
            Get.back(result: _listAddSelect);
          },
        ),
      ),
      body: ViewLoadMoreBase(
        paddingList: 0,
        heightAppBar: 65,
        child: SingleChildScrollView(
          child: Container(
            padding: EdgeInsets.only(
              top: 8,
              bottom: 8,
            ),
            decoration: BoxDecoration(
              color: COLORS.WHITE,
              boxShadow: [
                BoxShadow(
                  color: Colors.grey.withOpacity(0.3),
                  spreadRadius: 1,
                  blurRadius: 5,
                  offset: Offset(0, 0), // changes position of shadow
                ),
              ],
            ),
            child: SearchBase(
              controller: _editingController,
              hint: title != null
                  ? getT(KeyT.find) + ' ${title?.toLowerCase() ?? ''}'
                  : getT(KeyT.find_product),
              onChange: (v) {
                _onClickSearch();
              },
              leadIcon: SvgPicture.asset(ICONS.IC_SEARCH_SVG),
              endIcon: GestureDetector(
                onTap: () {
                  Navigator.of(context)
                      .push(MaterialPageRoute(
                          builder: (context) => ScannerQrcode()))
                      .then((value) async {
                    if (value != '' && value != null) {
                      _editingController.text = value;
                      _onClickSearch();
                    }
                  });
                },
                child: Icon(
                  Icons.qr_code_scanner,
                  size: 20,
                ),
              ),
            ),
          ),
        ),
        isInit: true,
        functionInit: (page, isInit) {
          return _bloc.getListProduct(
            page: page,
            querySearch: _editingController.text,
            group: group,
          );
        },
        itemWidget: (int index, data) {
          ProductsRes _item = data as ProductsRes;
          final index = _listAddSelect.indexWhere((element) =>
              element.productId == _item.productId &&
              element.comboId == _item.comboId);
          if (index !=
              -1) // check xem có trong list chưa có rồi thì hiển thị data select vào
            _item = _listAddSelect[index];
          return ItemProducts(
            key: Key('key${_item.toJson()}'),
            data: _item,
            onAdd: (ProductsRes v) {
              final int index = _listAddSelect.indexWhere((element) =>
                  element.productId == v.productId &&
                  element.comboId == v.comboId);
              if (index != -1) {
                // nếu có rồi thì tìm vị trí của nó và set lại
                _listAddSelect[index] = v;
              } else {
                // nếu chưa có thì thêm
                _listAddSelect.add(v);
              }
            },
            onDelete: (ProductsRes v) {
              _listAddSelect.remove(v);
            },
            typeContract: typeContract,
          );
        },
        widgetLoad: widgetLoadingProduct(),
        controller: _bloc.loadMoreControllerProduct,
      ),
    );
  }

  void _onClickSearch() {
    _bloc.loadMoreControllerProduct.reloadData();
  }
}
