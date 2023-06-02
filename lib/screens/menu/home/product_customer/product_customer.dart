import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';
import 'package:gen_crm/bloc/product_customer_module/product_customer_module_bloc.dart';
import 'package:gen_crm/screens/menu/home/product_customer/item_product_customer.dart';
import 'package:get/get.dart';
import 'package:hexcolor/hexcolor.dart';
import '../../../../src/app_const.dart';
import '../../../../src/models/model_generator/list_product_customer_response.dart';
import '../../../../src/src_index.dart';
import '../../../../widgets/appbar_base.dart';
import '../../../../widgets/widget_search.dart';
import '../../../../widgets/widget_text.dart';
import '../../menu_left/menu_drawer/main_drawer.dart';
import '../product/scanner_qrcode.dart';

class ProductCustomerScreen extends StatefulWidget {
  const ProductCustomerScreen({Key? key}) : super(key: key);

  @override
  State<ProductCustomerScreen> createState() => _ProductCustomerScreenState();
}

class _ProductCustomerScreenState extends State<ProductCustomerScreen> {
  GlobalKey<ScaffoldState> _drawerKey = GlobalKey();
  late final TextEditingController _controllerText;
  late final ProductCustomerModuleBloc _bloc;
  late final ScrollController _scrollController;
  late final String title;

  @override
  void initState() {
    title = Get.arguments ?? '';
    _scrollController = ScrollController();
    _bloc = ProductCustomerModuleBloc.of(context);
    _controllerText = TextEditingController();
    getDataFirst();
    listenerLoadMore();
    _bloc.getFilter();
    super.initState();
  }

  listenerLoadMore() {
    _scrollController.addListener(() {
      if (_scrollController.offset ==
              _scrollController.position.maxScrollExtent &&
          _bloc.isLength) {
        _bloc.page = _bloc.page + 1;
        _bloc.add(GetProductCustomerModuleEvent(
            page: _bloc.page,
            filter: _bloc.filter,
            querySearch: _bloc.querySearch));
      } else {}
    });
  }

  search() {
    _bloc.add(GetProductCustomerModuleEvent(
        page: BASE_URL.PAGE_DEFAULT,
        filter: _bloc.filter,
        querySearch: _bloc.querySearch));
  }

  getDataFirst() {
    _bloc.add(GetProductCustomerModuleEvent());
  }

  @override
  void deactivate() {
    _bloc.dispose();
    super.deactivate();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        key: _drawerKey,
        resizeToAvoidBottomInset: false,
        drawer:
            MainDrawer(onPress: (v) => handleOnPressItemMenu(_drawerKey, v)),
        appBar: AppbarBase(_drawerKey, title),
        floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
        floatingActionButton: FloatingActionButton(
          backgroundColor: Color(0xff1AA928),
          onPressed: () => AppNavigator.navigateFormAdd(
              'Thêm $title', PRODUCT_CUSTOMER_TYPE),
          child: Icon(Icons.add, size: 40),
        ),
        body: Container(
          child: Column(
            children: [
              Container(
                margin: EdgeInsets.only(
                  right: 25,
                  left: 25,
                  top: 25,
                  bottom: 10,
                ),
                width: double.infinity,
                height: AppValue.heights * 0.06,
                decoration: BoxDecoration(
                  border: Border.all(color: HexColor("#DBDBDB")),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: WidgetSearch(
                  inputController: _controllerText,
                  hintTextStyle: TextStyle(
                      fontFamily: "Quicksand",
                      fontSize: 16,
                      fontWeight: FontWeight.w400,
                      color: HexColor("#707070")),
                  hint: "Nhập tên, barCode, qrCode",
                  leadIcon: SvgPicture.asset(ICONS.IC_SEARCH_SVG),
                  endIconFinal: Row(
                    children: [
                      Container(
                        padding: EdgeInsets.symmetric(
                          horizontal: 12,
                        ),
                        height: double.maxFinite,
                        decoration: BoxDecoration(
                          border: Border(
                            left: BorderSide(color: HexColor("#DBDBDB")),
                            right: BorderSide(color: HexColor("#DBDBDB")),
                          ),
                        ),
                        child: GestureDetector(
                          onTap: () {
                            Navigator.of(context)
                                .push(MaterialPageRoute(
                                    builder: (context) => ScannerQrcode()))
                                .then((value) async {
                              if (value != '') {
                                final result = await _bloc.getListProduct(
                                    querySearch: value);
                                if (result?.data?.lists?.isNotEmpty ?? false) {
                                  AppNavigator.navigateDetailProductCustomer(
                                      result?.data?.lists?.first.name ?? '',
                                      result?.data?.lists?.first.id ?? '');
                                } else {
                                  ShowDialogCustom.showDialogBase(
                                    title: MESSAGES.NOTIFICATION,
                                    content: 'Không có dữ liệu',
                                  );
                                }
                              }
                            });
                          },
                          child: Icon(
                            Icons.qr_code_scanner,
                            size: 20,
                          ),
                        ),
                      ),
                      Container(
                        padding: EdgeInsets.symmetric(
                          horizontal: 12,
                        ),
                        child: GestureDetector(
                            onTap: () {
                              showBotomSheet(_bloc.dataFilter ?? []);
                            },
                            child: SvgPicture.asset(
                              ICONS.IC_FILTER_SVG,
                              height: 20,
                              width: 20,
                            )),
                      ),
                    ],
                  ),
                  onSubmit: (v) {
                    _bloc.querySearch = v;
                    search();
                  },
                ),
              ),
              Expanded(child: BlocBuilder<ProductCustomerModuleBloc,
                  ProductCustomerModuleState>(
                builder: (BuildContext context, state) {
                  if (state is SuccessGetListProductCustomerModuleState) {
                    _bloc.dataList = state.list;
                    final list = state.list;
                    if (list.length < BASE_URL.SIZE_DEFAULT) {
                      _bloc.isLength = false;
                    }
                    return Container(
                      height: MediaQuery.of(context).size.height,
                      child: RefreshIndicator(
                        onRefresh: () async {
                          await getDataFirst();
                        },
                        child: ListView.builder(
                            padding: EdgeInsets.only(top: 10, bottom: 10),
                            controller: _scrollController,
                            physics: AlwaysScrollableScrollPhysics(),
                            itemCount: list.length,
                            itemBuilder: (context, i) => ItemProductCustomer(
                                  productModule: list[i],
                                  onTap: () {
                                    AppNavigator.navigateDetailProductCustomer(
                                        list[i].name ?? '', list[i].id ?? '');
                                  },
                                )),
                      ),
                    );
                  }
                  return Container();
                },
              ))
            ],
          ),
        ));
  }

  showBotomSheet(List<DataFilter> dataFilter) {
    showModalBottomSheet(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.only(
              topLeft: Radius.circular(10), topRight: Radius.circular(10)),
        ),
        elevation: 2,
        context: context,
        isScrollControlled: true,
        constraints: BoxConstraints(maxHeight: Get.height * 0.7),
        builder: (context) {
          return StatefulBuilder(
            builder: (context, setState) {
              return SafeArea(
                child: Container(
                  padding: EdgeInsets.all(16),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Center(
                        child: WidgetText(
                          title: 'Chọn lọc',
                          textAlign: TextAlign.center,
                          style: AppStyle.DEFAULT_16_BOLD,
                        ),
                      ),
                      Column(
                        children: List.generate(
                            dataFilter.length,
                            (index) => GestureDetector(
                                  onTap: () {
                                    _bloc.filter =
                                        dataFilter[index].id.toString();
                                    Get.back();
                                    search();
                                  },
                                  child: Container(
                                    padding: EdgeInsets.symmetric(vertical: 8),
                                    decoration: BoxDecoration(
                                        border: Border(
                                            bottom: BorderSide(
                                                width: 1,
                                                color: COLORS.LIGHT_GREY))),
                                    child: Row(
                                      // crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        SvgPicture.asset(
                                          ICONS.IC_FILTER_SVG,
                                          width: 20,
                                          height: 20,
                                          fit: BoxFit.contain,
                                        ),
                                        SizedBox(
                                          width: 8,
                                        ),
                                        Expanded(
                                            child: Container(
                                          child: WidgetText(
                                            title: dataFilter[index].name ?? '',
                                            style: AppStyle.DEFAULT_16,
                                          ),
                                        )),
                                      ],
                                    ),
                                  ),
                                )),
                      )
                    ],
                  ),
                ),
              );
            },
          );
        });
  }
}
