import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter/material.dart';
import 'package:gen_crm/bloc/contract/contract_bloc.dart';
import 'package:gen_crm/bloc/contract/detail_contract_bloc.dart';
import 'package:gen_crm/bloc/payment_contract/payment_contract_bloc.dart';
import 'package:gen_crm/screens/menu/home/contract/contract_job.dart';
import 'package:gen_crm/screens/menu/home/contract/contract_operation.dart';
import 'package:gen_crm/screens/menu/home/contract/contract_payment.dart';
import 'package:gen_crm/screens/menu/home/contract/contract_support.dart';
import 'package:gen_crm/widgets/btn_thao_tac.dart';
import 'package:get/get.dart';
import '../../../../bloc/job_contract/job_contract_bloc.dart';
import '../../../../bloc/support_contract_bloc/support_contract_bloc.dart';
import '../../../../src/src_index.dart';
import '../../../../widgets/loading_api.dart';
import '../../../../widgets/show_thao_tac.dart';
import '../../../../widgets/widget_appbar.dart';
import '../../attachment/attachment.dart';

class InfoContractPage extends StatefulWidget {
  const InfoContractPage({Key? key}) : super(key: key);

  @override
  State<InfoContractPage> createState() => _InfoContractPageState();
}

class _InfoContractPageState extends State<InfoContractPage> {
  String id = Get.arguments[0];
  String name = Get.arguments[1];
  List<ModuleThaoTac> list = [];

  @override
  void initState() {
    getThaoTac();
    Future.delayed(Duration(milliseconds: 100), () {
      DetailContractBloc.of(context)
          .add(InitGetDetailContractEvent(int.parse(id)));
      PaymentContractBloc.of(context)
          .add(InitGetPaymentContractEvent(int.parse(id)));
      JobContractBloc.of(context).add(InitGetJobContractEvent(int.parse(id)));
      SupportContractBloc.of(context)
          .add(InitGetSupportContractEvent(int.parse(id)));
    });
    super.initState();
  }

  getThaoTac() {
    list.add(ModuleThaoTac(
      title: "Thêm công việc",
      icon: ICONS.IC_ADD_WORD_SVG,
      onThaoTac: () {
        Get.back();
        AppNavigator.navigateFormAdd('Thêm công việc', 42, id: int.parse(id));
      },
    ));

    list.add(ModuleThaoTac(
      title: "Thêm hỗ trợ",
      icon: ICONS.IC_ADD_SUPPORT_SVG,
      onThaoTac: () {
        Get.back();
        AppNavigator.navigateFormAdd('Thêm hỗ trợ', 41, id: int.parse(id));
      },
    ));

    list.add(ModuleThaoTac(
      title: "Thêm thảo luận",
      icon: ICONS.IC_ADD_DISCUSS_SVG,
      onThaoTac: () {
        Get.back();
        AppNavigator.navigateAddNoteScreen(4, id);
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
                  typeModule: Module.HOP_DONG,
                )));
      },
    ));

    list.add(ModuleThaoTac(
      title: "Sửa",
      icon: ICONS.IC_EDIT_SVG,
      onThaoTac: () {
        Get.back();
        AppNavigator.navigateEditContractScreen(id);
      },
    ));

    list.add(ModuleThaoTac(
      title: "Xoá",
      icon: ICONS.IC_DELETE_SVG,
      onThaoTac: () {
        ShowDialogCustom.showDialogBase(
            onTap2: () => DetailContractBloc.of(context)
                .add(InitDeleteContractEvent(int.parse(id))),
            content: "Bạn chắc chắn muốn xóa không ?");
      },
    ));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: BlocListener<DetailContractBloc, DetailContractState>(
        listener: (context, state) async {
          if (state is SuccessDeleteContractState) {
            LoadingApi().popLoading();
            ShowDialogCustom.showDialogBase(
              title: MESSAGES.NOTIFICATION,
              content: "Thành công",
              onTap1: () {
                Get.back();
                Get.back();
                Get.back();
                Get.back();
                ContractBloc.of(context).add(InitGetContractEvent(1, "", ""));
              },
            );
          } else if (state is ErrorDeleteContractState) {
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
          }
        },
        child: Column(
          children: [
            WidgetAppbar(
              title: name,
              left: _buildBack(),
            ),
            AppValue.vSpaceTiny,
            Expanded(
              child: Padding(
                padding: EdgeInsets.symmetric(horizontal: 15),
                child: DefaultTabController(
                    length: 4,
                    child: Column(
                      children: [
                        Align(
                          alignment: Alignment.centerLeft,
                          child: const TabBar(
                            isScrollable: true,
                            automaticIndicatorColorAdjustment: true,
                            indicatorColor: COLORS.TEXT_COLOR,
                            labelColor: COLORS.TEXT_COLOR,
                            unselectedLabelColor: COLORS.GREY,
                            labelStyle: AppStyle.DEFAULT_LABEL_TARBAR,
                            tabs: [
                              Tab(
                                text: 'Thông tin chung',
                              ),
                              Tab(
                                text: 'Thanh toán',
                              ),
                              Tab(
                                text: 'Công việc',
                              ),
                              Tab(
                                text: 'Hỗ trợ',
                              ),
                            ],
                          ),
                        ),
                        Expanded(
                          child: TabBarView(
                            children: [
                              ContractOperation(
                                id: id,
                              ),
                              ContractPayment(id: int.parse(id)),
                              ContractJob(id: int.parse(id)),
                              ContractSupport(id: id),
                            ],
                          ),
                        ),
                        BlocBuilder<DetailContractBloc, DetailContractState>(
                          builder: (context, state) {
                            return Padding(
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 9),
                              child: ButtonThaoTac(onTap: () {
                                showThaoTac(context, list);
                              }),
                            );
                          },
                        )
                      ],
                    )),
              ),
            )
          ],
        ),
      ),
    );
  }

  _buildBack() {
    return IconButton(
      onPressed: () {
        AppNavigator.navigateBack();
      },
      icon: Image.asset(
        ICONS.IC_BACK_PNG,
        height: 28,
        width: 28,
        color: COLORS.BLACK,
      ),
    );
  }
}
