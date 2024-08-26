import 'package:flutter/material.dart';
import 'package:flutter_expandable_fab/flutter_expandable_fab.dart';
import 'package:gen_crm/bloc/blocs.dart';
import 'package:gen_crm/screens/widget/floating_action_button.dart';
import 'package:gen_crm/src/models/model_generator/customer_clue.dart';
import 'package:gen_crm/widgets/appbar_base.dart';
import '../../../../bloc/manager_filter/manager_bloc.dart';
import '../../../../bloc/unread_list_notification/unread_list_notifi_bloc.dart';
import '../../../../l10n/key_text.dart';
import '../../../../src/app_const.dart';
import '../../../../src/models/model_generator/customer.dart';
import '../../../../src/src_index.dart';
import '../../../../widgets/drop_down_base.dart';
import '../../../../widgets/listview/list_load_infinity.dart';
import '../../../../widgets/search_base.dart';
import '../../../../widgets/tree/tree_widget.dart';
import '../../menu_left/menu_drawer/main_drawer.dart';
import '../../widget/tree_filter.dart';
import '../product/scanner_qrcode.dart';
import 'widget/item_list_customer.dart';

class CustomerScreen extends StatefulWidget {
  const CustomerScreen({Key? key}) : super(key: key);

  @override
  State<CustomerScreen> createState() => _CustomerScreenState();
}

class _CustomerScreenState extends State<CustomerScreen> {
  GlobalKey<ScaffoldState> _drawerKey = GlobalKey();
  late final _key = GlobalKey<ExpandableFabState>();
  String title = ModuleMy.getNameModuleMy(
    ModuleMy.CUSTOMER,
    isTitle: true,
  );
  List<Customer> listAdd = [];
  late final ManagerBloc managerBloc;
  late final GetListCustomerBloc _bloc;

  @override
  void initState() {
    _bloc = GetListCustomerBloc.of(context);
    _loadAddPlus();
    managerBloc =
        ManagerBloc(userRepository: ManagerBloc.of(context).userRepository);
    managerBloc.getManager(module: Module.KHACH_HANG);
    UnreadNotificationBloc.of(context).add(
      CheckNotification(
        isLoading: false,
      ),
    );
    super.initState();
  }

  _loadAddPlus() {
    listAdd = [];
    if (LoginBloc.of(context).checkRegisterSuccess())
      listAdd.add(
        Customer.two(
          id: ModuleText.CALL,
          name: getT(KeyT.call_operator),
        ),
      );
    listAdd.addAll([
      Customer.two(
        id: ModuleText.CUSTOMER,
        name: '$title ${getT(KeyT.individual).toLowerCase()}',
        danh_xung: getT(KeyT.add),
      ),
      Customer.two(
        id: ModuleText.CUSTOMER_ORGANIZATION,
        name: '$title ${getT(KeyT.organization).toLowerCase()}',
        danh_xung: getT(KeyT.add),
      ),
    ]);
  }

  _reloadLanguage() async {
    await _bloc.loadMoreController.reloadData();

    title = ModuleMy.getNameModuleMy(
      ModuleMy.CUSTOMER,
      isTitle: true,
    );
    _loadAddPlus();
    setState(() {});
  }

  @override
  void dispose() {
    _bloc.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _drawerKey,
      appBar: AppbarBase(_drawerKey, title),
      drawer: MainDrawer(
        moduleMy: ModuleMy.CUSTOMER,
        drawerKey: _drawerKey,
        onReload: () async {
          _reloadLanguage();
        },
      ),
      floatingActionButtonLocation: ExpandableFab.location,
      floatingActionButton: floatingActionButton(_key, listAdd),
      body: ViewLoadMoreBase(
        isShowAll: _bloc.listType,
        isInit: true,
        child: SingleChildScrollView(
          child: Column(
            children: [
              AppValue.vSpaceSmall,
              SearchBase(
                hint: '${getT(KeyT.find)} ${title.toLowerCase()}',
                leadIcon: itemSearch(),
                endIcon: GestureDetector(
                  onTap: () {
                    Navigator.of(context)
                        .push(MaterialPageRoute(
                            builder: (context) => ScannerQrcode()))
                        .then((value) async {
                      if (value != '' && value != null) {
                        final ListCustomerResponse? result =
                            await _bloc.getListCustomerQR(qr: value);
                        if (result?.data?.list?.isNotEmpty ?? false) {
                          AppNavigator.navigateDetailCustomer(
                            result?.data?.list?.first.id ?? '',
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
                  _bloc.search = v;
                  _bloc.loadMoreController.reloadData();
                },
              ),
              AppValue.vSpaceTiny,
              Padding(
                padding: const EdgeInsets.only(
                  top: 1,
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
                      stream: _bloc.listType,
                      onTap: (item) {
                        if (_bloc.idFilter != item.id.toString()) {
                          _bloc.idFilter = item.id.toString();
                          _bloc.loadMoreController.reloadData();
                        }
                      },
                    ),
                    TreeFilter(
                      treeStream: managerBloc.managerTrees,
                      onTap: () {
                        showManagerFilter(
                          context,
                          managerBloc,
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
        functionInit: (page, isInit) {
          return _bloc.getListCustomer(
            page: page,
          );
        },
        itemWidget: (int index, data) {
          CustomerData snap = data;
          return ItemCustomer(
            data: snap,
            onTap: () => AppNavigator.navigateDetailCustomer(
              snap.id ?? '',
            ),
          );
        },
        controller: _bloc.loadMoreController,
      ),
    );
  }
}
