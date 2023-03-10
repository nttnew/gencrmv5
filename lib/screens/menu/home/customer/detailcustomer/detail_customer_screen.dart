import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';
import 'package:gen_crm/bloc/blocs.dart';
import 'package:gen_crm/bloc/detail_customer/detail_customer_bloc.dart';
import 'package:gen_crm/screens/menu/home/customer/index.dart';
import 'package:gen_crm/widgets/widget_text.dart';
import 'package:get/get.dart';
import 'package:hexcolor/hexcolor.dart';

import '../../../../../bloc/chance_customer/chance_customer_bloc.dart';
import '../../../../../bloc/clue_customer/clue_customer_bloc.dart';
import '../../../../../bloc/contract_customer/contract_customer_bloc.dart';
import '../../../../../bloc/job_customer/job_customer_bloc.dart';
import '../../../../../bloc/list_note/list_note_bloc.dart';
import '../../../../../bloc/support_customer/support_customer_bloc.dart';
import '../../../../../src/src_index.dart';
import '../../../../../widgets/line_horizontal_widget.dart';
import '../../../../../widgets/widget_dialog.dart';

class DetailCustomerScreen extends StatefulWidget {
  const DetailCustomerScreen({Key? key}) : super(key: key);

  @override
  State<DetailCustomerScreen> createState() => _DetailCustomerScreenState();
}

class _DetailCustomerScreenState extends State<DetailCustomerScreen> with SingleTickerProviderStateMixin {
  String id=Get.arguments[0];
  String name=Get.arguments[1];
  late TabController _tabController;
  int page=0;
  bool drag=false;

  @override
  void initState() {
    _tabController=TabController(length: 6, vsync: this);
    Future.delayed(Duration(seconds: 0),(){
      DetailCustomerBloc.of(context).add(InitGetDetailCustomerEvent(int.parse(id)));
      ListNoteBloc.of(context).add(InitNoteCusEvent(id,"1"));
      ClueCustomerBloc.of(context).add(InitGetClueCustomerEvent(int.parse(id)));
      ChanceCustomerBloc.of(context).add(InitGetChanceCustomerEvent(int.parse(id)));
      ContractCustomerBloc.of(context).add(InitGetContractCustomerEvent(int.parse(id)));
      JobCustomerBloc.of(context).add(InitGetJobCustomerEvent(int.parse(id)));
      SupportCustomerBloc.of(context).add(InitGetSupportCustomerEvent(int.parse(id)));

    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        toolbarHeight: AppValue.heights * 0.1,
        backgroundColor: HexColor("#D0F1EB"),
        centerTitle: false,
        title:
            WidgetText(title: name, style: AppStyle.DEFAULT_16.copyWith(fontWeight: FontWeight.w700)),
        leading: Padding(
            padding: EdgeInsets.only(left: 30),
            child: InkWell(onTap:()=>AppNavigator.navigateBack(),child: Icon(Icons.arrow_back,color:Colors.black))),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(
            bottom: Radius.circular(15),
          ),
        ),


      ),
      body:BlocListener<DetailCustomerBloc, DetailCustomerState>(
        listener: (context, state) async {
          if(state is SuccessDeleteCustomerState){
            showDialog(
              context: context,
              builder: (BuildContext context) {
                return WidgetDialog(
                  title: MESSAGES.NOTIFICATION,
                  content: "Th??nh c??ng",
                  textButton1: "OK",
                  backgroundButton1: COLORS.PRIMARY_COLOR,
                  onTap1: (){
                    Get.back();
                    Get.back();
                    Get.back();
                    Get.back();
                    GetListCustomerBloc.of(context).add(InitGetListOrderEvent("", 1, ""));
                  },
                );
              },
            );
          }
          else if(state is ErrorDeleteCustomerState){
            showDialog(
              context: context,
              builder: (BuildContext context) {
                return WidgetDialog(
                  title: MESSAGES.NOTIFICATION,
                  content: state.msg,
                  textButton1: "Quay l???i",
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
        child: Container(
          margin: EdgeInsets.only(left: 20),
          child: SafeArea(
            child: Scaffold(
              appBar:TabBar(
                isScrollable: true,
                controller: _tabController,
                labelColor: HexColor("#006CB1"),
                unselectedLabelColor: HexColor("#697077"),
                labelStyle: TextStyle(fontFamily: "Quicksand",fontSize: 14,fontWeight: FontWeight.w700),
                indicatorColor: HexColor("#006CB1"),
                tabs: <Widget>[
                  Tab(
                    text: "Th??ng tin chung",
                  ),
                  Tab(
                    text: "?????u m???i",
                  ),
                  Tab(
                    text: "C?? h???i",
                  ),
                  Tab(
                    text: "H???p ?????ng",
                  ),
                  Tab(
                    text: "C??ng vi???c",
                  ),
                  Tab(
                    text: "H??? tr???",
                  ),
                ],
              ),
              body: Container(
                margin: EdgeInsets.only(right: 20),
                child:  Column(
                  children: [
                    LineHorizontal(),
                    Expanded(
                      child: TabBarView(
                        controller: _tabController,
                        physics:BouncingScrollPhysics(),
                        children: <Widget>[
                          GeneralInforCustomer(id: id),
                          ClueCustomer(id: id),
                          ChanceCustomer(id: id),
                          ConstractCustomer(id: id),
                          WorkCustomer(id: id),
                          SupportCustomer(id: id),
                        ],
                      ),
                    ),
                    SizedBox(height: AppValue.heights*0.02,),
                    InkWell(
                      onTap: (){
                        showModalBottomSheet(
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.vertical(top: Radius.circular(30)),),
                            context: context,
                            builder: (context) {
                              return
                                SafeArea(
                                  child: Container(
                                    height: AppValue.heights*0.8,
                                    child: Column(
                                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      mainAxisSize: MainAxisSize.max,
                                      children: [
                                        SizedBox(height: AppValue.heights*0.02,),
                                        GestureDetector(
                                          onTap: (){
                                            Get.back();
                                            AppNavigator.navigateFormAdd('Th??m ?????u m???i',11,id: int.parse(id));
                                          },
                                          child: Row(
                                            children: [
                                              SizedBox(width: AppValue.widths*0.2,),
                                              SvgPicture.asset("assets/icons/addclue.svg"),
                                              SizedBox(width: AppValue.widths*0.1,),
                                              Text("Th??m ?????u m???i",style: styleTitleBottomSheet(),),
                                            ],
                                          ),
                                        ),

                                        GestureDetector(
                                          onTap: (){
                                            Get.back();
                                            AppNavigator.navigateFormAdd('Th??m c?? h???i',12,id: int.parse(id));
                                          },
                                          child: Row(
                                            children: [
                                              SizedBox(width: AppValue.widths*0.2,),
                                              SvgPicture.asset("assets/icons/addchance.svg"),
                                              SizedBox(width: AppValue.widths*0.1,),
                                              Text("Th??m c?? h???i",style: styleTitleBottomSheet())
                                            ],
                                          ),
                                        ),

                                        GestureDetector(
                                          onTap: (){
                                            Get.back();
                                            AppNavigator.navigateAddContract(customer_id: id);
                                          },
                                          child: Row(
                                            mainAxisAlignment: MainAxisAlignment.start,
                                            children: [
                                              SizedBox(width: AppValue.widths*0.2,),
                                              SvgPicture.asset("assets/icons/addcontract.svg"),
                                              SizedBox(width: AppValue.widths*0.1,),
                                              Text("Th??m h???p ?????ng",style: styleTitleBottomSheet())
                                            ],
                                          ),
                                        ),

                                        GestureDetector(
                                          onTap: (){
                                            Get.back();
                                            AppNavigator.navigateFormAdd('Th??m c??ng vi???c',14,id: int.parse(id));
                                          },
                                          child: Row(
                                            mainAxisAlignment: MainAxisAlignment.start,
                                            children: [
                                              SizedBox(width: AppValue.widths*0.2,),
                                              SvgPicture.asset("assets/icons/addwork.svg"),
                                              SizedBox(width: AppValue.widths*0.1,),
                                              Text("Th??m c??ng vi???c",style: styleTitleBottomSheet())
                                            ],
                                          ),
                                        ),

                                        GestureDetector(
                                          onTap: (){
                                            Get.back();
                                            AppNavigator.navigateFormAdd('Th??m h??? tr???',15,id: int.parse(id));
                                          },
                                          child: Row(
                                            mainAxisAlignment: MainAxisAlignment.start,
                                            children: [
                                              SizedBox(width: AppValue.widths*0.2,),
                                              SvgPicture.asset("assets/icons/addsupport.svg"),
                                              SizedBox(width: AppValue.widths*0.1,),
                                              Text("Th??m h??? tr???",style: styleTitleBottomSheet())
                                            ],
                                          ),
                                        ),

                                        GestureDetector(
                                          onTap: (){
                                            Get.back();
                                            AppNavigator.navigateAddNoteScreen(1, id);
                                          },
                                          child: Row(
                                            mainAxisAlignment: MainAxisAlignment.start,
                                            children: [
                                              SizedBox(width: AppValue.widths*0.2,),
                                              SvgPicture.asset("assets/icons/adddiscuss.svg"),
                                              SizedBox(width: AppValue.widths*0.1,),
                                              Text("Th??m th???o lu???n",style: styleTitleBottomSheet())
                                            ],
                                          ),
                                        ),

                                        GestureDetector(
                                          onTap: (){
                                            Get.back();
                                            AppNavigator.navigateEditDataScreen(id,1);
                                          },
                                          child: Row(
                                            mainAxisAlignment: MainAxisAlignment.start,
                                            children: [
                                              SizedBox(width: AppValue.widths*0.2,),
                                              SvgPicture.asset("assets/icons/edit.svg"),
                                              SizedBox(width: AppValue.widths*0.1,),
                                              Text("S???a",style: styleTitleBottomSheet())
                                            ],
                                          ),
                                        ),

                                        GestureDetector(
                                          onTap: (){

                                            ShowDialogCustom.showDialogTwoButton(
                                                onTap2:()=> DetailCustomerBloc.of(context).add(DeleteCustomerEvent(int.parse(id))),
                                                content: "B???n ch???c ch???n mu???n x??a kh??ng ?"
                                            );
                                          },
                                          child: Row(
                                            mainAxisAlignment: MainAxisAlignment.start,
                                            children: [
                                              SizedBox(width: AppValue.widths*0.2,),
                                              SvgPicture.asset("assets/icons/delete.svg"),
                                              SizedBox(width: AppValue.widths*0.1,),
                                              WidgetText(title: "Xo??",style: styleTitleBottomSheet())
                                            ],
                                          ),
                                        ),
                                        Row(
                                          mainAxisAlignment: MainAxisAlignment.center,
                                          children: [
                                            InkWell(
                                              onTap:()=>Navigator.of(context).pop(),
                                              child: Container(
                                                width: AppValue.widths*0.8,
                                                height: AppValue.heights*0.06,
                                                decoration: BoxDecoration(
                                                  color:HexColor("#D0F1EB"),
                                                  borderRadius: BorderRadius.circular(17.06),
                                                ),
                                                child: Center(
                                                  child: Text("????ng"),
                                                ),
                                              ),
                                            ),
                                          ],
                                        ),

                                      ],
                                    ),
                                  ),
                                );
                            });
                      },
                      child: Container(
                        width: double.infinity,
                        // height: AppValue.heights*0.06,
                        padding: EdgeInsets.symmetric(vertical: 8),
                        margin: EdgeInsets.only(bottom: 8),
                        decoration: BoxDecoration(
                          color:HexColor("#D0F1EB"),
                          borderRadius: BorderRadius.circular(17.06),
                        ),
                        child: Center(
                          child: Text("THAO T??C",style:TextStyle(fontFamily: "Quicksand",fontWeight: FontWeight.w700,fontSize: 16)),
                        ),
                      ),
                    )
                  ],
                ),
              ),
            ),
          ),
        ),
      )
    );
  }

  TextStyle styleTitleBottomSheet() => TextStyle(color:HexColor("#0069CD"),fontFamily: "Quicksand",fontWeight: FontWeight.w700, fontSize: 20);


}
