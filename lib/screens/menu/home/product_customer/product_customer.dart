import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';
import 'package:gen_crm/bloc/product_customer_module/product_customer_module_bloc.dart';
import 'package:gen_crm/screens/menu/home/product_customer/widget/item_product_customer.dart';
import 'package:gen_crm/widgets/tree/tree_node_model.dart';
import 'package:get/get.dart';
import '../../../../bloc/manager_filter/manager_bloc.dart';
import '../../../../bloc/unread_list_notification/unread_list_notifi_bloc.dart';
import '../../../../l10n/key_text.dart';
import '../../../../src/app_const.dart';
import '../../../../src/models/model_generator/list_product_customer_response.dart';
import '../../../../src/src_index.dart';
import '../../../../widgets/appbar_base.dart';
import '../../../../widgets/drop_down_base.dart';
import '../../../../widgets/search_base.dart';
import '../../../../widgets/tree/tree_widget.dart';
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
  late final ProductCustomerModuleBloc _bloc;
  late final ScrollController _scrollController;
  late final String title;
  late final ManagerBloc managerBloc;

  @override
  void initState() {
    managerBloc =
        ManagerBloc(userRepository: ManagerBloc.of(context).userRepository);
    managerBloc.getManager(module: Module.SAN_PHAM_KH);
    title = ModuleMy.getNameModuleMy(
      ModuleMy.CUSTOMER,
      isTitle: true,
    );
    GetNotificationBloc.of(context).add(CheckNotification());
    _scrollController = ScrollController();
    _bloc = ProductCustomerModuleBloc.of(context);
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
          querySearch: _bloc.querySearch,
          ids: _bloc.ids,
        ));
      } else {}
    });
  }

  _research() {
    _bloc.add(GetProductCustomerModuleEvent(
      page: BASE_URL.PAGE_DEFAULT,
      filter: _bloc.filter,
      querySearch: _bloc.querySearch,
      ids: _bloc.ids,
    ));
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

  _reloadLanguage() async {
    await _research();
    title = ModuleMy.getNameModuleMy(
      ModuleMy.CUSTOMER,
      isTitle: true,
    );
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        key: _drawerKey,
        resizeToAvoidBottomInset: false,
        drawer: MainDrawer(
          onPress: (v) => handleOnPressItemMenu(_drawerKey, v),
          onReload: () async {
            await _reloadLanguage();
          },
        ),
        appBar: AppbarBase(_drawerKey, title),
        floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
        floatingActionButton: FloatingActionButton(
          backgroundColor: COLORS.ff1AA928,
          onPressed: () => AppNavigator.navigateFormAdd(
              '${getT(KeyT.add)} $title', PRODUCT_CUSTOMER_TYPE),
          child: Icon(Icons.add, size: 40),
        ),
        body: Container(
          child: Column(
            children: [
              AppValue.vSpaceSmall,
              SearchBase(
                hint: getT(KeyT.enter_name_barcode_qr_code),
                leadIcon: SvgPicture.asset(ICONS.IC_SEARCH_SVG),
                endIcon: GestureDetector(
                  onTap: () {
                    Navigator.of(context)
                        .push(MaterialPageRoute(
                            builder: (context) => ScannerQrcode()))
                        .then((value) async {
                      if (value != '') {
                        final result = await _bloc.getListProductCustomer(
                            querySearch: value);
                        if (result?.data?.lists?.isNotEmpty ?? false) {
                          AppNavigator.navigateDetailProductCustomer(
                            result?.data?.lists?.first.name ?? '',
                            result?.data?.lists?.first.id ?? '',
                          );
                        } else {
                          ShowDialogCustom.showDialogBase(
                            title: getT(KeyT.notification),
                            content: getT(KeyT.no_data),
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
                onSubmit: (String v) {
                  _bloc.querySearch = v;
                  _research();
                },
              ),
              SizedBox(
                height: 6,
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 25.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(
                      child: DropDownBase(
                        isName: true,
                        stream: _bloc.listFilter,
                        onTap: (item) {
                          _bloc.filter = item.id.toString();
                          _research();
                        },
                      ),
                    ),
                    StreamBuilder<List<TreeNodeData>>(
                        stream: managerBloc.managerTrees,
                        builder: (context, snapshot) {
                          if (snapshot.data?.isNotEmpty ?? false)
                            return Padding(
                              padding: const EdgeInsets.only(left: 6.0),
                              child: GestureDetector(
                                  onTap: () {
                                    showManagerFilter(context, managerBloc,
                                        (v) {
                                      _bloc.ids = v;
                                      _research();
                                    });
                                  },
                                  child: Container(
                                    padding: EdgeInsets.all(14),
                                    decoration: BoxDecoration(
                                        border: Border.all(
                                          color: COLORS.GREY_400,
                                        ),
                                        borderRadius: BorderRadius.all(
                                            Radius.circular(4))),
                                    child: SvgPicture.asset(
                                      ICONS.IC_FILL_SVG,
                                      width: 20,
                                      height: 20,
                                      fit: BoxFit.contain,
                                    ),
                                  )),
                            );
                          return SizedBox();
                        }),
                  ],
                ),
              ),
              SizedBox(
                height: 6,
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
                            physics: ClampingScrollPhysics(
                                parent: AlwaysScrollableScrollPhysics()),
                            padding: EdgeInsets.only(top: 10, bottom: 10),
                            controller: _scrollController,
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
              return Container(
                padding: EdgeInsets.all(16),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Center(
                      child: WidgetText(
                        title: getT(KeyT.select_filter),
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
                                  _research();
                                },
                                child: Container(
                                  padding: EdgeInsets.symmetric(vertical: 8),
                                  decoration: BoxDecoration(
                                      border: Border(
                                          bottom: BorderSide(
                                              width: 1,
                                              color: COLORS.LIGHT_GREY))),
                                  child: Row(
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
              );
            },
          );
        });
  }
}
