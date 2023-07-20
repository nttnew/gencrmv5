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
  _init() {
    PaymentContractBloc.of(context).add(InitGetPaymentContractEvent(widget.id));
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return RefreshIndicator(
      onRefresh: () async {
        await _init();
      },
      child: SingleChildScrollView(
        physics: AlwaysScrollableScrollPhysics(),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            BlocBuilder<PaymentContractBloc, PaymentContractState>(
                builder: (context, state) {
              if (state is SuccessPaymentContractState) if ((state
                          .listPaymentContract?.length ??
                      0) >
                  0)
                return Padding(
                  padding: const EdgeInsets.symmetric(vertical: 25),
                  child: _buildContent1(state.listPaymentContract),
                );
              else {
                return Container(
                  height: MediaQuery.of(context).size.height / 2,
                  child: Center(child: noData()),
                );
              }
              else
                return Container();
            })
          ],
        ),
      ),
    );
  }

  Widget _buildContent1(List<List<PaymentContractItem>?>? data) {
    return Column(
      children: (data ?? [])
          .map((e) => Container(
                padding: EdgeInsets.symmetric(horizontal: 25, vertical: 10),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Column(
                      children: List.generate(e?.length ?? 0, (index) {
                        if (e?[index].field_hidden != 1)
                          return Container(
                            margin: EdgeInsets.symmetric(vertical: 8),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                WidgetText(
                                  title: e?[index].field_label ?? '',
                                  style: AppStyle.DEFAULT_14
                                      .copyWith(color: Colors.grey),
                                ),
                                WidgetText(
                                    title: e?[index].field_value.toString(),
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
              ))
          .toList(),
    );
  }

  @override
  bool get wantKeepAlive => true;
}
