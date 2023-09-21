import 'package:flutter/material.dart';
import 'package:gen_crm/src/models/model_generator/product_response.dart';
import 'package:gen_crm/widgets/widgets.dart';
import 'package:rxdart/rxdart.dart';
import '../../../../models/product_model.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:get/get.dart';
import '../../../../src/src_index.dart';

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
  bool typeGiamGia = true;
  bool typeGiamGiaDefault = true;
  BehaviorSubject<double> intoMoney = BehaviorSubject.seeded(0);
  late final BehaviorSubject<String> soLuong;
  String dvt = '';
  String vat = '';
  String giamGia = '0';
  TextEditingController _saleController = TextEditingController();
  TextEditingController _priceController = TextEditingController();
  TextEditingController _quantityController = TextEditingController();
  TextEditingController _intoMoneyController = TextEditingController();

  @override
  void initState() {
    soLuong = BehaviorSubject.seeded("0");
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
        typeGiamGia = widget.model!.typeGiamGia == "%" ? false : true;
        soLuong.add(widget.model!.soLuong.toString());
        price = widget.model!.item.sell_price!;
      });
      widget.onDVT!(widget.model!.item.dvt, dvt);
      widget.onVAT!(widget.model!.item.vat, vat);
    } else {
      setState(() {
        dvt = index != -1 ? widget.listDvt[index][1] : "";
        vat = indexVat != -1 ? widget.listVat[indexVat][1] : "0";
        soLuong.add("0");
      });
      widget.onDVT!(widget.data.dvt, dvt);
      widget.onVAT!(widget.data.vat, vat);
    }
    soLuong.listen((value) {
      _getIntoMoney();
      widget.onReload();
    });
    _getIntoMoney();
    super.initState();
  }

  @override
  void didUpdateWidget(covariant ItemProduct oldWidget) {
    final typeWidget = (widget.model!.typeGiamGia == "%" ? false : true);
    if (oldWidget != widget) {
      soLuong.add((widget.model?.soLuong ?? 0).toString());
      price = widget.model?.item.sell_price ?? '';
      dvt = widget.model!.nameDvt;
      vat = widget.model!.nameVat;
      giamGia = widget.model!.giamGia;
      _getIntoMoney();
      if (typeGiamGiaDefault != typeWidget) {
        typeGiamGiaDefault = typeWidget;
        typeGiamGia = typeWidget;
      }
    }
    super.didUpdateWidget(oldWidget);
  }

  void _getIntoMoney({bool newPrice = false}) {
    double priceProduct = 0;
    double vatProduct = 0;
    double vatProductNumber = 0;
    double discount = 0;
    double discountNumber = 0;
    double countProduct = 0;
    try {
      if (double.parse(price) > 0) priceProduct = double.parse(price);

      if (double.parse(giamGia) > 0) discountNumber = double.parse(giamGia);

      if (!typeGiamGia) {
        discount = priceProduct * discountNumber / 100;
      } else {
        discount = discountNumber;
      }

      if (double.parse(vat.split('%').first) > 0) {
        vatProductNumber = double.parse(vat.split('%').first);
        vatProduct = vatProductNumber * (priceProduct - discount) / 100;
      }

      if (soLuong.value.isNotEmpty) countProduct = double.parse(soLuong.value);
    } catch (e) {}

    if (price != '' && !newPrice) {
      double money = 0;
      money = (priceProduct + vatProduct - discount) * countProduct;
      intoMoney.add(money);
    } else if (newPrice) {
      if (countProduct > 0) {
        double newPrice = 0;
        double oneProduct = intoMoney.value / countProduct;
        double discount = 0;
        double vat = 0;
        if (!typeGiamGia) {
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
        setState(() {});
      } else {
        intoMoney.add(0);
      }
    }
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
                    onClickPrice();
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
                soLuong != "0" || widget.neverHidden == true
                    ? new Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          SizedBox(
                            height: 5,
                          ),
                          Row(
                            children: [
                              GestureDetector(
                                onTap: this.onClickDvt,
                                child: Container(
                                  decoration: BoxDecoration(
                                      border: Border.all(
                                          width: 1, color: COLORS.BLUE),
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
                                onTap: this.onClickVat,
                                child: Container(
                                  constraints: BoxConstraints(
                                      maxWidth: AppValue.widths * 0.28),
                                  decoration: BoxDecoration(
                                      border: Border.all(
                                          width: 1, color: COLORS.BLUE),
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
                              if (double.parse(widget.model?.giamGia ?? '0') >
                                  0) {
                                _saleController.text =
                                    widget.model?.giamGia ?? '';
                              } else {
                                _saleController.text = '';
                              }
                              onClickGiamGia();
                            },
                            child: Container(
                              decoration: BoxDecoration(
                                  border:
                                      Border.all(width: 1, color: COLORS.BLUE),
                                  borderRadius: BorderRadius.circular(7)),
                              padding: EdgeInsets.symmetric(horizontal: 10),
                              child: WidgetText(
                                title:
                                    "${AppLocalizations.of(Get.context!)?.sale}: " +
                                        (typeGiamGia
                                            ? AppValue.format_money(giamGia)
                                            : giamGia.trim()) +
                                        "${typeGiamGia ? '' : '%'}",
                                style: AppStyle.DEFAULT_14
                                    .copyWith(color: COLORS.BLUE),
                              ),
                            ),
                          ),
                          SizedBox(
                            height: 5,
                          ),
                          StreamBuilder<double>(
                              stream: intoMoney,
                              builder: (context, snapshot) {
                                return GestureDetector(
                                  onTap: () {
                                    if (intoMoney.value > 0) {
                                      _intoMoneyController.text =
                                          intoMoney.value.toStringAsFixed(0);
                                    } else {
                                      _intoMoneyController.text = '';
                                    }
                                    onClickIntoMoney();
                                  },
                                  child: Container(
                                    decoration: BoxDecoration(
                                        border: Border.all(
                                            width: 1, color: COLORS.BLUE),
                                        borderRadius: BorderRadius.circular(7)),
                                    padding:
                                        EdgeInsets.symmetric(horizontal: 10),
                                    child: WidgetText(
                                      title: "${AppLocalizations.of(Get.context!)?.into_money}: " +
                                          "${AppValue.format_money(intoMoney.value.toString())}",
                                      style: AppStyle.DEFAULT_14
                                          .copyWith(color: COLORS.BLUE),
                                    ),
                                  ),
                                );
                              }),
                        ],
                      )
                    : Container()
              ],
            ),
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              GestureDetector(
                onTap: () {
                  if (double.parse(soLuong.value) >= 1) {
                    setState(() {
                      soLuong.add((double.parse(soLuong.value) - 1).toString());
                    });
                  } else {
                    setState(() {
                      soLuong.add("0");
                    });
                  }
                  widget.onChangeQuantity!(
                      double.parse(soLuong.value).toStringAsFixed(2));
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
                  if (double.parse(soLuong.value) == 0) {
                    _quantityController.text = '';
                  } else {
                    _quantityController.text =
                        double.parse(soLuong.value).toStringAsFixed(2);
                  }
                  onClickSoLuong();
                },
                child: Container(
                  padding: EdgeInsets.symmetric(vertical: 16),
                  child: WidgetText(
                    title: double.parse(soLuong.value).toStringAsFixed(2),
                    style:
                        AppStyle.DEFAULT_16_BOLD.copyWith(color: COLORS.BLUE),
                  ),
                ),
              ),
              GestureDetector(
                onTap: () {
                  setState(() {
                    soLuong.add((double.parse(soLuong.value) + 1).toString());
                  });
                  widget.onChangeQuantity!(
                      double.parse(soLuong.value).toStringAsFixed(2));
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
          )
        ],
      ),
    );
  }

  void onClickDvt() {
    showModalBottomSheet(
        enableDrag: false,
        isScrollControlled: true,
        context: context,
        constraints:
            BoxConstraints(maxHeight: Get.height * 0.55, minWidth: Get.width),
        builder: (BuildContext context) {
          return Container(
            padding: EdgeInsets.all(16),
            width: Get.width,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  width: Get.width,
                  child: WidgetText(
                    title: AppLocalizations.of(Get.context!)?.select,
                    style: AppStyle.DEFAULT_16_BOLD,
                    textAlign: TextAlign.center,
                  ),
                ),
                Expanded(
                    child: SingleChildScrollView(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: List.generate(
                        widget.listDvt.length,
                        (index) => GestureDetector(
                            onTap: () {
                              setState(() {
                                dvt = widget.listDvt[index][1];
                              });
                              widget.onDVT!(widget.listDvt[index][0],
                                  widget.listDvt[index][1]);
                              Get.back();
                            },
                            child: _item(widget.listDvt[index][1]))),
                  ),
                ))
              ],
            ),
          );
        });
  }

  Widget _item(String data) {
    return Container(
      padding: EdgeInsets.symmetric(vertical: 8),
      width: Get.width,
      decoration: BoxDecoration(
          border: Border(bottom: BorderSide(width: 1, color: COLORS.GREY_400))),
      child: WidgetText(
        title: data.toString(),
        style: AppStyle.DEFAULT_16.copyWith(color: COLORS.TEXT_BLUE_BOLD),
      ),
    );
  }

  void onClickVat() {
    showModalBottomSheet(
        enableDrag: false,
        isScrollControlled: true,
        context: context,
        constraints:
            BoxConstraints(maxHeight: Get.height * 0.55, minWidth: Get.width),
        builder: (BuildContext context) {
          return Container(
            padding: EdgeInsets.all(16),
            width: Get.width,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  width: Get.width,
                  child: WidgetText(
                    title: AppLocalizations.of(Get.context!)?.select ?? '',
                    style: AppStyle.DEFAULT_16_BOLD,
                    textAlign: TextAlign.center,
                  ),
                ),
                Expanded(
                    child: SingleChildScrollView(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: List.generate(
                        widget.listVat.length,
                        (index) => GestureDetector(
                            onTap: () {
                              vat = widget.listVat[index][1];
                              widget.onVAT!(widget.listVat[index][0],
                                  widget.listVat[index][1]);
                              _getIntoMoney();
                              setState(() {});
                              Get.back();
                            },
                            child: _item(widget.listVat[index][1]))),
                  ),
                ))
              ],
            ),
          );
        });
  }

  void onClickGiamGia() {
    showModalBottomSheet(
        enableDrag: false,
        isScrollControlled: true,
        context: context,
        builder: (BuildContext context) {
          return StatefulBuilder(
            builder: (context, setState1) {
              return Container(
                width: Get.width,
                padding: EdgeInsets.only(
                    bottom: MediaQuery.of(context).viewInsets.bottom + 16,
                    top: 16,
                    left: 16,
                    right: 16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Container(
                      width: Get.width,
                      child: WidgetText(
                        title:
                            AppLocalizations.of(Get.context!)?.enter_price_sale,
                        style: AppStyle.DEFAULT_16_BOLD,
                        textAlign: TextAlign.center,
                      ),
                    ),
                    SizedBox(
                      height: 16,
                    ),
                    Row(
                      children: [
                        Expanded(
                            child: Container(
                          decoration: BoxDecoration(
                              border:
                                  Border.all(width: 1, color: COLORS.GREY_400),
                              borderRadius: BorderRadius.circular(15)),
                          child: TextField(
                            controller: _saleController,
                            decoration: InputDecoration(
                                contentPadding:
                                    EdgeInsets.symmetric(horizontal: 10),
                                border: InputBorder.none,
                                disabledBorder: InputBorder.none,
                                focusedBorder: InputBorder.none,
                                errorBorder: InputBorder.none),
                            keyboardType:
                                TextInputType.numberWithOptions(decimal: true),
                          ),
                        )),
                        SizedBox(
                          width: 8,
                        ),
                        GestureDetector(
                          onTap: () {
                            typeGiamGia = !typeGiamGia;
                            setState1(() {});
                          },
                          child: Container(
                            padding: EdgeInsets.symmetric(
                                horizontal: 5, vertical: 3),
                            decoration: BoxDecoration(
                                border:
                                    Border.all(width: 1, color: COLORS.BLUE),
                                borderRadius: BorderRadius.circular(10)),
                            width: 45,
                            child: WidgetText(
                              textAlign: TextAlign.center,
                              title: typeGiamGia ? "đ" : "%",
                              style: AppStyle.DEFAULT_14,
                            ),
                          ),
                        ),
                        SizedBox(
                          width: 8,
                        ),
                        GestureDetector(
                          onTap: () {
                            if (typeGiamGia &&
                                (double.parse(_saleController.text) >
                                    double.parse(
                                        widget.data.sell_price ?? '0'))) {
                              ShowDialogCustom.showDialogBase(
                                title: AppLocalizations.of(Get.context!)
                                    ?.notification,
                                content: AppLocalizations.of(Get.context!)
                                        ?.you_cannot_enter_a_discount_greater_than_the_price_of_the_product ??
                                    '',
                                onTap1: () {
                                  Get.back();
                                },
                              );
                            } else if (!typeGiamGia &&
                                (double.parse(_saleController.text) > 100)) {
                              ShowDialogCustom.showDialogBase(
                                title: AppLocalizations.of(Get.context!)
                                    ?.notification,
                                content: AppLocalizations.of(Get.context!)
                                    ?.you_cannot_enter_more_than_100,
                                onTap1: () {
                                  Get.back();
                                },
                              );
                            } else {
                              if (double.parse(_saleController.text) == 0) {
                                giamGia = '0';
                                _saleController.text = giamGia;
                              } else {
                                giamGia = _saleController.text;
                              }

                              widget.onGiamGia!(
                                _saleController.text,
                                typeGiamGia ? "đ" : "%",
                              );
                              _getIntoMoney();
                              setState(() {});
                              Get.back();
                            }
                          },
                          child: Container(
                            decoration: BoxDecoration(
                                color: COLORS.PRIMARY_COLOR,
                                borderRadius: BorderRadius.circular(30)),
                            padding: EdgeInsets.symmetric(
                                horizontal: 16, vertical: 8),
                            child: WidgetText(
                              title: AppLocalizations.of(Get.context!)?.enter,
                              style: AppStyle.DEFAULT_16,
                            ),
                          ),
                        )
                      ],
                    )
                  ],
                ),
              );
            },
          );
        });
  }

  void onClickSoLuong() {
    showModalBottomSheet(
        enableDrag: false,
        isScrollControlled: true,
        context: context,
        builder: (BuildContext context) {
          return StatefulBuilder(
            builder: (context, setState1) {
              return Container(
                width: Get.width,
                padding: EdgeInsets.only(
                    bottom: MediaQuery.of(context).viewInsets.bottom + 16,
                    top: 16,
                    left: 16,
                    right: 16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Container(
                      width: Get.width,
                      child: WidgetText(
                        title: AppLocalizations.of(Get.context!)
                            ?.enter_the_quantity,
                        style: AppStyle.DEFAULT_16_BOLD,
                        textAlign: TextAlign.center,
                      ),
                    ),
                    SizedBox(
                      height: 16,
                    ),
                    Row(
                      children: [
                        Expanded(
                            child: Container(
                          decoration: BoxDecoration(
                              border:
                                  Border.all(width: 1, color: COLORS.GREY_400),
                              borderRadius: BorderRadius.circular(15)),
                          child: TextFormField(
                            controller: _quantityController,
                            decoration: InputDecoration(
                                contentPadding:
                                    EdgeInsets.symmetric(horizontal: 10),
                                border: InputBorder.none,
                                disabledBorder: InputBorder.none,
                                focusedBorder: InputBorder.none,
                                errorBorder: InputBorder.none),
                            keyboardType: TextInputType.numberWithOptions(
                                decimal: true, signed: false),
                          ),
                        )),
                        SizedBox(
                          width: 8,
                        ),
                        GestureDetector(
                          onTap: () {
                            String text = _quantityController
                                .text; // Đoạn văn bản cần kiểm tra
                            double number = 0;
                            try {
                              number = double.parse(text);
                            } catch (e) {
                              if (text.split(',').length <= 2) {
                                number =
                                    double.parse(text.replaceAll(",", "."));
                              }
                              //khong phai kieu double
                            }

                            if (number > 0) {
                              soLuong.add(number.toString());
                              widget.onChangeQuantity!(number
                                  .toStringAsFixed(2)); // change data quantity
                              setState(() {});
                              Get.back();
                            }
                          },
                          child: Container(
                            decoration: BoxDecoration(
                                color: COLORS.PRIMARY_COLOR,
                                borderRadius: BorderRadius.circular(30)),
                            padding: EdgeInsets.symmetric(
                                horizontal: 16, vertical: 8),
                            child: WidgetText(
                              title: AppLocalizations.of(Get.context!)?.enter,
                              style: AppStyle.DEFAULT_16,
                            ),
                          ),
                        )
                      ],
                    )
                  ],
                ),
              );
            },
          );
        });
  }

  void onClickPrice() {
    showModalBottomSheet(
        enableDrag: false,
        isScrollControlled: true,
        context: context,
        builder: (BuildContext context) {
          return StatefulBuilder(
            builder: (context, setState1) {
              return Container(
                width: Get.width,
                padding: EdgeInsets.only(
                    bottom: MediaQuery.of(context).viewInsets.bottom + 16,
                    top: 16,
                    left: 16,
                    right: 16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Container(
                      width: Get.width,
                      child: WidgetText(
                        title: AppLocalizations.of(Get.context!)?.enter_price,
                        style: AppStyle.DEFAULT_16_BOLD,
                        textAlign: TextAlign.center,
                      ),
                    ),
                    SizedBox(
                      height: 16,
                    ),
                    Row(
                      children: [
                        Expanded(
                            child: Container(
                          decoration: BoxDecoration(
                              border:
                                  Border.all(width: 1, color: COLORS.GREY_400),
                              borderRadius: BorderRadius.circular(15)),
                          child: TextField(
                            controller: _priceController,
                            decoration: InputDecoration(
                                contentPadding:
                                    EdgeInsets.symmetric(horizontal: 10),
                                border: InputBorder.none,
                                disabledBorder: InputBorder.none,
                                focusedBorder: InputBorder.none,
                                errorBorder: InputBorder.none),
                            keyboardType: TextInputType.numberWithOptions(),
                          ),
                        )),
                        SizedBox(
                          width: 8,
                        ),
                        GestureDetector(
                          onTap: () {
                            if (_priceController.text != '') {
                              price = _priceController.text;
                              widget.onPrice!(price);
                              _getIntoMoney();
                              setState(() {});
                            } else {
                              _priceController.text = price;
                            }
                            Get.back();
                          },
                          child: Container(
                            decoration: BoxDecoration(
                                color: COLORS.PRIMARY_COLOR,
                                borderRadius: BorderRadius.circular(30)),
                            padding: EdgeInsets.symmetric(
                                horizontal: 16, vertical: 8),
                            child: WidgetText(
                              title: AppLocalizations.of(Get.context!)?.enter,
                              style: AppStyle.DEFAULT_16,
                            ),
                          ),
                        )
                      ],
                    )
                  ],
                ),
              );
            },
          );
        });
  }

  void onClickIntoMoney() {
    showModalBottomSheet(
        enableDrag: false,
        isScrollControlled: true,
        context: context,
        builder: (BuildContext context) {
          return StatefulBuilder(
            builder: (context, setState1) {
              return Container(
                width: Get.width,
                padding: EdgeInsets.only(
                  bottom: MediaQuery.of(context).viewInsets.bottom + 16,
                  top: 16,
                  left: 16,
                  right: 16,
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Container(
                      width: Get.width,
                      child: WidgetText(
                        title: '${AppLocalizations.of(Get.context!)?.enter} ' +
                            '${AppLocalizations.of(Get.context!)?.into_money}'
                                .toLowerCase(),
                        style: AppStyle.DEFAULT_16_BOLD,
                        textAlign: TextAlign.center,
                      ),
                    ),
                    SizedBox(
                      height: 16,
                    ),
                    Row(
                      children: [
                        Expanded(
                            child: Container(
                          decoration: BoxDecoration(
                              border:
                                  Border.all(width: 1, color: COLORS.GREY_400),
                              borderRadius: BorderRadius.circular(15)),
                          child: TextField(
                            controller: _intoMoneyController,
                            decoration: InputDecoration(
                                contentPadding:
                                    EdgeInsets.symmetric(horizontal: 10),
                                border: InputBorder.none,
                                disabledBorder: InputBorder.none,
                                focusedBorder: InputBorder.none,
                                errorBorder: InputBorder.none),
                            keyboardType: TextInputType.numberWithOptions(),
                          ),
                        )),
                        SizedBox(
                          width: 8,
                        ),
                        GestureDetector(
                          onTap: () {
                            if (double.parse(_intoMoneyController.text) >= 0) {
                              intoMoney
                                  .add(double.parse(_intoMoneyController.text));
                              _getIntoMoney(newPrice: true);
                              // widget.onPay!(intoMoney.value);
                            } else {
                              _intoMoneyController.text =
                                  intoMoney.value.toString();
                            }
                            Get.back();
                          },
                          child: Container(
                            decoration: BoxDecoration(
                                color: COLORS.PRIMARY_COLOR,
                                borderRadius: BorderRadius.circular(30)),
                            padding: EdgeInsets.symmetric(
                                horizontal: 16, vertical: 8),
                            child: WidgetText(
                              title: AppLocalizations.of(Get.context!)?.enter,
                              style: AppStyle.DEFAULT_16,
                            ),
                          ),
                        )
                      ],
                    )
                  ],
                ),
              );
            },
          );
        });
  }
}
