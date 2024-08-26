import 'package:flutter/material.dart';
import 'package:gen_crm/bloc/contract/contract_bloc.dart';
import 'package:gen_crm/src/models/model_generator/contract.dart';
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
import 'widget/item_contract.dart';

class ContractScreen extends StatefulWidget {
  const ContractScreen({Key? key}) : super(key: key);

  @override
  State<ContractScreen> createState() => _ContractScreenState();
}

class _ContractScreenState extends State<ContractScreen> {
  GlobalKey<ScaffoldState> _drawerKey = GlobalKey();
  String _title = '';
  late final ManagerBloc _blocManager;
  late final ContractBloc _bloc;

  @override
  void initState() {
    _getDataFirst();
    _bloc = ContractBloc.of(context);
    _blocManager =
        ManagerBloc(userRepository: ManagerBloc.of(context).userRepository);
    _blocManager.getManager(module: Module.HOP_DONG);
    UnreadNotificationBloc.of(context).add(CheckNotification(isLoading: false));
    _bloc.add(InitGetContractEvent());
    super.initState();
  }

  _getDataFirst() {
    _title = ModuleMy.getNameModuleMy(
      ModuleMy.HOP_DONG,
      isTitle: true,
    );
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
      appBar: AppbarBase(_drawerKey, _title),
      drawer: MainDrawer(
        drawerKey: _drawerKey,
        onReload: () async {
          await _reloadLanguage();
        },
        moduleMy: ModuleMy.HOP_DONG,
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.endDocked,
      floatingActionButton: Padding(
        padding: EdgeInsets.only(bottom: 20),
        child: FloatingActionButton(
          backgroundColor: COLORS.ff1AA928,
          onPressed: () {
            AppNavigator.navigateForm(
              title: '${getT(KeyT.add)} ${_title.toLowerCase()}',
              type: ADD_CONTRACT,
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
          return _bloc.getListContract(
            page: page,
          );
        },
        itemWidget: (int index, data) {
          ContractItemData snap = data;
          return ItemContract(
            onRefreshForm: () {
              _bloc.loadMoreController.reloadData();
            },
            data: snap,
          );
        },
        controller: _bloc.loadMoreController,
      ),
    );
  }
}
