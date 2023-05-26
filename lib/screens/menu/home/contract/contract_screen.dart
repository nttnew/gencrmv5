import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:flutter/material.dart';
import 'package:gen_crm/bloc/contract/contract_bloc.dart';
import 'package:gen_crm/widgets/widget_text.dart';
import 'package:get/get.dart';
import 'package:hexcolor/hexcolor.dart';
import '../../../../bloc/unread_list_notification/unread_list_notifi_bloc.dart';
import '../../../../src/app_const.dart';
import '../../../../src/models/model_generator/customer.dart';
import '../../../../src/src_index.dart';
import '../../../../widgets/appbar_base.dart';
import '../../../../widgets/widget_search.dart';
import '../../menu_left/menu_drawer/main_drawer.dart';
import 'item_list_contract.dart';

class ContractScreen extends StatefulWidget {
  const ContractScreen({Key? key}) : super(key: key);

  @override
  State<ContractScreen> createState() => _ContractScreenState();
}

class _ContractScreenState extends State<ContractScreen> {
  GlobalKey<ScaffoldState> _drawerKey = GlobalKey();
  int page = 1;
  String total = "0";
  int length = 0;
  String idFilter = "";
  String title = "";
  String search = "";
  TextEditingController _editingController = TextEditingController();
  bool isCheck = true;

  @override
  void initState() {
    GetListUnReadNotifiBloc.of(context).add(CheckNotification());
    ContractBloc.of(context).add(InitGetContractEvent(page, "", ""));
    _scrollController.addListener(() {
      if (_scrollController.offset ==
              _scrollController.position.maxScrollExtent &&
          length < int.parse(total)) {
        ContractBloc.of(context).add(InitGetContractEvent(
            page + 1, _editingController.text, idFilter,
            isLoadMore: true));
        page = page + 1;
      } else {}
    });
    title = Get.arguments ?? '';
    super.initState();
  }

  ScrollController _scrollController = ScrollController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _drawerKey,
      drawer: MainDrawer(onPress: (v) => handleOnPressItemMenu(_drawerKey, v)),
      floatingActionButtonLocation: FloatingActionButtonLocation.endDocked,
      appBar: AppbarBase(_drawerKey, title),
      body: Column(
        children: [
          AppValue.vSpaceTiny,
          _buildSearch(),
          BlocBuilder<ContractBloc, ContractState>(builder: (context, state) {
            if (state is UpdateGetContractState) {
              total = state.total;
              length = state.listContract.length;
              return Expanded(
                  child: RefreshIndicator(
                onRefresh: () =>
                    Future.delayed(Duration(milliseconds: 250), () {
                  ContractBloc.of(context)
                      .add(InitGetContractEvent(page, "", ""));
                }),
                child: SingleChildScrollView(
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
      floatingActionButton: Padding(
        padding: EdgeInsets.only(bottom: 20),
        child: FloatingActionButton(
          backgroundColor: Color(0xff1AA928),
          onPressed: () {
            AppNavigator.navigateAddContract(title: title.toLowerCase());
          },
          child: Icon(Icons.add, size: 40),
        ),
      ),
    );
  }

  _buildSearch() {
    return BlocBuilder<ContractBloc, ContractState>(builder: (context, state) {
      if (state is UpdateGetContractState)
        return Container(
          margin: EdgeInsets.symmetric(horizontal: 25, vertical: 8),
          decoration: BoxDecoration(
            border: Border.all(color: HexColor("#DBDBDB")),
            borderRadius: BorderRadius.circular(10),
          ),
          child: WidgetSearch(
            inputController: _editingController,
            hintTextStyle: TextStyle(
                fontFamily: "Quicksand",
                fontSize: 16,
                fontWeight: FontWeight.w400,
                color: HexColor("#707070")),
            hint: "Tìm ${title.toLowerCase()}",
            leadIcon: SvgPicture.asset(ICONS.IC_SEARCH_SVG),
            endIcon: SvgPicture.asset(ICONS.IC_FILL_SVG),
            onClickRight: () {
              this.onClickFilter(state.listFilter);
            },
            onSubmit: (v) {
              search = v;
              ContractBloc.of(context)
                  .add(InitGetContractEvent(page, v, idFilter));
            },
          ),
        );
      else
        return Container();
    });
  }

  void onClickFilter(List<FilterData> data) {
    showModalBottomSheet(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.only(
              topLeft: Radius.circular(10), topRight: Radius.circular(10)),
        ),
        elevation: 2,
        context: context,
        isScrollControlled: true,
        constraints: BoxConstraints(maxHeight: Get.height * 0.7),
        builder: (context) {
          return StatefulBuilder(
            builder: (context, setState) {
              return SafeArea(
                child: Container(
                  padding: EdgeInsets.all(16),
                  child: SingleChildScrollView(
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Center(
                          child: WidgetText(
                            title: 'Chọn lọc',
                            textAlign: TextAlign.center,
                            style: AppStyle.DEFAULT_16_BOLD,
                          ),
                        ),
                        Column(
                          children: List.generate(
                              data.length,
                              (index) => GestureDetector(
                                    onTap: () {
                                      Get.back();
                                      idFilter = data[index].id.toString();
                                      ContractBloc.of(context).add(
                                          InitGetContractEvent(
                                              page,
                                              _editingController.text,
                                              data[index].id.toString()));
                                    },
                                    child: Container(
                                      padding:
                                          EdgeInsets.symmetric(vertical: 8),
                                      decoration: BoxDecoration(
                                          border: Border(
                                              bottom: BorderSide(
                                                  width: 1,
                                                  color: COLORS.LIGHT_GREY))),
                                      child: Row(
                                        // crossAxisAlignment: CrossAxisAlignment.start,
                                        children: [
                                          SvgPicture.asset(
                                            ICONS.IC_FILTER_SVG,
                                            width: 20,
                                            height: 20,
                                            fit: BoxFit.contain,
                                          ),
                                          SizedBox(
                                            width: 8,
                                          ),
                                          Expanded(
                                              child: Container(
                                            child: WidgetText(
                                              title: data[index].name ?? '',
                                              style: AppStyle.DEFAULT_16,
                                            ),
                                          )),
                                        ],
                                      ),
                                    ),
                                  )),
                        )
                      ],
                    ),
                  ),
                ),
              );
            },
          );
        });
  }
}
