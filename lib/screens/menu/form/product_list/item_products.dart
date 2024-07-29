import 'package:dartx/dartx.dart';
import 'package:flutter/material.dart';
import 'package:gen_crm/screens/menu/form/product_list/function_product/text_numeric_product.dart';
import 'package:gen_crm/src/models/model_generator/products_response.dart';
import 'package:gen_crm/src/string_ext.dart';
import 'package:gen_crm/widgets/line_horizontal_widget.dart';
import 'package:gen_crm/widgets/showToastM.dart';
import 'package:gen_crm/widgets/widgets.dart';
import '../../../../l10n/key_text.dart';
import '../../../../src/src_index.dart';
import '../../../../storages/share_local.dart';
import 'function_product/count_product.dart';
import 'function_product/date_product.dart';
import 'function_product/select_product.dart';
import 'function_product/textfield_product.dart';

const String SO_LUONG = 'so_luong';
const String DON_GIA = 'don_gia';
const String THANH_TIEN = 'thanh_tien';
const String SO_TIEN_GUI = 'so_tien_gui';
const String THANH_TIEN_GUI = 'THANH_TIEN_GUI';
const String BA0_HIEM_TRA = 'gia_bao_hiem';
const String GIAM_GIA = 'sdgiamgiapopchhd';
const String VAT = 'sdvatpopchhd';

const String COUNT = 'COUNT';
const String SELECT = 'SELECT';
const String TEXT_NUMERIC = 'TEXT_NUMERIC';
const String PERCENTAGE = 'PERCENTAGE';
const String TEXT = 'TEXT';
const String DATE = 'DATE';

const String TYPE_GIAM_GIA = 'type';
const String VALUE_GIAM_GIA = 'value';
const String PHAN_TRAM = '%';

class ItemProducts extends StatefulWidget {
  ItemProducts({
    Key? key,
    required this.data,
    this.paddingHorizontal,
    required this.onAdd,
    required this.onDelete,
    this.isDelete = false,
    required this.typeContract,
  }) : super(key: key);

  final ProductsRes data;
  final double? paddingHorizontal;
  final bool isDelete;
  final String typeContract;
  final Function(ProductsRes) onAdd;
  final Function(ProductsRes) onDelete;

  @override
  State<ItemProducts> createState() => _ItemProductsState();
}

class _ItemProductsState extends State<ItemProducts> {
  late final ProductsRes _dataNew;
  String _typeContract = '';

  @override
  void initState() {
    _typeContract = widget.typeContract;
    final ProductsRes _dataSort = widget.data;

    int index =
        _dataSort.form?.indexWhere((element) => element.fieldType == COUNT) ??
            0; // lấy vị trí của số lượng
    FormProduct? element = _dataSort.form!
        .removeAt(index); // Lấy phần tử ở vị trí index và xóa nó khỏi danh sách
    _dataSort.form?.insert(0, element); // Chèn phần tử vào vị trí đầu tiên

    _dataNew = _dataSort;
    _dataNew.form?.forEach((element) {
      //isShow = true hiện field
      element.isShow = _check(element.listTypeContract ?? []);
    });
    if (_dataNew.donGiaDefault == null)
      _dataNew.donGiaDefault = _getData(DON_GIA).toString().toIntOrNull();
    super.initState();
  }

  bool _check(List<String> data) {
    if (data.contains(_typeContract) || data.length == 0) {
      return true;
    }
    return false;
  }

  _reload() {
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      setState(() {});
    });
  }

  _isShowReload({bool? v}) {
    _dataNew.isShowLocal = v ?? !_dataNew.isShowLocal;
    _reload();
  }

  bool _checkSoLuong() => _getData(SO_LUONG).toString().toDoubleTry() > 0;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => FocusManager.instance.primaryFocus?.unfocus(),
      child: Container(
        padding: EdgeInsets.symmetric(
          horizontal: widget.paddingHorizontal ?? 16,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            AppValue.vSpaceSmall,
            WidgetText(
              title: _dataNew.productName ?? '',
              style: AppStyle.DEFAULT_16_BOLD,
            ),
            _tenCombo(_dataNew),
            Row(
              children: [
                Expanded(
                  child: WidgetText(
                    title: '${getT(KeyT.code_product)}: ' +
                        '${_dataNew.productCode ?? ''}',
                    style: AppStyle.DEFAULT_14_BOLD.copyWith(
                      color: COLORS.TEXT_GREY,
                    ),
                  ),
                ),
                if (_checkSoLuong() &&
                    ((_dataNew.form ?? [])
                                .where((element) => element.isShow)
                                .toList())
                            .length >
                        6)
                  ElevatedButton(
                    onPressed: () {
                      _isShowReload();
                    },
                    style: ElevatedButton.styleFrom(
                      tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                      padding: EdgeInsets.symmetric(
                        horizontal: 8,
                        vertical: 4,
                      ),
                      minimumSize: Size(0, 0),
                      backgroundColor: !_dataNew.isShowLocal
                          ? COLORS.BLUE
                          : COLORS.ORANGE_IMAGE,
                    ),
                    child: WidgetText(
                      title: !_dataNew.isShowLocal
                          ? getT(KeyT.hien_them)
                          : getT(KeyT.an_bot),
                      style: AppStyle.DEFAULT_14.copyWith(
                        color: COLORS.WHITE,
                      ),
                    ),
                  ),
              ],
            ),
            AppValue.vSpace10,
            Wrap(
              runSpacing: _checkSoLuong() ? 10 : 0,
              spacing: _checkSoLuong() ? 10 : 0,
              children: ((_dataNew.form ?? [])
                      .where((element) => element.isShow)
                      .toList())
                  .asMap()
                  .mapEntries((e) {
                if (e.key > (_checkSoLuong() ? 5 : 0) && !_dataNew.isShowLocal)
                  return SizedBox.shrink();
                return _widget(
                  e.value,
                  (
                    dynamic value, {
                    bool? isVND,
                    bool? isDidUpdate,
                  }) {
                    e.value.isReloadLocal = false;

                    switch (e.value.fieldType) {
                      case COUNT:
                      case TEXT_NUMERIC:
                      case TEXT:
                      case DATE:
                        e.value.fieldSetValue = value;
                        break;
                      case PERCENTAGE: // chỉ có trường giảm giá là type == PERCENTAGE
                        e.value.typeOfSale = isVND == true
                            ? '${shareLocal.getString(PreferencesKey.MONEY) ?? ''}'
                            : PHAN_TRAM;
                        bool isValidate = _validateSale(value);
                        if (isValidate) {
                          e.value.fieldSetValue = '';
                        } else {
                          e.value.fieldSetValue = value;
                        }
                        break;
                      case SELECT:
                        e.value.fieldSetValue = value[0];
                        e.value.fieldSetValueDatasource = [value];
                        break;
                    }

                    if ((e.value.fieldName == DON_GIA ||
                            e.value.fieldName == SO_LUONG ||
                            e.value.fieldName == VAT ||
                            e.value.fieldName == GIAM_GIA) &&
                        isDidUpdate != true) {
                      _setValueText(
                        THANH_TIEN,
                        _getIntoMoney(),
                      );
                      _reload();
                    }

                    if (e.value.fieldName == THANH_TIEN &&
                        isDidUpdate != true) {
                      _getNewPriceOrNewCount();
                      _reload();
                    }

                    if (_checkSoLuong()) {
                      widget.onAdd(_dataNew);
                    } else {
                      _isShowReload(v: false);
                      widget.onDelete(_dataNew);
                    }
                  },
                );
              }).toList(),
            ),
            _deleteWidget(),
            AppValue.vSpace10,
            LineHorizontal(
              color: COLORS.GREY_400,
            ),
          ],
        ),
      ),
    );
  }

  Widget _deleteWidget() => (!widget.isDelete)
      ? SizedBox()
      : Container(
          margin: EdgeInsets.only(
            top: 10,
          ),
          child: GestureDetector(
            onTap: () {
              widget.onDelete(_dataNew);
            },
            child: Container(
              alignment: Alignment.centerRight,
              child: WidgetText(
                textAlign: TextAlign.end,
                title: getT(KeyT.delete),
                style: AppStyle.DEFAULT_14_BOLD.copyWith(
                  color: COLORS.RED,
                  fontWeight: FontWeight.w800,
                ),
              ),
            ),
          ),
        );

  _setValueText(
    String fieldName,
    value,
  ) {
    for (int i = 0; i < (_dataNew.form ?? []).length; i++) {
      if (_dataNew.form?[i].fieldName == fieldName) {
        _dataNew.form?[i].fieldSetValue = value;
        _dataNew.form?[i].isReloadLocal = true;
      }
    }
  }

  bool _isDataNull(String _data) => _getData(_data) == null;

  bool? _checkTypeGiamGia() {
    bool? _isTypeGiamGia = _isDataNull(GIAM_GIA)
        ? null
        : _getData(GIAM_GIA)[TYPE_GIAM_GIA] != PHAN_TRAM;
    // nếu mà giam gía == null thì mặc định sẽ là giảm giá theo %
    return _isTypeGiamGia;
  }

  bool _validateSale(String v) {
    bool? _isTypeSale = _checkTypeGiamGia();
    double _priceProduct = _getData(DON_GIA).toString().toDoubleTry();

    if (_isTypeSale == null) {
      return false;
    }

    if (_isTypeSale && (v.toDoubleTry() > _priceProduct)) {
      showToastM(context,
          title: getT(KeyT
              .you_cannot_enter_a_discount_greater_than_the_price_of_the_product));
      return true;
    } else if (!_isTypeSale && v.toDoubleTry() > 100) {
      showToastM(context, title: getT(KeyT.you_cannot_enter_more_than_100));
      return true;
    }
    return false;
  }

  void _getNewPriceOrNewCount() {
    double _vatProductNumber = _isDataNull(VAT)
        ? 0
        : _getData(VAT).split(PHAN_TRAM).first.toString().toDoubleTry();
    double _discountNumber = _isDataNull(GIAM_GIA)
        ? 0
        : _getData(GIAM_GIA)[VALUE_GIAM_GIA].toString().toDoubleTry();
    bool? _isTypeGiamGia = _checkTypeGiamGia();
    double _countProduct = _getData(SO_LUONG).toString().toDoubleTry();
    double _thanhTien = _getData(THANH_TIEN).toString().toDoubleTry();
    double _priceProduct = _getData(DON_GIA).toString().toDoubleTry();
    double _vatProduct = 0;
    double _discount = 0;

    if (_countProduct > 0) {
      double _oneProduct = _thanhTien / _countProduct; //giá
      double _tienTruocVat = _oneProduct / (1 + _vatProductNumber / 100);
      double _tienTruocGiamGia = 0;

      if (_isTypeGiamGia != null) {
        if (!_isTypeGiamGia) {
          _tienTruocGiamGia = _tienTruocVat / ((100 - _discountNumber) / 100);
        } else {
          _tienTruocGiamGia = _tienTruocVat + _discountNumber;
        }
      } else {
        _tienTruocGiamGia = _tienTruocVat;
      }

      _setValueText(DON_GIA, _tienTruocGiamGia.toStringAsFixed(0));
    } else {
      if (_isTypeGiamGia != null) if (!_isTypeGiamGia) {
        _discount = _priceProduct * _discountNumber / 100;
      } else {
        _discount = _discountNumber;
      }

      _vatProduct = _vatProductNumber * (_priceProduct - _discount) / 100;
      _countProduct = _thanhTien / (_priceProduct + _vatProduct - _discount);

      _setValueText(SO_LUONG, _countProduct.toString());
    }
  }

  String _getIntoMoney() {
    double _priceProduct = _getData(DON_GIA).toString().toDoubleTry();
    double _vatProduct = 0;
    double _vatProductNumber = _isDataNull(VAT)
        ? 0
        : _getData(VAT).split(PHAN_TRAM).first.toString().toDoubleTry();
    double _discount = 0;
    double _discountNumber = _isDataNull(GIAM_GIA)
        ? 0
        : _getData(GIAM_GIA)[VALUE_GIAM_GIA].toString().toDoubleTry();
    bool? _isTypeGiamGia = _checkTypeGiamGia();
    double _countProduct = _getData(SO_LUONG).toString().toDoubleTry();

    ///
    ///
    if (_isTypeGiamGia != null) if (!_isTypeGiamGia) {
      _discount = _priceProduct * _discountNumber / 100;
    } else {
      _discount = _discountNumber;
    }

    _vatProduct = _vatProductNumber * (_priceProduct - _discount) / 100;

    double _intoMoney = 0;
    _intoMoney = (_priceProduct + _vatProduct - _discount) * _countProduct;
    return _intoMoney.toString();
  }

  _getData(String fieldName) {
    for (final FormProduct value in _dataNew.form ?? []) {
      if (fieldName == value.fieldName)
        switch (value.fieldType) {
          case COUNT:
          case TEXT_NUMERIC:
          case TEXT:
            return value.fieldSetValue;
          case PERCENTAGE:
            return {
              VALUE_GIAM_GIA: value.fieldSetValue,
              TYPE_GIAM_GIA: value.typeOfSale,
            };
          case SELECT:
            if ((value.fieldSetValueDatasource?.length ?? 0) > 0)
              return value.fieldSetValueDatasource?.first[1];
            else
              return '';
        }
    }
  }

  Widget _tenCombo(
    ProductsRes dataF,
  ) {
    return dataF.tenCombo != null
        ? Container(
            margin: EdgeInsets.symmetric(
              vertical: 6,
            ),
            padding: EdgeInsets.symmetric(
              horizontal: 10,
              vertical: 3,
            ),
            decoration: BoxDecoration(
              color: COLORS.GREY.withOpacity(0.2),
              borderRadius: BorderRadius.all(
                Radius.circular(
                  4,
                ),
              ),
            ),
            child: WidgetText(
              title: dataF.tenCombo ?? '',
              style: AppStyle.DEFAULT_14.copyWith(
                color: COLORS.BLACK,
                fontSize: 12,
              ),
            ),
          )
        : SizedBox.shrink();
  }

  Widget _widget(
    FormProduct dataF,
    Function(
      dynamic, {
      bool? isVND,
      bool? isDidUpdate,
    }) onChange,
  ) {
    switch (dataF.fieldType) {
      case COUNT:
        return CountProduct(
          formProduct: dataF,
          onChange: (
            String v, {
            bool? isReload,
          }) {
            onChange(
              v,
            );
          },
        );
      case SELECT:
        return SelectProduct(
          formProduct: dataF,
          onChange: (List<dynamic> v) {
            onChange(v);
          },
          donGia: _dataNew.donGiaDefault,
          soTienGui: _dataNew.soTienGui,
          onChangeDonGia: (Map<String, dynamic> v) {
            _setValueText(DON_GIA, v[THANH_TIEN_GUI].toString());
            _dataNew.soTienGui = v[SO_TIEN_GUI];
            _setValueText(
              THANH_TIEN,
              _getIntoMoney(),
            );
            _reload();
          },
        );
      case TEXT_NUMERIC:
      case PERCENTAGE:
        return TextNumericProduct(
          formProduct: dataF,
          isShowVND: PERCENTAGE == dataF.fieldType,
          onChange: (
            String? v, {
            bool? isVND,
            bool? isDidUpdate,
          }) {
            onChange(
              v,
              isVND: isVND,
              isDidUpdate: isDidUpdate,
            );
          },
        );
      case TEXT:
        return TextFieldProduct(
          formProduct: dataF,
          onChange: (String v) {
            onChange(v);
          },
        );
      case DATE:
        return DateProduct(
          formProduct: dataF,
          onSelect: (int v) {
            onChange(v);
          },
        );
      default:
        return SizedBox();
    }
  }

  Color getColor(
    bool isChange, {
    Color? colorDF,
  }) =>
      isChange ? COLORS.ORANGE_IMAGE : colorDF ?? COLORS.BLUE;
}
