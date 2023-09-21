import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gen_crm/bloc/product/product_bloc.dart';
import 'package:gen_crm/src/models/model_generator/product_response.dart';
import 'package:gen_crm/widgets/widgets.dart';
import '../../../../models/product_model.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:get/get.dart';
import '../../../../src/app_const.dart';
import '../../../../src/src_index.dart';
import '../../../../widgets/appbar_base.dart';
import 'item_product.dart';

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
  String? group = Get.arguments[3];
  late final ProductBloc _bloc;
  List<ProductModel> listUI = [];

  @override
  void initState() {
    _bloc = ProductBloc(userRepository: ProductBloc.of(context).userRepository);
    _bloc.add(InitGetListProductEvent(BASE_URL.PAGE_DEFAULT.toString(), "",
        group: group));
    _scrollController.addListener(() {
      if (_scrollController.offset ==
              _scrollController.position.maxScrollExtent &&
          length < total) {
        _bloc.add(InitGetListProductEvent(
            (page + 1).toString(), _editingController.text,
            group: group));
        page = page + 1;
      }
    });
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  _handleDataSelect(SuccessGetListProductState state) {
    total = state.total;
    length = state.listProduct.length;
    for (int i = 0; i < state.listProduct.length; i++) {
      listUI.add(ProductModel(
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
        "",
      ));
    }
    for (int i = 0; i < listUI.length; i++) {
      int indexS = listSelected.indexWhere(
        (element) =>
            element.id == listUI[i].id &&
            (element.item.combo_id == '' ||
                element.item.combo_id == null ||
                element.item.ten_combo == '' ||
                element.item.ten_combo == null),
      );
      if (indexS != -1) {
        listUI[i] = listSelected[indexS];
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppbarBaseNormal(
          AppLocalizations.of(Get.context!)?.select_product ?? ''),
      body: BlocBuilder<ProductBloc, ProductState>(
          bloc: _bloc,
          builder: (context, state) {
            if (state is LoadingGetListProductState) {
              listUI = [];
              return Container();
            } else if (state is SuccessGetListProductState) {
              _handleDataSelect(state);
              return Container(
                margin: EdgeInsets.only(top: 8, bottom: 8),
                height: Get.height,
                color: COLORS.WHITE,
                child: Column(
                  children: [
                    Container(
                      margin: EdgeInsets.symmetric(horizontal: 16),
                      child: Row(
                        children: [
                          Expanded(
                              child: Container(
                            decoration: BoxDecoration(
                                border: Border.all(
                                    width: 1, color: COLORS.GREY_400),
                                borderRadius: BorderRadius.circular(10)),
                            padding: EdgeInsets.symmetric(horizontal: 8),
                            margin: EdgeInsets.only(right: 8),
                            child: TextField(
                              controller: _editingController,
                              decoration: InputDecoration(
                                hintText: AppLocalizations.of(Get.context!)
                                        ?.find_product ??
                                    '',
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
                              padding: EdgeInsets.symmetric(
                                  vertical: 8, horizontal: 16),
                              decoration: BoxDecoration(
                                  color: COLORS.PRIMARY_COLOR,
                                  borderRadius: BorderRadius.circular(20)),
                              child: WidgetText(
                                title:
                                    AppLocalizations.of(Get.context!)?.find ??
                                        '',
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
                        child: Padding(
                          padding: const EdgeInsets.all(16),
                          child: Column(
                            children: List.generate(listUI.length, (index) {
                              return ItemProduct(
                                neverHidden: false,
                                data: listUI[index].item,
                                listDvt: state.listDvt,
                                listVat: state.listVat,
                                onChangeQuantity: (soLuong) {
                                  listUI[index].soLuong = double.parse(soLuong);
                                },
                                onDVT: (id, name) {
                                  listUI[index].nameDvt = name;
                                  listUI[index].item.dvt = id;
                                },
                                onVAT: (id, name) {
                                  listUI[index].nameVat = name;
                                  listUI[index].item.vat = id;
                                  // }
                                },
                                onGiamGia: (so, type) {
                                  listUI[index].giamGia = so;
                                  listUI[index].typeGiamGia = type;
                                },
                                onPrice: (price) {
                                  listUI[index].item.sell_price = price;
                                },
                                onIntoMoney: (intoMoney) {
                                  listUI[index].intoMoney = intoMoney;
                                },
                                model: listUI[index],
                                onReload: () {
                                  reload();
                                },
                              );
                            }),
                          ),
                        ),
                      ),
                    ),
                    Container(
                      padding: EdgeInsets.only(top: 8, bottom: 8),
                      child: GestureDetector(
                        onTap: this.onClickSelect,
                        child: Container(
                          padding: EdgeInsets.symmetric(vertical: 8),
                          width: Get.width * 0.5,
                          decoration: BoxDecoration(
                              color: COLORS.PRIMARY_COLOR,
                              borderRadius: BorderRadius.circular(20)),
                          child: WidgetText(
                            title:
                                AppLocalizations.of(Get.context!)?.select ?? '',
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

  void onClickSelect() {
    for (int i = 0; i < listUI.length; i++) {
      if (listUI[i].soLuong > 0) {
        addProduct(listUI[i]);
      }
    }
    reload();
    Get.back();
  }

  void onClickSearch() {
    _bloc.add(
        InitGetListProductEvent('1', _editingController.text, group: group));
  }
}
