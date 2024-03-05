import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:gen_crm/bloc/product_module/product_module_bloc.dart';
import 'package:gen_crm/screens/menu/home/product/scanner_qrcode.dart';
import 'package:gen_crm/src/models/model_generator/list_product_response.dart';
import '../../../../bloc/manager_filter/manager_bloc.dart';
import '../../../../bloc/unread_list_notification/unread_list_notifi_bloc.dart';
import '../../../../l10n/key_text.dart';
import '../../../../src/app_const.dart';
import '../../../../src/src_index.dart';
import '../../../../widgets/appbar_base.dart';
import '../../../../widgets/drop_down_base.dart';
import '../../../../widgets/listview/list_load_infinity.dart';
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
  String title = '';
  late final ManagerBloc managerBloc;

  @override
  void initState() {
    managerBloc =
        ManagerBloc(userRepository: ManagerBloc.of(context).userRepository);
    managerBloc.getManager(module: Module.PRODUCT);
    GetNotificationBloc.of(context).add(CheckNotification(isLoading: false));
    title = ModuleMy.getNameModuleMy(
      ModuleMy.SAN_PHAM,
      isTitle: true,
    );
    _bloc = ProductModuleBloc.of(context);
    _bloc.getFilter();
    super.initState();
  }

  _reloadLanguage() async {
    await _bloc.loadMoreController.reloadData();
    title = ModuleMy.getNameModuleMy(
      ModuleMy.SAN_PHAM,
      isTitle: true,
    );
    setState(() {});
  }

  @override
  void deactivate() {
    _bloc.dispose();
    super.deactivate();
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
        onPressed: () => AppNavigator.navigateForm(
          title: '${getT(KeyT.add)} $title',
          type: PRODUCT_TYPE,
        ),
        child: Icon(Icons.add, size: 40),
      ),
      body: ViewLoadMoreBase(
        isShowAll: _bloc.listType,
        child: SingleChildScrollView(
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
                onChange: (String v) {
                  _bloc.querySearch = v;
                  _bloc.loadMoreController.reloadData();
                },
              ),
              AppValue.vSpaceTiny,
              Row(
                // mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    child: DropDownBase(
                      stream: _bloc.listType,
                      onTap: (item) {
                        _bloc.type = item.id;
                        _bloc.loadMoreController.reloadData();
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
                          _bloc.loadMoreController.reloadData();
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
                                  showManagerFilter(context, managerBloc, (v) {
                                    _bloc.ids = v;
                                    _bloc.loadMoreController.reloadData();
                                  });
                                },
                                child: Container(
                                  padding: EdgeInsets.all(14),
                                  decoration: BoxDecoration(
                                      border: Border.all(
                                        color: COLORS.GREY_400,
                                      ),
                                      borderRadius:
                                          BorderRadius.all(Radius.circular(4))),
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
            ],
          ),
        ),
        isInit: true,
        functionInit: (page, isInit) {
          return _bloc.getListProductMain(
            page: page,
          );
        },
        itemWidget: (int index, data) {
          ProductModule snap = data;
          return ItemProductModule(
            productModule: snap,
          );
        },
        controller: _bloc.loadMoreController,
      ),
    );
  }
}
