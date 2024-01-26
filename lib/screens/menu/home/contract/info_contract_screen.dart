import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:gen_crm/bloc/contract/contract_bloc.dart';
import 'package:gen_crm/bloc/contract/detail_contract_bloc.dart';
import 'package:gen_crm/screens/menu/home/contract/widget/contract_operation.dart';
import 'package:gen_crm/screens/menu/home/contract/widget/contract_payment.dart';
import 'package:gen_crm/widgets/btn_thao_tac.dart';
import 'package:get/get.dart';
import 'package:hexcolor/hexcolor.dart';
import '../../../../bloc/list_note/list_note_bloc.dart';
import '../../../../bloc/payment_contract/payment_contract_bloc.dart';
import '../../../../l10n/key_text.dart';
import '../../../../src/app_const.dart';
import '../../../../src/models/model_generator/job_chance.dart';
import '../../../../src/models/model_generator/support.dart';
import '../../../../src/src_index.dart';
import '../../../../widgets/appbar_base.dart';
import '../../../../widgets/listview_loadmore_base.dart';
import '../../../../widgets/loading_api.dart';
import '../../../../widgets/show_thao_tac.dart';
import '../../../../widgets/widget_text.dart';
import '../../attachment/attachment.dart';
import '../support/widget/item_support.dart';

class DetailInfoContract extends StatefulWidget {
  const DetailInfoContract({Key? key}) : super(key: key);

  @override
  State<DetailInfoContract> createState() => _DetailInfoContractState();
}

class _DetailInfoContractState extends State<DetailInfoContract> {
  String id = Get.arguments[0];
  String name = Get.arguments[1];
  List<ModuleThaoTac> list = [];
  late final DetailContractBloc _bloc;
  late final ListNoteBloc _blocNote;

  @override
  void initState() {
    getThaoTac();
    PaymentContractBloc.of(context)
        .add(InitGetPaymentContractEvent(int.parse(id)));
    _bloc = DetailContractBloc(
        userRepository: DetailContractBloc.of(context).userRepository);
    _blocNote =
        ListNoteBloc(userRepository: ListNoteBloc.of(context).userRepository);
    super.initState();
  }

  getThaoTac() {
    list.add(ModuleThaoTac(
      title: getT(KeyT.sign),
      icon: ICONS.IC_ELECTRIC_SIGN_PNG,
      isSvg: false,
      onThaoTac: () {
        Get.back();
        AppNavigator.navigateFormSign(getT(KeyT.sign), id);
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
            ADD_JOB_CONTRACT,
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
            ADD_SUPPORT_CONTRACT,
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
        AppNavigator.navigateAddNoteScreen(Module.HOP_DONG, id, onRefresh: () {
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
                  typeModule: Module.HOP_DONG,
                )));
      },
    ));

    list.add(ModuleThaoTac(
      title: getT(KeyT.edit),
      icon: ICONS.IC_EDIT_SVG,
      onThaoTac: () {
        Get.back();
        AppNavigator.navigateEditContractScreen(id, onRefresh: () {
          _bloc.add(InitGetDetailContractEvent(int.parse(id)));
        });
      },
    ));

    list.add(ModuleThaoTac(
      title: getT(KeyT.delete),
      icon: ICONS.IC_DELETE_SVG,
      onThaoTac: () {
        ShowDialogCustom.showDialogBase(
          onTap2: () => _bloc.add(InitDeleteContractEvent(int.parse(id))),
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
                Get.back();
                ContractBloc.of(context).add(InitGetContractEvent());
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
            AppbarBaseNormal(name),
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
                              id: id,
                              bloc: _bloc,
                              blocNote: _blocNote,
                            ),
                            ContractPayment(id: int.parse(id)),
                            Padding(
                              padding: const EdgeInsets.only(
                                top: 8,
                              ),
                              child: ListViewLoadMoreBase(
                                functionInit: (page, isInit) {
                                  return _bloc.getJobContract(
                                    id: int.parse(id),
                                    page: page,
                                    isInit: isInit,
                                  );
                                },
                                itemWidget: (int index, data) {
                                  return GestureDetector(
                                    onTap: () {
                                      AppNavigator.navigateDetailWork(
                                          int.parse(data.id ?? ''),
                                          data.name_job ?? '');
                                    },
                                    child: _tabBarWork(data),
                                  );
                                },
                                controller: _bloc.controllerCV,
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.only(
                                top: 8,
                              ),
                              child: ListViewLoadMoreBase(
                                functionInit: (page, isInit) {
                                  return _bloc.getSupportContract(
                                    id: int.parse(id),
                                    page: page,
                                    isInit: isInit,
                                  );
                                },
                                itemWidget: (int index, data) {
                                  return ItemSupport(
                                    data: SupportItemData(
                                      data.id,
                                      data.name,
                                      data.created_date,
                                      data.status,
                                      data.color,
                                      data.total_note,
                                      CustomerData(
                                        data.khach_hang,
                                        data.khach_hang,
                                      ),
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
                      ButtonThaoTac(onTap: () {
                        showThaoTac(context, list);
                      }),
                    ],
                  )),
            )
          ],
        ),
      ),
    );
  }

  _tabBarWork(DataFormAdd data) {
    return Container(
      margin: EdgeInsets.only(
        bottom: 16,
        left: 16,
        right: 16,
      ),
      padding: EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: COLORS.WHITE,
        borderRadius: BorderRadius.circular(10),
        border: Border.all(width: 1, color: COLORS.WHITE),
        boxShadow: [
          BoxShadow(
            color: COLORS.BLACK.withOpacity(0.1),
            spreadRadius: 1,
            blurRadius: 5,
          )
        ],
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Container(
                child: WidgetText(
                  title: data.name_job ?? "",
                  style: AppStyle.DEFAULT_TITLE_PRODUCT
                      .copyWith(color: COLORS.TEXT_COLOR),
                ),
                width: AppValue.widths * 0.7,
              ),
              Image.asset(
                ICONS.IC_RED_PNG,
                color: (data.color != null && data.color != "")
                    ? HexColor(data.color!)
                    : COLORS.PRIMARY_COLOR,
              )
            ],
          ),
          AppValue.vSpaceTiny,
          if (data.name_customer?.isNotEmpty ?? false) ...[
            Row(
              children: [
                SvgPicture.asset(
                  ICONS.IC_USER2_SVG,
                  color: Color(0xffE75D18),
                ),
                AppValue.hSpaceTiny,
                WidgetText(
                    title: data.name_customer ?? "",
                    style: AppStyle.DEFAULT_LABEL_PRODUCT),
              ],
            ),
            AppValue.vSpaceTiny,
          ],
          if (data.status_job?.isNotEmpty ?? false) ...[
            Row(
              children: [
                SvgPicture.asset(
                  ICONS.IC_DANG_XU_LY_SVG,
                  color: (data.color != null && data.color != "")
                      ? HexColor(data.color!)
                      : COLORS.PRIMARY_COLOR,
                ),
                AppValue.hSpaceTiny,
                WidgetText(
                  title: data.status_job ?? '',
                  style: AppStyle.DEFAULT_LABEL_PRODUCT.copyWith(
                      color: (data.color != null && data.color != "")
                          ? HexColor(data.color ?? 'fff-fff')
                          : COLORS.PRIMARY_COLOR),
                ),
              ],
            ),
            AppValue.vSpaceTiny,
          ],
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  Image.asset(
                    ICONS.IC_DATE_PNG,
                    height: 20,
                    width: 20,
                  ),
                  AppValue.hSpaceTiny,
                  WidgetText(
                      title: data.start_date ?? "",
                      style: AppStyle.DEFAULT_LABEL_PRODUCT
                          .copyWith(color: COLORS.GREY_400)),
                ],
              ),
              Row(
                children: [
                  SvgPicture.asset(ICONS.IC_MESS),
                  SizedBox(
                    width: 5,
                  ),
                  WidgetText(
                    title: data.total_comment.toString(),
                    style: AppStyle.DEFAULT_14
                        .copyWith(color: COLORS.TEXT_BLUE_BOLD),
                  )
                ],
              )
            ],
          ),
        ],
      ),
    );
  }
}
