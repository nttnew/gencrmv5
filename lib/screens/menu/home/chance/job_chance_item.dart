import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter/material.dart';
import '../../../../bloc/blocs.dart';
import '../../../../src/app_const.dart';
import '../../../../src/src_index.dart';
import '../clue/work_card_widget.dart';

class JobListChance extends StatefulWidget {
  const JobListChance({Key? key, required this.id}) : super(key: key);

  final String? id;

  @override
  State<JobListChance> createState() => _JobListChanceState();
}

class _JobListChanceState extends State<JobListChance>
    with AutomaticKeepAliveClientMixin {
  @override
  Widget build(BuildContext context) {
    super.build(context);
    return BlocBuilder<GetJobChanceBloc, JobChanceState>(
        builder: (context, state) {
      if (state is UpdateGetJobChanceState) {
        if (state.data.length > 0) {
          return ListView.separated(
            padding: EdgeInsets.only(left: 25, right: 25, bottom: 25),
            itemBuilder: (context, index) {
              return GestureDetector(
                onTap: () {
                  AppNavigator.navigateDetailWork(
                    int.parse(state.data[index].id!),
                    state.data[index].name_job ?? '',
                  );
                },
                child: WorkCardWidget(
                  color: state.data[index].color,
                  nameCustomer: state.data[index].name_customer,
                  nameJob: state.data[index].name_job,
                  statusJob: state.data[index].status_job,
                  startDate: state.data[index].start_date,
                  totalComment: state.data[index].total_comment,
                ),
              );
            },
            separatorBuilder: (BuildContext context, int index) =>
                const SizedBox(),
            itemCount: state.data.length,
          );
        } else
          return noData();
      } else
        return noData();
    });
  }

  @override
  bool get wantKeepAlive => true;
}
