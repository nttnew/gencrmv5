import "package:flutter/material.dart";
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gen_crm/bloc/job_customer/job_customer_bloc.dart';
import 'package:gen_crm/screens/menu/home/customer/detailcustomer/workcustomer/work_card_widget.dart';
import '../../../../../../src/app_const.dart';
import '../../../../../../src/src_index.dart';

class WorkCustomer extends StatefulWidget {
  WorkCustomer({Key? key, required this.id}) : super(key: key);

  final String id;

  @override
  State<WorkCustomer> createState() => _WorkCustomerState();
}

class _WorkCustomerState extends State<WorkCustomer>
    with AutomaticKeepAliveClientMixin {
  @override
  Widget build(BuildContext context) {
    super.build(context);
    return SingleChildScrollView(
      physics: RangeMaintainingScrollPhysics(),
      child: Column(
        children: [
          SizedBox(
            height: AppValue.heights * 0.02,
          ),
          BlocBuilder<JobCustomerBloc, JobCustomerState>(
              builder: (context, state) {
            if (state is UpdateGetJobCustomerState) if (state.listJob.length >
                0)
              return Column(
                children: List.generate(
                    state.listJob.length,
                    (index) => GestureDetector(
                        onTap: () {
                          AppNavigator.navigateDetailWork(
                              int.parse(state.listJob[index].id!),
                              state.listJob[index].name ?? '');
                        },
                        child: WorkCardWidget(data: state.listJob[index]))),
              );
            else {
              return noData();
            }
            else
              return Container();
          }),
        ],
      ),
    );
  }

  @override
  bool get wantKeepAlive => true;
}
