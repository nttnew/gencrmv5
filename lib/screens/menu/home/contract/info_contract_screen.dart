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
import 'package:gen_crm/src/models/model_generator/attach_file.dart';
import 'package:gen_crm/widgets/widget_button.dart';
import 'package:gen_crm/widgets/widget_input.dart';
import 'package:gen_crm/widgets/widget_line.dart';
import 'package:get/get.dart';
import 'package:get/get_connect/http/src/utils/utils.dart';

import '../../../../bloc/job_contract/job_contract_bloc.dart';
import '../../../../bloc/support_contract_bloc/support_contract_bloc.dart';
import '../../../../src/src_index.dart';
import '../../../../widgets/widget_appbar.dart';
import '../../../../widgets/widget_dialog.dart';

class InfoContractPage extends StatefulWidget {
  const InfoContractPage({Key? key}) : super(key: key);

  @override
  State<InfoContractPage> createState() => _InfoContractPageState();
}

class _InfoContractPageState extends State<InfoContractPage> {
  String id = Get.arguments[0];
  String name = Get.arguments[1];
  List<AttachFile> listFile = [];

  @override
  void initState() {
    Future.delayed(Duration(milliseconds: 100), () {
      DetailContractBloc.of(context).add(InitGetDetailContractEvent(int.parse(id)));
      PaymentContractBloc.of(context).add(InitGetPaymentContractEvent(int.parse(id)));
      JobContractBloc.of(context).add(InitGetJobContractEvent(int.parse(id)));
      SupportContractBloc.of(context).add(InitGetSupportContractEvent(int.parse(id)));
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
                  content: "Th??nh c??ng",
                  textButton1: "OK",
                  backgroundButton1: COLORS.PRIMARY_COLOR,
                  onTap1: () {
                    Get.back();
                    Get.back();
                    Get.back();
                    Get.back();
                    ContractBloc.of(context).add(InitGetContractEvent(1, "", ""));
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
                  textButton1: "Quay l???i",
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
                    child: Scaffold(
                      appBar: const TabBar(
                        isScrollable: true,
                        automaticIndicatorColorAdjustment: true,
                        indicatorColor: COLORS.TEXT_COLOR,
                        labelColor: COLORS.TEXT_COLOR,
                        unselectedLabelColor: COLORS.GREY,
                        labelStyle: AppStyle.DEFAULT_LABEL_TARBAR,
                        tabs: [
                          Tab(
                            text: 'Th??ng tin chung',
                          ),
                          Tab(
                            text: 'Thanh to??n',
                          ),
                          Tab(
                            text: 'C??ng vi???c',
                          ),
                          Tab(
                            text: 'H??? tr???',
                          ),
                        ],
                      ),
                      body: TabBarView(
                        // physics: NeverScrollableScrollPhysics(),
                        children: [
                          ContractOperation(
                            id: id,
                          ),
                          ContractPayment(id: int.parse(id)),
                          ContractJob(id: int.parse(id)),
                          ContractSupport(id: id),
                        ],
                      ),
                    )),
              ),
            )
          ],
        ),
      ),
      bottomNavigationBar: BlocBuilder<DetailContractBloc, DetailContractState>(
        builder: (context, state) {
          if (state is SuccessDetailContractState) {
            listFile = state.listDetailContract[0].listFile ?? [];
          }
          return WidgetButton(
            text: 'Thao T??c',
            onTap: () {
              showModalBottomSheet(
                  // isDismissible: false,
                  enableDrag: false,
                  context: context,
                  builder: (BuildContext context) {
                    return Container(
                      height: AppValue.heights * 0.45,
                      padding: EdgeInsets.symmetric(vertical: 25, horizontal: 30),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              AppValue.hSpaceLarge,
                              Image.asset('assets/icons/Support.png'),
                              SizedBox(width: 10),
                              InkWell(
                                  onTap: () {
                                    Get.back();
                                    AppNavigator.navigateFormAdd('Th??m h??? tr???', 41, id: int.parse(id));
                                  },
                                  child: Text(
                                    'Th??m h??? tr???',
                                    style: AppStyle.DEFAULT_16_BOLD.copyWith(color: Color(0xff006CB1)),
                                  ))
                            ],
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              AppValue.hSpaceLarge,
                              Image.asset('assets/icons/addWork.png'),
                              SizedBox(width: 10),
                              InkWell(
                                  onTap: () {
                                    Get.back();
                                    AppNavigator.navigateFormAdd('Th??m c??ng vi???c', 42, id: int.parse(id));
                                  },
                                  child: Text(
                                    'Th??m c??ng vi???c',
                                    style: AppStyle.DEFAULT_16_BOLD.copyWith(color: Color(0xff006CB1)),
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
                                Image.asset('assets/icons/addContent.png'),
                                SizedBox(width: 10),
                                Text(
                                  'Th??m th???o lu???n',
                                  style: AppStyle.DEFAULT_16_BOLD.copyWith(color: Color(0xff006CB1)),
                                )
                              ],
                            ),
                          ),
                          GestureDetector(
                            onTap: () {
                              Get.back();
                              AppNavigator.navigateAttachment(id, name, listFile);
                            },
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: [
                                AppValue.hSpaceLarge,
                                SvgPicture.asset('assets/icons/attack.svg'),
                                SizedBox(width: 10),
                                Text(
                                  'Xem ????nh k??m',
                                  style: AppStyle.DEFAULT_16_BOLD.copyWith(color: Color(0xff006CB1)),
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
                                Image.asset('assets/icons/edit.png'),
                                SizedBox(width: 10),
                                Text(
                                  'S???a',
                                  style: AppStyle.DEFAULT_16_BOLD.copyWith(color: Color(0xff006CB1)),
                                )
                              ],
                            ),
                          ),
                          GestureDetector(
                            onTap: () {
                              ShowDialogCustom.showDialogTwoButton(onTap2: () => DetailContractBloc.of(context).add(InitDeleteContractEvent(int.parse(id))), content: "B???n ch???c ch???n mu???n x??a kh??ng ?");
                            },
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: [
                                AppValue.hSpaceLarge,
                                Image.asset('assets/icons/remove.png'),
                                SizedBox(width: 10),
                                Text(
                                  'X??a',
                                  style: AppStyle.DEFAULT_16_BOLD.copyWith(color: Color(0xff006CB1)),
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
                                child: Text('????ng', style: AppStyle.DEFAULT_16_BOLD),
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
        ICONS.ICON_BACK,
        height: 28,
        width: 28,
        color: COLORS.BLACK,
      ),
    );
  }

  _buildContent1() {
    return Container(
      height: AppValue.heights * 0.22,
      padding: EdgeInsets.only(bottom: 10),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          WidgetLine(
            color: Colors.grey,
          ),
          Text(
            'Nh??m n???i dung 1',
            style: AppStyle.DEFAULT_16_BOLD,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'H??? v?? t??n',
                style: AppStyle.DEFAULT_14.copyWith(color: Colors.grey),
              ),
              Text('Ho??ng Th??? Ho??i Lan', style: AppStyle.DEFAULT_14)
            ],
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Kh??ch h??ng',
                style: AppStyle.DEFAULT_14.copyWith(color: Colors.grey),
              ),
              Text('C??ng ty H??? G????m Audio', style: AppStyle.DEFAULT_14)
            ],
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Doanh s???',
                style: AppStyle.DEFAULT_14.copyWith(color: Colors.grey),
              ),
              Text('123.456.789vn??', style: AppStyle.DEFAULT_14.copyWith(color: Colors.red))
            ],
          ),
          WidgetLine(
            color: Colors.grey,
          )
        ],
      ),
    );
  }

  _buildContent2() {
    return Container(
      height: AppValue.heights * 0.18,
      padding: EdgeInsets.symmetric(vertical: 10),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Nh??m n???i dung 2',
            style: AppStyle.DEFAULT_16_BOLD,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                '?????a ch???',
                style: AppStyle.DEFAULT_14.copyWith(color: Colors.grey),
              ),
              Text('298 C???u gi???y', style: AppStyle.DEFAULT_14)
            ],
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                '??i???n tho???i',
                style: AppStyle.DEFAULT_14.copyWith(color: Colors.grey),
              ),
              Text('0983 123 456', style: AppStyle.DEFAULT_14)
            ],
          ),
          WidgetLine(
            color: Colors.grey,
          )
        ],
      ),
    );
  }

  _discuss() {
    return ListView.separated(
      shrinkWrap: true,
      // physics: NeverScrollableScrollPhysics(),
      itemCount: 2,
      itemBuilder: (context, index) {
        return Row(
          children: [
            Padding(
              padding: EdgeInsets.only(bottom: AppValue.heights * 0.1),
              child: CircleAvatar(
                backgroundImage: AssetImage('assets/images/img-1.png'),
              ),
            ),
            AppValue.hSpaceTiny,
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Nguy???n Ho??ng Nam',
                    style: AppStyle.DEFAULT_14.copyWith(fontWeight: FontWeight.w600),
                  ),
                  Text(
                    '20/03/2022 l??c 05:15 PM',
                    style: AppStyle.DEFAULT_12.copyWith(color: Color(0xff838A91)),
                  ),
                  SizedBox(
                    height: 4,
                  ),
                  Text(
                    'Ch??? Th???o mu???n nh???n b??o gi?? c?? ??u ????i. N???u gi?? t???t s??? b???t ?????u tri???n khai ngay v??o ?????u th??ng t???i. Ch?? ??: g???i b??o gi?? c??? b???n c???ng v?? b???n m???m cho ch???.',
                    style: AppStyle.DEFAULT_14.copyWith(fontWeight: FontWeight.w500),
                  )
                ],
              ),
            )
          ],
        );
      },
      separatorBuilder: (BuildContext context, int index) => const SizedBox(
        height: 8,
      ),
    );
  }

  _tabBarSupport() {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 10, vertical: 5),
      child: Container(
        height: AppValue.heights * 0.3,
        padding: EdgeInsets.symmetric(horizontal: 15, vertical: 20),
        width: AppValue.widths,
        decoration: BoxDecoration(
          color: COLORS.WHITE,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(width: 1, color: Colors.white),
          boxShadow: [
            BoxShadow(
              color: COLORS.BLACK.withOpacity(0.1),
              spreadRadius: 1,
              blurRadius: 5,
            )
          ],
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  child: Text(
                    'H???n g???p ch??? Lan ????? demo gi???i thi???u s???n ph???m phi??n b???n m???i n??m 2022',
                    style: AppStyle.DEFAULT_TITLE_PRODUCT.copyWith(color: COLORS.TEXT_COLOR),
                  ),
                  width: AppValue.widths * 0.7,
                ),
                Row(
                  children: [
                    SvgPicture.asset(
                      'assets/icons/User.svg',
                      color: Color(0xffE75D18),
                    ),
                    AppValue.hSpaceTiny,
                    Text('Anh Trung Duc', style: AppStyle.DEFAULT_LABEL_PRODUCT),
                  ],
                ),
                Row(
                  children: [
                    SvgPicture.asset('assets/icons/dangxuly.svg'),
                    AppValue.hSpaceTiny,
                    Text(
                      'Dang thuc hien',
                      style: AppStyle.DEFAULT_LABEL_PRODUCT.copyWith(color: Colors.red),
                    ),
                  ],
                ),
                Row(
                  children: [
                    Image.asset('assets/icons/date.png'),
                    AppValue.hSpaceTiny,
                    Text('20/05/2022', style: AppStyle.DEFAULT_LABEL_PRODUCT.copyWith(color: Colors.grey)),
                  ],
                ),
              ],
            ),
            Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [Image.asset('assets/icons/red.png'), SvgPicture.asset('assets/icons/Mess.svg')],
            ),
          ],
        ),
      ),
    );
  }
}
