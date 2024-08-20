import 'package:flutter/material.dart';
import 'package:flutter_expandable_fab/flutter_expandable_fab.dart';
import 'package:gen_crm/bloc/unread_list_notification/unread_list_notifi_bloc.dart';
import 'package:gen_crm/bloc/support/support_bloc.dart';
import 'package:gen_crm/src/models/model_generator/support.dart';
import '../../../../bloc/manager_filter/manager_bloc.dart';
import '../../../../l10n/key_text.dart';
import '../../../../src/app_const.dart';
import '../../../../src/src_index.dart';
import '../../../../widgets/appbar_base.dart';
import '../../../../widgets/drop_down_base.dart';
import '../../../../widgets/listview/list_load_infinity.dart';
import '../../../../widgets/search_base.dart';
import '../../../../widgets/tree/tree_node_model.dart';
import '../../../../widgets/tree/tree_widget.dart';
import '../../../../widgets/widget_text.dart';
import '../../menu_left/menu_drawer/main_drawer.dart';
import 'widget/item_support.dart';

class SupportScreen extends StatefulWidget {
  const SupportScreen({Key? key}) : super(key: key);

  @override
  State<SupportScreen> createState() => _SupportScreenState();
}

class _SupportScreenState extends State<SupportScreen> {
  GlobalKey<ScaffoldState> _drawerKey = GlobalKey();
  final _key = GlobalKey<ExpandableFabState>();
  String title = ModuleMy.getNameModuleMy(
    ModuleMy.CSKH,
    isTitle: true,
  );
  List<String> listAdd = [
    '${getT(KeyT.add)} ${getT(KeyT.check_in).toLowerCase()}',
    '${getT(KeyT.add)} ${ModuleMy.getNameModuleMy(
      ModuleMy.CSKH,
      isTitle: true,
    ).toLowerCase()}'
  ];
  late final ManagerBloc managerBloc;
  late final SupportBloc _bloc;

  @override
  void initState() {
    _bloc = SupportBloc.of(context);
    managerBloc =
        ManagerBloc(userRepository: ManagerBloc.of(context).userRepository);
    managerBloc.getManager(module: Module.HO_TRO);
    UnreadNotificationBloc.of(context).add(CheckNotification(isLoading: false));
    super.initState();
  }

  _handleRouter(String value) {
    AppNavigator.navigateForm(
      title: value,
      type: ADD_SUPPORT,
      isCheckIn: listAdd.first == value,
    );
  }

  _reloadLanguage() async {
    await _bloc.loadMoreController.reloadData();
    listAdd = [
      '${getT(KeyT.add)} ${getT(KeyT.check_in).toLowerCase()}',
      '${getT(KeyT.add)} ${title.toLowerCase()}'
    ];
    title = ModuleMy.getNameModuleMy(
      ModuleMy.CSKH,
      isTitle: true,
    );
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
      resizeToAvoidBottomInset: false,
      drawer: MainDrawer(
        drawerKey: _drawerKey,
        moduleMy: ModuleMy.CSKH,
        onReload: () async {
          await _reloadLanguage();
        },
      ),
      floatingActionButtonLocation: ExpandableFab.location,
      floatingActionButton: ExpandableFab(
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
                          ICONS.IC_SUPPORT_3X_PNG,
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
      appBar: AppbarBase(_drawerKey, title),
      body: ViewLoadMoreBase(
        isShowAll: _bloc.listType,
        child: SingleChildScrollView(
          child: Column(
            children: [
              AppValue.vSpaceSmall,
              StreamBuilder<List<TreeNodeData>>(
                  stream: managerBloc.managerTrees,
                  builder: (context, snapshot) {
                    return SearchBase(
                      hint: "${getT(KeyT.find)} ${title.toLowerCase()}",
                      leadIcon: itemSearch(),
                      endIcon: (snapshot.data ?? []).isNotEmpty
                          ? itemSearchFilterTree()
                          : null,
                      onClickRight: () {
                        showManagerFilter(context, managerBloc, (v) {
                          _bloc.ids = v;
                          _bloc.loadMoreController.reloadData();
                        });
                      },
                      onChange: (String v) {
                        _bloc.search = v;
                        _bloc.loadMoreController.reloadData();
                      },
                    );
                  }),
              AppValue.vSpaceTiny,
              DropDownBase(
                isName: true,
                stream: _bloc.listType,
                onTap: (item) {
                  _bloc.idFilter = item.id.toString();
                  _bloc.loadMoreController.reloadData();
                },
              ),
            ],
          ),
        ),
        isInit: true,
        functionInit: (page, isInit) {
          return _bloc.getListSupport(
            page: page,
          );
        },
        itemWidget: (int index, data) {
          SupportItemData snap = data;
          return ItemSupport(
            data: snap,
            onRefreshForm: () {
              _bloc.loadMoreController.reloadData();
            },
          );
        },
        controller: _bloc.loadMoreController,
      ),
    );
  }
}
