
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gen_crm/bloc/work_clue/work_clue_bloc.dart';

import '../../../../src/models/model_generator/work_clue.dart';
import 'package:gen_crm/screens/menu/home/clue/work_card_widget.dart';

import '../../../../src/src_index.dart';
import '../../../../widgets/widget_text.dart';

class ListWorkClue extends StatefulWidget {
  ListWorkClue({Key? key,required this.id}) : super(key: key);

  final String id;

  @override
  State<ListWorkClue> createState() => _ListWorkClueState();
}

class _ListWorkClueState extends State<ListWorkClue> {

  @override
  void initState() {
    // Future.delayed(Duration(milliseconds: 100),(){
    //   WorkClueBloc.of(context).add(GetWorkClue(id: widget.id));
    // });

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      child: BlocBuilder<WorkClueBloc, WorkClueState>(builder: (context, state) {
        if (state is UpdateWorkClue) {
          if(state.data!.length>0){
            List<WorkClueData> listWorkClue = state.data!;
            return ListView.separated(
              shrinkWrap: true,
              itemBuilder: (context, index) =>
                  GestureDetector(
                    onTap: (){
                      AppNavigator.navigateDeatailWork(int.parse(listWorkClue[index].id!),listWorkClue[index].name_job??'');
                    },
                    child: WorkCardWidget(
                      nameCustomer: listWorkClue[index].name_customer,
                      nameJob: listWorkClue[index].name_job,
                      startDate: listWorkClue[index].start_date,
                      statusJob: listWorkClue[index].status_job,
                      totalComment: listWorkClue[index].total_comment,
                      color: listWorkClue[index].color,
                    ),
                  ),
              itemCount: state.data!.length,
              separatorBuilder: (BuildContext context, int index) =>
                  SizedBox(
                    height: AppValue.heights * 0.01,
                  ),
            );
          }
          else {
            return Center(
              child: WidgetText(
                title: 'Không có dữ liệu',
                style: AppStyle.DEFAULT_18_BOLD,
              ),
            );
          }
        } else {
          return Center(
            child: WidgetText(
              title: 'Không có dữ liệu',
              style: AppStyle.DEFAULT_18_BOLD,
            ),
          );
        }
      }),
    );
  }


}
