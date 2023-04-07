import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gen_crm/screens/menu/home/customer/detailcustomer/contractcustomer/contract_card_widget.dart';

import '../../../../../../bloc/contract_customer/contract_customer_bloc.dart';
import '../../../../../../src/src_index.dart';
import '../../../../../../widgets/widget_text.dart';

class ConstractCustomer extends StatefulWidget {
  ConstractCustomer({Key? key, required this.id}) : super(key: key);

  final String id;

  @override
  State<ConstractCustomer> createState() => _ConstractCustomerState();
}

class _ConstractCustomerState extends State<ConstractCustomer>
    with AutomaticKeepAliveClientMixin {
  @override
  Widget build(BuildContext context) {
    super.build(context);
    return SingleChildScrollView(
        child: Column(
      children: [
        SizedBox(
          height: AppValue.heights * 0.02,
        ),
        BlocBuilder<ContractCustomerBloc, ContractCustomerState>(
            builder: (context, state) {
          if (state is UpdateGetContractCustomerState) if (state
                  .listContract.length >
              0)
            return Column(
              children: List.generate(
                  state.listContract.length,
                  (index) => GestureDetector(
                      onTap: () {
                        AppNavigator.navigateInfoContract(
                            state.listContract[index].id!,
                            state.listContract[index].name!);
                      },
                      child: ConstractCardWidget(
                        data: state.listContract[index],
                      ))),
            );
          else {
            return Center(
              child: WidgetText(
                title: "Không có dữ liệu",
                style: AppStyle.DEFAULT_16_BOLD,
              ),
            );
          }
          else
            return Container();
        }),
      ],
    ));
  }

  @override
  bool get wantKeepAlive => true;
}
