import 'package:flutter/material.dart';
import 'package:gen_crm/bloc/product/product_bloc.dart';
import 'package:get/get.dart';
import '../../../../l10n/key_text.dart';
import '../../../../src/app_const.dart';
import '../../../../src/models/model_generator/products_response.dart';
import '../../../../src/models/model_generator/service_pack_response.dart';
import '../../../../src/src_index.dart';
import '../../../../widgets/appbar_base.dart';
import '../../../../widgets/btn_thao_tac.dart';
import '../../../../widgets/listview/list_load_infinity.dart';
import '../../../../widgets/search_base.dart';
import '../../../../widgets/widget_text.dart';
import '../../home/product/scanner_qrcode.dart';

class ListServicePark extends StatefulWidget {
  const ListServicePark({Key? key}) : super(key: key);

  @override
  State<ListServicePark> createState() => _ListServiceParkState();
}

class _ListServiceParkState extends State<ListServicePark> {
  final String _title = Get.arguments;
  late final ProductBloc _bloc;
  TextEditingController _searchController = TextEditingController();

  @override
  void initState() {
    _bloc = ProductBloc(userRepository: ProductBloc.of(context).userRepository);
    super.initState();
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppbarBaseNormal('${getT(KeyT.select)} ${_title.toLowerCase()}'),
      body: ViewLoadMoreBase(
        child: SingleChildScrollView(
          child: Container(
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
              controller: _searchController,
              hint: '${getT(KeyT.search)} ${_title.toLowerCase()}',
              onChange: (v) {
                _bloc.loadMoreController.reloadData();
              },
              leadIcon: itemSearch(),
              endIcon: GestureDetector(
                onTap: () {
                  Navigator.of(context)
                      .push(MaterialPageRoute(
                          builder: (context) => ScannerQrcode()))
                      .then((value) async {
                    if (value != '' && value != null) {
                      _searchController.text = value;
                      _bloc.loadMoreController.reloadData();
                    }
                  });
                },
                child: Icon(
                  Icons.qr_code_scanner,
                  size: 20,
                ),
              ),
            ),
          ),
        ),
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
            margin: EdgeInsets.only(
              top: 8,
              left: 16,
              right: 16,
            ),
            padding: EdgeInsets.only(
              bottom: 16,
            ),
            decoration: BoxDecoration(
              border: Border(
                bottom: BorderSide(
                  width: 1,
                  color: COLORS.GREY_400,
                ),
              ),
            ),
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
                        Container(
                          width: MediaQuery.of(context).size.width / 1.6,
                          child: WidgetText(
                            title:
                                '${getT(KeyT.ten_goi_dich_vu)}: ${dataItem.tenCombo}',
                            style: AppStyle.DEFAULT_14_BOLD
                                .copyWith(color: COLORS.TEXT_GREY),
                          ),
                        ),
                        SizedBox(
                          height: 3,
                        ),
                        WidgetText(
                          title:
                              '${getT(KeyT.so_luong_san_pham)}: ${dataItem.countSp}',
                          style: AppStyle.DEFAULT_14_BOLD
                              .copyWith(color: COLORS.TEXT_GREY),
                        ),
                        SizedBox(
                          height: 3,
                        ),
                        WidgetText(
                          title:
                              '${getT(KeyT.into_money)}: ${dataItem.tongTienFormat}',
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
                              title: '${getT(KeyT.dang_su_dung)}',
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
                                    onChanged: null,
                                  ),
                                ),
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
                            _bloc.listId.indexWhere((e) => e == dataItem.id) !=
                                -1),
                    onChanged: (v) {
                      dataItem.isSelect = v;
                      if (v ?? false) {
                        _bloc.listId.add(dataItem.id ?? '');
                      } else {
                        _bloc.listId.remove(dataItem.id ?? '');
                      }
                      setState(() {});
                    },
                  ),
                ),
              ],
            ),
          );
        },
        widgetLoad: widgetLoadingPack(),
        controller: _bloc.loadMoreController,
      ),
      bottomNavigationBar: Container(
        width: double.infinity,
        height: 65,
        padding: EdgeInsets.symmetric(
          horizontal: 16,
          vertical: 12,
        ),
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
        child: ButtonBaseSmall(
          title: getT(KeyT.select),
          onTap: () async {
            if (_bloc.listId.isNotEmpty) {
              final result = await _bloc.getProductServicePack(_bloc.listId
                  .toString()
                  .substring(1, _bloc.listId.toString().length - 1));
              if (result['mess'] == '') {
                if (result['list'] != []) {
                  List<ProductsRes> _list = result['list'];
                  Get.back(result: _list);
                } else {
                  //not_select
                  ShowDialogCustom.showDialogBase(
                    title: getT(KeyT.notification),
                    content: '${getT(KeyT.not_select)} $_title',
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
                content: '${getT(KeyT.not_select)} $_title',
              );
            }
          },
        ),
      ),
    );
  }
}
