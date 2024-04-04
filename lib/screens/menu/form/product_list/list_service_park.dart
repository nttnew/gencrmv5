import 'package:flutter/material.dart';
import 'package:gen_crm/bloc/product/product_bloc.dart';
import 'package:gen_crm/src/models/model_generator/product_response.dart';
import 'package:get/get.dart';
import '../../../../l10n/key_text.dart';
import '../../../../models/product_model.dart';
import '../../../../src/models/model_generator/product_service_pack_response.dart';
import '../../../../src/models/model_generator/service_pack_response.dart';
import '../../../../src/src_index.dart';
import '../../../../widgets/appbar_base.dart';
import '../../../../widgets/listview/list_load_infinity.dart';
import '../../../../widgets/widget_text.dart';

class ListServicePark extends StatefulWidget {
  const ListServicePark({Key? key}) : super(key: key);

  @override
  State<ListServicePark> createState() => _ListServiceParkState();
}

class _ListServiceParkState extends State<ListServicePark> {
  Function addProduct = Get.arguments[0];
  Function reload = Get.arguments[1];
  List<ProductModel> listSelect = Get.arguments[2];
  final String title = Get.arguments[3];
  late final ProductBloc _bloc;
  TextEditingController _searchController = TextEditingController();

  @override
  void initState() {
    _bloc = ProductBloc(userRepository: ProductBloc.of(context).userRepository);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppbarBaseNormal('${getT(KeyT.select)} ${title.toLowerCase()}'),
      body: Column(
        children: [
          AppValue.vSpaceSmall,
          Container(
            margin: EdgeInsets.symmetric(horizontal: 16),
            child: Row(
              children: [
                Expanded(
                    child: Container(
                  decoration: BoxDecoration(
                      border: Border.all(width: 1, color: COLORS.GREY_400),
                      borderRadius: BorderRadius.circular(10)),
                  padding: EdgeInsets.symmetric(horizontal: 8),
                  margin: EdgeInsets.only(right: 8),
                  child: TextField(
                    controller: _searchController,
                    decoration: InputDecoration(
                      hintText: '${getT(KeyT.search)} ${title.toLowerCase()}',
                      border: InputBorder.none,
                      disabledBorder: InputBorder.none,
                      enabledBorder: InputBorder.none,
                      errorBorder: InputBorder.none,
                      focusedBorder: InputBorder.none,
                    ),
                  ),
                )),
                GestureDetector(
                  onTap: () {
                    _bloc.loadMoreController.reloadData();
                    FocusManager.instance.primaryFocus?.unfocus();
                  },
                  child: Container(
                    padding: EdgeInsets.symmetric(vertical: 8, horizontal: 16),
                    decoration: BoxDecoration(
                        color: COLORS.PRIMARY_COLOR,
                        borderRadius: BorderRadius.circular(20)),
                    child: WidgetText(
                      title: getT(KeyT.find),
                      style: AppStyle.DEFAULT_16,
                      textAlign: TextAlign.center,
                    ),
                  ),
                )
              ],
            ),
          ),
          Expanded(
            child: ViewLoadMoreBase(
              isInit: true,
              functionInit: (page, isInit) {
                return _bloc.getServicePack(
                  txt: _searchController.text,
                  page: page,
                );
              },
              itemWidget: (int index, data) {
                final dataItem = data as DataServicePark;
                return Container(
                  margin: EdgeInsets.only(top: 8, left: 16, right: 16),
                  padding: EdgeInsets.only(bottom: 16),
                  decoration: BoxDecoration(
                      border: Border(
                          bottom:
                              BorderSide(width: 1, color: COLORS.GREY_400))),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Row(
                        children: [
                          WidgetContainerImage(
                            image: ICONS.IC_CART_PNG,
                            width: 25,
                            height: 25,
                            fit: BoxFit.contain,
                            borderRadius: BorderRadius.circular(0),
                            colorImage: COLORS.BLUE,
                          ),
                          SizedBox(
                            width: 16,
                          ),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              SizedBox(
                                height: 3,
                              ),
                              WidgetText(
                                title: "Tên gói dịch vụ: ${dataItem.tenCombo}",
                                style: AppStyle.DEFAULT_14_BOLD
                                    .copyWith(color: COLORS.TEXT_GREY),
                              ),
                              SizedBox(
                                height: 3,
                              ),
                              WidgetText(
                                title: "Số lượng sản phẩm: ${dataItem.countSp}",
                                style: AppStyle.DEFAULT_14_BOLD
                                    .copyWith(color: COLORS.TEXT_GREY),
                              ),
                              SizedBox(
                                height: 3,
                              ),
                              WidgetText(
                                title: "Thành tiền: ${dataItem.tongTienFormat}",
                                style: AppStyle.DEFAULT_14_BOLD
                                    .copyWith(color: COLORS.TEXT_GREY),
                              ),
                              SizedBox(
                                height: 3,
                              ),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  WidgetText(
                                    title: "Đang sử dụng",
                                    style: AppStyle.DEFAULT_14_BOLD
                                        .copyWith(color: COLORS.TEXT_GREY),
                                  ),
                                  SizedBox(
                                    width: 8,
                                  ),
                                  SizedBox(
                                    height: 16,
                                    width: 16,
                                    child: Center(
                                      child: Transform.scale(
                                          scale: 0.8,
                                          child: Checkbox(
                                              //1 là đang sử dụng
                                              value: dataItem.suDung == '1',
                                              onChanged: null)),
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ],
                      ),
                      Transform.scale(
                          scale: 1.2,
                          child: Checkbox(
                              value: (dataItem.isSelect ??
                                  false ||
                                      _bloc.listId.indexWhere(
                                              (e) => e == dataItem.id) !=
                                          -1),
                              onChanged: (v) {
                                dataItem.isSelect = v;
                                if (v ?? false) {
                                  _bloc.listId.add(dataItem.id ?? '');
                                } else {
                                  _bloc.listId.remove(dataItem.id ?? '');
                                }
                                setState(() {});
                              })),
                    ],
                  ),
                );
              },
              controller: _bloc.loadMoreController,
            ),
          ),
          Container(
            padding: EdgeInsets.only(top: 8, bottom: 8),
            child: GestureDetector(
              onTap: () async {
                if (_bloc.listId.isNotEmpty) {
                  final result = await _bloc.getProductServicePack(_bloc.listId
                      .toString()
                      .substring(1, _bloc.listId.toString().length - 1));
                  if (result['mess'] == '') {
                    if (result['list'] != []) {
                      List<DataProductServicePack> list = result['list'];
                      _handleData(list);
                      reload(true);
                      Get.back();
                    } else {
                      ShowDialogCustom.showDialogBase(
                        title: getT(KeyT.notification),
                        content: 'Bạn chưa chọn $title',
                      );
                    }
                  } else {
                    ShowDialogCustom.showDialogBase(
                      title: getT(KeyT.notification),
                      content: result['mess'],
                    );
                  }
                } else {
                  ShowDialogCustom.showDialogBase(
                    title: getT(KeyT.notification),
                    content: 'Bạn chưa chọn $title',
                  );
                }
              },
              child: Container(
                padding: EdgeInsets.symmetric(vertical: 8),
                width: Get.width * 0.5,
                decoration: BoxDecoration(
                    color: COLORS.PRIMARY_COLOR,
                    borderRadius: BorderRadius.circular(20)),
                child: WidgetText(
                  title: getT(KeyT.select),
                  style: AppStyle.DEFAULT_16,
                  textAlign: TextAlign.center,
                ),
              ),
            ),
          ),
          AppValue.vSpaceTiny,
        ],
      ),
    );
  }

  _handleData(List<DataProductServicePack> list) {
    for (int i = 0; i < list.length; i++) {
      int index = listSelect.indexWhere(
          (element) => element.item.combo_id == (list[i].comboId ?? ''));
      if (index == -1) {
        addProduct(ProductModel(
          list[i].productId ?? '',
          double.parse((list[i].quantity ?? 0).toString()),
          ProductItem(
            list[i].productId,
            list[i].code,
            '', // list[i].productEdit,
            list[i].nameProduct,
            list[i].unit,
            list[i].vat,
            '${list[i].price}',
            ten_combo: list[i].tenCombo,
            combo_id: list[i].comboId,
          ),
          '${list[i].saleOff?.value}',
          list[i].unitName ?? '',
          list[i].vatName ?? '',
          list[i].saleOff?.type ?? '',
        ));
      } else {
        double quantity = listSelect[index].soLuong +
            double.parse((list[i].quantity ?? 0).toString());
        listSelect[index] = ProductModel(
          list[i].productId ?? '',
          quantity,
          ProductItem(
            list[i].productId,
            list[i].code,
            '', // list[i].productEdit,
            list[i].nameProduct,
            list[i].unit,
            list[i].vat,
            '${list[i].price}',
            ten_combo: list[i].tenCombo,
            combo_id: list[i].comboId,
          ),
          '${list[i].saleOff?.value}',
          list[i].unitName ?? '',
          list[i].vatName ?? '',
          list[i].saleOff?.type ?? '',
        );
      }
    }
  }
}
