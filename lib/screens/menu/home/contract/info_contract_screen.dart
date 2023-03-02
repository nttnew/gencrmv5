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
  String id=Get.arguments[0];
  String name=Get.arguments[1];


  @override
  void initState() {
    Future.delayed(Duration(milliseconds: 100),(){
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
      body:
      BlocListener<DetailContractBloc, DetailContractState>(
        listener: (context, state) async {
          if(state is SuccessDeleteContractState){
            showDialog(
              context: context,
              builder: (BuildContext context) {
                return WidgetDialog(
                  title: MESSAGES.NOTIFICATION,
                  content: "Thành công",
                  textButton1: "OK",
                  backgroundButton1: COLORS.PRIMARY_COLOR,
                  onTap1: (){
                    Get.back();
                    Get.back();
                    Get.back();
                    Get.back();
                    ContractBloc.of(context).add(InitGetContractEvent(1, "", ""));
                  },
                );
              },
            );
          }
          else if(state is ErrorDeleteContractState){
            showDialog(
              context: context,
              builder: (BuildContext context) {
                return WidgetDialog(
                  title: MESSAGES.NOTIFICATION,
                  content: state.msg,
                  textButton1: "Quay lại",
                  onTap1: (){
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
                          Tab(text: 'Thông tin chung',),
                          Tab(text: 'Thanh toán',),
                          Tab(text: 'Công việc',),
                          Tab(text: 'Hỗ trợ',),
                        ],
                      ),
                      body: TabBarView(
                        // physics: NeverScrollableScrollPhysics(),
                        children: [
                          ContractOperation(id: id,),
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
      bottomNavigationBar: WidgetButton(
        text: 'Thao Tác', onTap: () {
        showModalBottomSheet(
            // isDismissible: false,
            enableDrag: false,
            context: context,
            builder: (BuildContext context){
              return Container(
                height: AppValue.heights*0.45,
                padding: EdgeInsets.symmetric(vertical: 25,horizontal: 30),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        AppValue.hSpaceLarge,
                        Image.asset('assets/icons/Support.png'),SizedBox(width: 10),
                        InkWell(
                            onTap: (){
                              Get.back();
                              AppNavigator.navigateFormAdd('Thêm hỗ trợ',41,id: int.parse(id));
                            },
                            child: Text('Thêm hỗ trợ',style: AppStyle.DEFAULT_16_BOLD.copyWith(color: Color(0xff006CB1)),))
                      ],),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        AppValue.hSpaceLarge,
                        Image.asset('assets/icons/addWork.png'),SizedBox(width: 10),
                        InkWell(
                            onTap: (){
                              Get.back();
                              AppNavigator.navigateFormAdd('Thêm công việc',42,id: int.parse(id));
                            },
                            child: Text('Thêm công việc',style: AppStyle.DEFAULT_16_BOLD.copyWith(color: Color(0xff006CB1)),))
                      ],),
                    GestureDetector(
                      onTap: (){
                        Get.back();
                        AppNavigator.navigateAddNoteScreen(4, id);
                      },
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          AppValue.hSpaceLarge,
                          Image.asset('assets/icons/addContent.png'),SizedBox(width: 10),
                          Text('Thêm thảo luận',style: AppStyle.DEFAULT_16_BOLD.copyWith(color: Color(0xff006CB1)),)
                        ],),
                    ),
                    GestureDetector(
                      onTap: (){
                        Get.back();
                        AppNavigator.navigateEditContractScreen(id);
                      },
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          AppValue.hSpaceLarge,
                          Image.asset('assets/icons/edit.png'),SizedBox(width: 10),
                          Text('Sửa',style: AppStyle.DEFAULT_16_BOLD.copyWith(color: Color(0xff006CB1)),)
                        ],),
                    ),
                    GestureDetector(
                      onTap: (){
                        ShowDialogCustom.showDialogTwoButton(
                            onTap2:()=> DetailContractBloc.of(context).add(InitDeleteContractEvent(int.parse(id))),
                            content: "Bạn chắc chắn muốn xóa không ?"
                        );

                      },
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          AppValue.hSpaceLarge,
                          Image.asset('assets/icons/remove.png'),SizedBox(width: 10),
                          Text('Xóa',style: AppStyle.DEFAULT_16_BOLD.copyWith(color: Color(0xff006CB1)),)
                        ],),
                    ),
                    GestureDetector(
                      onTap: ()=>AppNavigator.navigateBack(),
                      child: Container(
                        width: AppValue.widths,height: 40,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(15),
                          color: COLORS.PRIMARY_COLOR,
                        ),
                        child: Center(child: Text('Đóng',style: AppStyle.DEFAULT_16_BOLD),),
                      ),
                    )
                  ],
                ),
              );
            }
        );
      },
        textColor: Colors.black,
        backgroundColor: COLORS.PRIMARY_COLOR,
        height: 40,
        padding: EdgeInsets.only(left: 20,right: 20,bottom: 10),
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
  _buildContent1(){
    return Container(
      height: AppValue.heights*0.22,
      padding: EdgeInsets.only(bottom: 10),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          WidgetLine(color: Colors.grey,),
          Text('Nhóm nội dung 1',style: AppStyle.DEFAULT_16_BOLD,),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text('Họ và tên',style: AppStyle.DEFAULT_14.copyWith(color: Colors.grey),),
              Text('Hoàng Thị Hoài Lan',style: AppStyle.DEFAULT_14)
            ],),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text('Khách hàng',style: AppStyle.DEFAULT_14.copyWith(color: Colors.grey),),
              Text('Công ty Hồ Gươm Audio',style: AppStyle.DEFAULT_14)
            ],),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text('Doanh số',style: AppStyle.DEFAULT_14.copyWith(color: Colors.grey),),
              Text('123.456.789vnđ',style: AppStyle.DEFAULT_14.copyWith(color: Colors.red))
            ],),
          WidgetLine(color: Colors.grey,)
        ],
      ),
    );
  }
  _buildContent2(){
    return Container(
      height: AppValue.heights*0.18,
      padding: EdgeInsets.symmetric(vertical: 10),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('Nhóm nội dung 2',style: AppStyle.DEFAULT_16_BOLD,),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text('Địa chỉ',style: AppStyle.DEFAULT_14.copyWith(color: Colors.grey),),
              Text('298 Cầu giấy',style: AppStyle.DEFAULT_14)
            ],),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text('Điện thoại',style: AppStyle.DEFAULT_14.copyWith(color: Colors.grey),),
              Text('0983 123 456',style: AppStyle.DEFAULT_14)
            ],),
          WidgetLine(color: Colors.grey,)
        ],
      ),
    );
  }
  _discuss(){
    return ListView.separated(
      shrinkWrap: true,
      // physics: NeverScrollableScrollPhysics(),
      itemCount: 2,
      itemBuilder: (context,index){
        return Row(
          children: [
            Padding(
              padding: EdgeInsets.only(bottom: AppValue.heights*0.1),
              child: CircleAvatar(
                backgroundImage: AssetImage('assets/images/img-1.png'),
              ),
            ),
            AppValue.hSpaceTiny,
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Nguyễn Hoàng Nam',style: AppStyle.DEFAULT_14.copyWith(fontWeight: FontWeight.w600),),
                  Text('20/03/2022 lúc 05:15 PM',style: AppStyle.DEFAULT_12.copyWith(color: Color(0xff838A91)),),
                  SizedBox(height: 4,),
                  Text('Chị Thảo muốn nhận báo giá có ưu đãi. Nếu giá tốt sẽ bắt đầu triển khai ngay vào đầu tháng tới. Chú ý: gửi báo giá cả bản cứng và bản mềm cho chị.',
                    style: AppStyle.DEFAULT_14.copyWith(fontWeight: FontWeight.w500),

                  )
                ],
              ),
            )
          ],
        );
      },
      separatorBuilder: (BuildContext context, int index) => const SizedBox(height: 8,),);
  }

  _tabBarSupport(){
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 10,vertical: 5),
      child: Container(
        height: AppValue.heights*0.3,
        padding: EdgeInsets.symmetric(horizontal: 15,vertical: 20),
        width: AppValue.widths,
        decoration: BoxDecoration(
          color: COLORS.WHITE,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(width: 1,color: Colors.white),
          boxShadow: [
            BoxShadow(
              color: COLORS.BLACK.withOpacity(0.1),
              spreadRadius: 1, blurRadius: 5,)],
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
                    'Hẹn gặp chị Lan để demo giới thiệu sản phẩm phiên bản mới năm 2022',
                    style: AppStyle.DEFAULT_TITLE_PRODUCT.copyWith(color: COLORS.TEXT_COLOR),
                  ),
                  width: AppValue.widths*0.7,
                ),
                Row(
                  children: [
                    SvgPicture.asset('assets/icons/User.svg',color: Color(0xffE75D18),),
                    AppValue.hSpaceTiny,
                    Text('Anh Trung Duc',style: AppStyle.DEFAULT_LABEL_PRODUCT),
                  ],
                ),
                Row(
                  children: [
                    SvgPicture.asset('assets/icons/dangxuly.svg'),
                    AppValue.hSpaceTiny,
                    Text('Dang thuc hien',style: AppStyle.DEFAULT_LABEL_PRODUCT.copyWith(color: Colors.red),),
                  ],
                ),
                Row(
                  children: [
                    Image.asset('assets/icons/date.png'),
                    AppValue.hSpaceTiny,
                    Text('20/05/2022',style: AppStyle.DEFAULT_LABEL_PRODUCT.copyWith(color: Colors.grey)),
                  ],
                ),
              ],
            ),
            Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Image.asset('assets/icons/red.png'),
                SvgPicture.asset('assets/icons/Mess.svg')
              ],
            ),
          ],
        ),
      ),
    );
  }
}
