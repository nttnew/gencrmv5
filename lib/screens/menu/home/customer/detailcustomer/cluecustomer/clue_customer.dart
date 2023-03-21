import "package:flutter/material.dart";
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';
import 'package:gen_crm/bloc/clue_customer/clue_customer_bloc.dart';
import 'package:gen_crm/screens/menu/home/customer/detailcustomer/cluecustomer/clue_card_widget.dart';
import 'package:hexcolor/hexcolor.dart';

import '../../../../../../src/src_index.dart';
import '../../../../../../widgets/widget_text.dart';

class ClueCustomer extends StatefulWidget {
  ClueCustomer({Key? key, required this.id}) : super(key: key);

  String? id;

  @override
  State<ClueCustomer> createState() => _ClueCustomerState();
}

class _ClueCustomerState extends State<ClueCustomer> {
  int page = 1;
  ScrollController _scrollController = ScrollController();
  bool check = false;

  @override
  void initState() {
    check = true;
    // ClueCustomerBloc.of(context).add(InitGetClueCustomerEvent(int.parse(widget.id!)));
    // Future.delayed(Duration(milliseconds: 500),(){
    //   ClueCustomerBloc.of(context).add(InitGetClueCustomerEvent(int.parse(widget.id!)));
    // });
    // _scrollController.addListener(() {
    //   if (_scrollController.offset ==
    //       _scrollController.position.maxScrollExtent && lenght<total) {
    //     ClueCustomerBloc.of(context).add(InitGetClueCustomerEvent(61));
    //     page = page + 1;
    //   } else {
    //   }
    // });
    super.initState();
  }

  // @override
  // void didUpdateWidget(ClueCustomer oldWidget) {
  //   if(oldWidget.id!=null){
  //     Future.delayed(Duration(milliseconds: 0),(){
  //       ClueCustomerBloc.of(context).add(InitGetClueCustomerEvent(int.parse(widget.id!)));
  //     });
  //   }
  // }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      controller: _scrollController,
      child: Column(
        children: [
          SizedBox(
            height: AppValue.heights * 0.02,
          ),
          BlocBuilder<ClueCustomerBloc, ClueCustomerState>(builder: (context, state) {
            if (state is UpdateGetClueCustomerState) if (state.listClue.length > 0)
              return Column(
                children: List.generate(
                    state.listClue.length,
                    (index) => GestureDetector(
                        onTap: () {
                          AppNavigator.navigateInfoClue(state.listClue[index].id!, state.listClue[index].name!, customerId: widget.id);
                        },
                        child: ClueCardWidget(data: state.listClue[index]))),
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
            // itemBuilder: (context,index)=> ClueCardWidget(data: state.listClue[index],),
            // physics: BouncingScrollPhysics(),
            // itemCount: state.listClue.length,
            // separatorBuilder: (BuildContext context, int index) => SizedBox(height: AppValue.heights*0.01,),);
            else
              return Container();
          })
        ],
      ),
    );
  }
}
