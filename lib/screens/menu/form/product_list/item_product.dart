import 'package:flutter/material.dart';
import 'package:gen_crm/screens/menu/form/product_list/function_product/click_so_luong.dart';
import 'package:gen_crm/screens/menu/form/product_list/function_product/click_vat.dart';
import 'package:gen_crm/src/models/model_generator/product_response.dart';
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
    required this.neverHidden,
    required this.onChangeQuantity,
    required this.onDVT,
    required this.onVAT,
    required this.onGiamGia,
    required this.onPrice,
    required this.model,
    this.canDelete = false,
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
  final Function() onReload;
  final ProductModel model;
  final bool neverHidden;
  final bool canDelete;
  final Function(ProductModel productModel) onDelete;

  @override
  State<ItemProduct> createState() => _ItemProductState();
}

class _ItemProductState extends State<ItemProduct> {
  String price = '';
  bool isTypeGiamGIa = true;
  bool typeGiamGiaDefault = true;
  double intoMoney = 0;
  String dvt = '';
  String vat = '';
  String giamGia = '0';
  String soLuong = '0';
  TextEditingController _giamGiaController = TextEditingController();
  TextEditingController _priceController = TextEditingController();
  TextEditingController _soLuongController = TextEditingController();
  TextEditingController _intoMoneyController = TextEditingController();
  String priceInit = '';
  String countInit = '0';
  String dvtInit = '';
  String vatInit = '';
  String saleInit = '0';
  double intoMoneyInit = 0;
  bool isTypeGiamGIaInit = true;

  @override
  void initState() {
    int index =
        widget.listDvt.indexWhere((element) => element[0] == widget.data.dvt);
    int indexVat =
        widget.listVat.indexWhere((element) => element[0] == widget.data.vat);
    price = widget.data.sell_price ?? '';

    /// init set color
    priceInit = widget.data.sell_price ?? '';

    ///
    if (widget.model.soLuong != 0) {
      setState(() {
        /// init set color
        priceInit = widget.model.item.sell_price ?? '';
        countInit = widget.model.soLuong.toString();
        dvtInit = widget.model.nameDvt;
        vatInit = widget.model.nameVat;
        saleInit = widget.model.giamGia;
        isTypeGiamGIaInit = widget.model.typeGiamGia == '%' ? false : true;

        ///
        dvt = widget.model.nameDvt;
        vat = widget.model.nameVat;
        giamGia = widget.model.giamGia;
        isTypeGiamGIa = widget.model.typeGiamGia == '%' ? false : true;
        soLuong = widget.model.soLuong.toString();
        price = widget.model.item.sell_price ?? '';
      });
      widget.onDVT(widget.model.item.dvt, dvt);
      widget.onVAT(widget.model.item.vat, vat);
    } else {
      setState(() {
        dvt = index != -1 ? widget.listDvt[index][1] : '';
        vat = indexVat != -1 ? widget.listVat[indexVat][1] : '0';
        soLuong = '0';

        /// init set color
        dvtInit = index != -1 ? widget.listDvt[index][1] : '';
        vatInit = indexVat != -1 ? widget.listVat[indexVat][1] : '0';
        countInit = '0';

        ///
      });
      widget.onDVT(widget.data.dvt, dvt);
      widget.onVAT(widget.data.vat, vat);
    }

    /// init set color
    intoMoneyInit = widget.model.intoMoney ?? 0;

    ///
    intoMoney = widget.model.intoMoney ?? 0;
    super.initState();
  }

  @override
  void didUpdateWidget(covariant ItemProduct oldWidget) {
    final typeWidget = (widget.model.typeGiamGia == '%' ? false : true);
    if (oldWidget != widget) {
      soLuong = widget.model.soLuong.toString();
      price = widget.model.item.sell_price ?? '';
      dvt = widget.model.nameDvt;
      vat = widget.model.nameVat;
      giamGia = widget.model.giamGia;
      if (typeGiamGiaDefault != typeWidget) {
        typeGiamGiaDefault = typeWidget;
        isTypeGiamGIa = typeWidget;
      }
      if (intoMoney != (widget.model.intoMoney ?? 0)) {
        intoMoney = widget.model.intoMoney ?? 0;
      }
      widget.onReload();
    }
    super.didUpdateWidget(oldWidget);
  }

  void _getIntoMoney() {
    double priceProduct = 0;
    double vatProduct = 0;
    double vatProductNumber = 0;
    double discount = 0;
    double discountNumber = 0;
    double countProduct = 0;
    try {
      if (double.parse(price) > 0) priceProduct = double.parse(price);

      if (double.parse(giamGia) > 0) discountNumber = double.parse(giamGia);

      if (!isTypeGiamGIa) {
        discount = priceProduct * discountNumber / 100;
      } else {
        discount = discountNumber;
      }

      try {
        if (double.parse(vat.split('%').first) > 0) {
          vatProductNumber = double.parse(vat.split('%').first);
          vatProduct = vatProductNumber * (priceProduct - discount) / 100;
        }
      } catch (e) {}

      if (soLuong.isNotEmpty) countProduct = double.parse(soLuong);
    } catch (e) {}

    double money = 0;
    money = (priceProduct + vatProduct - discount) * countProduct;
    intoMoney = money;
    widget.onIntoMoney(money);
    widget.onReload();
    setState(() {});
  }

  void _getNewPrice() {
    double vatProductNumber = 0;
    double discountNumber = 0;
    double countProduct = 0;
    try {
      if (double.parse(giamGia) > 0) discountNumber = double.parse(giamGia);

      try {
        if (double.parse(vat.split('%').first) > 0) {
          vatProductNumber = double.parse(vat.split('%').first);
        }
      } catch (e) {}

      if (soLuong.isNotEmpty) countProduct = double.parse(soLuong);
    } catch (e) {}

    if (countProduct > 0) {
      double newPrice = 0;
      double oneProduct = intoMoney / countProduct;
      double discount = 0;
      double vat = 0;
      if (!isTypeGiamGIa) {
        discount = oneProduct - oneProduct * (100 - discountNumber) / 100;
      } else {
        discount = discountNumber;
      }
      if (vatProductNumber > 0) {
        vat = (oneProduct - discount) -
            (oneProduct - discount) * (100 - vatProductNumber) / 100;
      }
      newPrice = oneProduct - vat + discount;

      price = newPrice.toStringAsFixed(0);
      _priceController.text = price;
      widget.onPrice(price);
      widget.onIntoMoney(intoMoney);
    } else {
      intoMoney = 0;
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
                  colorDF: COLORS.GREY,
                  title: '${getT(KeyT.price)}: ' +
                      '${AppValue.format_money(price)}',
                  isChange:
                      !(double.tryParse(price) == double.tryParse(priceInit)),
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
                        price = v;
                        widget.onPrice(price);
                        _getIntoMoney();
                      } else {
                        _priceController.text = price;
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
                      title: '${getT(KeyT.dvt)}: ' + '${dvt}',
                      isChange: dvt != dvtInit,
                      onTap: () {
                        onClickDVT(context, widget.listDvt, (v) {
                          dvt = v[1];
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
                      title: '${getT(KeyT.vat)}: ' + '${vat == '' ? '0' : vat}',
                      isChange: vat != vatInit,
                      onTap: () {
                        onClickVAT(context, widget.listVat, (v) {
                          vat = v[1];
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
                      (isTypeGiamGIa
                          ? AppValue.format_money(giamGia)
                          : giamGia.trim()) +
                      '${isTypeGiamGIa ? '' : '%'}',
                  isChange: isTypeGiamGIa != isTypeGiamGIaInit ||
                      double.tryParse(giamGia) != double.tryParse(saleInit),
                  onTap: () {
                    if (double.parse(widget.model.giamGia) > 0) {
                      _giamGiaController.text = AppValue.format_money(
                        widget.model.giamGia,
                        isD: false,
                      );
                    } else {
                      _giamGiaController.text = '';
                    }
                    onClickGiamGia(
                      context,
                      isTypeGiamGIa,
                      _giamGiaController,
                      (isGiam, txt) {
                        _onClickGiamGia(isGiam, txt);
                      },
                    );
                  },
                ),
                SizedBox(
                  height: 5,
                ),
                itemClick(
                  title: '${getT(KeyT.into_money)}: ' +
                      '${AppValue.format_money(intoMoney.toStringAsFixed(0))}',
                  isChange: intoMoney != intoMoneyInit,
                  onTap: () {
                    if (intoMoney > 0) {
                      _intoMoneyController.text = AppValue.format_money(
                        intoMoney.toStringAsFixed(0),
                        isD: false,
                      );
                    } else {
                      _intoMoneyController.text = '';
                    }
                    onClickIntoMoney(context, _intoMoneyController, (v) {
                      if (double.parse(v) >= 0) {
                        intoMoney = (double.parse(v));
                        _getNewPrice();
                      } else {
                        _intoMoneyController.text =
                            intoMoney.toStringAsFixed(0);
                      }
                      widget.onReload();
                      Get.back();
                    });
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

  _onClickGiamGia(bool isGiam, String txt) {
    isTypeGiamGIa = isGiam;
    if (isTypeGiamGIa &&
        (double.parse(txt) > double.parse(widget.data.sell_price ?? '0'))) {
      ShowDialogCustom.showDialogBase(
        title: getT(KeyT.notification),
        content: getT(KeyT
            .you_cannot_enter_a_discount_greater_than_the_price_of_the_product),
        onTap1: () {
          Get.back();
        },
      );
    } else if (!isTypeGiamGIa && (double.parse(txt) > 100)) {
      ShowDialogCustom.showDialogBase(
        title: getT(KeyT.notification),
        content: getT(KeyT.you_cannot_enter_more_than_100),
        onTap1: () {
          Get.back();
        },
      );
    } else {
      if (double.parse(txt) == 0) {
        giamGia = '0';
        _giamGiaController.text = giamGia;
      } else {
        giamGia = txt;
      }

      widget.onGiamGia(
        txt,
        isTypeGiamGIa ? shareLocal.getString(PreferencesKey.MONEY) ?? '' : '%',
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
              if (double.parse(soLuong) > 1) {
                soLuong = (double.parse(soLuong) - 1).toString();
              } else {
                soLuong = '0';
                widget.onDelete(widget.model);
              }
              widget.onChangeQuantity(double.parse(soLuong).toStringAsFixed(2));
              _getIntoMoney();
            },
            child: WidgetContainerImage(
              image: ICONS.IC_MINUS_PNG,
              width: 24,
              height: 24,
              fit: BoxFit.contain,
              borderRadius: BorderRadius.circular(0),
              colorImage: COLORS.GRAY_IMAGE,
            ),
          ),
          GestureDetector(
            onTap: () {
              if (double.parse(soLuong) == 0) {
                _soLuongController.text = '';
              } else {
                _soLuongController.text =
                    double.parse(soLuong).toStringAsFixed(2);
              }
              onClickSoLuong(context, _soLuongController, (v) {
                String text = v; // Đoạn văn bản cần kiểm tra
                double number = 0;
                try {
                  number = double.parse(text);
                } catch (e) {
                  if (text.split(',').length <= 2) {
                    number = double.parse(text.replaceAll(',', '.'));
                  }
                  //khong phai kieu double
                }

                if (number > 0) {
                  soLuong = number.toString();
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
                title: double.parse(soLuong).toStringAsFixed(2),
                style: AppStyle.DEFAULT_16_BOLD.copyWith(
                  color: getColor(
                    double.tryParse(soLuong) != double.tryParse(countInit),
                  ),
                ),
              ),
            ),
          ),
          GestureDetector(
            onTap: () {
              soLuong = (double.parse(soLuong) + 1).toString();
              widget.onChangeQuantity(double.parse(soLuong).toStringAsFixed(2));
              _getIntoMoney();
            },
            child: WidgetContainerImage(
              image: ICONS.IC_PLUS_PNG,
              width: 24,
              height: 24,
              fit: BoxFit.contain,
              borderRadius: BorderRadius.circular(0),
              colorImage: COLORS.GRAY_IMAGE,
            ),
          ),
          widget.canDelete == false
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
