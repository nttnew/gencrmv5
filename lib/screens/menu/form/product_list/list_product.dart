import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';
import 'package:gen_crm/bloc/product/product_bloc.dart';
import 'package:gen_crm/src/models/model_generator/product_response.dart';
import 'package:gen_crm/widgets/btn_thao_tac.dart';
import '../../../../l10n/key_text.dart';
import '../../../../models/product_model.dart';
import 'package:get/get.dart';
import '../../../../src/app_const.dart';
import '../../../../src/src_index.dart';
import '../../../../widgets/appbar_base.dart';
import '../../../../widgets/search_base.dart';
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
      appBar: AppbarBaseNormal(getT(KeyT.select_product)),
      body: BlocBuilder<ProductBloc, ProductState>(
          bloc: _bloc,
          builder: (context, state) {
            if (state is LoadingGetListProductState) {
              listUI = [];
              return SizedBox.shrink();
            } else if (state is SuccessGetListProductState) {
              _handleDataSelect(state);
              return Column(
                children: [
                  Container(
                    padding: EdgeInsets.only(
                      top: 16,
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
                      hint: getT(KeyT.find_product),
                      onChange: (v) {
                        _onClickSearch();
                      },
                      leadIcon: SvgPicture.asset(ICONS.IC_SEARCH_SVG),
                    ),
                  ),
                  Expanded(
                    child: SingleChildScrollView(
                      padding: const EdgeInsets.only(
                        top: 8,
                        bottom: 16,
                        right: 16,
                        left: 16,
                      ),
                      controller: _scrollController,
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
                            onDelete: (ProductModel productModel) {},
                          );
                        }),
                      ),
                    ),
                  ),
                  Container(
                    width: double.infinity,
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
                    child: ButtonThaoTac(
                      marginHorizontal: 30,
                      title: getT(KeyT.select),
                      onTap: () {
                        _onClickSelect();
                      },
                    ),
                  ),
                ],
              );
            } else
              return noData();
          }),
    );
  }

  void _onClickSelect() {
    for (int i = 0; i < listUI.length; i++) {
      if (listUI[i].soLuong > 0) {
        addProduct(listUI[i]);
      }
    }
    reload();
    Get.back();
  }

  void _onClickSearch() {
    _bloc.add(
        InitGetListProductEvent('1', _editingController.text, group: group));
  }
}
