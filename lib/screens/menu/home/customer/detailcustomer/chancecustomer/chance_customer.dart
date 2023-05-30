import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gen_crm/bloc/chance_customer/chance_customer_bloc.dart';
import 'package:gen_crm/screens/menu/home/customer/detailcustomer/chancecustomer/chance_card_widget.dart';
import '../../../../../../src/app_const.dart';
import '../../../../../../src/src_index.dart';

class ChanceCustomer extends StatefulWidget {
  ChanceCustomer({Key? key, required this.id}) : super(key: key);

  final String id;

  @override
  State<ChanceCustomer> createState() => _ChanceCustomerState();
}

class _ChanceCustomerState extends State<ChanceCustomer>
    with AutomaticKeepAliveClientMixin {
  @override
  Widget build(BuildContext context) {
    super.build(context);
    return Padding(
      padding: const EdgeInsets.all(25),
      child: BlocBuilder<ChanceCustomerBloc, ChanceCustomerState>(
          builder: (context, state) {
        if (state is UpdateGetChanceCustomerState) if (state.listChance.length >
            0)
          return ListView.builder(
            itemCount: state.listChance.length,
            itemBuilder: (BuildContext context, int index) => GestureDetector(
                onTap: () {
                  AppNavigator.navigateInfoChance(state.listChance[index].id!,
                      state.listChance[index].name!);
                },
                child: ChanceCardWidget(data: state.listChance[index])),
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
