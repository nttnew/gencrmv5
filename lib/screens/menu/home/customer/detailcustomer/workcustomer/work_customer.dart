import "package:flutter/material.dart";
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';
import 'package:gen_crm/bloc/job_customer/job_customer_bloc.dart';
import 'package:gen_crm/screens/menu/home/customer/detailcustomer/workcustomer/work_card_widget.dart';
import 'package:hexcolor/hexcolor.dart';

import '../../../../../../src/src_index.dart';
import '../../../../../../widgets/widget_text.dart';
class WorkCustomer extends StatefulWidget {
  WorkCustomer({Key? key,required this.id}) : super(key: key);

  final String id;

  @override
  State<WorkCustomer> createState() => _WorkCustomerState();
}

class _WorkCustomerState extends State<WorkCustomer> {

  @override
  void initState() {
    // Future.delayed(Duration(milliseconds: 100),(){
    //   JobCustomerBloc.of(context).add(InitGetJobCustomerEvent(int.parse(widget.id)));
    // });

    super.initState();
  }

  // @override
  // void didUpdateWidget(WorkCustomer oldWidget) {
  //   if(oldWidget.id!=null){
  //     Future.delayed(Duration(milliseconds: 100),(){
  //       JobCustomerBloc.of(context).add(InitGetJobCustomerEvent(int.parse(widget.id)));
  //     });
  //   }
  // }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      physics: RangeMaintainingScrollPhysics(),
      child: Column(
        children: [
          SizedBox(height: AppValue.heights*0.02,),
          BlocBuilder<JobCustomerBloc, JobCustomerState>(
              builder: (context, state) {
                if (state is UpdateGetJobCustomerState)
                  if(state.listJob.length>0)
                  return Column(
                    children: List.generate(state.listJob.length, (index) => GestureDetector(
                      onTap: (){
                        AppNavigator.navigateDeatailWork(int.parse(state.listJob[index].id!),state.listJob[index].name??'');
                      },
                        child: WorkCardWidget(data: state.listJob[index]))),
                  );
                  else{
                    return Center(child: WidgetText(title: "Không có dữ liệu",style: AppStyle.DEFAULT_16_BOLD,),);
                  }
                else
                  return Container();
              }),
          // ListView.separated(
          //   shrinkWrap: true,
          //   itemBuilder: (context,index)=> WorkCardWidget(),
          //   itemCount: 5,
          //   physics: BouncingScrollPhysics(),
          //   separatorBuilder: (BuildContext context, int index) => SizedBox(height: AppValue.heights*0.01,),)
        ],
      ),
    );
  }

}
