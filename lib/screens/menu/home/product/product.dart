import 'package:flutter/material.dart';
import 'package:gen_crm/bloc/product_module/product_module_bloc.dart';
import 'package:gen_crm/screens/menu/home/product/scanner_qrcode.dart';
import 'package:gen_crm/screens/menu/widget/box_item.dart';
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
  String _title = '';
  late final ManagerBloc _blocManager;

  @override
  void initState() {
    _getDataFirst();
    _blocManager =
        ManagerBloc(userRepository: ManagerBloc.of(context).userRepository);
    _blocManager.getManager(module: Module.PRODUCT);
    UnreadNotificationBloc.of(context).add(CheckNotification(isLoading: false));
    _bloc = ProductModuleBloc.of(context);
    _bloc.getFilter();
    super.initState();
  }

  _getDataFirst() {
    _title = ModuleMy.getNameModuleMy(
      ModuleMy.SAN_PHAM,
      isTitle: true,
    );
  }

  _reloadLanguage() async {
    await _bloc.loadMoreController.reloadData();
    _getDataFirst();
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
        drawerKey: _drawerKey,
        moduleMy: ModuleMy.SAN_PHAM,
        onReload: () async {
          await _reloadLanguage();
        },
      ),
      appBar: AppbarBase(_drawerKey, _title),
      floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
      floatingActionButton: FloatingActionButton(
        backgroundColor: COLORS.ff1AA928,
        onPressed: () => AppNavigator.navigateForm(
          title: '${getT(KeyT.add)} $_title',
          type: PRODUCT_TYPE,
        ),
        child: Icon(Icons.add, size: 40),
      ),
      body: ViewLoadMoreBase(
        widgetLoad: _widgetLoad(),
        isShowAll: _bloc.listType,
        child: SingleChildScrollView(
          child: Column(
            children: [
              AppValue.vSpaceSmall,
              SearchBase(
                hint: getT(KeyT.enter_name_barcode_qr_code),
                leadIcon: itemSearch(),
                endIcon: GestureDetector(
                  onTap: () {
                    Navigator.of(context)
                        .push(MaterialPageRoute(
                            builder: (context) => ScannerQrcode()))
                        .then((value) async {
                      if (value != '' && value != null) {
                        final result =
                            await _bloc.getListProduct(querySearch: value);
                        if (result?.data?.lists?.isNotEmpty ?? false) {
                          AppNavigator.navigateDetailProduct(
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
              Padding(
                padding: const EdgeInsets.only(
                  left: 16,
                  right: 16,
                  bottom: 16,
                ),
                child: Row(
                  children: [
                    DropDownBase(
                      isExpand: true,
                      isPadding: false,
                      stream: _bloc.listType,
                      onTap: (item) {
                        _bloc.type = item.id;
                        _bloc.loadMoreController.reloadData();
                      },
                    ),
                    DropDownBase(
                      isExpand: true,
                      isMarginRight: true,
                      isPadding: false,
                      stream: _bloc.listFilterKho,
                      isName: true,
                      title: getT(KeyT.select_kho),
                      onTap: (item) {
                        _bloc.khoId = item.id;
                        _bloc.loadMoreController.reloadData();
                      },
                    ),
                    DropDownBase(
                      isExpand: true,
                      isMarginRight: true,
                      isPadding: false,
                      stream: _bloc.listFilter,
                      isName: true,
                      onTap: (item) {
                        _bloc.filter = item.id;
                        _bloc.loadMoreController.reloadData();
                      },
                    ),
                  ],
                ),
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

  _widgetLoad() {
    return BoxItem(
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            itemLoading(
              height: 80,
              width: 80,
            ),
            SizedBox(
              width: 16,
            ),
            Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                itemLoading(),
                SizedBox(
                  height: 8,
                ),
                itemLoading(),
              ],
            ),
          ],
        ),
        onTap: () {});
  }
}
