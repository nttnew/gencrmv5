import "package:flutter/material.dart";
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gen_crm/bloc/clue_customer/clue_customer_bloc.dart';
import 'package:gen_crm/screens/menu/home/customer/detailcustomer/cluecustomer/clue_card_widget.dart';
import '../../../../../../src/app_const.dart';
import '../../../../../../src/src_index.dart';

class ClueCustomer extends StatefulWidget {
  ClueCustomer({Key? key, required this.id}) : super(key: key);

  String? id;

  @override
  State<ClueCustomer> createState() => _ClueCustomerState();
}

class _ClueCustomerState extends State<ClueCustomer>
    with AutomaticKeepAliveClientMixin {
  int page = 1;
  ScrollController _scrollController = ScrollController();
  bool check = false;

  @override
  void initState() {
    check = true;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return SingleChildScrollView(
      controller: _scrollController,
      child: Column(
        children: [
          SizedBox(
            height: AppValue.heights * 0.02,
          ),
          BlocBuilder<ClueCustomerBloc, ClueCustomerState>(
              builder: (context, state) {
            if (state is UpdateGetClueCustomerState) if (state.listClue.length >
                0)
              return Column(
                children: List.generate(
                    state.listClue.length,
                    (index) => GestureDetector(
                        onTap: () {
                          AppNavigator.navigateInfoClue(
                              state.listClue[index].id!,
                              state.listClue[index].name!);
                        },
                        child: ClueCardWidget(data: state.listClue[index]))),
              );
            else {
              return noData();
            }
            else
              return Container();
          })
        ],
      ),
    );
  }

  @override
  bool get wantKeepAlive => true;
}
