import 'package:flutter/material.dart';
import 'package:gen_crm/bloc/blocs.dart';
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
import 'widget/widget_chance_item.dart';

class ChanceScreen extends StatefulWidget {
  const ChanceScreen({Key? key}) : super(key: key);

  @override
  State<ChanceScreen> createState() => _ChanceScreenState();
}

class _ChanceScreenState extends State<ChanceScreen> {
  GlobalKey<ScaffoldState> _drawerKey = GlobalKey();
  String _title = '';
  late final ManagerBloc _blocManager;
  late final GetListChanceBloc _bloc;

  @override
  void initState() {
    _getDataFirst();
    _bloc = GetListChanceBloc.of(context);
    _blocManager =
        ManagerBloc(userRepository: ManagerBloc.of(context).userRepository);
    _blocManager.getManager(module: Module.CO_HOI_BH);
    UnreadNotificationBloc.of(context).add(CheckNotification(isLoading: false));
    super.initState();
  }

  _reloadLanguage() async {
    await _bloc.loadMoreController.reloadData();
    _getDataFirst();
    setState(() {});
  }

  _getDataFirst() {
    _title = ModuleMy.getNameModuleMy(
      ModuleMy.LICH_HEN,
      isTitle: true,
    );
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
        moduleMy: ModuleMy.LICH_HEN,
        drawerKey: _drawerKey,
        onReload: () async {
          await _reloadLanguage();
        },
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.endDocked,
      appBar: AppbarBase(_drawerKey, _title),
      floatingActionButton: Padding(
        padding: EdgeInsets.only(bottom: 20),
        child: FloatingActionButton(
          backgroundColor: COLORS.ff1AA928,
          onPressed: () {
            AppNavigator.navigateForm(
              title: '${getT(KeyT.add)} ${_title.toLowerCase()}',
              type: ADD_CHANCE,
            );
          },
          child: Icon(Icons.add, size: 40),
        ),
      ),
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
          return _bloc.getListChance(
            page: page,
          );
        },
        itemWidget: (int index, data) {
          ListChanceData snap = data;
          return WidgetItemChance(
            data: snap,
          );
        },
        controller: _bloc.loadMoreController,
      ),
    );
  }
}
