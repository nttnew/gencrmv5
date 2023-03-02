import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:gen_crm/bloc/detail_customer/detail_customer_bloc.dart';
import 'package:gen_crm/bloc/list_note/list_note_bloc.dart';
import 'package:gen_crm/screens/menu/home/customer/list_note.dart';
import 'package:gen_crm/src/models/model_generator/detail_customer.dart';
import 'package:gen_crm/widgets/widget_text.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../../../../../bloc/clue_customer/clue_customer_bloc.dart';
import '../../../../../../src/models/model_generator/note.dart';
import '../../../../../../src/src_index.dart';
import '../../../../../../widgets/line_horizontal_widget.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

class GeneralInforCustomer extends StatefulWidget {

  GeneralInforCustomer({Key? key,required this.id}) : super(key: key);

  final String id;

  @override
  State<GeneralInforCustomer> createState() => _GeneralInforCustomerState();
}

class _GeneralInforCustomerState extends State<GeneralInforCustomer> {

  @override
  void initState() {
    // Future.delayed(Duration(milliseconds: 100),(){
    //   DetailCustomerBloc.of(context).add(InitGetDetailCustomerEvent(int.parse(widget.id)));
    //   ListNoteBloc.of(context).add(InitNoteCusEvent(widget.id,"1"));
    //   // ClueCustomerBloc.of(context).add(InitGetClueCustomerEvent(int.parse(widget.id)));
    //   //   Future.delayed(Duration(milliseconds: 0),(){
    //
    //   //   });
    // });

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child:Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          AppValue.vSpaceSmall,
          BlocBuilder<DetailCustomerBloc, DetailCustomerState>(
              builder: (context, state) {
                if (state is UpdateGetDetailCustomerState)
                  return Container(
                    child:  Column(
                      children: List.generate(state.customerInfo.length, (index) => _renderInfo(state.customerInfo[index])),
                    ),
                  );
                else
                  return Container();
              }),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              WidgetText(
                title: "Thảo luận",
                style: AppStyle.DEFAULT_12_BOLD,
              ),
              ListNote(type: 1, id: widget.id),
            ],
          )

        ],
      ),
    );
  }

  Widget _renderInfo(CustomerInfoData data){
    return(
        Container(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            WidgetText(title: data.group_name!,style: AppStyle.DEFAULT_14.copyWith(fontWeight: FontWeight.w700)),
            AppValue.vSpaceTiny,
            Column(
              children: List.generate(
                data.data!.length,
                    (index) => Container(
                margin: EdgeInsets.only(bottom: 10),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    WidgetText(title: data.data![index].label_field,style: AppStyle.DEFAULT_12.copyWith(fontWeight: FontWeight.w600,color: COLORS.TEXT_GREY),),
                    // Spacer(),
                    SizedBox(width: 8,),
                    Expanded(
                      child: GestureDetector(
                        onTap: (){
                          if(data.data![index].action == 2){
                            launchUrl(
                              Uri(scheme: "tel",path: "${data.data![index].link}")
                            );
                          }
                        },
                          child: WidgetText(title: data.data![index].value_field,textAlign: TextAlign.right,style: AppStyle.DEFAULT_12_BOLD.copyWith(color:data.data![index].action !=null ?COLORS.TEXT_BLUE_BOLD: COLORS.TEXT_GREY_BOLD),)),
                    ),
                  ],
                ),
              ),
              ),
            ),
            AppValue.vSpaceTiny,
            LineHorizontal(),
            SizedBox(height: AppValue.heights*0.02,),
          ],
        ),
      )
    );
  }

  // Widget _renderNote(){
  //   return(
  //       BlocBuilder<ListNoteBloc, ListNoteState>(
  //           builder: (context, state) {
  //             if (state is SuccessGetNoteOppState)
  //               return ListNote(type: 1, id: id);
  //             else
  //               return Container();
  //           })
  //   );
  // }

  TextStyle ValueStyle([String? color]) => TextStyle(fontFamily: "Quicksand",color: color==null?HexColor("#263238"):HexColor(color),fontWeight: FontWeight.w700,fontSize: 12);


}
