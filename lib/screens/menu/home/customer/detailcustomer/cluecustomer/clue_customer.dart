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
  @override
  Widget build(BuildContext context) {
    super.build(context);
    return Padding(
      padding: const EdgeInsets.all(25),
      child: BlocBuilder<ClueCustomerBloc, ClueCustomerState>(
          builder: (context, state) {
        if (state is UpdateGetClueCustomerState) if (state.listClue.length > 0)
          return ListView.builder(
            itemCount: state.listClue.length,
            itemBuilder: (context, int index) => GestureDetector(
              onTap: () {
                AppNavigator.navigateInfoClue(state.listClue[index].id ?? '',
                    state.listClue[index].name ?? '');
              },
              child: ClueCardWidget(data: state.listClue[index]),
            ),
          );
        else {
          return noData();
        }
        else
          return Container();
      }),
    );
  }

  @override
  bool get wantKeepAlive => true;
}
