import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gen_crm/bloc/detail_product_customer/detail_product_customer_bloc.dart';
import 'package:gen_crm/widgets/btn_thao_tac.dart';
import 'package:get/get.dart';
import '../../../../../src/src_index.dart';
import '../../../../l10n/key_text.dart';
import '../../../../src/app_const.dart';
import '../../../../src/models/model_generator/contract.dart';
import '../../../../src/models/model_generator/detail_product_customer_response.dart';
import '../../../../src/models/model_generator/support.dart';
import '../../../../widgets/appbar_base.dart';
import '../../../../widgets/listview_loadmore_base.dart';
import '../../../../widgets/loading_api.dart';
import '../../../../widgets/show_thao_tac.dart';
import '../../attachment/attachment.dart';
import '../chance/widget/widget_chance_item.dart';
import '../clue/widget/work_card_widget.dart';
import '../contract/widget/item_list_contract.dart';
import '../support/widget/item_support.dart';
import 'widget/infor_tab.dart';

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
  late final DetailProductCustomerBloc _bloc;

  @override
  void dispose() {
    _bloc.dispose();
    super.dispose();
  }

  @override
  void initState() {
    _bloc = DetailProductCustomerBloc.of(context);
    _bloc.initController(id);
    _bloc.add(InitGetDetailProductCustomerEvent(id));
    super.initState();
  }

  List<Widget> listBody(state, List<Tabs> listTab) {
    List<Widget> listWidget = [];
    int idM = int.parse(id);
    for (final value in listTab) {
      if (value.module == 'thong_tin_chung') {
        listWidget.add(InfoTabProductCustomer());
      } else if (value.module == 'opportunity') {
        //cơ hội
        listWidget.add(ListViewLoadMoreBase(
          functionInit: (page, isInit) {
            return _bloc.getListCHProductCustomer(
                page: page, isInit: isInit, id: idM);
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
          controller: _bloc.controllerCh,
        ));
      } else if (value.module == 'contract') {
        //hợp đồng
        listWidget.add(ListViewLoadMoreBase(
          functionInit: (page, isInit) {
            return _bloc.getListHDProductCustomer(
                page: page, isInit: isInit, id: idM);
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
          controller: _bloc.controllerHd,
        ));
      } else if (value.module == 'job') {
        listWidget.add(ListViewLoadMoreBase(
          functionInit: (page, isInit) {
            return _bloc.getListCVProductCustomer(
                page: page, isInit: isInit, id: idM);
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
          controller: _bloc.controllerCv,
        ));
      } else if (value.module == 'support') {
        listWidget.add(ListViewLoadMoreBase(
          functionInit: (page, isInit) {
            return _bloc.getListHTProductCustomer(
                page: page, isInit: isInit, id: idM);
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
                null,
              ),
            );
          },
          controller: _bloc.controllerHt,
        ));
      }
    }
    return listWidget;
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
            AppNavigator.navigateFormAdd(
                value.name ?? '', CH_PRODUCT_CUSTOMER_TYPE,
                id: int.parse(id));
          } else if (ModuleMy.HOP_DONG == module) {
            AppNavigator.navigateFormAdd(
                value.name ?? '', HD_PRODUCT_CUSTOMER_TYPE,
                id: int.parse(id));
          } else if (ModuleMy.CONG_VIEC == module) {
            AppNavigator.navigateFormAdd(
                value.name ?? '', CV_PRODUCT_CUSTOMER_TYPE,
                id: int.parse(id));
          } else if (ModuleMy.CSKH == module) {
            AppNavigator.navigateFormAdd(
                value.name ?? '', HT_PRODUCT_CUSTOMER_TYPE,
                id: int.parse(id));
          }
        },
      ));
    }
    _list.add(ModuleThaoTac(
      title: getT(KeyT.see_attachment),
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
      title: getT(KeyT.edit),
      icon: ICONS.IC_EDIT_SVG,
      onThaoTac: () {
        Get.back();
        AppNavigator.navigateEditDataScreen(id, PRODUCT_CUSTOMER_TYPE);
      },
    ));

    _list.add(ModuleThaoTac(
      title: getT(KeyT.delete),
      icon: ICONS.IC_DELETE_SVG,
      onThaoTac: () {
        ShowDialogCustom.showDialogBase(
          onTap2: () async {
            _bloc.add(DeleteProductEvent(id));
          },
          content: getT(KeyT.are_you_sure_you_want_to_delete),
        );
      },
    ));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppbarBaseNormal(title),
      body: BlocListener<DetailProductCustomerBloc, DetailProductCustomerState>(
        listener: (context, state) async {
          if (state is SuccessDeleteProductState) {
            LoadingApi().popLoading();
            ShowDialogCustom.showDialogBase(
              title:getT(KeyT.notification),
              content: getT(KeyT.delete_success),
              onTap1: () {
                Navigator.pushNamedAndRemoveUntil(context,
                    ROUTE_NAMES.PRODUCT_CUSTOMER, ModalRoute.withName('/'),
                    arguments: title);
              },
            );
          } else if (state is ErrorDeleteProductState) {
            LoadingApi().popLoading();
            ShowDialogCustom.showDialogBase(
              title:getT(KeyT.notification),
              content: state.msg,
              textButton1: getT(KeyT.come_back),
              onTap1: () {
                Get.back();
                Get.back();
                Get.back();
                _bloc.add(InitGetDetailProductCustomerEvent(id));
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
                  ...[
                    Tabs(
                        module: 'thong_tin_chung', name: getT(KeyT.information))
                  ],
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
                  labelColor: COLORS.ff006CB1,
                  unselectedLabelColor: COLORS.ff697077,
                  labelStyle: TextStyle(
                      fontFamily: "Quicksand",
                      fontSize: 14,
                      fontWeight: FontWeight.w700),
                  indicatorColor: COLORS.ff006CB1,
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
