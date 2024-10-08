import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gen_crm/bloc/detail_product_customer/detail_product_customer_bloc.dart';
import 'package:gen_crm/src/models/model_generator/customer_clue.dart';
import 'package:gen_crm/widgets/btn_thao_tac.dart';
import 'package:get/get.dart';
import '../../../../../src/src_index.dart';
import '../../../../bloc/product_customer_module/product_customer_module_bloc.dart';
import '../../../../l10n/key_text.dart';
import '../../../../src/app_const.dart';
import '../../../../src/models/model_generator/contract.dart';
import '../../../../src/models/model_generator/detail_product_customer_response.dart';
import '../../../../src/models/model_generator/list_ch_product_customer_response.dart';
import '../../../../src/models/model_generator/list_cv_customer_response.dart';
import '../../../../src/models/model_generator/list_hd_product_customer_response.dart';
import '../../../../src/models/model_generator/list_ht_product_customer_response.dart';
import '../../../../src/models/model_generator/support.dart';
import '../../../../widgets/appbar_base.dart';
import '../../../../widgets/listview/list_load_infinity.dart';
import '../../../../widgets/loading_api.dart';
import '../../../../widgets/show_thao_tac.dart';
import '../../attachment/attachment.dart';
import '../chance/widget/widget_chance_item.dart';
import '../clue/widget/work_card_widget.dart';
import '../contract/widget/item_contract.dart';
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
  bool _reload = false;
  String _title = '';
  String _id = Get.arguments ?? '';
  late TabController _tabController;
  List<ModuleThaoTac> _list = [];
  List<Tabs> _listTab = [];
  late final DetailProductCustomerBloc _bloc;

  @override
  void initState() {
    _bloc = DetailProductCustomerBloc(
        userRepository: DetailProductCustomerBloc.of(context).userRepository);
    _bloc.add(InitGetDetailProductCustomerEvent(_id));
    super.initState();
  }

  List<Widget> listBody(state, List<Tabs> listTab) {
    List<Widget> _listWidget = [];
    int _idM = int.parse(_id);
    for (final value in listTab) {
      if (value.module == 'thong_tin_chung') {
        _listWidget.add(RefreshIndicator(
          color: getBackgroundWithIsCar(),
          onRefresh: () async {
            _bloc.add(InitGetDetailProductCustomerEvent(_id));
          },
          child: InfoTabProductCustomer(
            bloc: _bloc,
          ),
        ));
      } else if (value.module == 'opportunity') {
        //cơ hội
        _listWidget.add(Padding(
          padding: const EdgeInsets.only(top: 8.0),
          child: ViewLoadMoreBase(
            isInit: true,
            functionInit: (page, isInit) {
              return _bloc.getListCHProductCustomer(page: page, id: _idM);
            },
            itemWidget: (int index, data) {
              final CHProductCustomer item = data as CHProductCustomer;
              return WidgetItemChance(
                data: ListChanceData(
                  item.id,
                  item.name,
                  item.price,
                  item.trangThai,
                  null,
                  item.color,
                  item.starDate,
                  item.customer,
                  item.product_customer,
                ),
              );
            },
            controller: _bloc.controllerCh,
          ),
        ));
      } else if (value.module == 'contract') {
        //hợp đồng
        _listWidget.add(Padding(
          padding: const EdgeInsets.only(top: 8.0),
          child: ViewLoadMoreBase(
            isInit: true,
            functionInit: (page, isInit) {
              return _bloc.getListHDProductCustomer(
                page: page,
                id: _idM,
              );
            },
            itemWidget: (int index, data) {
              final ListHDProductCustomer item = data as ListHDProductCustomer;
              return ItemContract(
                data: ContractItemData(
                  item.id,
                  item.name,
                  item.price,
                  item.status,
                  null, //data.status_edit,
                  item.color,
                  null, //data.avatar,
                  item.customer,
                  item.product_customer,
                  null, //data.total_note,
                  item.conlai,
                ),
                onRefreshForm: () {
                  _bloc.controllerHd.reloadData();
                },
              );
            },
            controller: _bloc.controllerHd,
          ),
        ));
      } else if (value.module == 'job') {
        _listWidget.add(Padding(
          padding: const EdgeInsets.only(top: 8.0),
          child: ViewLoadMoreBase(
            isInit: true,
            functionInit: (page, isInit) {
              return _bloc.getListCVProductCustomer(page: page, id: _idM);
            },
            itemWidget: (int index, data) {
              final DataList _item = data as DataList;
              _item.productCustomer = Customer.two(
                // mục đính để k hiển thị chuyển màn sang sản phầm vì đg ở đây rồi
                name: _item.productCustomer?.name,
              );
              return WorkCardWidget(
                onTap: () {
                  AppNavigator.navigateDetailWork(
                    int.parse(data.id ?? '0'),
                  );
                },
                customer: _item.customer,
                productCustomer: _item.productCustomer,
                nameCustomer: _item.customer?.name,
                nameJob: _item.nameJob,
                startDate: _item.starDate,
                statusJob: _item.status,
                totalComment: _item.totalNote,
                color: _item.color,
                recordUrl: _item.recordingUrl,
              );
            },
            controller: _bloc.controllerCv,
          ),
        ));
      } else if (value.module == 'support') {
        _listWidget.add(Padding(
          padding: const EdgeInsets.only(top: 8.0),
          child: ViewLoadMoreBase(
            isInit: true,
            functionInit: (page, isInit) {
              return _bloc.getListHTProductCustomer(page: page, id: _idM);
            },
            itemWidget: (int index, data) {
              final DataHTProductCustomer item = data as DataHTProductCustomer;
              return ItemSupport(
                data: SupportItemData(
                  item.id,
                  item.tenHoTro,
                  item.createdDate,
                  item.trangThai,
                  item.color,
                  item.totalNote,
                  item.customer,
                  item.product_customer,
                  null,
                ),
                onRefreshForm: () {
                  _bloc.controllerHt.reloadData();
                },
              );
            },
            controller: _bloc.controllerHt,
          ),
        ));
      }
    }
    return _listWidget;
  }

  _getThaoTac(List<Tabs> listAction) {
    for (final value in listAction) {
      _list.add(ModuleThaoTac(
        title: value.name ?? '',
        icon: ModuleMy.getIcon(value.module ?? ''),
        isSvg: false,
        onThaoTac: () async {
          String module = value.module ?? '';
          Get.back();
          if (ModuleMy.LICH_HEN == module) {
            AppNavigator.navigateForm(
              title: value.name ?? '',
              type: CH_PRODUCT_CUSTOMER_TYPE,
              id: int.parse(_id),
              onRefreshForm: () {
                _bloc.controllerCh.reloadData();
              },
            );
          } else if (ModuleMy.HOP_DONG == module) {
            AppNavigator.navigateForm(
              title: value.name ?? '',
              type: HD_PRODUCT_CUSTOMER_TYPE,
              id: int.parse(_id),
              onRefreshForm: () {
                _bloc.controllerHd.reloadData();
              },
            );
          } else if (ModuleMy.CONG_VIEC == module) {
            AppNavigator.navigateForm(
              title: value.name ?? '',
              type: CV_PRODUCT_CUSTOMER_TYPE,
              id: int.parse(_id),
              onRefreshForm: () {
                _bloc.controllerCv.reloadData();
              },
            );
          } else if (ModuleMy.CSKH == module) {
            AppNavigator.navigateForm(
              title: value.name ?? '',
              type: HT_PRODUCT_CUSTOMER_TYPE,
              id: int.parse(_id),
              onRefreshForm: () {
                _bloc.controllerHt.reloadData();
              },
            );
          }
        },
      ));
    }
    _list.add(ModuleThaoTac(
      title: getT(KeyT.see_attachment),
      icon: ICONS.IC_ATTACK_PNG,
      isSvg: false,
      onThaoTac: () async {
        Get.back();
        Navigator.of(context).push(MaterialPageRoute(
            builder: (context) => Attachment(
                  id: _id,
                  typeModule: Module.SAN_PHAM_KH,
                )));
      },
    ));

    _list.add(ModuleThaoTac(
      title: getT(KeyT.edit),
      icon: ICONS.IC_EDIT_SVG,
      onThaoTac: () {
        Get.back();
        AppNavigator.navigateForm(
          title: getT(KeyT.edit),
          type: PRODUCT_CUSTOMER_TYPE_EDIT,
          id: int.tryParse(_id),
          onRefreshForm: () {
            _reload = true;
            _bloc.add(InitGetDetailProductCustomerEvent(_id));
          },
        );
      },
    ));

    _list.add(ModuleThaoTac(
      title: getT(KeyT.delete),
      icon: ICONS.IC_DELETE_SVG,
      onThaoTac: () {
        ShowDialogCustom.showDialogBase(
          onTap2: () async {
            _bloc.add(DeleteProductEvent(_id));
          },
          content: getT(KeyT.are_you_sure_you_want_to_delete),
        );
      },
    ));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppbarBaseNormal(
        _title,
        reload: _reload,
      ),
      body: BlocListener<DetailProductCustomerBloc, DetailProductCustomerState>(
        bloc: _bloc,
        listener: (context, state) async {
          if (state is SuccessDeleteProductState) {
            Loading().popLoading();
            ShowDialogCustom.showDialogBase(
              title: getT(KeyT.notification),
              content: getT(KeyT.delete_success),
              onTap1: () {
                Get.back();
                Get.back();
                Get.back();
                Get.back(result: true);
                ProductCustomerModuleBloc.of(context)
                    .loadMoreController
                    .reloadData();
              },
            );
          } else if (state is ErrorDeleteProductState) {
            Loading().popLoading();
            ShowDialogCustom.showDialogBase(
              title: getT(KeyT.notification),
              content: state.msg,
              textButton1: getT(KeyT.come_back),
              onTap1: () {
                Get.back();
                Get.back();
                Get.back();
                Get.back();
                _bloc.add(InitGetDetailProductCustomerEvent(_id));
              },
            );
          }
        },
        child: Container(
          height: MediaQuery.of(context).size.height,
          width: MediaQuery.of(context).size.width,
          child: BlocBuilder<DetailProductCustomerBloc,
                  DetailProductCustomerState>(
              bloc: _bloc,
              builder: (context, state) {
                if (state is GetDetailProductCustomerState) {
                  if (_listTab.isEmpty) {
                    _listTab = [
                      ...[
                        Tabs(
                            module: 'thong_tin_chung',
                            name: getT(KeyT.information))
                      ],
                      ...state.productInfo.tabs ?? []
                    ];
                    _tabController =
                        TabController(length: _listTab.length, vsync: this);
                    _getThaoTac(state.productInfo.actions ?? []);
                  }
                  _title = checkTitle(
                    state.productInfo.data ?? [],
                    'bien_so',
                  );

                  WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
                    setState(() {});
                  });
                  return Scaffold(
                    appBar: TabBar(
                      padding: EdgeInsets.symmetric(horizontal: 16),
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
                          ),
                        ),
                        BlocBuilder<DetailProductCustomerBloc,
                            DetailProductCustomerState>(
                          bloc: _bloc,
                          builder: (context, state) {
                            if (state is GetDetailProductCustomerState)
                              return ButtonCustom(onTap: () {
                                showThaoTac(context, _list);
                              });
                            return ButtonCustom();
                          },
                        ),
                      ],
                    ),
                  );
                } else if (state is ErrorGetDetailProductCustomerState) {
                  return Text(
                    state.msg,
                    style: AppStyle.DEFAULT_16_T,
                  );
                } else
                  return SizedBox();
              }),
        ),
      ),
    );
  }
}
