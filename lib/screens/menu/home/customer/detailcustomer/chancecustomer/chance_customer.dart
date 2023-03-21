import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';
import 'package:gen_crm/bloc/chance_customer/chance_customer_bloc.dart';
import 'package:gen_crm/screens/menu/home/customer/detailcustomer/chancecustomer/chance_card_widget.dart';
import 'package:hexcolor/hexcolor.dart';

import '../../../../../../src/src_index.dart';
import '../../../../../../widgets/widget_text.dart';

class ChanceCustomer extends StatefulWidget {
  ChanceCustomer({Key? key, required this.id}) : super(key: key);

  final String id;

  @override
  State<ChanceCustomer> createState() => _ChanceCustomerState();
}

class _ChanceCustomerState extends State<ChanceCustomer> {
  @override
  void initState() {
    // Future.delayed(Duration(milliseconds: 100),(){
    //   ChanceCustomerBloc.of(context).add(InitGetChanceCustomerEvent(int.parse(widget.id)));
    // });

    super.initState();
  }

  // @override
  // void didUpdateWidget(ChanceCustomer oldWidget) {
  //   if(oldWidget.id!=null){
  //     Future.delayed(Duration(milliseconds: 100),(){
  //       ChanceCustomerBloc.of(context).add(InitGetChanceCustomerEvent(int.parse(widget.id)));
  //     });
  //   }
  // }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        children: [
          SizedBox(
            height: AppValue.heights * 0.02,
          ),
          BlocBuilder<ChanceCustomerBloc, ChanceCustomerState>(builder: (context, state) {
            if (state is UpdateGetChanceCustomerState) if (state.listChance.length > 0)
              return Column(
                children: List.generate(
                    state.listChance.length,
                    (index) => GestureDetector(
                        onTap: () {
                          AppNavigator.navigateInfoChance(state.listChance[index].id!, state.listChance[index].name!, customerId: widget.id);
                        },
                        child: ChanceCardWidget(data: state.listChance[index]))),
              );
            else {
              return Center(
                child: WidgetText(
                  title: "Không có dữ liệu",
                  style: AppStyle.DEFAULT_16_BOLD,
                ),
              );
            }

            // ListView.separated(
            // shrinkWrap: true,
            // itemBuilder: (context,index)=> ChanceCardWidget(data: state.listChance[index]),
            // itemCount: state.listChance.length,
            // physics: BouncingScrollPhysics(),
            // separatorBuilder: (BuildContext context, int index) => SizedBox(height: AppValue.heights*0.01,),);
            else
              return Container();
          })
        ],
      ),
    );
  }
}
