import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gen_crm/bloc/payment_contract/payment_contract_bloc.dart';
import 'package:gen_crm/widgets/widget_text.dart';

import '../../../../../src/app_const.dart';
import '../../../../../src/models/model_generator/detail_contract.dart';
import '../../../../../src/src_index.dart';
import '../../../../../widgets/widget_line.dart';

class ContractPayment extends StatefulWidget {
  ContractPayment({Key? key, required this.id}) : super(key: key);

  final int id;

  @override
  State<ContractPayment> createState() => _ContractPaymentState();
}

class _ContractPaymentState extends State<ContractPayment>
    with AutomaticKeepAliveClientMixin {
  @override
  Widget build(BuildContext context) {
    super.build(context);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        BlocBuilder<PaymentContractBloc, PaymentContractState>(
            builder: (context, state) {
          if (state is SuccessPaymentContractState) if (state
                      .listPaymentContract.length >
                  0)
            return _buildContent1(state.listPaymentContract);
          else {
            return noData();
          }
          else
            return Container();
        })
      ],
    );
  }

  _buildContent1(List<PaymentContractItem> data) {
    return Container(
      padding: EdgeInsets.all(25),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Column(
            children: List.generate(data.length, (index) {
              if (data[index].field_hidden != 1)
                return Container(
                  margin: EdgeInsets.symmetric(vertical: 8),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      WidgetText(
                        title: data[index].field_label ?? '',
                        style: AppStyle.DEFAULT_14.copyWith(color: Colors.grey),
                      ),
                      WidgetText(
                          title: data[index].field_value.toString(),
                          style: AppStyle.DEFAULT_14)
                    ],
                  ),
                );
              else
                return Container();
            }),
          ),
          WidgetLine(
            color: Colors.grey,
          )
        ],
      ),
    );
  }

  @override
  bool get wantKeepAlive => true;
}
