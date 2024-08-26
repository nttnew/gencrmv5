import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gen_crm/bloc/payment_contract/payment_contract_bloc.dart';
import 'package:gen_crm/screens/widget/information.dart';
import 'package:gen_crm/widgets/showToastM.dart';
import 'package:gen_crm/widgets/widget_text.dart';
import '../../../../../bloc/contract/detail_contract_bloc.dart';
import '../../../../../l10n/key_text.dart';
import '../../../../../src/app_const.dart';
import '../../../../../src/models/model_generator/detail_contract.dart';
import '../../../../../src/src_index.dart';
import '../../../../../widgets/widget_line.dart';

class ContractPayment extends StatefulWidget {
  ContractPayment({
    Key? key,
    required this.id,
    required this.bloc,
  }) : super(key: key);
  final int id;
  final DetailContractBloc bloc;

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
      color: getBackgroundWithIsCar(),
      onRefresh: () async {
        await _init();
      },
      child: SingleChildScrollView(
        padding: EdgeInsets.zero,
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
                return _buildContent1(state.listPaymentContract);
              else {
                return Container(
                  height: MediaQuery.of(context).size.height / 2,
                  child: Center(child: noData()),
                );
              }
              else
                return Padding(
                  padding: EdgeInsets.only(top: 16),
                  child: loadInfo(isTitle: false),
                );
            })
          ],
        ),
      ),
    );
  }

  Widget _buildContent1(List<List<PaymentContractItem>?>? data) {
    return Column(
      children: (data ?? []).map((e) {
        String idPayment = '${e?.first.id_payment ?? ''}';
        String idDetail = '${e?.first.id_chi_tiet_thanh_toan ?? ''}';
        return Container(
          padding: EdgeInsets.symmetric(
            horizontal: 16,
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Column(
                children: List.generate(e?.length ?? 0, (index) {
                  if (e?[index].field_hidden != 1 &&
                      '${e?[index].field_value ?? ''}'.trim() != '')
                    return Container(
                      margin: EdgeInsets.symmetric(vertical: 8),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          WidgetText(
                            title: e?[index].field_label ?? '',
                            style: AppStyle.DEFAULT_14
                                .copyWith(color: Colors.grey),
                          ),
                          AppValue.hSpaceTiny,
                          Expanded(
                            child: WidgetText(
                              title: '${e?[index].field_value ?? ''}',
                              style: AppStyle.DEFAULT_14,
                              textAlign: TextAlign.right,
                            ),
                          )
                        ],
                      ),
                    );
                  else
                    return SizedBox.shrink();
                }),
              ),
              AppValue.vSpaceSmall,
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  GestureDetector(
                    onTap: () {
                      ShowDialogCustom.showDialogBase(
                        onTap2: () async {
                          final res = await PaymentContractBloc.of(context)
                              .deletePayment(
                            idContract: widget.id.toString(),
                            idPayment: idPayment,
                          );
                          if (res == '') {
                            Navigator.of(context).pop();
                            Navigator.of(context).pop();
                            PaymentContractBloc.of(context)
                                .add(InitGetPaymentContractEvent(widget.id));
                            widget.bloc.add(InitGetDetailContractEvent(widget.id));
                          } else {
                            showToastM(context, title: res);
                          }
                        },
                        content: getT(KeyT.are_you_sure_you_want_to_delete),
                      );
                    },
                    child: Icon(
                      Icons.delete,
                      size: 20,
                    ),
                  ),
                  AppValue.hSpaceSmall,
                  GestureDetector(
                    onTap: () {
                      AppNavigator.navigateForm(
                        title: getT(KeyT.edit_payment),
                        type: EDIT_PAYMENT,
                        id: widget.id,
                        idPay: idPayment,
                        idDetail: idDetail,
                        onRefreshForm: () {
                          PaymentContractBloc.of(context)
                              .add(InitGetPaymentContractEvent(widget.id));
                        },
                      );
                    },
                    child: Icon(
                      Icons.edit,
                      size: 20,
                    ),
                  ),
                ],
              ),
              AppValue.vSpaceSmall,
              WidgetLine(
                color: Colors.grey,
              ),
            ],
          ),
        );
      }).toList(),
    );
  }

  @override
  bool get wantKeepAlive => true;
}
