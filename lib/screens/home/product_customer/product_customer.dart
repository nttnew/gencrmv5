import 'dart:io';
import 'package:flutter/material.dart';
import 'package:gen_crm/bloc/product_customer_module/product_customer_module_bloc.dart';
import 'package:gen_crm/screens/home/product_customer/widget/item_product_customer.dart';
import '../../../../bloc/manager_filter/manager_bloc.dart';
import '../../../../bloc/unread_list_notification/unread_list_notifi_bloc.dart';
import '../../../../l10n/key_text.dart';
import '../../../../src/app_const.dart';
import '../../../../src/models/model_generator/list_product_customer_response.dart';
import '../../../../src/src_index.dart';
import '../../../../widgets/appbar_base.dart';
import '../../../../widgets/drop_down_base.dart';
import '../../../../widgets/listview/list_load_infinity.dart';
import '../../../../widgets/loading_api.dart';
import '../../../../widgets/pick_file_image.dart';
import '../../../../widgets/search_base.dart';
import '../../../../widgets/tree/tree_widget.dart';
import '../../form/widget/camera_custom.dart';
import '../../menu_left/menu_drawer/main_drawer.dart';
import '../../widget/tree_filter.dart';
import '../product/scanner_qrcode.dart';

class ProductCustomerScreen extends StatefulWidget {
  const ProductCustomerScreen({Key? key}) : super(key: key);

  @override
  State<ProductCustomerScreen> createState() => _ProductCustomerScreenState();
}

class _ProductCustomerScreenState extends State<ProductCustomerScreen> {
  GlobalKey<ScaffoldState> _drawerKey = GlobalKey();
  late final ProductCustomerModuleBloc _bloc;
  late final String _title;
  late final ManagerBloc _blocManager;

  @override
  void initState() {
    _getDataFirst();
    _blocManager =
        ManagerBloc(userRepository: ManagerBloc.of(context).userRepository);
    _blocManager.getManager(module: Module.SAN_PHAM_KH);
    UnreadNotificationBloc.of(context).add(CheckNotification(isLoading: false));
    _bloc = ProductCustomerModuleBloc.of(context);
    _bloc.getFilter();
    super.initState();
  }

  @override
  void deactivate() {
    _bloc.dispose();
    super.deactivate();
  }

  _getDataFirst() {
    _title = ModuleMy.getNameModuleMy(
      ModuleMy.SAN_PHAM_KH,
      isTitle: true,
    );
  }

  _reloadLanguage() async {
    await _bloc.loadMoreController.reloadData();
    _getDataFirst();
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _drawerKey,
      resizeToAvoidBottomInset: false,
      drawer: MainDrawer(
        drawerKey: _drawerKey,
        onReload: () async {
          await _reloadLanguage();
        },
        moduleMy: ModuleMy.SAN_PHAM_KH,
      ),
      appBar: AppbarBase(_drawerKey, _title),
      floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
      floatingActionButton: FloatingActionButton(
        backgroundColor: COLORS.ff1AA928,
        onPressed: () => AppNavigator.navigateForm(
          title: '${getT(KeyT.add)} $_title',
          type: PRODUCT_CUSTOMER_TYPE,
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
                leadIcon: itemSearch(),
                endIcon: GestureDetector(
                  onTap: () {
                    _handelRightIconSearch();
                  },
                  child: Icon(
                    isCarCrm()
                        ? Icons.photo_camera_outlined
                        : Icons.qr_code_scanner,
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
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    DropDownBase(
                      isExpand: true,
                      isPadding: false,
                      isName: true,
                      stream: _bloc.listFilter,
                      onTap: (item) {
                        _bloc.filter = item.id.toString();
                        _bloc.loadMoreController.reloadData();
                      },
                    ),
                    TreeFilter(
                      treeStream: _blocManager.managerTrees,
                      onTap: () {
                        showManagerFilter(
                          context,
                          _blocManager,
                          (v) {
                            _bloc.ids = v;
                            _bloc.loadMoreController.reloadData();
                          },
                        );
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
          return _bloc.getListProduct(
            page: page,
          );
        },
        itemWidget: (int index, data) {
          ProductCustomerResponse snap = data;
          return ItemProductCustomer(
            productModule: snap,
            onTap: () {
              AppNavigator.navigateDetailProductCustomer(
                snap.id ?? '',
              );
            },
          );
        },
        controller: _bloc.loadMoreController,
      ),
    );
  }

  void _handelRightIconSearch() async {
    if (isCarCrm()) {
      final String? file = await Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => CameraCustom(),
          ));
      if (file != null) {
        Loading().showLoading();
        final File file2MB = await compressImage(File(file));
        final res = await _bloc.getBienSoWithImg(file: file2MB);
        if (res['mes'] == '') {
          if (res['data'] != '') _handelSearchWithText(res['data'].toString());
        } else {
          ShowDialogCustom.showDialogBase(
            title: getT(KeyT.notification),
            content: getT(KeyT.no_data),
          );
        }
      }
    } else {
      Navigator.of(context)
          .push(MaterialPageRoute(builder: (context) => ScannerQrcode()))
          .then((value) async {
        _handelSearchWithText(value);
      });
    }
  }

  _handelSearchWithText(String v) async {
    if (v != '') {
      final result = await _bloc.getListProductCustomer(querySearch: v);
      if (result?.data?.lists?.isNotEmpty ?? false) {
        AppNavigator.navigateDetailProductCustomer(
          result?.data?.lists?.first.id ?? '',
        );
      } else {
        ShowDialogCustom.showDialogBase(
          title: getT(KeyT.notification),
          content: getT(KeyT.no_data),
        );
      }
    }
  }
}
