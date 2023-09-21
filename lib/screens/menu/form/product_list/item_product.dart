import 'package:flutter/material.dart';
import 'package:gen_crm/screens/menu/form/product_list/function_product/click_so_luong.dart';
import 'package:gen_crm/screens/menu/form/product_list/function_product/click_vat.dart';
import 'package:gen_crm/src/models/model_generator/product_response.dart';
import 'package:gen_crm/widgets/widgets.dart';
import '../../../../models/product_model.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:get/get.dart';
import '../../../../src/src_index.dart';
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
    this.onChangeQuantity,
    this.onDVT,
    this.onVAT,
    this.onGiamGia,
    this.onPrice,
    this.model,
    this.canDelete = false,
    this.onDelete,
    this.onIntoMoney,
    required this.onReload,
  }) : super(key: key);

  final ProductItem data;
  final List<List<dynamic>> listDvt;
  final List<List<dynamic>> listVat;
  final Function? onChangeQuantity;
  final Function? onDVT;
  final Function? onVAT;
  final Function? onGiamGia;
  final Function? onPrice;
  final Function(double)? onIntoMoney;
  final Function() onReload;
  final ProductModel? model;
  final bool neverHidden;
  final bool canDelete;
  final Function(ProductModel productModel)? onDelete;

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

  @override
  void initState() {
    int index =
        widget.listDvt.indexWhere((element) => element[0] == widget.data.dvt);
    int indexVat =
        widget.listVat.indexWhere((element) => element[0] == widget.data.vat);
    price = widget.data.sell_price ?? "";
    if (widget.model != null && widget.model!.soLuong != 0) {
      setState(() {
        dvt = widget.model!.nameDvt;
        vat = widget.model!.nameVat;
        giamGia = widget.model!.giamGia;
        isTypeGiamGIa = widget.model!.typeGiamGia == "%" ? false : true;
        soLuong = widget.model!.soLuong.toString();
        price = widget.model!.item.sell_price!;
      });
      widget.onDVT!(widget.model!.item.dvt, dvt);
      widget.onVAT!(widget.model!.item.vat, vat);
    } else {
      setState(() {
        dvt = index != -1 ? widget.listDvt[index][1] : "";
        vat = indexVat != -1 ? widget.listVat[indexVat][1] : "0";
        soLuong = '0';
      });
      widget.onDVT!(widget.data.dvt, dvt);
      widget.onVAT!(widget.data.vat, vat);
    }
    _getIntoMoney();
    super.initState();
  }

  @override
  void didUpdateWidget(covariant ItemProduct oldWidget) {
    final typeWidget = (widget.model!.typeGiamGia == "%" ? false : true);
    if (oldWidget != widget) {
      soLuong = (widget.model?.soLuong ?? 0).toString();
      price = widget.model?.item.sell_price ?? '';
      dvt = widget.model!.nameDvt;
      vat = widget.model!.nameVat;
      giamGia = widget.model!.giamGia;
      if (typeGiamGiaDefault != typeWidget) {
        typeGiamGiaDefault = typeWidget;
        isTypeGiamGIa = typeWidget;
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
    widget.onIntoMoney!(money);
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
      widget.onPrice!(price);
      widget.onIntoMoney!(intoMoney);
    } else {
      intoMoney = 0;
      widget.onIntoMoney!(0);
    }
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
          border: Border(bottom: BorderSide(width: 1, color: COLORS.GREY_400))),
      margin: EdgeInsets.only(
        top: 8,
      ),
      padding: EdgeInsets.only(bottom: 16),
      child: Row(
        children: [
          widget.canDelete == false
              ? WidgetContainerImage(
                  image: ICONS.IC_CART_PNG,
                  width: 25,
                  height: 25,
                  fit: BoxFit.contain,
                  borderRadius: BorderRadius.circular(0),
                  colorImage: COLORS.BLUE,
                )
              : GestureDetector(
                  onTap: () {
                    widget.onDelete!(widget.model!);
                  },
                  child: Icon(Icons.delete),
                ),
          SizedBox(
            width: 8,
          ),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                WidgetText(
                  title: widget.data.product_name ?? '',
                  style:
                      AppStyle.DEFAULT_14_BOLD.copyWith(color: COLORS.ORANGE),
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
                        borderRadius: BorderRadius.all(Radius.circular(4))),
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
                  title:
                      "${AppLocalizations.of(Get.context!)?.code_product}: " +
                          "${widget.data.product_code ?? ''}",
                  style: AppStyle.DEFAULT_14_BOLD
                      .copyWith(color: COLORS.TEXT_GREY),
                ),
                SizedBox(
                  height: 3,
                ),
                GestureDetector(
                  onTap: () {
                    _priceController.text = widget.data.sell_price != '' &&
                            widget.data.sell_price != null
                        ? double.parse(widget.data.sell_price ?? '0')
                            .toInt()
                            .toString()
                        : '';
                    onClickPrice(context, _priceController, (v) {
                      if (v != '') {
                        price = v;
                        widget.onPrice!(price);
                        _getIntoMoney();
                      } else {
                        _priceController.text = price;
                      }
                      Get.back();
                    });
                  },
                  child: Container(
                      decoration: BoxDecoration(
                          border: Border.all(width: 1, color: COLORS.TEXT_GREY),
                          borderRadius: BorderRadius.circular(7)),
                      padding: EdgeInsets.symmetric(horizontal: 10),
                      child: WidgetText(
                        title: "${AppLocalizations.of(Get.context!)?.price}: " +
                            "${AppValue.format_money(price)}",
                        style: AppStyle.DEFAULT_14_BOLD
                            .copyWith(color: COLORS.TEXT_GREY),
                      )),
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(
                      height: 5,
                    ),
                    Row(
                      children: [
                        GestureDetector(
                          onTap: () {
                            onClickDVT(context, widget.listDvt, (v) {
                              dvt = v[1];
                              widget.onDVT!(v[0], v[1]);
                              setState(() {});
                              Get.back();
                            });
                          },
                          child: Container(
                            decoration: BoxDecoration(
                                border:
                                    Border.all(width: 1, color: COLORS.BLUE),
                                borderRadius: BorderRadius.circular(7)),
                            padding: EdgeInsets.symmetric(horizontal: 10),
                            child: WidgetText(
                              title:
                                  "${AppLocalizations.of(Get.context!)?.dvt}: " +
                                      "${dvt}",
                              style: AppStyle.DEFAULT_14
                                  .copyWith(color: COLORS.BLUE),
                              maxLine: 4,
                            ),
                          ),
                        ),
                        SizedBox(
                          width: 5,
                        ),
                        GestureDetector(
                          onTap: () {
                            onClickVAT(context, widget.listVat, (v) {
                              vat = v[1];
                              widget.onVAT!(v[0], v[1]);
                              _getIntoMoney();
                              Get.back();
                            });
                          },
                          child: Container(
                            constraints: BoxConstraints(
                                maxWidth: AppValue.widths * 0.28),
                            decoration: BoxDecoration(
                                border:
                                    Border.all(width: 1, color: COLORS.BLUE),
                                borderRadius: BorderRadius.circular(7)),
                            padding: EdgeInsets.symmetric(horizontal: 10),
                            child: WidgetText(
                              title:
                                  "${AppLocalizations.of(Get.context!)?.vat}: " +
                                      "${vat == '' ? '0' : vat}",
                              style: AppStyle.DEFAULT_14
                                  .copyWith(color: COLORS.BLUE),
                              maxLine: 4,
                            ),
                          ),
                        )
                      ],
                    ),
                    SizedBox(
                      height: 5,
                    ),
                    GestureDetector(
                      onTap: () {
                        if (double.parse(widget.model?.giamGia ?? '0') > 0) {
                          _giamGiaController.text = widget.model?.giamGia ?? '';
                        } else {
                          _giamGiaController.text = '';
                        }
                        onClickGiamGia(
                            context, isTypeGiamGIa, _giamGiaController,
                            (isGiam, txt) {
                          _onClickGiamGia(isGiam, txt);
                        });
                      },
                      child: Container(
                        decoration: BoxDecoration(
                            border: Border.all(width: 1, color: COLORS.BLUE),
                            borderRadius: BorderRadius.circular(7)),
                        padding: EdgeInsets.symmetric(horizontal: 10),
                        child: WidgetText(
                          title:
                              "${AppLocalizations.of(Get.context!)?.sale}: " +
                                  (isTypeGiamGIa
                                      ? AppValue.format_money(giamGia)
                                      : giamGia.trim()) +
                                  "${isTypeGiamGIa ? '' : '%'}",
                          style:
                              AppStyle.DEFAULT_14.copyWith(color: COLORS.BLUE),
                        ),
                      ),
                    ),
                    SizedBox(
                      height: 5,
                    ),
                    GestureDetector(
                      onTap: () {
                        if (intoMoney > 0) {
                          _intoMoneyController.text =
                              intoMoney.toStringAsFixed(0);
                        } else {
                          _intoMoneyController.text = '';
                        }
                        onClickIntoMoney(context, _intoMoneyController, (v) {
                          if (double.parse(v) >= 0) {
                            intoMoney = (double.parse(v));
                            _getNewPrice();
                            // widget.onPay!(intoMoney.value);
                          } else {
                            _intoMoneyController.text =
                                intoMoney.toStringAsFixed(0);
                          }
                          widget.onReload();
                          Get.back();
                        });
                      },
                      child: Container(
                        decoration: BoxDecoration(
                            border: Border.all(width: 1, color: COLORS.BLUE),
                            borderRadius: BorderRadius.circular(7)),
                        padding: EdgeInsets.symmetric(horizontal: 10),
                        child: WidgetText(
                          title: "${AppLocalizations.of(Get.context!)?.into_money}: " +
                              "${AppValue.format_money(intoMoney.toStringAsFixed(0))}",
                          style:
                              AppStyle.DEFAULT_14.copyWith(color: COLORS.BLUE),
                        ),
                      ),
                    ),
                  ],
                )
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
        title: AppLocalizations.of(Get.context!)?.notification,
        content: AppLocalizations.of(Get.context!)
                ?.you_cannot_enter_a_discount_greater_than_the_price_of_the_product ??
            '',
        onTap1: () {
          Get.back();
        },
      );
    } else if (!isTypeGiamGIa && (double.parse(txt) > 100)) {
      ShowDialogCustom.showDialogBase(
        title: AppLocalizations.of(Get.context!)?.notification,
        content:
            AppLocalizations.of(Get.context!)?.you_cannot_enter_more_than_100,
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

      widget.onGiamGia!(
        txt,
        isTypeGiamGIa ? "đ" : "%",
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
              if (double.parse(soLuong) >= 1) {
                soLuong = (double.parse(soLuong) - 1).toString();
              } else {
                soLuong = '0';
              }
              widget
                  .onChangeQuantity!(double.parse(soLuong).toStringAsFixed(2));
              _getIntoMoney();
            },
            child: WidgetContainerImage(
              image: ICONS.IC_MINUS_PNG,
              width: 20,
              height: 20,
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
                    number = double.parse(text.replaceAll(",", "."));
                  }
                  //khong phai kieu double
                }

                if (number > 0) {
                  soLuong = number.toString();
                  widget.onChangeQuantity!(
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
                style: AppStyle.DEFAULT_16_BOLD.copyWith(color: COLORS.BLUE),
              ),
            ),
          ),
          GestureDetector(
            onTap: () {
              soLuong = (double.parse(soLuong) + 1).toString();
              widget
                  .onChangeQuantity!(double.parse(soLuong).toStringAsFixed(2));
              _getIntoMoney();
            },
            child: WidgetContainerImage(
              image: ICONS.IC_PLUS_PNG,
              width: 20,
              height: 20,
              fit: BoxFit.contain,
              borderRadius: BorderRadius.circular(0),
              colorImage: COLORS.GRAY_IMAGE,
            ),
          )
        ],
      );
}
