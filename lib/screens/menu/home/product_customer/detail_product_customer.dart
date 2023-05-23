import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gen_crm/bloc/detail_product_customer/detail_product_customer_bloc.dart';
import 'package:gen_crm/widgets/btn_thao_tac.dart';
import 'package:gen_crm/widgets/widget_text.dart';
import 'package:get/get.dart';
import 'package:hexcolor/hexcolor.dart';
import '../../../../../src/src_index.dart';
import '../../../../src/app_const.dart';
import '../../../../src/models/model_generator/contract.dart';
import '../../../../src/models/model_generator/detail_product_customer_response.dart';
import '../../../../src/models/model_generator/support.dart';
import '../../../../widgets/listview_loadmore_base.dart';
import '../../../../widgets/loading_api.dart';
import '../../../../widgets/show_thao_tac.dart';
import '../../attachment/attachment.dart';
import '../chance/widget_chance_item.dart';
import '../clue/work_card_widget.dart';
import '../contract/item_list_contract.dart';
import '../support/item_support.dart';
import 'infor_tab.dart';

class DetailProductCustomerScreen extends StatefulWidget {
  const DetailProductCustomerScreen({Key? key}) : super(key: key);

  @override
  State<DetailProductCustomerScreen> createState() =>
      _DetailProductCustomerScreenState();
}

class _DetailProductCustomerScreenState
    extends State<DetailProductCustomerScreen>
    with SingleTickerProviderStateMixin {
  String title = Get.arguments[0];
  String id = Get.arguments[1];
  late TabController _tabController;
  List<ModuleThaoTac> _list = [];
  List<Tabs> _listTab = [];
  final _controllerCv = LoadMoreController();
  final _controllerHd = LoadMoreController();
  final _controllerHt = LoadMoreController();
  final _controllerCh = LoadMoreController();

  List<Widget> listBody(state, List<Tabs> listTab) {
    List<Widget> listWidget = [];
    int idM = int.parse(id);
    for (final value in listTab) {
      if (value.module == 'thong_tin_chung') {
        listWidget.add(InfoTabProductCustomer(
          state: state,
        ));
      } else if (value.module == 'opportunity') {
        //cơ hội
        listWidget.add(ListViewLoadMoreBase(
          functionInit: (page, isInit) {
            return DetailProductCustomerBloc.of(context)
                .getListCHProductCustomer(page: page, isInit: isInit, id: idM);
          },
          itemWidget: (int index, data) {
            return WidgetItemChance(
              listChanceData: ListChanceData(
                  data.id,
                  data.name,
                  data.price,
                  data.trangThai,
                  null,
                  null,
                  DataCustomer(data.customer.id, data.customer.name, null)),
            );
          },
          controller: _controllerCh,
        ));
      } else if (value.module == 'contract') {
        //hợp đồng
        listWidget.add(ListViewLoadMoreBase(
          functionInit: (page, isInit) {
            return DetailProductCustomerBloc.of(context)
                .getListHDProductCustomer(page: page, isInit: isInit, id: idM);
          },
          itemWidget: (int index, data) {
            return ItemContract(
              data: ContractItemData(
                data.id,
                data.name,
                data.price,
                data.status,
                null, //data.status_edit,
                data.color,
                null, //data.avatar,
                CustomerContract(
                  data.customer.id,
                  data.customer.name,
                ),
                null, //data.total_note,
                data.conlai,
              ),
            );
          },
          controller: _controllerHd,
        ));
      } else if (value.module == 'job') {
        listWidget.add(ListViewLoadMoreBase(
          functionInit: (page, isInit) {
            return DetailProductCustomerBloc.of(context)
                .getListCVProductCustomer(page: page, isInit: isInit, id: idM);
          },
          itemWidget: (int index, data) {
            return GestureDetector(
              onTap: () {
                AppNavigator.navigateDetailWork(
                    int.parse(data.id ?? '0'), data.nameJob ?? '');
              },
              child: Padding(
                padding: EdgeInsets.symmetric(horizontal: 25),
                child: WorkCardWidget(
                  nameCustomer: data.customer.name,
                  nameJob: data.nameJob,
                  startDate: data.startDate,
                  statusJob: data.status,
                  totalComment: data.totalNote,
                  color: data.color,
                ),
              ),
            );
          },
          controller: _controllerCv,
        ));
      } else if (value.module == 'support') {
        listWidget.add(ListViewLoadMoreBase(
          functionInit: (page, isInit) {
            return DetailProductCustomerBloc.of(context)
                .getListHTProductCustomer(page: page, isInit: isInit, id: idM);
          },
          itemWidget: (int index, data) {
            return ItemSupport(
              data: SupportItemData(
                data.id,
                data.tenHoTro,
                data.createdDate,
                data.trangThai,
                data.color,
                data.totalNote,
                CustomerData(
                  data.customer.id,
                  data.customer.name,
                ),
              ),
            );
          },
          controller: _controllerHt,
        ));
      }
    }
    return listWidget;
  }

  @override
  void initState() {
    DetailProductCustomerBloc.of(context)
        .add(InitGetDetailProductCustomerEvent(id));
    super.initState();
  }

  getThaoTac(List<Tabs> listAction) {
    for (final value in listAction) {
      _list.add(ModuleThaoTac(
        title: value.name ?? '',
        icon: ModuleMy.getIcon(value.module ?? ''),
        isSvg: false,
        onThaoTac: () async {
          String module = value.module ?? '';
          Get.back();
          if (ModuleMy.LICH_HEN == module) {
            //todo
          } else if (ModuleMy.DAU_MOI == module) {
            //todo
          } else if (ModuleMy.CONG_VIEC == module) {
            //todo
          } else if (ModuleMy.CSKH == module) {
            //todo
          }
        },
      ));
    }
    _list.add(ModuleThaoTac(
      title: "Xem đính kèm",
      icon: ICONS.IC_ATTACK_SVG,
      onThaoTac: () async {
        Get.back();
        Navigator.of(context).push(MaterialPageRoute(
            builder: (context) => Attachment(
                  id: id,
                  typeModule: Module.SAN_PHAM_KH,
                )));
      },
    ));

    _list.add(ModuleThaoTac(
      title: "Sửa",
      icon: ICONS.IC_EDIT_SVG,
      onThaoTac: () {
        Get.back();
        AppNavigator.navigateEditDataScreen(id, PRODUCT_CUSTOMER_TYPE);
      },
    ));

    _list.add(ModuleThaoTac(
      title: "Xoá",
      icon: ICONS.IC_DELETE_SVG,
      onThaoTac: () {
        ShowDialogCustom.showDialogBase(
            onTap2: () async {
              DetailProductCustomerBloc.of(context).add(DeleteProductEvent(id));
            },
            content: "Bạn chắc chắn muốn xóa không ?");
      },
    ));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        toolbarHeight: AppValue.heights * 0.1,
        backgroundColor: HexColor("#D0F1EB"),
        title: WidgetText(
          title: title,
          style: AppStyle.DEFAULT_18_BOLD,
        ),
        leading: Padding(
            padding: EdgeInsets.only(left: 30),
            child: GestureDetector(
                onTap: () => AppNavigator.navigateBack(),
                child: Icon(Icons.arrow_back, color: Colors.black))),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(
            bottom: Radius.circular(15),
          ),
        ),
      ),
      body: BlocListener<DetailProductCustomerBloc, DetailProductCustomerState>(
        listener: (context, state) async {
          if (state is SuccessDeleteProductState) {
            LoadingApi().popLoading();
            ShowDialogCustom.showDialogBase(
              title: MESSAGES.NOTIFICATION,
              content: "Xoá thành công",
              onTap1: () {
                Navigator.pushNamedAndRemoveUntil(context,
                    ROUTE_NAMES.PRODUCT_CUSTOMER, ModalRoute.withName('/'),
                    arguments: title);
              },
            );
          } else if (state is ErrorDeleteProductState) {
            LoadingApi().popLoading();
            ShowDialogCustom.showDialogBase(
              title: MESSAGES.NOTIFICATION,
              content: state.msg,
              textButton1: "Quay lại",
              onTap1: () {
                Get.back();
                Get.back();
                Get.back();
                DetailProductCustomerBloc.of(context)
                    .add(InitGetDetailProductCustomerEvent(id));
              },
            );
          }
        },
        child: Container(
          height: MediaQuery.of(context).size.height,
          width: MediaQuery.of(context).size.width,
          child: BlocBuilder<DetailProductCustomerBloc,
              DetailProductCustomerState>(builder: (context, state) {
            if (state is GetDetailProductCustomerState) {
              if (_listTab.isEmpty) {
                _listTab = [
                  ...[Tabs(module: 'thong_tin_chung', name: 'Thông tin chung')],
                  ...state.productInfo.tabs ?? []
                ];
                _tabController =
                    TabController(length: _listTab.length, vsync: this);
                getThaoTac(state.productInfo.actions ?? []);
              }
              return Scaffold(
                appBar: TabBar(
                  padding: EdgeInsets.symmetric(horizontal: 25),
                  isScrollable: true,
                  controller: _tabController,
                  labelColor: HexColor("#006CB1"),
                  unselectedLabelColor: HexColor("#697077"),
                  labelStyle: TextStyle(
                      fontFamily: "Quicksand",
                      fontSize: 14,
                      fontWeight: FontWeight.w700),
                  indicatorColor: HexColor("#006CB1"),
                  tabs: _listTab
                      .map(
                        (e) => Tab(
                          text: e.name,
                        ),
                      )
                      .toList(),
                ),
                body: Column(
                  children: [
                    Expanded(
                        child: TabBarView(
                      controller: _tabController,
                      children: listBody(state, _listTab),
                    )),
                    Padding(
                      padding: EdgeInsets.symmetric(horizontal: 25),
                      child: ButtonThaoTac(onTap: () {
                        showThaoTac(context, _list);
                      }),
                    ),
                  ],
                ),
              );
            } else
              return SizedBox();
          }),
        ),
      ),
    );
  }
}
