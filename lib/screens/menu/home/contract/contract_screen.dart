import 'package:flutter_svg/flutter_svg.dart';
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
import 'widget/item_list_contract.dart';

class ContractScreen extends StatefulWidget {
  const ContractScreen({Key? key}) : super(key: key);

  @override
  State<ContractScreen> createState() => _ContractScreenState();
}

class _ContractScreenState extends State<ContractScreen> {
  GlobalKey<ScaffoldState> _drawerKey = GlobalKey();
  String title = '';
  late final ManagerBloc managerBloc;
  late final ContractBloc _bloc;

  @override
  void initState() {
    _bloc = ContractBloc.of(context);
    managerBloc =
        ManagerBloc(userRepository: ManagerBloc.of(context).userRepository);
    managerBloc.getManager(module: Module.HOP_DONG);
    GetNotificationBloc.of(context).add(CheckNotification(isLoading: false));
    _bloc.add(InitGetContractEvent());
    title = ModuleMy.getNameModuleMy(
      ModuleMy.HOP_DONG,
      isTitle: true,
    );
    super.initState();
  }

  _reloadLanguage() async {
    await _bloc.loadMoreController.reloadData();
    title = ModuleMy.getNameModuleMy(
      ModuleMy.HOP_DONG,
      isTitle: true,
    );
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
      resizeToAvoidBottomInset: false,
      appBar: AppbarBase(_drawerKey, title),
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
              title: '${getT(KeyT.add)} ${title.toLowerCase()}',
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
                  stream: managerBloc.managerTrees,
                  builder: (context, snapshot) {
                    return SearchBase(
                      hint: "${getT(KeyT.find)} ${title.toLowerCase()}",
                      leadIcon: SvgPicture.asset(ICONS.IC_SEARCH_SVG),
                      endIcon: (snapshot.data ?? []).isNotEmpty
                          ? SvgPicture.asset(
                              ICONS.IC_USER2_SVG,
                              width: 16,
                              height: 16,
                              fit: BoxFit.contain,
                            )
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
          return _bloc.getListContract(
            page: page,
          );
        },
        itemWidget: (int index, data) {
          ContractItemData snap = data;
          return ItemContract(
            data: snap,
          );
        },
        controller: _bloc.loadMoreController,
      ),
    );
  }
}
