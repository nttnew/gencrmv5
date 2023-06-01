import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gen_crm/bloc/product/product_bloc.dart';
import 'package:gen_crm/src/models/model_generator/product_response.dart';
import 'package:gen_crm/widgets/widgets.dart';
import 'package:rxdart/rxdart.dart';
import '../../../../models/product_model.dart';
import '../../../../src/app_const.dart';
import '../../../../src/src_index.dart';
import 'package:get/get.dart';
import '../../../../widgets/appbar_base.dart';

class ListProduct extends StatefulWidget {
  ListProduct({Key? key}) : super(key: key);

  @override
  State<ListProduct> createState() => _ListProductState();
}

class _ListProductState extends State<ListProduct> {
  ScrollController _scrollController = ScrollController();
  int page = 1;
  int total = 0;
  int length = 0;
  TextEditingController _editingController = TextEditingController();
  Function addProduct = Get.arguments[0];
  Function reload = Get.arguments[1];
  List<ProductModel> listSelected = List.from(Get.arguments[2]);

  @override
  void initState() {
    ProductBloc.of(context).add(InitGetListProductEvent("1", ""));
    _scrollController.addListener(() {
      if (_scrollController.offset ==
              _scrollController.position.maxScrollExtent &&
          length < total) {
        ProductBloc.of(context).add(InitGetListProductEvent(
            (page + 1).toString(), _editingController.text));
        page = page + 1;
      } else {}
    });
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppbarBaseNormal('Chọn sản phẩm'),
      body: BlocBuilder<ProductBloc, ProductState>(builder: (context, state) {
        if (state is LoadingGetListProductState) {
          listSelected = [];
          return Container();
        } else if (state is SuccessGetListProductState) {
          total = state.total;
          length = state.listProduct.length;
          for (int i = 0; i < state.listProduct.length; i++) {
            int indexS = listSelected.indexWhere(
                (element) => element.id == state.listProduct[i].product_id!);
            if (indexS == -1)
              listSelected.add(ProductModel(
                  state.listProduct[i].product_id!,
                  0,
                  ProductItem(
                      state.listProduct[i].product_id,
                      state.listProduct[i].product_code,
                      state.listProduct[i].product_edit,
                      state.listProduct[i].product_name,
                      state.listProduct[i].dvt,
                      state.listProduct[i].vat,
                      state.listProduct[i].sell_price),
                  "0",
                  "",
                  "",
                  ""));
          }
          return Container(
            margin: EdgeInsets.only(top: 8, bottom: 8),
            height: Get.height,
            color: Colors.white,
            child: Column(
              children: [
                Container(
                  margin: EdgeInsets.symmetric(horizontal: 16),
                  child: Row(
                    children: [
                      Expanded(
                          child: Container(
                        decoration: BoxDecoration(
                            border:
                                Border.all(width: 1, color: COLORS.GREY_400),
                            borderRadius: BorderRadius.circular(10)),
                        padding: EdgeInsets.symmetric(horizontal: 8),
                        margin: EdgeInsets.only(right: 8),
                        child: TextField(
                          controller: _editingController,
                          decoration: InputDecoration(
                            hintText: "Tìm sản phẩm",
                            border: InputBorder.none,
                            disabledBorder: InputBorder.none,
                            enabledBorder: InputBorder.none,
                            errorBorder: InputBorder.none,
                            focusedBorder: InputBorder.none,
                          ),
                        ),
                      )),
                      GestureDetector(
                        onTap: this.onClickSearch,
                        child: Container(
                          padding:
                              EdgeInsets.symmetric(vertical: 8, horizontal: 16),
                          decoration: BoxDecoration(
                              color: COLORS.PRIMARY_COLOR,
                              borderRadius: BorderRadius.circular(20)),
                          child: WidgetText(
                            title: "Tìm",
                            style: AppStyle.DEFAULT_16,
                            textAlign: TextAlign.center,
                          ),
                        ),
                      )
                    ],
                  ),
                ),
                Expanded(
                  child: SingleChildScrollView(
                    controller: _scrollController,
                    child: Column(
                      children: List.generate(listSelected.length, (index) {
                        return ItemProduct(
                          neverHidden: false,
                          data: listSelected[index].item,
                          listDvt: state.listDvt,
                          listVat: state.listVat,
                          onPlus: (soLuong) {
                            listSelected[index].soLuong = soLuong;
                          },
                          onMinus: (soLuong) {
                            listSelected[index].soLuong = soLuong;
                          },
                          onDVT: (id, name) {
                            listSelected[index].nameDvt = name;
                            listSelected[index].item.dvt = id;
                          },
                          onVAT: (id, name) {
                            listSelected[index].nameVat = name;
                            listSelected[index].item.vat = id;
                            // }
                          },
                          onGiamGia: (so, type) {
                            listSelected[index].giamGia = so;
                            listSelected[index].typeGiamGia = type;
                          },
                          onPrice: (price) {
                            listSelected[index].item.sell_price = price;
                          },
                          model: listSelected[index],
                          onReload: () {
                            reload();
                          },
                        );
                      }),
                    ),
                  ),
                ),
                Container(
                  padding: EdgeInsets.only(top: 8, bottom: 8),
                  child: GestureDetector(
                    onTap: this.onClickChon,
                    child: Container(
                      padding: EdgeInsets.symmetric(vertical: 8),
                      width: Get.width * 0.5,
                      decoration: BoxDecoration(
                          color: COLORS.PRIMARY_COLOR,
                          borderRadius: BorderRadius.circular(20)),
                      child: WidgetText(
                        title: "Chọn",
                        style: AppStyle.DEFAULT_16,
                        textAlign: TextAlign.center,
                      ),
                    ),
                  ),
                )
              ],
            ),
          );
        } else
          return noData();
      }),
    );
  }

  void onClickChon() {
    for (int i = 0; i < listSelected.length; i++) {
      if (listSelected[i].soLuong > 0) {
        addProduct(listSelected[i]);
      }
    }
    reload();
    Get.back();
  }

  void onClickSearch() {
    ProductBloc.of(context)
        .add(InitGetListProductEvent("1", _editingController.text));
  }
}

class ItemProduct extends StatefulWidget {
  ItemProduct({
    Key? key,
    required this.data,
    required this.listDvt,
    required this.listVat,
    required this.neverHidden,
    this.onPlus,
    this.onMinus,
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
  Function? onPlus;
  Function? onMinus;
  Function? onDVT;
  Function? onVAT;
  Function? onGiamGia;
  Function? onPrice;
  Function() onReload;
  ProductModel? model;
  bool neverHidden;
  bool canDelete;
  Function(ProductModel productModel)? onDelete;

  @override
  State<ItemProduct> createState() => _ItemProductState();
}

class _ItemProductState extends State<ItemProduct> {
  String price = "";
  late final BehaviorSubject<String> soLuong;
  String Dvt = "";
  String Vat = "";
  String giamGia = "0";
  TextEditingController _editingController = TextEditingController();
  TextEditingController _priceTextfieldController = TextEditingController();

  bool typeGiamGia = true;

  @override
  void didUpdateWidget(covariant ItemProduct oldWidget) {
    if (oldWidget != widget) {
      setState(() {
        Dvt = widget.model?.nameDvt ?? '';
        Vat = widget.model?.nameVat ?? '';
        giamGia = widget.model?.giamGia ?? '';
        typeGiamGia = widget.model?.typeGiamGia == "%" ? false : true;
        soLuong.add((widget.model?.soLuong ?? 0).toString());
        price = widget.model?.item.sell_price ?? '';
      });
    }
    super.didUpdateWidget(oldWidget);
  }

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
        Dvt = widget.model!.nameDvt;
        Vat = widget.model!.nameVat;
        giamGia = widget.model!.giamGia;
        typeGiamGia = widget.model!.typeGiamGia == "%" ? false : true;
        soLuong.add(widget.model!.soLuong.toString());
        price = widget.model!.item.sell_price!;
      });
      widget.onDVT!(widget.model!.item.dvt, Dvt);
      widget.onVAT!(widget.model!.item.vat, Vat);
    } else {
      setState(() {
        Dvt = index != -1 ? widget.listDvt[index][1] : "";
        Vat = indexVat != -1 ? widget.listVat[indexVat][1] : "0";
        soLuong.add("0");
      });
      widget.onDVT!(widget.data.dvt, Dvt);
      widget.onVAT!(widget.data.vat, Vat);
    }
    _priceTextfieldController.text =
        widget.data.sell_price != '' && widget.data.sell_price != null
            ? double.parse(widget.data.sell_price ?? '0').toInt().toString()
            : '';
    soLuong.listen((value) {
      widget.onReload();
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
          border: Border(bottom: BorderSide(width: 1, color: COLORS.GREY_400))),
      margin: EdgeInsets.only(top: 8, left: 16, right: 16),
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
                  style: AppStyle.DEFAULT_14_BOLD
                      .copyWith(color: COLORS.TEXT_GREY),
                ),
                SizedBox(
                  height: 3,
                ),
                WidgetText(
                  title: "Mã sản phẩm: " + "${widget.data.product_code ?? ''}",
                  style: AppStyle.DEFAULT_14_BOLD
                      .copyWith(color: COLORS.TEXT_GREY),
                ),
                SizedBox(
                  height: 3,
                ),
                GestureDetector(
                  onTap: this.onClickPrice,
                  child: Container(
                    decoration: BoxDecoration(
                        border: Border.all(width: 1, color: COLORS.TEXT_GREY),
                        borderRadius: BorderRadius.circular(7)),
                    padding: EdgeInsets.symmetric(horizontal: 10),
                    child: WidgetText(
                      title: "Giá: " + "${AppValue.format_money(price)}",
                      style: AppStyle.DEFAULT_14_BOLD
                          .copyWith(color: COLORS.TEXT_GREY),
                    ),
                  ),
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
                                          width: 1, color: COLORS.ORANGE_IMAGE),
                                      borderRadius: BorderRadius.circular(7)),
                                  padding: EdgeInsets.symmetric(horizontal: 10),
                                  child: WidgetText(
                                    title: "ĐVT: " + "${Dvt}",
                                    style: AppStyle.DEFAULT_14
                                        .copyWith(color: COLORS.ORANGE_IMAGE),
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
                                  //width: AppValue.widths * 0.3,
                                  constraints: BoxConstraints(
                                      maxWidth: AppValue.widths * 0.28),
                                  decoration: BoxDecoration(
                                      border: Border.all(
                                          width: 1, color: COLORS.ORANGE_IMAGE),
                                      borderRadius: BorderRadius.circular(7)),
                                  padding: EdgeInsets.symmetric(horizontal: 10),
                                  child: WidgetText(
                                    title: "VAT: " + "${Vat}",
                                    style: AppStyle.DEFAULT_14
                                        .copyWith(color: COLORS.ORANGE_IMAGE),
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
                            onTap: this.onClickGiamGia,
                            child: Container(
                              decoration: BoxDecoration(
                                  border:
                                      Border.all(width: 1, color: COLORS.BLUE),
                                  borderRadius: BorderRadius.circular(7)),
                              padding: EdgeInsets.symmetric(horizontal: 10),
                              child: WidgetText(
                                title: "Giảm giá: " +
                                    giamGia +
                                    "${typeGiamGia == true ? 'vnd' : '%'}",
                                style: AppStyle.DEFAULT_14
                                    .copyWith(color: COLORS.BLUE),
                              ),
                            ),
                          ),
                        ],
                      )
                    : Container()
              ],
            ),
          ),
          Row(
            children: [
              GestureDetector(
                onTap: () {
                  if (int.parse(soLuong.value) > 0) {
                    setState(() {
                      soLuong.add((int.parse(soLuong.value) - 1).toString());
                    });
                  } else {
                    setState(() {
                      soLuong.add("0");
                    });
                  }
                  widget.onMinus!(int.parse(soLuong.value));
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
              SizedBox(
                width: 5,
              ),
              WidgetText(
                title: soLuong.value,
                style: AppStyle.DEFAULT_14,
              ),
              SizedBox(
                width: 5,
              ),
              GestureDetector(
                onTap: () {
                  setState(() {
                    soLuong.add((int.parse(soLuong.value) + 1).toString());
                  });
                  widget.onPlus!(int.parse(soLuong.value));
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
                    title: "Chọn",
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
                                Dvt = widget.listDvt[index][1];
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
                    title: "Chọn",
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
                              setState(() {
                                Vat = widget.listVat[index][1];
                              });
                              widget.onVAT!(widget.listVat[index][0],
                                  widget.listVat[index][1]);
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
                        title: "Nhập giảm giá",
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
                            controller: _editingController,
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
                            setState1(() {
                              typeGiamGia = !typeGiamGia;
                            });
                          },
                          child: Container(
                            padding: EdgeInsets.symmetric(
                                horizontal: 5, vertical: 3),
                            decoration: BoxDecoration(
                                border:
                                    Border.all(width: 1, color: COLORS.ORANGE),
                                borderRadius: BorderRadius.circular(10)),
                            width: 45,
                            child: WidgetText(
                              textAlign: TextAlign.center,
                              title: typeGiamGia == true ? "VNĐ" : "%",
                              style: AppStyle.DEFAULT_14,
                            ),
                          ),
                        ),
                        SizedBox(
                          width: 8,
                        ),
                        GestureDetector(
                          onTap: () {
                            if (typeGiamGia == true &&
                                (double.parse(_editingController.text) >
                                    double.parse(widget.data.sell_price!))) {
                              _editingController.text = widget.data.sell_price!;
                              ShowDialogCustom.showDialogBase(
                                title: MESSAGES.NOTIFICATION,
                                content:
                                    "Bạn không được nhập giá giảm lớn hơn giá của sản phẩm",
                                onTap1: () {
                                  Get.back();
                                },
                              );
                            } else if (typeGiamGia == false &&
                                (double.parse(_editingController.text) > 100)) {
                              ShowDialogCustom.showDialogBase(
                                title: MESSAGES.NOTIFICATION,
                                content: "Bạn không được nhập quá 100%",
                                onTap1: () {
                                  Get.back();
                                },
                              );
                            } else {
                              setState(() {
                                giamGia = typeGiamGia == true
                                    ? AppValue.APP_MONEY_FORMAT.format(
                                        double.parse(_editingController.text))
                                    : _editingController.text;
                              });
                              widget.onGiamGia!(_editingController.text,
                                  typeGiamGia == true ? "vnd" : "%");
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
                              title: "Nhập",
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
                        title: "Nhập giá",
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
                            controller: _priceTextfieldController,
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
                            if (_priceTextfieldController.text != '') {
                              setState(() {
                                price = _priceTextfieldController.text;
                              });
                              widget.onPrice!(price);
                            } else {
                              _priceTextfieldController.text = price;
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
                              title: "Nhập",
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
