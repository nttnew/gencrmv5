import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter/material.dart';
import 'package:gen_crm/bloc/contract/contract_bloc.dart';
import 'package:gen_crm/bloc/contract/detail_contract_bloc.dart';
import 'package:gen_crm/screens/menu/home/contract/widget/contract_operation.dart';
import 'package:gen_crm/screens/menu/home/contract/widget/contract_payment.dart';
import 'package:gen_crm/widgets/btn_thao_tac.dart';
import 'package:get/get.dart';
import '../../../../bloc/list_note/list_note_bloc.dart';
import '../../../../bloc/payment_contract/payment_contract_bloc.dart';
import '../../../../l10n/key_text.dart';
import '../../../../src/app_const.dart';
import '../../../../src/models/model_generator/customer_clue.dart';
import '../../../../src/models/model_generator/detail_contract.dart';
import '../../../../src/models/model_generator/job_chance.dart';
import '../../../../src/models/model_generator/support.dart';
import '../../../../src/src_index.dart';
import '../../../../widgets/appbar_base.dart';
import '../../../../widgets/listview/list_load_infinity.dart';
import '../../../../widgets/loading_api.dart';
import '../../../../widgets/show_thao_tac.dart';
import '../../attachment/attachment.dart';
import '../clue/widget/work_card_widget.dart';
import '../support/widget/item_support.dart';

class DetailInfoContract extends StatefulWidget {
  const DetailInfoContract({Key? key}) : super(key: key);

  @override
  State<DetailInfoContract> createState() => _DetailInfoContractState();
}

class _DetailInfoContractState extends State<DetailInfoContract> {
  String _id = Get.arguments ?? '';
  String _title = '';
  List<ModuleThaoTac> _list = [];
  late final DetailContractBloc _bloc;
  late final ListNoteBloc _blocNote;
  bool _reload = false;

  @override
  void initState() {
    getThaoTac();
    PaymentContractBloc.of(context).add(
      InitGetPaymentContractEvent(
        int.parse(_id),
        isLoad: false,
      ),
    );
    _bloc = DetailContractBloc(
        userRepository: DetailContractBloc.of(context).userRepository);
    _blocNote =
        ListNoteBloc(userRepository: ListNoteBloc.of(context).userRepository);
    super.initState();
  }

  getThaoTac() {
    _list.add(ModuleThaoTac(
      title: getT(KeyT.sign),
      icon: ICONS.IC_ELECTRIC_SIGN_PNG,
      isSvg: false,
      onThaoTac: () {
        Get.back();
        AppNavigator.navigateFormSign(
          getT(KeyT.sign),
          _id,
          onRefreshForm: () {
            _bloc.add(InitGetDetailContractEvent(int.tryParse(_id) ?? 0));
            PaymentContractBloc.of(context)
                .add(InitGetPaymentContractEvent(int.tryParse(_id) ?? 0));
          },
        );
      },
    ));

    _list.add(ModuleThaoTac(
      title: getT(KeyT.add_payment),
      icon: ICONS.IC_ADD_PAYMENT_PNG,
      isSvg: false,
      onThaoTac: () {
        Get.back();
        AppNavigator.navigateForm(
          title: getT(KeyT.add_payment),
          type: ADD_PAYMENT,
          id: int.tryParse(_id),
          onRefreshForm: () {
            _bloc.add(InitGetDetailContractEvent(int.tryParse(_id) ?? 0));
            PaymentContractBloc.of(context)
                .add(InitGetPaymentContractEvent(int.tryParse(_id) ?? 0));
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
          type: ADD_JOB_CONTRACT,
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
          type: ADD_SUPPORT_CONTRACT,
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
        AppNavigator.navigateAddNoteScreen(Module.HOP_DONG, _id, onRefresh: () {
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
                  typeModule: Module.HOP_DONG,
                )));
      },
    ));

    _list.add(ModuleThaoTac(
      title: getT(KeyT.edit),
      icon: ICONS.IC_EDIT_SVG,
      onThaoTac: () {
        Get.back();
        AppNavigator.navigateForm(
          type: EDIT_CONTRACT,
          id: int.tryParse(_id),
          onRefreshForm: () {
            _reload = true;
            _bloc.add(InitGetDetailContractEvent(int.parse(_id)));
          },
        );
      },
    ));

    _list.add(ModuleThaoTac(
      title: getT(KeyT.delete),
      icon: ICONS.IC_DELETE_SVG,
      onThaoTac: () {
        ShowDialogCustom.showDialogBase(
          onTap2: () => _bloc.add(InitDeleteContractEvent(int.parse(_id))),
          content: getT(KeyT.are_you_sure_you_want_to_delete),
        );
      },
    ));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: BlocListener<DetailContractBloc, DetailContractState>(
        bloc: _bloc,
        listener: (context, state) async {
          if (state is SuccessDeleteContractState) {
            LoadingApi().popLoading();
            ShowDialogCustom.showDialogBase(
              title: getT(KeyT.notification),
              content: getT(KeyT.success),
              onTap1: () {
                Get.back();
                Get.back();
                Get.back();
                Get.back(result: true);
                ContractBloc.of(context).loadMoreController.reloadData();
              },
            );
          } else if (state is ErrorDeleteContractState) {
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
          }
        },
        child: Column(
          children: [
            AppbarBaseNormal(
              _title,
              reload: _reload,
              widgetRight: GestureDetector(
                onTap: () {
                  AppNavigator.navigateDetailCarMain(_id);
                },
                child: Padding(
                  padding: const EdgeInsets.only(
                    right: 16,
                  ),
                  child: Image.asset(
                    ICONS.IC_SHOW_PNG,
                    height: 20,
                    width: 20,
                    color: COLORS.WHITE,
                  ),
                ),
              ),
            ),
            AppValue.vSpaceTiny,
            Expanded(
              child: DefaultTabController(
                  length: 4,
                  child: Column(
                    children: [
                      Align(
                        alignment: Alignment.centerLeft,
                        child: TabBar(
                          padding: EdgeInsets.symmetric(
                            horizontal: 16,
                          ),
                          isScrollable: true,
                          automaticIndicatorColorAdjustment: true,
                          indicatorColor: COLORS.TEXT_COLOR,
                          labelColor: COLORS.TEXT_COLOR,
                          unselectedLabelColor: COLORS.GREY,
                          labelStyle: AppStyle.DEFAULT_LABEL_TARBAR,
                          tabs: [
                            Tab(
                              text: getT(KeyT.information),
                            ),
                            Tab(
                              text: getT(KeyT.pay),
                            ),
                            Tab(
                              text: ModuleMy.getNameModuleMy(ModuleMy.CONG_VIEC,
                                  isTitle: true),
                            ),
                            Tab(
                              text: ModuleMy.getNameModuleMy(ModuleMy.CSKH,
                                  isTitle: true),
                            ),
                          ],
                        ),
                      ),
                      Expanded(
                        child: TabBarView(
                          children: [
                            ContractOperation(
                              id: _id,
                              bloc: _bloc,
                              blocNote: _blocNote,
                            ),
                            ContractPayment(
                              id: int.parse(_id),
                              bloc: _bloc,
                            ),
                            Padding(
                              padding: const EdgeInsets.only(
                                top: 8,
                              ),
                              child: ViewLoadMoreBase(
                                functionInit: (page, isInit) {
                                  return _bloc.getJobContract(
                                    id: int.parse(_id),
                                    page: page,
                                    isInit: isInit,
                                  );
                                },
                                itemWidget: (int index, data) {
                                  final DataFormAdd item = data as DataFormAdd;
                                  return GestureDetector(
                                    onTap: () {
                                      AppNavigator.navigateDetailWork(
                                          int.parse(data.id ?? ''),
                                          onRefreshForm: () {
                                        _bloc.controllerCV.reloadData();
                                      });
                                    },
                                    child: WorkCardWidget(
                                      color: item.color,
                                      nameCustomer: item.name_customer,
                                      nameJob: item.name_job,
                                      statusJob: item.status_job,
                                      startDate: item.start_date,
                                      totalComment: item.total_comment,
                                      productCustomer: item.product_customer,
                                    ),
                                  );
                                },
                                controller: _bloc.controllerCV,
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.only(
                                top: 8,
                              ),
                              child: ViewLoadMoreBase(
                                functionInit: (page, isInit) {
                                  return _bloc.getSupportContract(
                                    id: int.parse(_id),
                                    page: page,
                                    isInit: isInit,
                                  );
                                },
                                itemWidget: (int index, data) {
                                  final SupportContractData item =
                                      data as SupportContractData;
                                  return ItemSupport(
                                    onRefreshForm: () {
                                      _bloc.controllerHT.reloadData();
                                    },
                                    data: SupportItemData(
                                      item.id,
                                      item.name,
                                      item.created_date,
                                      item.status,
                                      item.color,
                                      item.total_note,
                                      Customer(
                                        '',
                                        data.khach_hang,
                                        '',
                                      ),
                                      item.product_customer,
                                      null,
                                    ),
                                  );
                                },
                                controller: _bloc.controllerHT,
                              ),
                            ),
                          ],
                        ),
                      ),
                      BlocBuilder<DetailContractBloc, DetailContractState>(
                        bloc: _bloc,
                        builder: (context, state) {
                          if (state is SuccessDetailContractState) {
                            _title =
                                checkTitle(state.listDetailContract, 'col121');
                            WidgetsBinding.instance
                                .addPostFrameCallback((timeStamp) {
                              setState(() {});
                            });
                            return ButtonThaoTac(onTap: () {
                              showThaoTac(context, _list);
                            });
                          }
                          return ButtonThaoTac(disable: true, onTap: () {});
                        },
                      ),
                    ],
                  )),
            )
          ],
        ),
      ),
    );
  }
}
