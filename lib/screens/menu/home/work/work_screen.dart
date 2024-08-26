import 'package:flutter/material.dart';
import 'package:flutter_expandable_fab/flutter_expandable_fab.dart';
import 'package:gen_crm/bloc/unread_list_notification/unread_list_notifi_bloc.dart';
import 'package:gen_crm/bloc/work/work_bloc.dart';
import 'package:gen_crm/screens/menu/widget/floating_action_button.dart';
import 'package:gen_crm/src/models/model_generator/customer_clue.dart';
import 'package:gen_crm/src/models/model_generator/work.dart';
import 'package:gen_crm/src/src_index.dart';
import 'package:gen_crm/screens/menu/home/work/widget/index.dart';
import '../../../../bloc/manager_filter/manager_bloc.dart';
import '../../../../l10n/key_text.dart';
import '../../../../src/app_const.dart';
import '../../../../widgets/appbar_base.dart';
import '../../../../widgets/drop_down_base.dart';
import '../../../../widgets/listview/list_load_infinity.dart';
import '../../../../widgets/search_base.dart';
import '../../../../widgets/tree/tree_node_model.dart';
import '../../../../widgets/tree/tree_widget.dart';
import '../../menu_left/menu_drawer/main_drawer.dart';

class WorkScreen extends StatefulWidget {
  const WorkScreen({Key? key}) : super(key: key);

  @override
  State<WorkScreen> createState() => _WorkScreenState();
}

class _WorkScreenState extends State<WorkScreen> {
  GlobalKey<ScaffoldState> _drawerKey = GlobalKey();
  String _title = '';
  List<Customer> _listAdd = [];
  final _key = GlobalKey<ExpandableFabState>();
  late final ManagerBloc _blocManager;
  late final WorkBloc _bloc;

  @override
  void initState() {
    _getDataFirst();
    _bloc = WorkBloc.of(context);
    _blocManager =
        ManagerBloc(userRepository: ManagerBloc.of(context).userRepository);
    _blocManager.getManager(module: Module.CONG_VIEC);
    UnreadNotificationBloc.of(context).add(CheckNotification(isLoading: false));
    super.initState();
  }

  _getDataFirst() {
    _title = ModuleMy.getNameModuleMy(
      ModuleMy.CONG_VIEC,
      isTitle: true,
    );
    _listAdd = [
      Customer.two(
        id: ModuleText.CONG_VIEC_CHECK_IN,
        name: '${getT(KeyT.add)} ${getT(KeyT.check_in).toLowerCase()}',
      ),
      Customer.two(
        id: ModuleText.CONG_VIEC,
        name: '${getT(KeyT.add)} ${_title.toLowerCase()}',
      ),
    ];
  }

  _reloadLanguage() async {
    await _bloc.loadMoreController.reloadData();
    _getDataFirst();
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
        onReload: () async {
          await _reloadLanguage();
        },
        moduleMy: ModuleMy.CONG_VIEC,
      ),
      floatingActionButtonLocation: ExpandableFab.location,
      floatingActionButton: floatingActionButton(_key, _listAdd),
      appBar: AppbarBase(_drawerKey, _title),
      body: ViewLoadMoreBase(
        isShowAll: _bloc.listType,
        child: SingleChildScrollView(
          child: Column(
            children: [
              AppValue.vSpaceSmall,
              StreamBuilder<List<TreeNodeData>>(
                  stream: _blocManager.managerTrees,
                  builder: (context, snapshot) {
                    return SearchBase(
                      hint: '${getT(KeyT.find)} ${_title.toLowerCase()}',
                      leadIcon: itemSearch(),
                      endIcon: (snapshot.data ?? []).isNotEmpty
                          ? itemSearchFilterTree()
                          : null,
                      onClickRight: () {
                        showManagerFilter(context, _blocManager, (v) {
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
          return _bloc.getListWork(
            page: page,
          );
        },
        itemWidget: (int index, data) {
          WorkItemData snap = data;
          return WorkCardWidget(
            item: snap,
            onTap: () => AppNavigator.navigateDetailWork(
              int.tryParse(snap.id ?? '') ?? 0,
            ),
          );
        },
        controller: _bloc.loadMoreController,
      ),
    );
  }
}
