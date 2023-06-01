import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gen_crm/bloc/support_customer/support_customer_bloc.dart';
import 'package:gen_crm/screens/menu/home/support/support_card_widget.dart';
import '../../../../../../src/app_const.dart';
import '../../../../../../src/src_index.dart';

class SupportCustomer extends StatefulWidget {
  SupportCustomer({Key? key, required this.id}) : super(key: key);

  final String id;

  @override
  State<SupportCustomer> createState() => _SupportCustomerState();
}

class _SupportCustomerState extends State<SupportCustomer>
    with AutomaticKeepAliveClientMixin {
  @override
  Widget build(BuildContext context) {
    super.build(context);
    return Padding(
      padding: const EdgeInsets.all(25.0),
      child: BlocBuilder<SupportCustomerBloc, SupportCustomerState>(
          builder: (context, state) {
        if (state
            is UpdateGetSupportCustomerState) if (state.listSupport.length > 0)
          return ListView.builder(
            itemCount: state.listSupport.length,
            itemBuilder: (BuildContext context, int index) => GestureDetector(
                onTap: () {
                  AppNavigator.navigateDetailSupport(
                      state.listSupport[index].id.toString(),
                      state.listSupport[index].name ?? '');
                },
                child: SupportCardWidget(data: state.listSupport[index])),
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
