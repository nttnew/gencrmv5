import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gen_crm/bloc/blocs.dart';
import 'package:gen_crm/bloc/detail_customer/detail_customer_bloc.dart';
import 'package:gen_crm/screens/menu/home/customer/widget/item/chance_card_widget.dart';
import 'package:gen_crm/screens/menu/home/customer/widget/item/clue_card_widget.dart';
import 'package:gen_crm/screens/menu/home/customer/widget/item/general_infor_customer.dart';
import 'package:gen_crm/screens/menu/home/customer/widget/item/work_card_widget.dart';
import 'package:gen_crm/src/models/model_generator/contract.dart';
import 'package:gen_crm/widgets/btn_thao_tac.dart';
import 'package:get/get.dart';
import '../../../../bloc/list_note/list_note_bloc.dart';
import '../../../../l10n/key_text.dart';
import '../../../../src/app_const.dart';
import '../../../../src/models/model_generator/contract_customer.dart';
import '../../../../src/models/model_generator/customer_clue.dart';
import '../../../../src/models/model_generator/job_customer.dart';
import '../../../../src/src_index.dart';
import '../../../../widgets/appbar_base.dart';
import '../../../../widgets/dialog_call.dart';
import '../../../../widgets/listview/list_load_infinity.dart';
import '../../../../widgets/loading_api.dart';
import '../../../../widgets/show_thao_tac.dart';
import '../../attachment/attachment.dart';
import 'package:gen_crm/screens/menu/home/support/widget/support_card_widget.dart';

import '../contract/widget/item_list_contract.dart';

class DetailCustomerScreen extends StatefulWidget {
  const DetailCustomerScreen({Key? key}) : super(key: key);

  @override
  State<DetailCustomerScreen> createState() => _DetailCustomerScreenState();
}

class _DetailCustomerScreenState extends State<DetailCustomerScreen>
    with SingleTickerProviderStateMixin {
  String _id = Get.arguments ?? '';
  String _title = '';
  late TabController _tabController;
  List<ModuleThaoTac> _list = [];
  late final ListNoteBloc _blocNote;
  late final DetailCustomerBloc _bloc;
  bool _reload = false;

  @override
  void deactivate() {
    _bloc.add(ReloadCustomerEvent());
    super.deactivate();
  }

  @override
  void initState() {
    _bloc = DetailCustomerBloc(
        userRepository: DetailCustomerBloc.of(context).userRepository);
    _blocNote =
        ListNoteBloc(userRepository: ListNoteBloc.of(context).userRepository);
    _bloc.initController(_id);
    _tabController = TabController(length: 6, vsync: this);
    super.initState();
  }

  _getThaoTac() {
    _list = [];
    if (_bloc.sdt != null && _bloc.sdt != '')
      _list.add(
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

    _list.add(
      ModuleThaoTac(
        title:
            '${getT(KeyT.add)} ${ModuleMy.getNameModuleMy(ModuleMy.DAU_MOI)}',
        icon: ICONS.IC_ADD_CLUE_SVG,
        onThaoTac: () {
          Get.back();
          AppNavigator.navigateForm(
            title:
                '${getT(KeyT.add)} ${ModuleMy.getNameModuleMy(ModuleMy.DAU_MOI)}',
            type: ADD_CLUE_CUSTOMER,
            id: int.parse(_id),
            onRefreshForm: () {
              _bloc.controllerDM.reloadData();
            },
          );
        },
      ),
    );

    _list.add(ModuleThaoTac(
      title: '${getT(KeyT.add)} ${ModuleMy.getNameModuleMy(ModuleMy.LICH_HEN)}',
      icon: ICONS.IC_ADD_CHANCE_SVG,
      onThaoTac: () {
        Get.back();
        AppNavigator.navigateForm(
          title:
              '${getT(KeyT.add)} ${ModuleMy.getNameModuleMy(ModuleMy.LICH_HEN)}',
          type: ADD_CHANCE_CUSTOMER,
          id: int.parse(_id),
          onRefreshForm: () {
            _bloc.controllerCH.reloadData();
          },
        );
      },
    ));

    _list.add(ModuleThaoTac(
      title: '${getT(KeyT.add)} ${ModuleMy.getNameModuleMy(ModuleMy.HOP_DONG)}',
      icon: ICONS.IC_ADD_CONTRACT_SVG,
      onThaoTac: () {
        Get.back();
        AppNavigator.navigateForm(
          title:
              '${getT(KeyT.add)} ${ModuleMy.getNameModuleMy(ModuleMy.HOP_DONG)}',
          type: ADD_CONTRACT_CUS,
          id: int.tryParse(_id),
          onRefreshForm: () {
            _bloc.controllerHD.reloadData();
          },
        );
      },
    ));

    _list.add(ModuleThaoTac(
      title:
          '${getT(KeyT.add)} ${ModuleMy.getNameModuleMy(ModuleMy.CONG_VIEC)}',
      icon: ICONS.IC_ADD_WORD_SVG,
      onThaoTac: () {
        Get.back();
        AppNavigator.navigateForm(
          title:
              '${getT(KeyT.add)} ${ModuleMy.getNameModuleMy(ModuleMy.CONG_VIEC)}',
          type: ADD_JOB_CUSTOMER,
          id: int.parse(_id),
          onRefreshForm: () {
            _bloc.controllerCV.reloadData();
          },
        );
      },
    ));

    _list.add(ModuleThaoTac(
      title: '${getT(KeyT.add)} ${ModuleMy.getNameModuleMy(ModuleMy.CSKH)}',
      icon: ICONS.IC_ADD_SUPPORT_SVG,
      onThaoTac: () {
        Get.back();
        AppNavigator.navigateForm(
          title: '${getT(KeyT.add)} ${ModuleMy.getNameModuleMy(ModuleMy.CSKH)}',
          type: ADD_SUPPORT_CUSTOMER,
          id: int.parse(_id),
          onRefreshForm: () {
            _bloc.controllerHT.reloadData();
          },
        );
      },
    ));

    _list.add(ModuleThaoTac(
      title: getT(KeyT.add_discuss),
      icon: ICONS.IC_ADD_DISCUSS_SVG,
      onThaoTac: () {
        Get.back();
        AppNavigator.navigateAddNoteScreen(Module.KHACH_HANG, _id,
            onRefresh: () {
          _blocNote.add(RefreshEvent());
        });
      },
    ));

    _list.add(ModuleThaoTac(
      title: getT(KeyT.see_attachment),
      icon: ICONS.IC_ATTACK_SVG,
      onThaoTac: () async {
        Get.back();
        Navigator.of(context).push(MaterialPageRoute(
            builder: (context) => Attachment(
                  id: _id,
                  typeModule: Module.KHACH_HANG,
                )));
      },
    ));

    _list.add(ModuleThaoTac(
      title: getT(KeyT.edit),
      icon: ICONS.IC_EDIT_SVG,
      onThaoTac: () {
        Get.back();
        AppNavigator.navigateForm(
          type: EDIT_CUSTOMER,
          id: int.tryParse(_id),
          onRefreshForm: () {
            _reload = true;
            _bloc.add(InitGetDetailCustomerEvent(int.parse(_id)));
          },
        );
      },
    ));

    _list.add(ModuleThaoTac(
      title: getT(KeyT.delete),
      icon: ICONS.IC_DELETE_SVG,
      onThaoTac: () {
        ShowDialogCustom.showDialogBase(
          onTap2: () => _bloc.add(DeleteCustomerEvent(int.parse(_id))),
          content: getT(KeyT.are_you_sure_you_want_to_delete),
        );
      },
    ));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppbarBaseNormal(_title, reload: _reload),
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
              _title = checkTitle(state.customerInfo, 'ten_khach_hang');
              _getThaoTac();
              setState(() {});
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
                fontFamily: 'Quicksand',
                fontSize: 14,
                fontWeight: FontWeight.w700,
              ),
              indicatorColor: COLORS.ff006CB1,
              tabs: <Widget>[
                Tab(
                  text: getT(KeyT.information),
                ),
                Tab(
                  text: ModuleMy.getNameModuleMy(
                    ModuleMy.DAU_MOI,
                    isTitle: true,
                  ),
                ),
                Tab(
                  text: ModuleMy.getNameModuleMy(
                    ModuleMy.LICH_HEN,
                    isTitle: true,
                  ),
                ),
                Tab(
                  text: ModuleMy.getNameModuleMy(
                    ModuleMy.HOP_DONG,
                    isTitle: true,
                  ),
                ),
                Tab(
                  text: ModuleMy.getNameModuleMy(
                    ModuleMy.CONG_VIEC,
                    isTitle: true,
                  ),
                ),
                Tab(
                  text: ModuleMy.getNameModuleMy(
                    ModuleMy.CSKH,
                    isTitle: true,
                  ),
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
                        id: _id,
                        blocNote: _blocNote,
                        bloc: _bloc,
                      ),
                      ViewLoadMoreBase(
                        functionInit: (page, isInit) {
                          return _bloc.getClueCustomer(
                            id: int.parse(_id),
                            page: page,
                            isInit: isInit,
                          );
                        },
                        itemWidget: (int index, data) {
                          return ClueCardWidget(
                            data: data,
                            onTap: () {
                              AppNavigator.navigateDetailClue(
                                data.id ?? '',
                                onRefreshForm: () {
                                  _bloc.controllerDM.reloadData();
                                },
                              );
                            },
                          );
                        },
                        controller: _bloc.controllerDM,
                      ),
                      ViewLoadMoreBase(
                        functionInit: (page, isInit) {
                          return _bloc.getChanceCustomer(
                              id: int.parse(_id), page: page, isInit: isInit);
                        },
                        itemWidget: (int index, data) {
                          return ChanceCardWidget(
                            data: data,
                            onTap: () {
                              AppNavigator.navigateDetailChance(
                                data.id ?? '',
                                onRefreshForm: () {
                                  _bloc.controllerCH.reloadData();
                                },
                              );
                            },
                          );
                        },
                        controller: _bloc.controllerCH,
                      ),
                      ViewLoadMoreBase(
                        functionInit: (page, isInit) {
                          return _bloc.getContractCustomer(
                            id: int.parse(_id),
                            page: page,
                            isInit: isInit,
                          );
                        },
                        itemWidget: (int index, data) {
                          ContractCustomerData snap = data;
                          return ItemContract(
                            onRefreshForm: () {
                              _bloc.controllerHD.reloadData();
                            },
                            data: ContractItemData(
                              snap.id,
                              snap.name,
                              snap.total_value,
                              snap.status,
                              null,
                              snap.color,
                              null,
                              Customer(
                                null,
                                snap.customer_name,
                                null,
                              ),
                              snap.product_customer,
                              snap.total_note,
                              null,
                            ),
                          );
                        },
                        controller: _bloc.controllerHD,
                      ),
                      ViewLoadMoreBase(
                        functionInit: (page, isInit) {
                          return _bloc.getJobCustomer(
                            id: int.parse(_id),
                            page: page,
                            isInit: isInit,
                          );
                        },
                        itemWidget: (int index, data) {
                          JobCustomerData item = data as JobCustomerData;
                          return WorkCardWidget(
                            data: item,
                            onTap: () {
                              AppNavigator.navigateDetailWork(
                                  int.tryParse(item.id ?? '') ?? 0,
                                  onRefreshForm: () {
                                _bloc.controllerCV.reloadData();
                              });
                            },
                          );
                        },
                        controller: _bloc.controllerCV,
                      ),
                      ViewLoadMoreBase(
                        functionInit: (page, isInit) {
                          return _bloc.getSupportCustomer(
                            id: int.parse(_id),
                            page: page,
                            isInit: isInit,
                          );
                        },
                        itemWidget: (int index, data) {
                          return SupportCardWidget(
                            data: data,
                            onTap: () {
                              AppNavigator.navigateDetailSupport(data.id ?? '',
                                  onRefreshForm: () {
                                _bloc.controllerHT.reloadData();
                              });
                            },
                          );
                        },
                        controller: _bloc.controllerHT,
                      ),
                    ],
                  ),
                ),
                BlocBuilder<DetailCustomerBloc, DetailCustomerState>(
                  bloc: _bloc,
                  builder: (context, state) {
                    if (state is UpdateGetDetailCustomerState)
                      return ButtonThaoTac(onTap: () {
                        showThaoTac(context, _list);
                      });
                    return ButtonThaoTac(disable: true, onTap: () {});
                  },
                ),
              ],
            ),
          ),
        ));
  }
}
