import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:flutter/material.dart';
import 'package:gen_crm/bloc/contract/contract_bloc.dart';
import '../../../../bloc/manager_filter/manager_bloc.dart';
import '../../../../bloc/unread_list_notification/unread_list_notifi_bloc.dart';
import '../../../../l10n/key_text.dart';
import '../../../../src/app_const.dart';
import '../../../../src/src_index.dart';
import '../../../../widgets/appbar_base.dart';
import '../../../../widgets/drop_down_base.dart';
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
  int page = BASE_URL.PAGE_DEFAULT;
  String total = "0";
  int length = 0;
  String idFilter = "";
  String title = "";
  String search = "";
  bool isCheck = true;
  String ids = '';
  late final ManagerBloc managerBloc;
  late final ContractBloc _bloc;
  ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    _bloc = ContractBloc.of(context);
    managerBloc =
        ManagerBloc(userRepository: ManagerBloc.of(context).userRepository);
    managerBloc.getManager(module: Module.HOP_DONG);
    GetNotificationBloc.of(context).add(CheckNotification());
    _bloc.add(InitGetContractEvent());
    title = ModuleMy.getNameModuleMy(
      ModuleMy.HOP_DONG,
      isTitle: true,
    );
    _scrollController.addListener(() {
      if (_scrollController.offset ==
              _scrollController.position.maxScrollExtent &&
          length < int.parse(total)) {
        page = page + 1;
        _research(isLoadMore: true, pageNew: page);
      } else {}
    });
    super.initState();
  }

  _research({int? pageNew, bool? isLoadMore}) {
    page = pageNew ?? BASE_URL.PAGE_DEFAULT;
    _bloc.add(InitGetContractEvent(
      filter: idFilter,
      page: page,
      ids: ids,
      search: search,
      isLoadMore: isLoadMore,
    ));
  }

  _reloadLanguage() async {
    await _research();
    title = ModuleMy.getNameModuleMy(
      ModuleMy.HOP_DONG,
      isTitle: true,
    );
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _drawerKey,
      resizeToAvoidBottomInset: false,
      appBar: AppbarBase(_drawerKey, title),
      drawer: MainDrawer(
        onPress: (v) => handleOnPressItemMenu(_drawerKey, v),
        onReload: () async {
          await _reloadLanguage();
        },
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.endDocked,
      floatingActionButton: Padding(
        padding: EdgeInsets.only(bottom: 20),
        child: FloatingActionButton(
          backgroundColor: COLORS.ff1AA928,
          onPressed: () {
            AppNavigator.navigateAddContract(
                title:
                    '${getT(KeyT.add)} ${title.toLowerCase()}');
          },
          child: Icon(Icons.add, size: 40),
        ),
      ),
      body: Column(
        children: [
          AppValue.vSpaceSmall,
          StreamBuilder<List<TreeNodeData>>(
              stream: managerBloc.managerTrees,
              builder: (context, snapshot) {
                return SearchBase(
                  hint:
                      "${getT(KeyT.find)} ${title.toLowerCase()}",
                  leadIcon: SvgPicture.asset(ICONS.IC_SEARCH_SVG),
                  endIcon: (snapshot.data ?? []).isNotEmpty
                      ? SvgPicture.asset(
                          ICONS.IC_FILL_SVG,
                          width: 16,
                          height: 16,
                          fit: BoxFit.contain,
                        )
                      : null,
                  onClickRight: () {
                    showManagerFilter(context, managerBloc, (v) {
                      ids = v;
                      _research();
                    });
                  },
                  onSubmit: (String v) {
                    search = v;
                    _research();
                  },
                );
              }),
          SizedBox(
            height: 6,
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 25.0),
            child: Align(
              alignment: Alignment.centerLeft,
              child: DropDownBase(
                isName: true,
                stream: _bloc.listType,
                onTap: (item) {
                  idFilter = item.id.toString();
                  _research();
                },
              ),
            ),
          ),
          SizedBox(
            height: 6,
          ),
          BlocBuilder<ContractBloc, ContractState>(builder: (context, state) {
            if (state is UpdateGetContractState) {
              total = state.total;
              length = state.listContract.length;
              return Expanded(
                  child: RefreshIndicator(
                onRefresh: () =>
                    Future.delayed(Duration(milliseconds: 250), () {
                  _research();
                }),
                child: SingleChildScrollView(
                  physics: ClampingScrollPhysics(
                      parent: AlwaysScrollableScrollPhysics()),
                  controller: _scrollController,
                  child: Padding(
                    padding: const EdgeInsets.only(top: 8),
                    child: Column(
                      children: List.generate(
                          state.listContract.length,
                          (index) =>
                              ItemContract(data: state.listContract[index])),
                    ),
                  ),
                ),
              ));
            } else
              return Container();
          }),
        ],
      ),
    );
  }
}
