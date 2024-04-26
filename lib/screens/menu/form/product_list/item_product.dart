import 'package:flutter/material.dart';
import 'package:gen_crm/screens/menu/form/product_list/function_product/click_so_luong.dart';
import 'package:gen_crm/screens/menu/form/product_list/function_product/click_vat.dart';
import 'package:gen_crm/src/models/model_generator/product_response.dart';
import 'package:gen_crm/src/string_ext.dart';
import 'package:gen_crm/widgets/widgets.dart';
import '../../../../l10n/key_text.dart';
import '../../../../models/product_model.dart';
import 'package:get/get.dart';
import '../../../../src/src_index.dart';
import '../../../../storages/share_local.dart';
import 'function_product/click_dvt.dart';
import 'function_product/click_giam_gia.dart';
import 'function_product/click_into_money.dart';
import 'function_product/click_price.dart';

class ItemProduct extends StatefulWidget {
  ItemProduct({
    Key? key,
    required this.data,
    required this.listDvt,
    required this.listVat,
    required this.onChangeQuantity,
    required this.onDVT,
    required this.onVAT,
    required this.onGiamGia,
    required this.onPrice,
    required this.model,
    this.isDelete = false,
    required this.onDelete,
    required this.onIntoMoney,
    required this.onReload,
  }) : super(key: key);

  final ProductItem data;
  final List<List<dynamic>> listDvt;
  final List<List<dynamic>> listVat;
  final Function onChangeQuantity;
  final Function onDVT;
  final Function onVAT;
  final Function onGiamGia;
  final Function onPrice;
  final Function(double) onIntoMoney;
  final Function(bool) onReload;
  final ProductModel model;
  final bool isDelete;
  final Function(ProductModel productModel) onDelete;

  @override
  State<ItemProduct> createState() => _ItemProductState();
}

class _ItemProductState extends State<ItemProduct> {
  String _price = '';
  bool _isTypeGiamGia = true;
  bool _isTypeGiamGiaDefault = true;
  double _thanhTien = 0;
  String _donViTinh = '';
  String _vat = 'null';
  String _giamGia = '0';
  String _soLuong = '0';
  TextEditingController _giamGiaController = TextEditingController();
  TextEditingController _priceController = TextEditingController();
  TextEditingController _soLuongController = TextEditingController();
  TextEditingController _intoMoneyController = TextEditingController();
  String _priceInit = '';
  String _countInit = '0';
  String _dvtInit = '';
  String _vatInit = 'null';
  String _saleInit = '0';
  double _intoMoneyInit = 0;
  bool _isTypeGiamGIaInit = true;

  @override
  void initState() {
    int _index =
        widget.listDvt.indexWhere((element) => element[0] == widget.data.dvt);
    int _indexVat =
        widget.listVat.indexWhere((element) => element[0] == widget.data.vat);
    _price = widget.data.sell_price ?? '';

    /// init set color
    _priceInit = widget.data.sell_price ?? '';

    ///
    if (widget.model.soLuong != 0) {
      /// init set color
      _priceInit = widget.model.item.sell_price ?? '';
      _countInit = widget.model.soLuong.toString();
      _dvtInit = widget.model.nameDvt;
      _vatInit = widget.model.nameVat;
      _saleInit = widget.model.giamGia;
      _isTypeGiamGIaInit = widget.model.typeGiamGia == '%' ? false : true;

      ///
      _donViTinh = widget.model.nameDvt;
      _vat = widget.model.nameVat;
      _giamGia = widget.model.giamGia;
      _isTypeGiamGia = widget.model.typeGiamGia == '%' ? false : true;
      _soLuong = widget.model.soLuong.toString();
      _price = widget.model.item.sell_price ?? '';
      widget.onDVT(widget.model.item.dvt, _donViTinh);
      widget.onVAT(widget.model.item.vat, _vat);
    } else {
      _donViTinh = _index != -1 ? widget.listDvt[_index][1] : '';
      _vat = _indexVat != -1 ? widget.listVat[_indexVat][1] : 'null';
      _soLuong = '0';

      /// init set color
      _dvtInit = _index != -1 ? widget.listDvt[_index][1] : '';
      _vatInit = _indexVat != -1 ? widget.listVat[_indexVat][1] : 'null';
      _countInit = '0';

      ///
      widget.onDVT(widget.data.dvt, _donViTinh);
      widget.onVAT(widget.data.vat, _vat);
    }

    /// init set color

    ///
    if (widget.model.intoMoney == null) {
      _getIntoMoney(isInit: true);
    } else {
      _thanhTien = widget.model.intoMoney ?? 0;
      _intoMoneyInit = widget.model.intoMoney ?? 0;
    }
    super.initState();
  }

  @override
  void didUpdateWidget(covariant ItemProduct oldWidget) {
    final typeWidget = (widget.model.typeGiamGia == '%' ? false : true);
    if (oldWidget != widget) {
      _soLuong = widget.model.soLuong.toString();
      _price = widget.model.item.sell_price ?? '';
      _donViTinh = widget.model.nameDvt;
      _vat = widget.model.nameVat;
      _giamGia = widget.model.giamGia;
      if (_isTypeGiamGiaDefault != typeWidget) {
        _isTypeGiamGiaDefault = typeWidget;
        _isTypeGiamGia = typeWidget;
      }
      if (_thanhTien != (widget.model.intoMoney ?? 0)) {
        _thanhTien = widget.model.intoMoney ?? 0;
      }
      widget.onReload(false);
    }
    super.didUpdateWidget(oldWidget);
  }

  void _getIntoMoney({bool isInit = false}) {
    double _priceProduct = _price.toDoubleTry();
    double _vatProduct = 0;
    double _vatProductNumber = _vat.split('%').first.toDoubleTry();
    double _discount = 0;
    double _discountNumber = _giamGia.toDoubleTry();
    double _countProduct = 0;

    if (!_isTypeGiamGia) {
      _discount = _priceProduct * _discountNumber / 100;
    } else {
      _discount = _discountNumber;
    }

    _vatProduct = _vatProductNumber * (_priceProduct - _discount) / 100;
    _countProduct = _soLuong.toDoubleTry();

    double _intoMoney = 0;
    _intoMoney = (_priceProduct + _vatProduct - _discount) * _countProduct;
    _thanhTien = _intoMoney;
    if (isInit) _intoMoneyInit = _intoMoney;
    widget.onIntoMoney(_intoMoney);
    widget.onReload(true);
    setState(() {});
  }

  void _getNewPrice() {
    double _vatProductNumber = _vat.split('%').first.toDoubleTry();
    double _discountNumber = _giamGia.toDoubleTry();
    double _countProduct = _soLuong.toDoubleTry();

    if (_countProduct > 0) {
      double _oneProduct = _thanhTien / _countProduct; //giá
      double _tienTruocVat = _oneProduct / (1 + _vatProductNumber / 100);
      double _tienTruocGiamGia = 0;
      if (!_isTypeGiamGia) {
        _tienTruocGiamGia = _tienTruocVat / ((100 - _discountNumber) / 100);
      } else {
        _tienTruocGiamGia = _tienTruocVat + _discountNumber;
      }
      _price = _tienTruocGiamGia.toStringAsFixed(0);
      _priceController.text = _price;
      widget.onPrice(_price);
      widget.onIntoMoney(_thanhTien);
    } else {
      _thanhTien = 0;
      widget.onIntoMoney(0);
    }
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        border: Border(
          bottom: BorderSide(
            width: 1,
            color: COLORS.GREY_400,
          ),
        ),
      ),
      margin: EdgeInsets.only(
        top: 8,
      ),
      padding: EdgeInsets.only(bottom: 16),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                WidgetText(
                  title: widget.data.product_name ?? '',
                  style: AppStyle.DEFAULT_16_BOLD,
                ),
                SizedBox(
                  height: 3,
                ),
                if (widget.data.ten_combo != null) ...[
                  Container(
                    margin: EdgeInsets.symmetric(
                      vertical: 3,
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
                      title: widget.data.ten_combo ?? '',
                      style: AppStyle.DEFAULT_14.copyWith(
                        color: COLORS.BLACK,
                        fontSize: 12,
                      ),
                    ),
                  ),
                ],
                WidgetText(
                  title: '${getT(KeyT.code_product)}: ' +
                      '${widget.data.product_code ?? ''}',
                  style: AppStyle.DEFAULT_14_BOLD
                      .copyWith(color: COLORS.TEXT_GREY),
                ),
                SizedBox(
                  height: 3,
                ),
                itemClick(
                  colorDF: COLORS.BLACK.withOpacity(0.8),
                  title: '${getT(KeyT.price)}: ' +
                      '${AppValue.format_money(_price)}',
                  isChange: !(_price.toDoubleTry() == _priceInit.toDoubleTry()),
                  onTap: () {
                    _priceController.text = AppValue.format_money(
                                widget.data.sell_price ?? '0',
                                isD: false) ==
                            '0'
                        ? ''
                        : AppValue.format_money(widget.data.sell_price ?? '0',
                            isD: false);
                    onClickPrice(context, _priceController, (v) {
                      if (v != '') {
                        _price = v;
                        widget.onPrice(_price);
                        _getIntoMoney();
                      } else {
                        _priceController.text = _price;
                      }
                      Get.back();
                    });
                  },
                ),
                SizedBox(
                  height: 5,
                ),
                Row(
                  children: [
                    itemClick(
                      title: '${getT(KeyT.dvt)}: ' + '${_donViTinh}',
                      isChange: _donViTinh != _dvtInit,
                      onTap: () {
                        onClickDVT(context, widget.listDvt, (v) {
                          _donViTinh = v[1];
                          widget.onDVT(v[0], v[1]);
                          setState(() {});
                          Get.back();
                        });
                      },
                    ),
                    SizedBox(
                      width: 5,
                    ),
                    itemClick(
                      title:
                          '${getT(KeyT.vat)}: ' + '${_vat == '' ? 'null' : _vat}',
                      isChange: _vat != _vatInit,
                      onTap: () {
                        onClickVAT(context, widget.listVat, (v) {
                          _vat = v[1];
                          widget.onVAT(v[0], v[1]);
                          _getIntoMoney();
                          Get.back();
                        });
                      },
                    ),
                  ],
                ),
                SizedBox(
                  height: 5,
                ),
                itemClick(
                  title: '${getT(KeyT.sale)}: ' +
                      (_isTypeGiamGia
                          ? AppValue.format_money(_giamGia)
                          : _giamGia.trim()) +
                      '${_isTypeGiamGia ? '' : '%'}',
                  isChange: _isTypeGiamGia != _isTypeGiamGIaInit ||
                      _giamGia.toDoubleTry() != _saleInit.toDoubleTry(),
                  onTap: () {
                    if (widget.model.giamGia.toDoubleTry() > 0) {
                      _giamGiaController.text = AppValue.format_money(
                        widget.model.giamGia,
                        isD: false,
                      );
                    } else {
                      _giamGiaController.text = '';
                    }
                    onClickGiamGia(
                      context,
                      _isTypeGiamGia,
                      _giamGiaController,
                      (bool isGiam, String txt) {
                        _onClickGiamGia(
                          isGiam,
                          txt,
                        );
                      },
                    );
                  },
                ),
                SizedBox(
                  height: 5,
                ),
                itemClick(
                  title: '${getT(KeyT.into_money)}: ' +
                      '${AppValue.format_money(_thanhTien.toStringAsFixed(0))}',
                  isChange: _thanhTien != _intoMoneyInit,
                  onTap: () {
                    if (_thanhTien > 0) {
                      _intoMoneyController.text = AppValue.format_money(
                        _thanhTien.toStringAsFixed(0),
                        isD: false,
                      );
                    } else {
                      _intoMoneyController.text = '';
                    }
                    onClickIntoMoney(
                      context,
                      _intoMoneyController,
                      (String v) {
                        if (v.toDoubleTry() >= 0) {
                          _thanhTien = v.toDoubleTry();
                          _getNewPrice();
                        } else {
                          _intoMoneyController.text =
                              _thanhTien.toStringAsFixed(0);
                        }
                        widget.onReload(false);
                        Get.back();
                      },
                    );
                  },
                ),
              ],
            ),
          ),
          _widgetSoLuong(),
        ],
      ),
    );
  }

  _onClickGiamGia(
    bool isGiam,
    String txt,
  ) {
    _isTypeGiamGia = isGiam;
    if (_isTypeGiamGia &&
        (txt.toDoubleTry() > widget.data.sell_price.toString().toDoubleTry())) {
      ShowDialogCustom.showDialogBase(
        title: getT(KeyT.notification),
        content: getT(KeyT
            .you_cannot_enter_a_discount_greater_than_the_price_of_the_product),
        onTap1: () {
          Get.back();
        },
      );
    } else if (!_isTypeGiamGia && txt.toDoubleTry() > 100) {
      ShowDialogCustom.showDialogBase(
        title: getT(KeyT.notification),
        content: getT(KeyT.you_cannot_enter_more_than_100),
        onTap1: () {
          Get.back();
        },
      );
    } else {
      if (txt == 0) {
        _giamGia = '0';
        _giamGiaController.text = _giamGia;
      } else {
        _giamGia = txt;
      }

      widget.onGiamGia(
        txt,
        _isTypeGiamGia ? shareLocal.getString(PreferencesKey.MONEY) ?? '' : '%',
      );
      _getIntoMoney();
      Get.back();
    }
  }

  _widgetSoLuong() => Column(
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          GestureDetector(
            onTap: () {
              if (_soLuong.toDoubleTry() > 1) {
                _soLuong = (_soLuong.toDoubleTry() - 1).toString();
                widget.onChangeQuantity(
                    _soLuong.toDoubleTry().toStringAsFixed(2));
                _getIntoMoney();
              } else {
                _soLuong = '0';
                if (widget.isDelete) {
                  widget.onDelete(widget.model);
                } else {
                  widget.onChangeQuantity(
                      _soLuong.toDoubleTry().toStringAsFixed(2));
                  _getIntoMoney();
                }
              }
            },
            child: WidgetContainerImage(
              image: ICONS.IC_MINUS_PNG,
              width: 24,
              height: 24,
              fit: BoxFit.contain,
              borderRadius: BorderRadius.circular(0),
              colorImage:
                  _soLuong.toDoubleTry() >= 1 ? COLORS.BLUE : COLORS.GRAY_IMAGE,
            ),
          ),
          GestureDetector(
            onTap: () {
              if (_soLuong.toDoubleTry() == 0) {
                _soLuongController.text = '';
              } else {
                _soLuongController.text =
                    _soLuong.toDoubleTry().toStringAsFixed(2);
              }
              onClickSoLuong(context, _soLuongController, (v) {
                String text = v; // Đoạn văn bản cần kiểm tra
                double number = 0;
                try {
                  number = text.toDoubleTry();
                } catch (e) {
                  if (text.split(',').length <= 2) {
                    number = text.replaceAll(',', '.').toDoubleTry();
                  }
                  //khong phai kieu double
                }

                if (number > 0) {
                  _soLuong = number.toString();
                  widget.onChangeQuantity(
                      number.toStringAsFixed(2)); // change data quantity
                  _getIntoMoney();
                  Get.back();
                }
              });
            },
            child: Container(
              padding: EdgeInsets.symmetric(vertical: 16),
              child: WidgetText(
                title: _soLuong.toDoubleTry().toStringAsFixed(2),
                style: AppStyle.DEFAULT_16_BOLD.copyWith(
                  color: getColor(
                    _soLuong.toDoubleTry() != _countInit.toDoubleTry(),
                  ),
                ),
              ),
            ),
          ),
          GestureDetector(
            onTap: () {
              _soLuong = (_soLuong.toDoubleTry() + 1).toString();
              widget
                  .onChangeQuantity(_soLuong.toDoubleTry().toStringAsFixed(2));
              _getIntoMoney();
            },
            child: WidgetContainerImage(
              image: ICONS.IC_PLUS_PNG,
              width: 24,
              height: 24,
              fit: BoxFit.contain,
              borderRadius: BorderRadius.circular(0),
              colorImage: COLORS.BLUE,
            ),
          ),
          widget.isDelete == false
              ? SizedBox()
              : GestureDetector(
                  onTap: () {
                    widget.onDelete(widget.model);
                  },
                  child: Container(
                    margin: const EdgeInsets.only(
                      top: 20,
                    ),
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
        ],
      );

  Widget itemClick({
    required String title,
    required bool isChange,
    required Function onTap,
    Color? colorDF,
  }) {
    return GestureDetector(
      onTap: () {
        onTap();
      },
      child: Container(
        decoration: BoxDecoration(
          border: Border.all(
            color: getColor(
              isChange,
              colorDF: colorDF,
            ),
          ),
          borderRadius: BorderRadius.circular(
            6,
          ),
        ),
        padding: EdgeInsets.symmetric(
          horizontal: 8,
          vertical: 2,
        ),
        child: WidgetText(
          title: title,
          style: AppStyle.DEFAULT_14_BOLD.copyWith(
            color: getColor(
              isChange,
              colorDF: colorDF,
            ),
          ),
        ),
      ),
    );
  }

  Color getColor(
    bool isChange, {
    Color? colorDF,
  }) =>
      isChange ? COLORS.ORANGE_IMAGE : colorDF ?? COLORS.BLUE;
}
