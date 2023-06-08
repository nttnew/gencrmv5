import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_expandable_fab/flutter_expandable_fab.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:gen_crm/bloc/blocs.dart';
import 'package:gen_crm/widgets/appbar_base.dart';
import 'package:gen_crm/widgets/tree/tree_node_model.dart';
import 'package:gen_crm/widgets/widget_text.dart';
import 'package:get/get.dart';
import '../../../../bloc/manager_filter/manager_bloc.dart';
import '../../../../bloc/unread_list_notification/unread_list_notifi_bloc.dart';
import '../../../../src/app_const.dart';
import '../../../../src/models/model_generator/customer.dart';
import '../../../../src/src_index.dart';
import '../../../../widgets/drop_down_base.dart';
import '../../../../widgets/search_base.dart';
import '../../../../widgets/tree/tree_widget.dart';
import '../../menu_left/menu_drawer/main_drawer.dart';
import 'item_list_customer.dart';

class CustomerScreen extends StatefulWidget {
  const CustomerScreen({Key? key}) : super(key: key);

  @override
  State<CustomerScreen> createState() => _CustomerScreenState();
}

class _CustomerScreenState extends State<CustomerScreen> {
  int page = BASE_URL.PAGE_DEFAULT;
  int total = 0;
  int length = 0;
  List<CustomerData> listCustomer = [];
  String idFilter = '';
  GlobalKey<ScaffoldState> _drawerKey = GlobalKey();
  final _key = GlobalKey<ExpandableFabState>();
  String search = '';
  String ids = '';
  String title = Get.arguments;
  ScrollController _scrollController = ScrollController();
  List<String> listAdd = [
    '${Get.arguments} tổ chức',
    '${Get.arguments} cá nhân',
  ];
  late final ManagerBloc managerBloc;
  late final GetListCustomerBloc _bloc;

  @override
  void initState() {
    _bloc = GetListCustomerBloc.of(context);
    managerBloc =
        ManagerBloc(userRepository: ManagerBloc.of(context).userRepository);
    managerBloc.getManager(module: Module.KHACH_HANG);
    GetListUnReadNotifiBloc.of(context).add(CheckNotification());
    _bloc.add(InitGetListOrderEvent());
    _scrollController.addListener(() {
      if (_scrollController.offset ==
              _scrollController.position.maxScrollExtent &&
          length < total) {
        page = page + 1;
        _research(isLoadMore: true, pageNew: page);
      }
    });
    super.initState();
  }

  _research({int? pageNew, bool? isLoadMore}) {
    page = pageNew ?? BASE_URL.PAGE_DEFAULT;
    _bloc.add(InitGetListOrderEvent(
      filter: idFilter,
      page: page,
      ids: ids,
      search: search,
      isLoadMore: isLoadMore,
    ));
  }

  _handleRouter(String value) {
    if (listAdd.last == value) {
      AppNavigator.navigateAddCustomer("Thêm ${value.toLowerCase()}");
    } else {
      AppNavigator.navigateFormAdd("Thêm ${value.toLowerCase()}", ADD_CUSTOMER);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _drawerKey,
      appBar: AppbarBase(_drawerKey, title),
      resizeToAvoidBottomInset: false,
      drawer: MainDrawer(onPress: (v) => handleOnPressItemMenu(_drawerKey, v)),
      floatingActionButtonLocation: ExpandableFab.location,
      floatingActionButton: ExpandableFab(
        childrenOffset: Offset(0, 0),
        key: _key,
        distance: 65,
        type: ExpandableFabType.up,
        child: Icon(Icons.add, size: 40),
        closeButtonStyle: const ExpandableFabCloseButtonStyle(
          child: Icon(Icons.close),
          foregroundColor: Colors.white,
          backgroundColor: Color(0xff1AA928),
        ),
        backgroundColor: Color(0xff1AA928),
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
                        color: Colors.white,
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
                        color: Colors.white,
                        shape: BoxShape.circle,
                      ),
                      child: SizedBox(
                        height: 20,
                        width: 20,
                        child: Image.asset(
                          ICONS.IC_CUSTOMER_3X_PNG,
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
      body: BlocBuilder<GetListCustomerBloc, CustomerState>(
          builder: (context, state) {
        if (state is UpdateGetListCustomerState) {
          total = state.total;
          length = state.listCustomer.length;
          listCustomer = state.listCustomer;
          return Column(
            children: [
              AppValue.vSpaceSmall,
              StreamBuilder<List<TreeNodeData>>(
                  stream: managerBloc.managerTrees,
                  builder: (context, snapshot) {
                    return SearchBase(
                      hint: "Tìm ${title.toLowerCase()}",
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
              Expanded(
                child: RefreshIndicator(
                  onRefresh: () =>
                      Future.delayed(Duration(microseconds: 300), () {
                    _research();
                  }),
                  child: SingleChildScrollView(
                    controller: _scrollController,
                    child: Padding(
                      padding: EdgeInsets.only(top: 10),
                      child: Column(
                        children: List.generate(
                            state.listCustomer.length,
                            (index) => ItemCustomer(
                                  data: state.listCustomer[index],
                                  onTap: () => AppNavigator.navigateDetailCustomer(
                                      state.listCustomer[index].id ?? '',
                                      '${state.listCustomer[index].danh_xung ?? ''}' +
                                          ' ' +
                                          '${state.listCustomer[index].name ?? ''}'),
                                )),
                      ),
                    ),
                  ),
                ),
              ),
            ],
          );
        } else
          return noData();
      }),
    );
  }
}
