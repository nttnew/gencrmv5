import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gen_crm/bloc/work_clue/work_clue_bloc.dart';
import '../../../../src/app_const.dart';
import '../../../../src/models/model_generator/work_clue.dart';
import 'package:gen_crm/screens/menu/home/clue/work_card_widget.dart';
import '../../../../src/src_index.dart';

class ListWorkClue extends StatefulWidget {
  ListWorkClue({Key? key, required this.id}) : super(key: key);

  final String id;

  @override
  State<ListWorkClue> createState() => _ListWorkClueState();
}

class _ListWorkClueState extends State<ListWorkClue>
    with AutomaticKeepAliveClientMixin {
  @override
  Widget build(BuildContext context) {
    super.build(context);
    return Container(
      child:
          BlocBuilder<WorkClueBloc, WorkClueState>(builder: (context, state) {
        if (state is UpdateWorkClue) {
          if (state.data!.length > 0) {
            List<WorkClueData> listWorkClue = state.data!;
            return ListView.separated(
              padding: EdgeInsets.only(
                left: 25,
                right: 25,
                bottom: 25,
              ),
              shrinkWrap: true,
              itemBuilder: (context, index) => GestureDetector(
                onTap: () {
                  AppNavigator.navigateDetailWork(
                      int.parse(listWorkClue[index].id!),
                      listWorkClue[index].name_job ?? '');
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
              separatorBuilder: (BuildContext context, int index) => SizedBox(
              ),
            );
          } else {
            return noData();
          }
        } else {
          return noData();
        }
      }),
    );
  }

  @override
  bool get wantKeepAlive => true;
}
