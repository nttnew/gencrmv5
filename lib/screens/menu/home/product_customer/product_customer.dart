import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:gen_crm/bloc/product_customer_module/product_customer_module_bloc.dart';
import 'package:gen_crm/screens/menu/home/product_customer/widget/item_product_customer.dart';
import 'package:gen_crm/widgets/tree/tree_node_model.dart';
import '../../../../bloc/manager_filter/manager_bloc.dart';
import '../../../../bloc/unread_list_notification/unread_list_notifi_bloc.dart';
import '../../../../l10n/key_text.dart';
import '../../../../src/app_const.dart';
import '../../../../src/models/model_generator/list_product_customer_response.dart';
import '../../../../src/src_index.dart';
import '../../../../widgets/appbar_base.dart';
import '../../../../widgets/drop_down_base.dart';
import '../../../../widgets/listview/list_load_infinity.dart';
import '../../../../widgets/search_base.dart';
import '../../../../widgets/tree/tree_widget.dart';
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
  late final String title;
  late final ManagerBloc managerBloc;

  @override
  void initState() {
    managerBloc =
        ManagerBloc(userRepository: ManagerBloc.of(context).userRepository);
    managerBloc.getManager(module: Module.SAN_PHAM_KH);
    title = ModuleMy.getNameModuleMy(
      ModuleMy.SAN_PHAM_KH,
      isTitle: true,
    );
    GetNotificationBloc.of(context).add(CheckNotification());
    _bloc = ProductCustomerModuleBloc.of(context);
    _bloc.getFilter();
    super.initState();
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
    await _bloc.loadMoreController.reloadData();
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
                  _bloc.loadMoreController.reloadData();
                },
              ),
              AppValue.vSpaceTiny,
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    child: DropDownBase(
                      isName: true,
                      stream: _bloc.listFilter,
                      onTap: (item) {
                        _bloc.filter = item.id.toString();
                        _bloc.loadMoreController.reloadData();
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
                                    borderRadius: BorderRadius.all(
                                      Radius.circular(
                                        4,
                                      ),
                                    ),
                                  ),
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
                snap.name ?? '',
                snap.id ?? '',
              );
            },
          );
        },
        controller: _bloc.loadMoreController,
      ),
    );
  }
}
