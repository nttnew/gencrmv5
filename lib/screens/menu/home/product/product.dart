import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';
import 'package:gen_crm/bloc/product_module/product_module_bloc.dart';
import 'package:gen_crm/screens/menu/home/product/scanner_qrcode.dart';
import '../../../../bloc/manager_filter/manager_bloc.dart';
import '../../../../bloc/unread_list_notification/unread_list_notifi_bloc.dart';
import '../../../../l10n/key_text.dart';
import '../../../../src/app_const.dart';
import '../../../../src/src_index.dart';
import '../../../../widgets/appbar_base.dart';
import '../../../../widgets/drop_down_base.dart';
import '../../../../widgets/search_base.dart';
import '../../../../widgets/tree/tree_node_model.dart';
import '../../../../widgets/tree/tree_widget.dart';
import '../../menu_left/menu_drawer/main_drawer.dart';
import 'widget/item_product.dart';

class ProductScreen extends StatefulWidget {
  const ProductScreen({Key? key}) : super(key: key);

  @override
  State<ProductScreen> createState() => _ProductScreenState();
}

class _ProductScreenState extends State<ProductScreen> {
  GlobalKey<ScaffoldState> _drawerKey = GlobalKey();
  late final ProductModuleBloc _bloc;
  late final ScrollController _scrollController;
  String title = '';
  late final ManagerBloc managerBloc;

  @override
  void initState() {
    managerBloc =
        ManagerBloc(userRepository: ManagerBloc.of(context).userRepository);
    managerBloc.getManager(module: Module.PRODUCT);
    GetNotificationBloc.of(context).add(CheckNotification());
    title = ModuleMy.getNameModuleMy(
      ModuleMy.SAN_PHAM,
      isTitle: true,
    );
    _scrollController = ScrollController();
    _bloc = ProductModuleBloc.of(context);
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
        _bloc.add(InitGetListProductModuleEvent(
          page: _bloc.page,
          filter: _bloc.filter,
          typeProduct: _bloc.type,
          querySearch: _bloc.querySearch,
          ids: _bloc.ids,
        ));
      } else {}
    });
  }

  _research() {
    _bloc.add(InitGetListProductModuleEvent(
      page: BASE_URL.PAGE_DEFAULT,
      filter: _bloc.filter,
      typeProduct: _bloc.type,
      querySearch: _bloc.querySearch,
      ids: _bloc.ids,
    ));
  }

  _reloadLanguage() async {
    await _research();
    title = ModuleMy.getNameModuleMy(
      ModuleMy.SAN_PHAM,
      isTitle: true,
    );
    setState(() {});
  }

  getDataFirst() {
    _bloc.add(InitGetListProductModuleEvent());
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
              '${getT(KeyT.add)} $title', PRODUCT_TYPE),
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
                        final result =
                            await _bloc.getListProduct(querySearch: value);
                        if (result?.data?.lists?.isNotEmpty ?? false) {
                          AppNavigator.navigateDetailProduct(
                            result?.data?.lists?.first.tenSanPham ?? '',
                            result?.data?.lists?.first.id ?? '',
                          );
                        } else {
                          ShowDialogCustom.showDialogBase(
                            title:getT(KeyT.notification),
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
              Padding(
                padding: EdgeInsets.only(
                  left: 25,
                  right: 25,
                  top: 6,
                  bottom: 6,
                ),
                child: Row(
                  // mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(
                      child: DropDownBase(
                        stream: _bloc.listType,
                        onTap: (item) {
                          _bloc.type = item.id;
                          _research();
                        },
                      ),
                    ),
                    if (_bloc.listFilter.value.isNotEmpty) ...[
                      SizedBox(
                        width: 6,
                      ),
                      Expanded(
                        child: DropDownBase(
                          stream: _bloc.listFilter,
                          isName: true,
                          onTap: (item) {
                            _bloc.filter = item.id;
                            _research();
                          },
                        ),
                      ),
                    ],
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
              Expanded(
                  child: BlocBuilder<ProductModuleBloc, ProductModuleState>(
                builder: (BuildContext context, state) {
                  if (state is SuccessGetListProductModuleState) {
                    _bloc.dataList = state.list;
                    final list = state.list;
                    if (list.length < BASE_URL.SIZE_DEFAULT) {
                      _bloc.isLength = false;
                    }
                    return Container(
                      height: MediaQuery.of(context).size.height,
                      child: RefreshIndicator(
                        onRefresh: () async {
                          await _research();
                        },
                        child: ListView.builder(
                            physics: ClampingScrollPhysics(
                                parent: AlwaysScrollableScrollPhysics()),
                            padding: EdgeInsets.only(top: 10, bottom: 10),
                            controller: _scrollController,
                            itemCount: list.length,
                            itemBuilder: (context, i) => GestureDetector(
                                  onTap: () {
                                    AppNavigator.navigateDetailProduct(
                                        list[i].tenSanPham ?? '',
                                        list[i].id ?? '');
                                  },
                                  child: ItemProductModule(
                                    productModule: list[i],
                                  ),
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
}
