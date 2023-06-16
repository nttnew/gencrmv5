import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gen_crm/bloc/blocs.dart';
import 'package:gen_crm/bloc/detail_customer/detail_customer_bloc.dart';
import 'package:gen_crm/screens/menu/home/customer/widget/item/chance_card_widget.dart';
import 'package:gen_crm/screens/menu/home/customer/widget/item/clue_card_widget.dart';
import 'package:gen_crm/screens/menu/home/customer/widget/item/contract_card_widget.dart';
import 'package:gen_crm/screens/menu/home/customer/widget/item/general_infor_customer.dart';
import 'package:gen_crm/screens/menu/home/customer/widget/item/work_card_widget.dart';
import 'package:gen_crm/widgets/btn_thao_tac.dart';
import 'package:get/get.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../../../bloc/list_note/list_note_bloc.dart';
import '../../../../src/app_const.dart';
import '../../../../src/src_index.dart';
import '../../../../widgets/appbar_base.dart';
import '../../../../widgets/listview_loadmore_base.dart';
import '../../../../widgets/loading_api.dart';
import '../../../../widgets/show_thao_tac.dart';
import '../../attachment/attachment.dart';
import 'package:gen_crm/screens/menu/home/support/widget/support_card_widget.dart';

class DetailCustomerScreen extends StatefulWidget {
  const DetailCustomerScreen({Key? key}) : super(key: key);

  @override
  State<DetailCustomerScreen> createState() => _DetailCustomerScreenState();
}

class _DetailCustomerScreenState extends State<DetailCustomerScreen>
    with SingleTickerProviderStateMixin {
  String id = Get.arguments[0];
  String title = Get.arguments[1];
  late TabController _tabController;
  int page = BASE_URL.PAGE_DEFAULT;
  bool drag = false;
  List<ModuleThaoTac> list = [];
  late final ListNoteBloc _blocNote;
  late final DetailCustomerBloc _bloc;

  @override
  void deactivate() {
    _bloc.add(ReloadCustomerEvent());
    super.deactivate();
  }

  @override
  void initState() {
    _bloc = DetailCustomerBloc(
        userRepository: DetailCustomerBloc.of(context).userRepository);
    _bloc.initController(id);
    _blocNote =
        ListNoteBloc(userRepository: ListNoteBloc.of(context).userRepository);
    _tabController = TabController(length: 6, vsync: this);
    super.initState();
  }

  getThaoTac() {
    list = [];
    if (_bloc.sdt != null)
      list.add(
        ModuleThaoTac(
          title: "Gọi điện",
          icon: ICONS.IC_PHONE_CUSTOMER_SVG,
          onThaoTac: () {
            Get.back();
            launchUrl(Uri(scheme: "tel", path: _bloc.sdt.toString()));
          },
        ),
      );

    list.add(
      ModuleThaoTac(
        title: "Thêm ${ModuleMy.getNameModuleMy(ModuleMy.DAU_MOI)}",
        icon: ICONS.IC_ADD_CLUE_SVG,
        onThaoTac: () {
          Get.back();
          AppNavigator.navigateFormAdd(
              "Thêm ${ModuleMy.getNameModuleMy(ModuleMy.DAU_MOI)}",
              ADD_CLUE_CUSTOMER,
              id: int.parse(id), onRefresh: () {
            _bloc.controllerDM.reloadData();
          });
        },
      ),
    );

    list.add(ModuleThaoTac(
      title: "Thêm ${ModuleMy.getNameModuleMy(ModuleMy.LICH_HEN)}",
      icon: ICONS.IC_ADD_CHANCE_SVG,
      onThaoTac: () {
        Get.back();
        AppNavigator.navigateFormAdd(
            "Thêm ${ModuleMy.getNameModuleMy(ModuleMy.LICH_HEN)}",
            ADD_CHANCE_CUSTOMER,
            id: int.parse(id), onRefresh: () {
          _bloc.controllerCH.reloadData();
        });
      },
    ));

    list.add(ModuleThaoTac(
      title: "Thêm ${ModuleMy.getNameModuleMy(ModuleMy.HOP_DONG)}",
      icon: ICONS.IC_ADD_CONTRACT_SVG,
      onThaoTac: () {
        Get.back();
        AppNavigator.navigateAddContract(
            customer_id: id,
            title: "${ModuleMy.getNameModuleMy(ModuleMy.HOP_DONG)}",
            onRefresh: () {
              _bloc.controllerHD.reloadData();
            });
        ;
      },
    ));

    list.add(ModuleThaoTac(
      title: "Thêm ${ModuleMy.getNameModuleMy(ModuleMy.CONG_VIEC)}",
      icon: ICONS.IC_ADD_WORD_SVG,
      onThaoTac: () {
        Get.back();
        AppNavigator.navigateFormAdd(
            "Thêm ${ModuleMy.getNameModuleMy(ModuleMy.CONG_VIEC)}",
            ADD_JOB_CUSTOMER,
            id: int.parse(id), onRefresh: () {
          _bloc.controllerCV.reloadData();
        });
      },
    ));

    list.add(ModuleThaoTac(
      title: "Thêm ${ModuleMy.getNameModuleMy(ModuleMy.CSKH)}",
      icon: ICONS.IC_ADD_SUPPORT_SVG,
      onThaoTac: () {
        Get.back();
        AppNavigator.navigateFormAdd(
            "Thêm ${ModuleMy.getNameModuleMy(ModuleMy.CSKH)}",
            ADD_SUPPORT_CUSTOMER,
            id: int.parse(id), onRefresh: () {
          _bloc.controllerHT.reloadData();
        });
      },
    ));

    list.add(ModuleThaoTac(
      title: "Thêm thảo luận",
      icon: ICONS.IC_ADD_DISCUSS_SVG,
      onThaoTac: () {
        Get.back();
        AppNavigator.navigateAddNoteScreen(Module.KHACH_HANG, id,
            onRefresh: () {
          _blocNote.add(RefreshEvent());
        });
      },
    ));

    list.add(ModuleThaoTac(
      title: "Xem đính kèm",
      icon: ICONS.IC_ATTACK_SVG,
      onThaoTac: () async {
        Get.back();
        Navigator.of(context).push(MaterialPageRoute(
            builder: (context) => Attachment(
                  id: id,
                  typeModule: Module.KHACH_HANG,
                )));
      },
    ));

    list.add(ModuleThaoTac(
      title: "Sửa",
      icon: ICONS.IC_EDIT_SVG,
      onThaoTac: () {
        Get.back();
        AppNavigator.navigateEditDataScreen(id, EDIT_CUSTOMER, onRefresh: () {
          _bloc.add(InitGetDetailCustomerEvent(int.parse(id)));
        });
      },
    ));

    list.add(ModuleThaoTac(
      title: "Xoá",
      icon: ICONS.IC_DELETE_SVG,
      onThaoTac: () {
        ShowDialogCustom.showDialogBase(
            onTap2: () => _bloc.add(DeleteCustomerEvent(int.parse(id))),
            content: "Bạn chắc chắn muốn xóa không ?");
      },
    ));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppbarBaseNormal(title),
        body: BlocListener<DetailCustomerBloc, DetailCustomerState>(
          bloc: _bloc,
          listener: (context, state) async {
            if (state is SuccessDeleteCustomerState) {
              LoadingApi().popLoading();
              ShowDialogCustom.showDialogBase(
                title: MESSAGES.NOTIFICATION,
                content: "Thành công",
                onTap1: () {
                  Get.back();
                  Get.back();
                  Get.back();
                  Get.back();
                  GetListCustomerBloc.of(context).add(InitGetListOrderEvent());
                },
              );
            } else if (state is ErrorDeleteCustomerState) {
              LoadingApi().popLoading();
              ShowDialogCustom.showDialogBase(
                title: MESSAGES.NOTIFICATION,
                content: state.msg,
                textButton1: "Quay lại",
                onTap1: () {
                  Get.back();
                  Get.back();
                  Get.back();
                  Get.back();
                },
              );
            } else if (state is UpdateGetDetailCustomerState) {
              getThaoTac();
            }
          },
          child: SafeArea(
            child: Scaffold(
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
                tabs: <Widget>[
                  Tab(
                    text: "Thông tin chung",
                  ),
                  Tab(
                    text: ModuleMy.getNameModuleMy(ModuleMy.DAU_MOI,
                        isTitle: true),
                  ),
                  Tab(
                    text: ModuleMy.getNameModuleMy(ModuleMy.LICH_HEN,
                        isTitle: true),
                  ),
                  Tab(
                    text: ModuleMy.getNameModuleMy(ModuleMy.HOP_DONG,
                        isTitle: true),
                  ),
                  Tab(
                    text: ModuleMy.getNameModuleMy(ModuleMy.CONG_VIEC,
                        isTitle: true),
                  ),
                  Tab(
                    text:
                        ModuleMy.getNameModuleMy(ModuleMy.CSKH, isTitle: true),
                  ),
                ],
              ),
              body: Column(
                children: [
                  Expanded(
                    child: TabBarView(
                      controller: _tabController,
                      physics: BouncingScrollPhysics(),
                      children: <Widget>[
                        TabInfoCustomer(
                          id: id,
                          blocNote: _blocNote,
                          bloc: _bloc,
                        ),
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 25),
                          child: ListViewLoadMoreBase(
                            functionInit: (page, isInit) {
                              return _bloc.getClueCustomer(
                                  id: int.parse(id),
                                  page: page,
                                  isInit: isInit);
                            },
                            itemWidget: (int index, data) {
                              return GestureDetector(
                                onTap: () {
                                  AppNavigator.navigateInfoClue(
                                      data.id ?? '', data.name ?? '');
                                },
                                child: ClueCardWidget(data: data),
                              );
                            },
                            controller: _bloc.controllerDM,
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 25),
                          child: ListViewLoadMoreBase(
                            functionInit: (page, isInit) {
                              return _bloc.getChanceCustomer(
                                  id: int.parse(id),
                                  page: page,
                                  isInit: isInit);
                            },
                            itemWidget: (int index, data) {
                              return GestureDetector(
                                onTap: () {
                                  AppNavigator.navigateInfoChance(
                                      data.id ?? '', data.name ?? '');
                                },
                                child: ChanceCardWidget(data: data),
                              );
                            },
                            controller: _bloc.controllerCH,
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 25),
                          child: ListViewLoadMoreBase(
                            functionInit: (page, isInit) {
                              return _bloc.getContractCustomer(
                                id: int.parse(id),
                                page: page,
                                isInit: isInit,
                              );
                            },
                            itemWidget: (int index, data) {
                              return GestureDetector(
                                onTap: () {
                                  AppNavigator.navigateInfoContract(
                                      data.id ?? '', data.name ?? '');
                                },
                                child: ConstractCardWidget(data: data),
                              );
                            },
                            controller: _bloc.controllerHD,
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 25),
                          child: ListViewLoadMoreBase(
                            functionInit: (page, isInit) {
                              return _bloc.getJobCustomer(
                                id: int.parse(id),
                                page: page,
                                isInit: isInit,
                              );
                            },
                            itemWidget: (int index, data) {
                              return GestureDetector(
                                onTap: () {
                                  AppNavigator.navigateDetailWork(
                                      int.parse(data.id ?? '0'),
                                      data.name ?? '');
                                },
                                child: WorkCardWidget(data: data),
                              );
                            },
                            controller: _bloc.controllerCV,
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 25),
                          child: ListViewLoadMoreBase(
                            functionInit: (page, isInit) {
                              return _bloc.getSupportCustomer(
                                id: int.parse(id),
                                page: page,
                                isInit: isInit,
                              );
                            },
                            itemWidget: (int index, data) {
                              return GestureDetector(
                                onTap: () {
                                  AppNavigator.navigateDetailSupport(
                                      data.id ?? '', data.name ?? '');
                                },
                                child: SupportCardWidget(data: data),
                              );
                            },
                            controller: _bloc.controllerHT,
                          ),
                        ),
                      ],
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 25),
                    child: ButtonThaoTac(onTap: () {
                      showThaoTac(context, list);
                    }),
                  ),
                ],
              ),
            ),
          ),
        ));
  }
}
