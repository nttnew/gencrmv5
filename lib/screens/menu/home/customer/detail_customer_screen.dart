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
import '../../../../bloc/list_note/list_note_bloc.dart';
import '../../../../l10n/key_text.dart';
import '../../../../src/app_const.dart';
import '../../../../src/src_index.dart';
import '../../../../widgets/appbar_base.dart';
import '../../../../widgets/dialog_call.dart';
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
          isSvg: false,
          title: getT(KeyT.call),
          icon: ICONS.IC_PHONE_PNG,
          onThaoTac: () {
            Get.back();
            showDialog(
              context: context,
              builder: (BuildContext context) {
                return DialogCall(
                  phone: _bloc.sdt ?? '',
                  name: _bloc.name ?? '',
                );
              },
            );
          },
        ),
      );

    list.add(
      ModuleThaoTac(
        title:
            "${getT(KeyT.add)} ${ModuleMy.getNameModuleMy(ModuleMy.DAU_MOI)}",
        icon: ICONS.IC_ADD_CLUE_SVG,
        onThaoTac: () {
          Get.back();
          AppNavigator.navigateFormAdd(
              "${getT(KeyT.add)} ${ModuleMy.getNameModuleMy(ModuleMy.DAU_MOI)}",
              ADD_CLUE_CUSTOMER,
              id: int.parse(id), onRefresh: () {
            _bloc.controllerDM.reloadData();
          });
        },
      ),
    );

    list.add(ModuleThaoTac(
      title: "${getT(KeyT.add)} ${ModuleMy.getNameModuleMy(ModuleMy.LICH_HEN)}",
      icon: ICONS.IC_ADD_CHANCE_SVG,
      onThaoTac: () {
        Get.back();
        AppNavigator.navigateFormAdd(
            "${getT(KeyT.add)} ${ModuleMy.getNameModuleMy(ModuleMy.LICH_HEN)}",
            ADD_CHANCE_CUSTOMER,
            id: int.parse(id), onRefresh: () {
          _bloc.controllerCH.reloadData();
        });
      },
    ));

    list.add(ModuleThaoTac(
      title: "${getT(KeyT.add)} ${ModuleMy.getNameModuleMy(ModuleMy.HOP_DONG)}",
      icon: ICONS.IC_ADD_CONTRACT_SVG,
      onThaoTac: () {
        Get.back();
        AppNavigator.navigateAddContract(
            customer_id: id,
            title:
                "${getT(KeyT.add)} ${ModuleMy.getNameModuleMy(ModuleMy.HOP_DONG)}",
            onRefresh: () {
              _bloc.controllerHD.reloadData();
            });
        ;
      },
    ));

    list.add(ModuleThaoTac(
      title:
          "${getT(KeyT.add)} ${ModuleMy.getNameModuleMy(ModuleMy.CONG_VIEC)}",
      icon: ICONS.IC_ADD_WORD_SVG,
      onThaoTac: () {
        Get.back();
        AppNavigator.navigateFormAdd(
            "${getT(KeyT.add)} ${ModuleMy.getNameModuleMy(ModuleMy.CONG_VIEC)}",
            ADD_JOB_CUSTOMER,
            id: int.parse(id), onRefresh: () {
          _bloc.controllerCV.reloadData();
        });
      },
    ));

    list.add(ModuleThaoTac(
      title: "${getT(KeyT.add)} ${ModuleMy.getNameModuleMy(ModuleMy.CSKH)}",
      icon: ICONS.IC_ADD_SUPPORT_SVG,
      onThaoTac: () {
        Get.back();
        AppNavigator.navigateFormAdd(
            "${getT(KeyT.add)} ${ModuleMy.getNameModuleMy(ModuleMy.CSKH)}",
            ADD_SUPPORT_CUSTOMER,
            id: int.parse(id), onRefresh: () {
          _bloc.controllerHT.reloadData();
        });
      },
    ));

    list.add(ModuleThaoTac(
      title: getT(KeyT.add_discuss),
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
      title: getT(KeyT.see_attachment),
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
      title: getT(KeyT.edit),
      icon: ICONS.IC_EDIT_SVG,
      onThaoTac: () {
        Get.back();
        AppNavigator.navigateEditDataScreen(id, EDIT_CUSTOMER, onRefresh: () {
          _bloc.add(InitGetDetailCustomerEvent(int.parse(id)));
        });
      },
    ));

    list.add(ModuleThaoTac(
      title: getT(KeyT.delete),
      icon: ICONS.IC_DELETE_SVG,
      onThaoTac: () {
        ShowDialogCustom.showDialogBase(
          onTap2: () => _bloc.add(DeleteCustomerEvent(int.parse(id))),
          content: getT(KeyT.are_you_sure_you_want_to_delete),
        );
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
                title: getT(KeyT.notification),
                content: getT(KeyT.success),
                onTap1: () {
                  Get.back();
                  Get.back();
                  Get.back();
                  Get.back();
                  GetListCustomerBloc.of(context)
                      .loadMoreController
                      .reloadData();
                },
              );
            } else if (state is ErrorDeleteCustomerState) {
              LoadingApi().popLoading();
              ShowDialogCustom.showDialogBase(
                title: getT(KeyT.notification),
                content: state.msg,
                textButton1: getT(KeyT.come_back),
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
          child: Scaffold(
            appBar: TabBar(
              padding: EdgeInsets.symmetric(
                horizontal: 16,
              ),
              isScrollable: true,
              controller: _tabController,
              labelColor: COLORS.ff006CB1,
              unselectedLabelColor: COLORS.ff697077,
              labelStyle: TextStyle(
                fontFamily: "Quicksand",
                fontSize: 14,
                fontWeight: FontWeight.w700,
              ),
              indicatorColor: COLORS.ff006CB1,
              tabs: <Widget>[
                Tab(
                  text: getT(KeyT.information),
                ),
                Tab(
                  text:
                      ModuleMy.getNameModuleMy(ModuleMy.DAU_MOI, isTitle: true),
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
                  text: ModuleMy.getNameModuleMy(ModuleMy.CSKH, isTitle: true),
                ),
              ],
            ),
            body: Column(
              children: [
                AppValue.vSpaceTiny,
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
                      ListViewLoadMoreBase(
                        functionInit: (page, isInit) {
                          return _bloc.getClueCustomer(
                              id: int.parse(id), page: page, isInit: isInit);
                        },
                        itemWidget: (int index, data) {
                          return ClueCardWidget(
                            data: data,
                            onTap: () {
                              AppNavigator.navigateInfoClue(
                                  data.id ?? '', data.name ?? '');
                            },
                          );
                        },
                        controller: _bloc.controllerDM,
                      ),
                      ListViewLoadMoreBase(
                        functionInit: (page, isInit) {
                          return _bloc.getChanceCustomer(
                              id: int.parse(id), page: page, isInit: isInit);
                        },
                        itemWidget: (int index, data) {
                          return ChanceCardWidget(
                            data: data,
                            onTap: () {
                              AppNavigator.navigateInfoChance(
                                  data.id ?? '', data.name ?? '');
                            },
                          );
                        },
                        controller: _bloc.controllerCH,
                      ),
                      ListViewLoadMoreBase(
                        functionInit: (page, isInit) {
                          return _bloc.getContractCustomer(
                            id: int.parse(id),
                            page: page,
                            isInit: isInit,
                          );
                        },
                        itemWidget: (int index, data) {
                          return ConstractCardWidget(
                            data: data,
                            onTap: () {
                              AppNavigator.navigateInfoContract(
                                  data.id ?? '', data.name ?? '');
                            },
                          );
                        },
                        controller: _bloc.controllerHD,
                      ),
                      ListViewLoadMoreBase(
                        functionInit: (page, isInit) {
                          return _bloc.getJobCustomer(
                            id: int.parse(id),
                            page: page,
                            isInit: isInit,
                          );
                        },
                        itemWidget: (int index, data) {
                          return WorkCardWidget(
                            data: data,
                            onTap: () {
                              AppNavigator.navigateDetailWork(
                                  int.parse(data.id ?? '0'), data.name ?? '');
                            },
                          );
                        },
                        controller: _bloc.controllerCV,
                      ),
                      ListViewLoadMoreBase(
                        functionInit: (page, isInit) {
                          return _bloc.getSupportCustomer(
                            id: int.parse(id),
                            page: page,
                            isInit: isInit,
                          );
                        },
                        itemWidget: (int index, data) {
                          return SupportCardWidget(
                            data: data,
                            onTap: () {
                              AppNavigator.navigateDetailSupport(
                                  data.id ?? '', data.name ?? '');
                            },
                          );
                        },
                        controller: _bloc.controllerHT,
                      ),
                    ],
                  ),
                ),
                ButtonThaoTac(onTap: () {
                  showThaoTac(context, list);
                }),
              ],
            ),
          ),
        ));
  }
}
