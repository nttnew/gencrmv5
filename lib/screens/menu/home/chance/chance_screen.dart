import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';
import 'package:gen_crm/bloc/blocs.dart';
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
import 'widget/widget_chance_item.dart';

class ChanceScreen extends StatefulWidget {
  const ChanceScreen({Key? key}) : super(key: key);

  @override
  State<ChanceScreen> createState() => _ChanceScreenState();
}

class _ChanceScreenState extends State<ChanceScreen> {
  int page = BASE_URL.PAGE_DEFAULT;
  String total = '';
  int length = 0;
  List<ListChanceData> listChanceData = [];
  String idFilter = "";
  GlobalKey<ScaffoldState> _drawerKey = GlobalKey();
  String search = '';
  String title = ModuleMy.getNameModuleMy(
    ModuleMy.LICH_HEN,
    isTitle: true,
  );
  String ids = '';
  ScrollController _scrollController = ScrollController();
  late final ManagerBloc managerBloc;
  late final GetListChanceBloc _bloc;

  _reloadLanguage() async {
    await _research();
    title = ModuleMy.getNameModuleMy(
      ModuleMy.LICH_HEN,
      isTitle: true,
    );
    setState(() {});
  }

  @override
  void initState() {
    _bloc = GetListChanceBloc.of(context);
    managerBloc =
        ManagerBloc(userRepository: ManagerBloc.of(context).userRepository);
    managerBloc.getManager(module: Module.CO_HOI_BH);
    GetNotificationBloc.of(context).add(CheckNotification());
    _bloc.add(InitGetListOrderEventChance());
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
    _bloc.add(InitGetListOrderEventChance(
      filter: idFilter,
      page: page,
      ids: ids,
      search: search,
      isLoadMore: isLoadMore,
    ));
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
      floatingActionButtonLocation: FloatingActionButtonLocation.endDocked,
      appBar: AppbarBase(_drawerKey, title),
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
          BlocBuilder<GetListChanceBloc, ChanceState>(
              builder: (context, state) {
            if (state is UpdateGetListChanceState) {
              total = state.total;
              length = state.listChanceData.length;
              return Expanded(
                child: RefreshIndicator(
                  onRefresh: () =>
                      Future.delayed(Duration(milliseconds: 300), () {
                    _research();
                  }),
                  child: ListView.separated(
                    physics: ClampingScrollPhysics(
                        parent: AlwaysScrollableScrollPhysics()),
                    padding: EdgeInsets.only(top: 16),
                    controller: _scrollController,
                    shrinkWrap: true,
                    itemCount: state.listChanceData.length,
                    itemBuilder: (context, index) {
                      return WidgetItemChance(
                        listChanceData: state.listChanceData[index],
                      );
                    },
                    separatorBuilder: (BuildContext context, int index) =>
                        const SizedBox(),
                  ),
                ),
              );
            } else
              return noData();
          }),
        ],
      ),
      floatingActionButton: BlocBuilder<GetListChanceBloc, ChanceState>(
          builder: (context, state) {
        if (state is UpdateGetListChanceState)
          return Padding(
            padding: EdgeInsets.only(bottom: 20),
            child: FloatingActionButton(
              backgroundColor: COLORS.ff1AA928,
              onPressed: () {
                AppNavigator.navigateFormAdd(
                    '${getT(KeyT.add)} ${title.toLowerCase()}',
                    ADD_CHANCE);
              },
              child: Icon(Icons.add, size: 40),
            ),
          );
        else
          return Container();
      }),
    );
  }
}
