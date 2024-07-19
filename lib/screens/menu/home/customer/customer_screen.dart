import 'package:flutter/material.dart';
import 'package:flutter_expandable_fab/flutter_expandable_fab.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:gen_crm/bloc/blocs.dart';
import 'package:gen_crm/widgets/appbar_base.dart';
import 'package:gen_crm/widgets/tree/tree_node_model.dart';
import 'package:gen_crm/widgets/widget_text.dart';
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
  List<String> listAdd = [];
  late final ManagerBloc managerBloc;
  late final GetListCustomerBloc _bloc;

  @override
  void initState() {
    _bloc = GetListCustomerBloc.of(context);
    listAdd = [
      '$title ${getT(KeyT.organization).toLowerCase()}',
      '$title ${getT(KeyT.individual).toLowerCase()}',
    ];
    if (LoginBloc.of(context).checkRegisterSuccess())
      listAdd.add(getT(KeyT.call_operator));
    managerBloc =
        ManagerBloc(userRepository: ManagerBloc.of(context).userRepository);
    managerBloc.getManager(module: Module.KHACH_HANG);
    UnreadNotificationBloc.of(context).add(CheckNotification(isLoading: false));
    super.initState();
  }

  _handleRouter(String value) {
    if (listAdd[0] == value) {
      AppNavigator.navigateForm(
        title: '${getT(KeyT.add)} ${value.toLowerCase()}',
        type: ADD_CUSTOMER_OR,
      );
    } else if (listAdd[1] == value) {
      AppNavigator.navigateForm(
        title: '${getT(KeyT.add)} ${value.toLowerCase()}',
        type: ADD_CUSTOMER,
      );
    } else {
      AppNavigator.navigateCall(title: title);
    }
  }

  _reloadLanguage() async {
    await _bloc.loadMoreController.reloadData();

    title = ModuleMy.getNameModuleMy(
      ModuleMy.CUSTOMER,
      isTitle: true,
    );
    listAdd = [
      '${title} ${getT(KeyT.organization)}',
      '${title} ${getT(KeyT.individual)}',
    ];
    setState(() {});
  }

  @override
  void dispose() {
    _bloc.init();
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
      floatingActionButton: ExpandableFab(
        childrenOffset: Offset(0, 0),
        key: _key,
        distance: 65,
        type: ExpandableFabType.up,
        child: Icon(Icons.add, size: 40),
        closeButtonStyle: const ExpandableFabCloseButtonStyle(
          child: Icon(Icons.close),
          foregroundColor: COLORS.WHITE,
          backgroundColor: COLORS.ff1AA928,
        ),
        backgroundColor: COLORS.ff1AA928,
        overlayStyle: ExpandableFabOverlayStyle(
          blur: 5,
        ),
        children: listAdd
            .map(
              (e) => InkWell(
                onTap: () async {
                  final state = _key.currentState;
                  if (state != null) {
                    if (state.isOpen) {
                      await _handleRouter(e);
                      state.toggle();
                    }
                  }
                },
                child: Row(
                  children: [
                    Container(
                      padding:
                          EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                      decoration: BoxDecoration(
                        color: COLORS.WHITE,
                        borderRadius: BorderRadius.circular(20),
                        boxShadow: [
                          BoxShadow(
                            color: COLORS.BLACK.withOpacity(0.2),
                            spreadRadius: 2,
                            blurRadius: 5,
                          )
                        ],
                      ),
                      child: WidgetText(
                        title: e,
                        style: AppStyle.DEFAULT_18_BOLD.copyWith(
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                    Container(
                      margin: EdgeInsets.only(
                        left: 8,
                        right: 8,
                      ),
                      padding: EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        boxShadow: [
                          BoxShadow(
                            color: COLORS.BLACK.withOpacity(0.2),
                            spreadRadius: 2,
                            blurRadius: 5,
                          )
                        ],
                        color: COLORS.WHITE,
                        shape: BoxShape.circle,
                      ),
                      child: SizedBox(
                        height: 20,
                        width: 20,
                        child: Image.asset(
                          listAdd.indexOf(e) == 2
                              ? ICONS.IC_PHONE_PNG
                              : ICONS.IC_CUSTOMER_3X_PNG,
                          fit: BoxFit.contain,
                        ),
                      ),
                    )
                  ],
                ),
              ),
            )
            .toList(),
      ),
      body: ViewLoadMoreBase(
        isShowAll: _bloc.listType,
        isInit: true,
        child: SingleChildScrollView(
          child: Column(
            children: [
              AppValue.vSpaceSmall,
              SearchBase(
                hint: '${getT(KeyT.find)} ${title.toLowerCase()}',
                leadIcon: SvgPicture.asset(ICONS.IC_SEARCH_SVG),
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
                  left: 16,
                  right: 16,
                  bottom: 16,
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(
                      child: DropDownBase(
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
                                    ICONS.IC_USER2_SVG,
                                    width: 20,
                                    height: 20,
                                    fit: BoxFit.contain,
                                  ),
                                ),
                              ),
                            );
                          return SizedBox();
                        }),
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
