import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';
import 'package:gen_crm/bloc/contract/detail_contract_bloc.dart';
import 'package:gen_crm/widgets/widget_text.dart';
import 'package:hexcolor/hexcolor.dart';

import '../../../../bloc/support_contract_bloc/support_contract_bloc.dart';
import '../../../../src/src_index.dart';

class ContractSupport extends StatefulWidget {
  ContractSupport({Key? key,required this.id}) : super(key: key);

  final String id;

  @override
  State<ContractSupport> createState() => _ContractSupportState();
}

class _ContractSupportState extends State<ContractSupport> {

  @override
  void initState() {
    // Future.delayed(Duration(milliseconds: 100),(){
    //   DetailContractBloc.of(context).add(InitGetSupportContractEvent(int.parse(widget.id)));
    // });

    // DetailContractBloc.of(context).add(InitGetSupportContractEvent(98));
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
        padding: EdgeInsets.only(bottom: 10),
        margin: EdgeInsets.only(top: 16),
        child: BlocBuilder<SupportContractBloc, SupportContractState>(
            builder: (context, state) {
              if (state is SuccessSupportContractState)
                if(state.listSupportContract.length>0)
                return ListView.separated(
                    itemBuilder: (context,index){
                      return GestureDetector(
                        onTap: (){
                          AppNavigator.navigateDeatailSupport(state.listSupportContract[index].id.toString(),state.listSupportContract[index].name??'');
                        },
                        child: Padding(
                          padding: EdgeInsets.symmetric(horizontal: 10,vertical: 5),
                          child: Container(
                            height: AppValue.heights*0.23,
                            padding: EdgeInsets.symmetric(horizontal: 16,vertical: 16),
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
                                      child: WidgetText(
                                        title: state.listSupportContract[index].name??'',
                                        style: AppStyle.DEFAULT_TITLE_PRODUCT.copyWith(color: COLORS.TEXT_COLOR),
                                      ),
                                      width: AppValue.widths*0.7,
                                    ),
                                    Row(
                                      children: [
                                        SvgPicture.asset('assets/icons/User.svg',color: Color(0xffE75D18),),
                                        AppValue.hSpaceTiny,
                                        WidgetText(title: state.listSupportContract[index].khach_hang??'',style: AppStyle.DEFAULT_LABEL_PRODUCT),
                                      ],
                                    ),
                                    Row(
                                      children: [
                                        SvgPicture.asset('assets/icons/dangxuly.svg',color: state.listSupportContract[index].color!=null?HexColor(state.listSupportContract[index].color!):COLORS.PRIMARY_COLOR,),
                                        AppValue.hSpaceTiny,
                                        WidgetText(title: state.listSupportContract[index].status??'',style: AppStyle.DEFAULT_LABEL_PRODUCT.copyWith(color: state.listSupportContract[index].color!=null?HexColor(state.listSupportContract[index].color!):COLORS.PRIMARY_COLOR),),
                                      ],
                                    ),
                                    Row(
                                      children: [
                                        Image.asset('assets/icons/date.png'),
                                        AppValue.hSpaceTiny,
                                        WidgetText(title: state.listSupportContract[index].created_date??"",style: AppStyle.DEFAULT_LABEL_PRODUCT.copyWith(color: Colors.grey)),
                                      ],
                                    ),
                                  ],
                                ),
                                Column(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: [
                                    Image.asset('assets/icons/red.png',color: state.listSupportContract[index].color!=null?HexColor(state.listSupportContract[index].color!):COLORS.PRIMARY_COLOR,),
                                    Row(
                                      children: [
                                        SvgPicture.asset('assets/icons/Mess.svg'),
                                        SizedBox(width: 5,),
                                        WidgetText(title: state.listSupportContract[index].total_note??"",style: AppStyle.DEFAULT_LABEL_PRODUCT.copyWith(color: COLORS.TEXT_BLUE_BOLD)),
                                      ],
                                    )
                                  ],
                                ),
                              ],
                            ),
                          ),
                        ),
                      );
                    },
                    separatorBuilder: (BuildContext context, int index) => const SizedBox(height: 10,),
                    itemCount: state.listSupportContract.length);
                else  return Center(
                  child: WidgetText(
                    title: "Kh??ng c?? d??? li???u",
                    style: AppStyle.DEFAULT_18,
                  ),
                );
              else
                return Container();
            })

    );
  }
}
