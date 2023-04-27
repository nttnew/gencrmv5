import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:flutter/material.dart';
import 'package:gen_crm/bloc/contract/contract_bloc.dart';
import 'package:gen_crm/bloc/contract/detail_contract_bloc.dart';
import 'package:gen_crm/bloc/payment_contract/payment_contract_bloc.dart';
import 'package:gen_crm/screens/menu/home/contract/contract_job.dart';
import 'package:gen_crm/screens/menu/home/contract/contract_operation.dart';
import 'package:gen_crm/screens/menu/home/contract/contract_payment.dart';
import 'package:gen_crm/screens/menu/home/contract/contract_support.dart';
import 'package:gen_crm/widgets/widget_button.dart';
import 'package:get/get.dart';

import '../../../../bloc/job_contract/job_contract_bloc.dart';
import '../../../../bloc/support_contract_bloc/support_contract_bloc.dart';
import '../../../../src/models/model_generator/file_response.dart';
import '../../../../src/src_index.dart';
import '../../../../widgets/widget_appbar.dart';
import '../../../../widgets/widget_dialog.dart';
import '../../attachment/attachment.dart';

class InfoContractPage extends StatefulWidget {
  const InfoContractPage({Key? key}) : super(key: key);

  @override
  State<InfoContractPage> createState() => _InfoContractPageState();
}

class _InfoContractPageState extends State<InfoContractPage> {
  String id = Get.arguments[0];
  String name = Get.arguments[1];
  @override
  void initState() {
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: BlocListener<DetailContractBloc, DetailContractState>(
        listener: (context, state) async {
          if (state is SuccessDeleteContractState) {
            showDialog(
              context: context,
              builder: (BuildContext context) {
                return WidgetDialog(
                  title: MESSAGES.NOTIFICATION,
                  content: "Thành công",
                  textButton1: MESSAGES.OKE,
                  backgroundButton1: COLORS.PRIMARY_COLOR,
                  onTap1: () {
                    Get.back();
                    Get.back();
                    Get.back();
                    Get.back();
                    ContractBloc.of(context)
                        .add(InitGetContractEvent(1, "", ""));
                  },
                );
              },
            );
          } else if (state is ErrorDeleteContractState) {
            showDialog(
              context: context,
              builder: (BuildContext context) {
                return WidgetDialog(
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
                      ],
                    )),
              ),
            )
          ],
        ),
      ),
      bottomNavigationBar: BlocBuilder<DetailContractBloc, DetailContractState>(
        builder: (context, state) {
          return WidgetButton(
            text: 'Thao Tác',
            onTap: () {
              showModalBottomSheet(
                  // isDismissible: false,
                  enableDrag: false,
                  context: context,
                  builder: (BuildContext context) {
                    return Container(
                      height: AppValue.heights * 0.45,
                      padding:
                          EdgeInsets.symmetric(vertical: 25, horizontal: 30),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              AppValue.hSpaceLarge,
                              Image.asset(ICONS.IC_SUPPORT_PNG),
                              SizedBox(width: 10),
                              InkWell(
                                  onTap: () {
                                    Get.back();
                                    AppNavigator.navigateFormAdd(
                                        'Thêm hỗ trợ', 41,
                                        id: int.parse(id));
                                  },
                                  child: Text(
                                    'Thêm hỗ trợ',
                                    style: AppStyle.DEFAULT_16_BOLD
                                        .copyWith(color: Color(0xff006CB1)),
                                  ))
                            ],
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              AppValue.hSpaceLarge,
                              Image.asset(ICONS.IC_WORK_PNG),
                              SizedBox(width: 10),
                              InkWell(
                                  onTap: () {
                                    Get.back();
                                    AppNavigator.navigateFormAdd(
                                        'Thêm công việc', 42,
                                        id: int.parse(id));
                                  },
                                  child: Text(
                                    'Thêm công việc',
                                    style: AppStyle.DEFAULT_16_BOLD
                                        .copyWith(color: Color(0xff006CB1)),
                                  ))
                            ],
                          ),
                          GestureDetector(
                            onTap: () {
                              Get.back();
                              AppNavigator.navigateAddNoteScreen(4, id);
                            },
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: [
                                AppValue.hSpaceLarge,
                                Image.asset(ICONS.IC_CONTENT_PNG),
                                SizedBox(width: 10),
                                Text(
                                  'Thêm thảo luận',
                                  style: AppStyle.DEFAULT_16_BOLD
                                      .copyWith(color: Color(0xff006CB1)),
                                )
                              ],
                            ),
                          ),
                          GestureDetector(
                            onTap: () {
                              Get.back();
                              Navigator.of(context).push(MaterialPageRoute(
                                  builder: (context) => Attachment(
                                        id: id,
                                        typeModule: Module.HOP_DONG,
                                      )));
                            },
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: [
                                AppValue.hSpaceLarge,
                                SvgPicture.asset(ICONS.IC_ATTACK_SVG),
                                SizedBox(width: 10),
                                Text(
                                  'Xem đính kèm',
                                  style: AppStyle.DEFAULT_16_BOLD
                                      .copyWith(color: Color(0xff006CB1)),
                                )
                              ],
                            ),
                          ),
                          GestureDetector(
                            onTap: () {
                              Get.back();
                              AppNavigator.navigateEditContractScreen(id);
                            },
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: [
                                AppValue.hSpaceLarge,
                                Image.asset(ICONS.IC_EDIT_2_PNG),
                                SizedBox(width: 10),
                                Text(
                                  'Sửa',
                                  style: AppStyle.DEFAULT_16_BOLD
                                      .copyWith(color: Color(0xff006CB1)),
                                )
                              ],
                            ),
                          ),
                          GestureDetector(
                            onTap: () {
                              ShowDialogCustom.showDialogTwoButton(
                                  onTap2: () => DetailContractBloc.of(context)
                                      .add(InitDeleteContractEvent(
                                          int.parse(id))),
                                  content: "Bạn chắc chắn muốn xóa không ?");
                            },
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: [
                                AppValue.hSpaceLarge,
                                Image.asset(ICONS.IC_REMOVE_PNG),
                                SizedBox(width: 10),
                                Text(
                                  'Xóa',
                                  style: AppStyle.DEFAULT_16_BOLD
                                      .copyWith(color: Color(0xff006CB1)),
                                )
                              ],
                            ),
                          ),
                          GestureDetector(
                            onTap: () => AppNavigator.navigateBack(),
                            child: Container(
                              width: AppValue.widths,
                              height: 40,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(15),
                                color: COLORS.PRIMARY_COLOR,
                              ),
                              child: Center(
                                child: Text('Đóng',
                                    style: AppStyle.DEFAULT_16_BOLD),
                              ),
                            ),
                          )
                        ],
                      ),
                    );
                  });
            },
            textColor: Colors.black,
            backgroundColor: COLORS.PRIMARY_COLOR,
            height: 40,
            padding: EdgeInsets.only(left: 20, right: 20, bottom: 10),
          );
        },
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
