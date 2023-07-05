import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gen_crm/bloc/product/product_bloc.dart';
import 'package:gen_crm/src/models/model_generator/product_response.dart';
import 'package:gen_crm/widgets/widgets.dart';
import '../../../../../models/product_model.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:get/get.dart';
import '../../../../../src/app_const.dart';
import '../../../../../src/src_index.dart';
import '../../../../../widgets/appbar_base.dart';
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

  @override
  void initState() {
    ProductBloc.of(context)
        .add(InitGetListProductEvent(BASE_URL.PAGE_DEFAULT.toString(), ""));
    _scrollController.addListener(() {
      if (_scrollController.offset ==
              _scrollController.position.maxScrollExtent &&
          length < total) {
        ProductBloc.of(context).add(InitGetListProductEvent(
            (page + 1).toString(), _editingController.text));
        page = page + 1;
      }
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
      appBar: AppbarBaseNormal(
          AppLocalizations.of(Get.context!)?.select_product ?? ''),
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
                            border:
                                Border.all(width: 1, color: COLORS.GREY_400),
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
                          padding:
                              EdgeInsets.symmetric(vertical: 8, horizontal: 16),
                          decoration: BoxDecoration(
                              color: COLORS.PRIMARY_COLOR,
                              borderRadius: BorderRadius.circular(20)),
                          child: WidgetText(
                            title:
                                AppLocalizations.of(Get.context!)?.find ?? '',
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
                        title: AppLocalizations.of(Get.context!)?.select ?? '',
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
